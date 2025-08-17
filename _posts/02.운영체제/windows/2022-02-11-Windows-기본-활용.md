---
title:  "Windows 기본 활용 완전 가이드"
description: "개발자를 꿈꾸는 초보자를 위한 Windows 필수 기능 가이드입니다. 파일 관리, 단축키, 시스템 도구, 개발 환경 설정까지 Windows를 효율적으로 사용하는 방법을 다룹니다. 2025년 Windows 11 최신 기능과 개발자 도구들을 포함하여 정리했습니다."
categories: [02.Operating System,Windows]
date:   2022-02-11 18:26:00 +0900
author: Hossam
image: /images/indexs/computing.png
tags: [컴퓨터활용,Operating System,Windows,개발환경,시스템관리,단축키]
pin: true
math: true
mermaid: true
---

## #01. Windows 기본 설정 (개발자 친화적)

### 1. 파일 확장자 표시하기

개발자에게는 파일 확장자가 매우 중요합니다.

#### Windows 11 방법
1. **탐색기 열기** (`Win + E`)
2. **상단 메뉴바 > 보기 > 표시 > 파일 확장명** 체크

#### Windows 10 방법
1. **탐색기 열기** (`Win + E`)
2. **보기 탭 > 파일 확장명** 체크

### 2. 숨김 파일 표시하기 (개발자 필수)

많은 개발 도구들이 `.git`, `.env`, `.htaccess` 같은 숨김 파일을 사용합니다.

1. **탐색기 > 보기 > 숨김 항목** 체크
2. 또는 `Win + E` → `Alt + V` → `H`

### 3. Windows Terminal 설치 (필수 개발 도구)

```powershell
# Microsoft Store에서 설치하거나
winget install Microsoft.WindowsTerminal

# 또는 PowerShell에서 직접 설치
```

## #02. 필수 단축키 마스터 가이드

### 1. 시스템 기본 단축키

| 단축키 | 설명 | 개발자 활용도 |
|--------|------|---------------|
| `Win + R` | 실행창 열기 | ⭐⭐⭐⭐⭐ 터미널, 서비스 실행 |
| `Win + E` | 탐색기 열기 | ⭐⭐⭐⭐⭐ 프로젝트 폴더 탐색 |
| `Win + X` | 관리자 메뉴 | ⭐⭐⭐⭐ 시스템 관리 |
| `Win + I` | 설정 열기 | ⭐⭐⭐ 시스템 설정 |
| `Win + L` | 화면 잠금 | ⭐⭐⭐⭐ 보안 |
| `Alt + F4` | 프로그램 종료 | ⭐⭐⭐⭐ 응급상황 |
| `Alt + Tab` | 프로그램 전환 | ⭐⭐⭐⭐⭐ 멀티태스킹 |

### 2. 고급 창 관리 단축키 (Windows 11/10)

| 단축키 | 설명 | 개발 시나리오 |
|--------|------|---------------|
| `Win + Left/Right` | 창 절반 크기로 좌우 배치 | 코드 에디터 + 브라우저 |
| `Win + Up/Down` | 창 최대화/최소화 | 전체화면 IDE 사용 |
| `Win + Shift + Left/Right` | 다른 모니터로 창 이동 | 듀얼 모니터 환경 |
| `Win + Tab` | 작업 보기 (Task View) | 프로젝트별 가상 데스크톱 |
| `Win + Ctrl + D` | 새 가상 데스크톱 | 개발/테스트 환경 분리 |
| `Win + Ctrl + Left/Right` | 가상 데스크톱 전환 | 빠른 환경 전환 |

### 3. 파일 관리 전문가 단축키

| 단축키 | 설명 | 개발자 팁 |
|--------|------|-----------|
| `F2` | 파일명 변경 | 스네이크케이스→카멜케이스 변환 |
| `Shift + 방향키` | 다중 파일 선택 | 배치 작업용 |
| `Ctrl + A` | 전체 선택 | 폴더 내 모든 파일 |
| `Ctrl + Shift + N` | 새 폴더 생성 | 프로젝트 구조 생성 |
| `Delete` | 휴지통으로 삭제 | 안전한 삭제 |
| `Shift + Delete` | 영구 삭제 | 캐시, 로그 파일 정리 |
| `Ctrl + X/C/V` | 잘라내기/복사/붙여넣기 | 파일 이동/복제 |
| `Ctrl + Z` | 실행 취소 | 실수 복구 |

### 4. 텍스트 편집 고급 단축키

