---
title:  "Mac gita로 여러 Git 저장소 한번에 관리하기"
description: "프로젝트가 늘어나면 저장소마다 폴더를 옮겨 다니며 git status, git pull을 반복하게 된다. gita는 여러 Git 저장소를 한 곳에 등록해 두고 어느 디렉터리에서든 상태 확인과 git 명령을 한번에 실행하는 도구다. Homebrew 설치, 저장소 등록, zsh 자동완성, 그룹 설정까지 그대로 따라할 수 있도록 정리했다."
categories: [02.Operating System,Mac]
date:   2026-10-30 11:00:00 +0900
author: Hossam
image: /images/indexs/mac.jpg
tags: [컴퓨터활용,Operating System,Mac,Git,gita,Homebrew]
pin: true
math: true
mermaid: true
---

## #01. gita란?

[gita](https://github.com/nosarthur/gita)는 여러 Git 저장소를 한번에 다루는 Python 기반 CLI 도구다.

- 저장소를 한 번 등록해 두면 어느 디렉터리에서든 전체 상태를 한 화면에서 본다.
- `gita pull`, `gita fetch`처럼 등록된 모든 저장소에 git 명령을 한번에 보낸다.
- 임의의 git 명령이나 alias도 `gita super 저장소명 ...` 형태로 위임할 수 있다.

### 작업 환경

| 항목 | 값 |
| --- | --- |
| OS | macOS (Apple Silicon) |
| 패키지 관리자 | Homebrew |
| 쉘 | zsh + oh-my-zsh |
| gita 버전 | 0.16.8.2 |

> Intel Mac은 Homebrew 경로가 `/opt/homebrew` 대신 `/usr/local`이다. 아래 명령에서 경로를 바꿔 읽는다.

## #02. 설치

### 1. 설치 방법 비교

| 방법 | 명령어 | 특징 |
| --- | --- | --- |
| Homebrew (권장) | `brew install gita` | Python 버전과 무관하게 동작. `brew upgrade gita`로 업데이트 |
| uv | `uv tool install gita` | `~/.local/bin`에 격리 설치. PyPI 최신 버전 |
| pip | `pip install gita` | pyenv 등으로 Python 버전을 바꾸면 사라질 수 있어 비권장 |

### 2. Homebrew로 설치

```shell
brew install gita
```

### 3. 설치 확인

```shell
which gita
gita --version
```

아래와 같이 표시되면 성공이다.

```text
/opt/homebrew/bin/gita
gita 0.16.8.2
```

## #03. 저장소 등록

### 1. 저장소 추가

관리할 저장소 경로를 나열한다. 경로는 띄어쓰기로 구분한다.

```shell
gita add ~/workspace/hossam-ml ~/workspace/lecture-pyai ~/claude-config
```

```text
Found 3 new repo(s).
```

### 2. 폴더 아래 저장소를 한번에 추가

저장소가 한 폴더 아래 모여 있으면 폴더만 지정한다.

```shell
## 하위 폴더를 뒤져서 저장소를 모두 등록
gita add -r ~/workspace

## 저장소 등록 + 폴더 구조대로 그룹까지 자동 생성
gita add -a ~/workspace
```

> `-n` 옵션을 붙이면 실제로 등록하지 않고 어떤 저장소가 잡히는지만 미리 본다.
> 저장소 안에 들어 있는 하위 저장소까지 잡힌다. 서브모듈을 빼려면 `-s` 옵션을 함께 쓴다.

### 3. 등록 확인

```shell
## 등록된 저장소 이름 목록
gita ls

## 저장소별 브랜치, 상태, 마지막 커밋
gita ll
```

```text
claude-config          main       [*]     claude-env-sync 스킬 추가 (3 days ago)
hossam-ml              main       []      auto commit 2026-10-26 08:33:59 (4 days ago)
lecture-pyai           main       []      auto commit 2026-10-29 18:19:17 (16 hours ago)
```

### 4. 등록 정보 저장 위치

등록 목록은 CSV 파일 한 개에 저장된다. 백업하거나 다른 컴퓨터로 옮길 때 이 파일만 챙기면 된다.

```shell
cat ~/.config/gita/repos.csv
```

```text
/Users/leekh/workspace/hossam-ml,hossam-ml,,
/Users/leekh/workspace/lecture-pyai,lecture-pyai,,
/Users/leekh/claude-config,claude-config,,
```

## #04. zsh 자동완성

`gita <Tab>`으로 하위 명령과 저장소 이름을 완성하는 설정이다. 공식 저장소의 `_gita` 파일을 Homebrew의 zsh completion 폴더에 넣기만 하면 된다.

### 1. completion 파일 내려받기

```shell
curl -fsSL -o /opt/homebrew/share/zsh/site-functions/_gita \
  https://raw.githubusercontent.com/nosarthur/gita/master/auto-completion/zsh/_gita
```

- `/opt/homebrew/share/zsh/site-functions`는 Homebrew를 쓰는 zsh라면 이미 `fpath`에 포함되어 있다.
- 그래서 `~/.zshrc`를 수정할 필요가 없다.

포함 여부가 궁금하면 아래 명령으로 확인한다.

```shell
echo $fpath | tr ' ' '\n' | grep site-functions
```

### 2. 적용 확인

**새 터미널을 연 뒤** 아래 명령을 실행한다. 기존 터미널에는 적용되지 않는다.

```shell
echo ${_comps[gita]}
```

`_gita`가 출력되면 완료다. 이제 `gita ` 뒤에서 `Tab`을 누르면 하위 명령이 표시된다.

> bash 사용자는 [.gita-completion.bash](https://github.com/nosarthur/gita/blob/master/auto-completion/bash/.gita-completion.bash)를 내려받아 `~/.bashrc`에서 `source` 한다.

## #05. 그룹 설정 (선택)

저장소가 많아지면 일부에만 명령을 보내고 싶어진다. 그룹을 만들면 `gita ll 그룹명`처럼 쓸 수 있다.

```shell
## ws 그룹 생성 (없으면 만들고, 있으면 추가)
gita group add ws hossam-ml lecture-pyai

## 그룹 목록
gita group ls

## 그룹에만 명령 실행
gita ll ws
gita pull ws

## 그룹 삭제 (저장소 등록은 유지)
gita group rm ws
```

그룹 정보는 `~/.config/gita/groups.csv`에 저장된다.

## #06. 자주 쓰는 명령

| 명령어 | 설명 |
| --- | --- |
| `gita ll` | 전체 저장소 상태 요약 |
| `gita fetch` | 전체 fetch |
| `gita pull` | 전체 pull |
| `gita push` | 전체 push |
| `gita st 저장소명` | 특정 저장소의 `git status` |
| `gita br` | 전체 로컬 브랜치 목록 |
| `gita super 저장소명 커밋명령` | 임의 git 명령 위임 |
| `gita shell 저장소명 쉘명령` | 저장소 폴더에서 임의 쉘 명령 실행 |
| `gita rm 저장소명` | 등록 해제 (폴더는 삭제하지 않음) |

### super 모드 예시

저장소 폴더로 이동하지 않고 커밋과 push를 한번에 처리한다.

```shell
gita super lecture-pyai commit -am "강의자료 업데이트"
gita super lecture-pyai push
```

### 상태 기호 읽는 법

`gita ll`의 브랜치 옆 대괄호 안에 표시되는 기호다.

| 기호 | 의미 |
| --- | --- |
| `*` | 커밋하지 않은 변경 있음 |
| `+` | 스테이징된 변경 있음 |
| `?` | 추적하지 않는 파일 있음 |
| `$` | stash 있음 |
| `↑` | 로컬이 원격보다 앞섬 (push 필요) |
| `↓` | 원격이 로컬보다 앞섬 (pull 필요) |
| `⇕` | 서로 갈라짐 |
| `∅` | 원격 없음 |

## #07. 다른 컴퓨터로 옮기기

등록 정보를 파일로 내보내고, 새 컴퓨터에서 그 파일로 한번에 clone 한다.

```shell
## 기존 컴퓨터: 저장소 목록 내보내기
gita freeze > gita-repos.csv

## 새 컴퓨터: 원래 경로 그대로 clone + 등록
gita clone -p gita-repos.csv
```

## #08. 제거

```shell
## 등록 정보 전체 삭제 (저장소 폴더는 그대로)
gita clear

## 프로그램 제거
brew uninstall gita

## 설정 파일과 자동완성 파일 제거
rm -rf ~/.config/gita
rm /opt/homebrew/share/zsh/site-functions/_gita
```
