---
title:  PDF 비밀번호 일괄 해제
description: 수업 준비 하면서 필요해서 만든 코드
categories: [01.Toy Project, 유틸리티]
date: 2025-08-19 12:39:33
author: Hossam
image: /images/indexs/python.jpg
tags: [Programming,Coding,Python,Utility]
pin: true
math: true
mermaid: true
---

평소 PDF 파일에 비밀번호를 걸어두는 편인데, 아이패드로 파일을 열람하려고 하니 비밀번호가 여간 귀찮은게 아니었다. 그래서 일괄적으로 비밀번호를 해제하는 python 스크립트를 만들었다.

python 파일과 같은 폴더 안의 pdf에 대해서 일괄 작동하며 pdf 파일의 비밀번호가 모두 동일해야 한다.

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
batch_pdf_decrypt.py

필요 패키지:
    pip install pikepdf
"""

import argparse
import sys
from pathlib import Path
import getpass
import tempfile
import os

import pikepdf
from pikepdf import PasswordError

def iter_pdfs(root: Path, recursive: bool):
    pattern = "**/*.pdf" if recursive else "*.pdf"
    for p in root.glob(pattern):
        if p.is_file():
            yield p

def load_passwords(single_pw: str | None, pw_file: str | None):
    seen = set()
    candidates = []

    # 1) 명시적 단일 비밀번호
    if single_pw is not None and single_pw not in seen:
        seen.add(single_pw)
        candidates.append(single_pw)

    # 2) 빈 문자열(일부 PDF는 빈 비밀번호)
    if "" not in seen:
        seen.add("")
        candidates.append("")

    # 3) 파일에서 후보 비밀번호
    if pw_file:
        path = Path(pw_file)
        if path.is_file():
            for line in path.read_text(encoding="utf-8", errors="ignore").splitlines():
                pw = line.strip()
                if pw not in seen:
                    seen.add(pw)
                    candidates.append(pw)
        else:
            print(f"[WARN] passwords-file 찾을 수 없음: {pw_file}", file=sys.stderr)

    return candidates

def try_open(pdf_path: Path, passwords: list[str]):
    """
    준비된 password 후보들로 열기를 시도.
    실패 시 None 반환. 성공 시 (opened_pdf, used_password) 반환.
    """
    for pw in passwords:
        try:
            pdf = pikepdf.open(str(pdf_path), password=pw)
            return pdf, pw
        except PasswordError:
            continue
        except Exception as e:
            # PDF 자체 손상 등 기타 오류
            print(f"[FAIL] {pdf_path.name}: 열기 오류 - {e}", file=sys.stderr)
            return None
    return None

def prompt_password_interactive(pdf_path: Path, max_tries: int = 3):
    for i in range(max_tries):
        pw = getpass.getpass(f"비밀번호 입력 [{pdf_path.name}] (시도 {i+1}/{max_tries}, Enter=건너뛰기): ")
        if pw == "":
            return None
        try:
            pdf = pikepdf.open(str(pdf_path), password=pw)
            return pdf, pw
        except PasswordError:
            print("  → 비밀번호 불일치.")
    return None

def safe_save(pdf: pikepdf.Pdf, src: Path, dest: Path, inplace: bool):
    if inplace:
        # 임시 파일에 저장 후 원본을 원자적으로 교체
        with tempfile.NamedTemporaryFile(suffix=".pdf", delete=False, dir=str(src.parent)) as tmp:
            tmp_path = Path(tmp.name)
        try:
            pdf.save(str(tmp_path))
            os.replace(str(tmp_path), str(src))
            return src
        finally:
            if tmp_path.exists():
                try:
                    tmp_path.unlink()
                except Exception:
                    pass
    else:
        dest.parent.mkdir(parents=True, exist_ok=True)
        pdf.save(str(dest))
        return dest

def main():
    parser = argparse.ArgumentParser(description="폴더 내 PDF 비밀번호 해제(복호화) 배치 처리")
    parser.add_argument("-r", "--recursive", action="store_true", help="하위 폴더까지 처리")
    parser.add_argument("-p", "--password", help="모든 파일에 시도할 단일 비밀번호")
    parser.add_argument("--passwords-file", help="후보 비밀번호 목록 파일(한 줄당 하나)")
    parser.add_argument("--inplace", action="store_true", help="성공 시 원본 파일을 직접 교체")
    parser.add_argument("--force", action="store_true", help="출력 파일이 있어도 덮어쓰기")
    parser.add_argument("--dry-run", action="store_true", help="저장 없이 처리 계획만 출력")
    args = parser.parse_args()

    root = Path(".").resolve()

    passwords = load_passwords(args.password, args.passwords_file)

    total = 0
    ok = 0
    skipped = 0
    failed = 0

    for pdf_path in iter_pdfs(root, args.recursive):
        total += 1

        # 비암호화 파일인지 빠르게 확인
        try:
            with pikepdf.open(str(pdf_path)) as pdf_plain:
                if not pdf_plain.is_encrypted:
                    print(f"[SKIP] {pdf_path.name}: 암호화되지 않음")
                    skipped += 1
                    continue
        except PasswordError:
            # 암호화된 파일 → 처리 계속
            pass
        except Exception as e:
            print(f"[FAIL] {pdf_path.name}: 열기 오류 - {e}")
            failed += 1
            continue

        # 출력을 정함
        if args.inplace:
            dest_path = pdf_path  # in-place
        else:
            dest_path = pdf_path.with_stem(pdf_path.stem + "_decrypted")

        if dest_path.exists() and not args.force and not args.inplace:
            print(f"[SKIP] {pdf_path.name}: 출력 존재({dest_path.name}), --force 없이 건너뜀")
            skipped += 1
            continue

        if args.dry_run:
            print(f"[PLAN] {pdf_path.name} → {'in-place 교체' if args.inplace else dest_path.name}")
            continue

        # 준비된 후보 비밀번호로 시도
        opened = try_open(pdf_path, passwords)

        # 후보로 실패하면 대화형 입력
        if opened is None:
            opened = prompt_password_interactive(pdf_path)

        if opened is None:
            print(f"[FAIL] {pdf_path.name}: 비밀번호 불일치 또는 미제공")
            failed += 1
            continue

        pdf_obj, used_pw = opened

        try:
            saved_to = safe_save(pdf_obj, pdf_path, dest_path, args.inplace)
            pdf_obj.close()
            print(f"[OK]   {pdf_path.name} → {saved_to.name} (pw={'<입력안함>' if used_pw=='' else '***'})")
            ok += 1
        except Exception as e:
            print(f"[FAIL] {pdf_path.name}: 저장 실패 - {e}")
            failed += 1
        finally:
            try:
                pdf_obj.close()
            except Exception:
                pass

    if not args.dry_run:
        print("\n=== 요약 ===")
        print(f"총 파일: {total}")
        print(f"성공:     {ok}")
        print(f"건너뜀:   {skipped}")
        print(f"실패:     {failed}")

if __name__ == "__main__":
    main()
```