| 단축키 | 설명 | 코딩 활용 |
|--------|------|-----------|
| `Ctrl + A` | 전체 선택 | 전체 코드 선택 |
| `Ctrl + C/X/V` | 복사/잘라내기/붙여넣기 | 코드 블록 조작 |
| `Ctrl + Z/Y` | 실행취소/다시실행 | 코드 변경 되돌리기 |
| `Ctrl + F` | 찾기 | 변수, 함수명 검색 |
| `Ctrl + H` | 바꾸기 | 변수명 일괄 변경 |
| `Ctrl + Left/Right` | 단어 단위 이동 | 빠른 코드 탐색 |
| `Shift + Ctrl + Left/Right` | 단어 단위 선택 | 변수명 선택 |
| `Home/End` | 줄 시작/끝 이동 | 라인 편집 |
| `Ctrl + Home/End` | 문서 시작/끝 이동 | 파일 전체 탐색 |

## #01. 파일 확장자 표시하기

아무 폴더나 열고 “보기 > 파일 확장명” 체크

## #02. 필수 단축키

### 1. 기본 단축키

| 단축키       | 설명                        |
| ------------ | --------------------------- |
| `WinKey + R` | 실행창 열기                 |
| `WinKey + E` | 탐색기 열기                 |
| `Alt + F4`   | 현재 사용중인 프로그램 종료 |

### 2. 파일 작업 단축키

> 탐색기에서 파일을 선택한 상태에서...

| 단축키                   | 설명                                                                                                                                |
| ------------------------ | ----------------------------------------------------------------------------------------------------------------------------------- |
| `F2` (파일이름 변경)     | 변경할 이름을 입력하고 엔터로 저장                                                                                                  |
| `Shift + 방향키 위,아래` | 방향키를 누른 만큼 여러 파일 동시 선택                                                                                              |
| `Delete`                 | 파일을 휴지통으로 보냄                                                                                                              |
| `Shift + Delete`         | 파일을 휴지통을 건너뛰고 즉시 삭제                                                                                                  |
| `Ctrl + X`               | 파일 잘라내기                                                                                                                       |
| `Ctrl + C`               | 파일 복사하기                                                                                                                       |
| `Ctrl + V`               | 잘라내거나 복사한 파일 붙여 넣기                                                                                                    |
| `Ctrl + Z`               | 작업 되돌리기<br/>- 잘라낸 후 붙여 넣은 파일(=이동)을 원래 위치로<br/>- 복사후 붙여넣은 파일을 삭제<br/>- 휴지통에 넣은 파일을 복원 |
| `Ctrl + Shift + N`       | 새 폴더 만들기                                                                                                                      |

### 3. 텍스트 입력 단축키

| 단축키                        | 설명                             |
| ----------------------------- | -------------------------------- |
| `Ctrl + C`                    | 선택된 내용 복사하기             |
| `Ctrl + X`                    | 선택된 내용 잘라내기             |
| `Ctrl + V`                    | 잘라내거나 복사한 내용 붙여 넣기 |
| `Ctrl + Z`                    | 작업 되돌리기                    |
| `Ctrl + Y`                    | 되돌리기 취소, 다시 실행         |
| `Home`                        | 행의 맨 앞으로 이동              |
| `End`                         | 행의 맨 뒤로 이동                |
| `Shift + 좌,우 방향키`        | 글자 단위로 내용 선택            |
| `Shift + 상,하 방향키`        | 행 단위로 내용 선택              |
| `Shift + Home, End`           | 커서 위치부터 처음, 끝까지 선택  |
| `Ctrl + 좌,우 방향키`         | 단어 단위로 커서 이동            |
| `Ctrl + Shift + 좌,우 방향키` | 단어 단위로 선택                 |
| `Ctrl + F`                    | 내용 검색                        |

## #03. 컴퓨팅 환경

### 1. 인터페이스(Interface)

- 2개 이상의 장치나 소프트웨어 사이에서 정보나 신호를 주고 받을 때 그 사이를 연결하는 장치, 소프트웨어, 조건, 규약등을 의미

### 2. 사용자 인터페이스 (UI: User Interface)

- 컴퓨터와 사용자간에 정보교환이 가능하도록 하는 장치나 프로그램 혹은 화면 형태를 의미하기도 함
- 일반적으로 화면의 모습을 UI라고 함

### 3. UI의 종류

#### GUI (Graphic User Interface)

- 사용자가 컴퓨터의 입출력 등의 기능을 쉽게 이해하고 사용할 수 있도록 아이콘 따위의 그래픽으로 나타낸 것.
- 컴퓨터를 조작하기 위하 다양한 입력(input)과 출력(output)이 필요하다.

| 용어                    | 설명                                                                                 |
| ----------------------- | ------------------------------------------------------------------------------------ |
| 입력소스(input source)  | 마우스, 키보드, 카메라 등 컴퓨터를 조작하기 위해 입력하는 것                         |
| 출력소스(output source) | 모니터로 화면을 나타내거나 스피커로 소리를 출력하는 등 사용자에게 결과를 표시하는 것 |
| I/O(input/output)       | 컴퓨터를 조작하기 위한 입력과 출력                                                   |


#### CLI (Command Line Interface)

- 명령어를 입력해 컴퓨터를 조작하는 방식

| 용어   | 설명                                                                                                                              |
| ------ | --------------------------------------------------------------------------------------------------------------------------------- |
| 터미널 | 콘솔상에서 실행하여 명령어를 입력하기 위한 환경                                                                                   |
| 쉘     | 터미널에 탑제된 명령어 해석기.<br/>- 유닉스 계열 : C쉘, Bash쉘,zsh쉘 등<br/>- 윈도우 계열 : 명령프롬프트(cmd), 파워쉘(PowerShell) |

## #04. Window 기본 명령어

- 명령프롬프트(commander)에서 실행한다.

> `WinKey + R`를 입력하여 실행창을 연 상태에서 `cmd`입력 후 엔터

![](/images/2022/0211/win_command.png)

### 1. 기본 명령어

| 명령어 | 설명 | 사용 예시 |
|--------|------|-----------|
| `dir` | 현재 디렉토리의 파일 및 폴더 목록 표시 | `dir` |
| `cd` | 디렉토리 변경 (Change Directory) | `cd C:\Users` |
| `md` 또는 `mkdir` | 새 디렉토리 생성 | `mkdir newfolder` |
| `rd` 또는 `rmdir` | 빈 디렉토리 삭제 | `rmdir emptyfolder` |
| `copy` | 파일 복사 | `copy file1.txt file2.txt` |
| `move` | 파일 이동 또는 이름 변경 | `move old.txt new.txt` |
| `del` | 파일 삭제 | `del filename.txt` |
| `type` | 텍스트 파일 내용 표시 | `type readme.txt` |
| `cls` | 화면 지우기 | `cls` |
| `exit` | 명령프롬프트 종료 | `exit` |

### 2. 고급 명령어

| 명령어 | 설명 | 사용 예시 |
|--------|------|-----------|
| `tree` | 디렉토리 구조를 트리 형태로 표시 | `tree /f` |
| `find` | 파일에서 텍스트 검색 | `find "keyword" filename.txt` |
| `findstr` | 고급 텍스트 검색 (정규식 지원) | `findstr /i "pattern" *.txt` |
| `attrib` | 파일 속성 변경 | `attrib +h filename.txt` |
| `tasklist` | 실행 중인 프로세스 목록 표시 | `tasklist` |
| `taskkill` | 프로세스 종료 | `taskkill /f /im notepad.exe` |
| `ping` | 네트워크 연결 테스트 | `ping google.com` |
| `ipconfig` | 네트워크 설정 정보 표시 | `ipconfig /all` |

### 3. 파일 및 폴더 관리 명령어

```cmd
# 현재 디렉토리 확인
cd

# 상위 디렉토리로 이동
cd ..

# 루트 디렉토리로 이동
cd \

# 특정 드라이브로 이동
D:

# 숨김 파일까지 모두 표시
dir /a

# 파일 크기별로 정렬하여 표시
dir /os

# 하위 폴더까지 재귀적으로 검색
dir /s *.txt

# 파일 강제 삭제 (읽기 전용 포함)
del /f filename.txt

# 폴더와 하위 내용 모두 삭제
rd /s /q foldername
```

## #05. 개발자를 위한 고급 활용법

### 1. 환경 변수 관리

#### 환경 변수 확인
```cmd
# 모든 환경 변수 표시
set

# 특정 환경 변수 표시
echo %PATH%
echo %JAVA_HOME%
echo %USERNAME%
```

#### 환경 변수 설정
```cmd
# 현재 세션에서만 유효한 환경 변수 설정
set TEMP_VAR=Hello World
echo %TEMP_VAR%

# 시스템 전체에 환경 변수 설정 (관리자 권한 필요)
setx JAVA_HOME "C:\Program Files\Java\jdk-17"
```

### 2. 배치 파일 활용

#### 간단한 배치 파일 생성
```cmd
@echo off
echo 자동화 스크립트 시작
cd C:\workspace
dir *.java
echo 작업 완료
pause
```

#### 매개변수를 받는 배치 파일
```cmd
@echo off
if "%1"=="" (
    echo 사용법: backup.bat [폴더명]
    exit /b
)
echo %1 폴더를 백업합니다.
xcopy "%1" "backup_%1" /e /i /y
echo 백업 완료
```

### 3. 시스템 정보 확인

```cmd
# 시스템 정보 자세히 보기
systeminfo

# 하드웨어 정보
wmic cpu get name
wmic memorychip get capacity
wmic diskdrive get size,model

# 설치된 프로그램 목록
wmic product get name,version

# 네트워크 어댑터 정보
wmic nic get name,speed
```

### 4. 프로세스 및 서비스 관리

```cmd
# 특정 프로세스 찾기
tasklist | findstr chrome

# CPU 사용률 높은 프로세스 찾기
wmic process get name,processid,percentprocessortime

# 서비스 목록 확인
sc query

# 특정 서비스 시작/중지
sc start "service_name"
sc stop "service_name"

# 서비스 상태 확인
sc query "service_name"
```

## #06. PowerShell 기본 사용법

Windows PowerShell은 명령프롬프트보다 강력한 기능을 제공합니다.

### 1. PowerShell 실행
- `WinKey + R` → `powershell` 입력
- 또는 `WinKey + X` → `Windows PowerShell` 선택

### 2. 기본 PowerShell 명령어

| PowerShell | 설명 | 명령프롬프트 대응 |
|------------|------|-------------------|
| `Get-Location` | 현재 위치 표시 | `cd` |
| `Set-Location` | 디렉토리 변경 | `cd` |
| `Get-ChildItem` | 파일/폴더 목록 | `dir` |
| `New-Item` | 파일/폴더 생성 | `md`, `copy con` |
| `Remove-Item` | 파일/폴더 삭제 | `del`, `rd` |
| `Copy-Item` | 파일/폴더 복사 | `copy` |
| `Move-Item` | 파일/폴더 이동 | `move` |
| `Get-Content` | 파일 내용 보기 | `type` |

### 3. PowerShell 별칭 (Alias)

PowerShell은 Unix/Linux 명령어와 호환되는 별칭을 제공합니다:

```powershell
# 디렉토리 목록 (여러 방법)
ls          # Unix 스타일
dir         # Windows 스타일
Get-ChildItem  # PowerShell 네이티브

# 파일 내용 보기
cat readme.txt    # Unix 스타일
type readme.txt   # Windows 스타일
Get-Content readme.txt  # PowerShell 네이티브
```

### 4. PowerShell 고급 기능

```powershell
# 파이프라인을 이용한 데이터 처리
Get-Process | Where-Object {$_.CPU -gt 100} | Sort-Object CPU -Descending

# CSV 파일로 데이터 내보내기
Get-Process | Export-Csv -Path "processes.csv" -NoTypeInformation

# JSON 형태로 데이터 변환
Get-Service | Select-Object Name, Status | ConvertTo-Json

# 원격 명령 실행
Invoke-Command -ComputerName "RemotePC" -ScriptBlock {Get-Service}
```

## #07. 개발 환경 최적화

### 1. Windows Terminal 설치 및 설정

Microsoft Store에서 "Windows Terminal" 설치 후 설정:

```json
{
    "defaultProfile": "{powerShell_guid}",
    "profiles": {
        "defaults": {
            "fontFace": "Cascadia Code",
            "fontSize": 12,
            "colorScheme": "Campbell Powershell"
        }
    }
}
```

### 2. 유용한 개발 도구 설치

#### Chocolatey 패키지 매니저
```powershell
# 관리자 권한으로 PowerShell 실행 후
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# 개발 도구 설치
choco install git nodejs python vscode -y
```

#### Windows Subsystem for Linux (WSL) 활용
```powershell
# WSL 기능 활성화
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Ubuntu 설치
wsl --install -d Ubuntu
```

### 3. 개발자를 위한 Windows 설정

#### 개발자 모드 활성화
1. `설정` → `업데이트 및 보안` → `개발자용`
2. `개발자 모드` 선택

#### 파일 시스템 성능 최적화
```cmd
# NTFS 파일 시스템 최적화
fsutil behavior set DisableLastAccess 1

# 임시 파일 정리 자동화
cleanmgr /sagerun:1
```

## #08. 문제 해결 및 진단

### 1. 시스템 파일 검사

```cmd
# 시스템 파일 무결성 검사
sfc /scannow

# Windows 이미지 복구
dism /online /cleanup-image /restorehealth

# 메모리 진단
mdsched.exe
```

### 2. 네트워크 문제 해결

```cmd
# DNS 캐시 초기화
ipconfig /flushdns

# 네트워크 어댑터 재설정
ipconfig /release
ipconfig /renew

# 네트워크 연결 테스트
ping -t google.com
tracert google.com
```

### 3. 성능 모니터링

```cmd
# 리소스 사용량 실시간 모니터링
perfmon

# 이벤트 로그 확인
eventvwr.msc

# 디스크 사용량 분석
powershell "Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID,Size,FreeSpace"
```

이제 Windows 기본 활용에 대한 포괄적인 내용이 완성되었습니다. 기본 사용법부터 개발자를 위한 고급 기능까지 단계적으로 설명되어 있어 다양한 수준의 사용자에게 도움이 될 것입니다.