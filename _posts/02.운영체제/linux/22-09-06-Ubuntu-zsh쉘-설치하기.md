---
title:  "Ubuntu에 zsh쉘 설치하기"
description: "쉘이란 명령어를 입력받아 실행시켜주는 명령어 해석기 입니다. 터미널에 탑재되어 실행되며 bash, bsh, csh 등 다양한 종류가 있습니다. 그 중에서 최근에는 여러가지 편의 기능을 위한 플러그인의 설치가 가능하고 테마도 적용할 수 있는 zsh 쉘이 널리 사용되고 있습니다."
categories: [02.Operating System,Linux,Ubuntu]
tags: [Operating System,Linux,Ubuntu,zsh]
image: /images/indexs/ubuntu.png
date: 2022-09-06 10:04:19 +0900
author: Hossam
pin: true
math: true
mermaid: true
---


## #01. 프로그램 설치

zsh 쉘과 curl, git 클라이언트를 설치한다.

프로그램 설치는 root 권한으로만 가능하기 때문에 `sudo` 명령을 사용하여 root의 권한을 임대한 상태로 설치해야 한다.

```bash
sudo apt-get -y install zsh curl git
```

만약 CentOS나 RedHat 계열이라면 `agt-get` 대신 `yum`명령을 사용한다.

```bash
sudo yum -y install zsh curl git
```

## #02. 현재 사용자의 쉘을 zsh로 변경

### 1. 쉘 변경하기

아래의 명령을 사용하여 쉘을 변경한 후 재로그인해야 적용된다.

```bash
chsh -s $(which zsh)
```

> chsh는 change shell의 약자

### 2. 쉘 적용하기

재로그인 후 아래와 같이 쉘 초기 설정에 대한 선택항목이 표시된다. 이후 과정에서 `oh-my-zsh`를 설치하여 설정을 진행할 것이므로 여기서는 `q`를 입력하여 아무런 설정도 진행하지 않음을 선택한다.

![plugin1](/images/2022/0905/first.png)

### 3. 재로그인 후 쉘 확인하기

```
$ echo $SHELL
/usr/bin/zsh
```

## #03. `oh-my-zsh` 설치하기

`oh-my-zsh`는 zsh쉘의 설정을 좀 더 손쉽게 할 수 있도록 하는 보조 도구이다.

```bash
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
```

![oh-my-zsh 설치 완료시 화면](/images/2022/0905/oh-my-zsh.png)

> 설치 완료 후 재로그인해야 적용된다.

## #04. 플러그인 설치

### 1. 문법 강조 플러그인 설치

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

![plugin1](/images/2022/0905/plugin1.png)

### 2. 명령어 자동 완성 플러그인 설치

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

![plugin2](/images/2022/0905/plugin2.png)


## #05. 초기화 파일 수정하기

설치 완료 후 vi에디터로 zsh 설정파일을 연다.

```bash
vi ~/.zshrc
```

### 1. theme 변경

아래와 같이 표시되는 곳을 찾아 사용하고자 하는 테마로 변경한다.

![theme](/images/2022/0905/theme.png)

#### 변경후

```bash
ZSH_THEME="af-magic"
```

그 밖에 다양한 테마를 확인하기 위해서는 아래의 URL에 방문해 보도록 하자.

[https://github.com/ohmyzsh/ohmyzsh/wiki/Themes](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)

### 2. 설정 파일의 플러그인 설정 추가

아래와 같이 표시되는 곳을 찾아 설치한 플러그인들의 이름을 추가한다.

![plugin](/images/2022/0905/plugin.png)

#### 변경 후

```bash
plugins=(
	git
	zsh-syntax-highlighting   ## 추가
	zsh-autosuggestions       ## 추가
)
```

### 3. 저장하기

`ESC`키를 눌러 명령어 모드로 전환한 후 `wq`를 입력하고 엔터를 누른다

![save](/images/2022/0905/save.png)

## #06. 설정내용 반영하기

설정 완료 후 다음의 명령어로 설정내용을 반영한다.

```
source ~/.zshrc
```

## #07. 고급 설정 및 커스터마이징

### 1. 추가 유용한 플러그인들

```bash
# 디렉토리 자동 점프 플러그인
git clone https://github.com/agkozak/zsh-z.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z

# 명령어 실행 시간 표시 플러그인
git clone https://github.com/popstas/zsh-command-time.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/command-time

# Docker 자동완성 플러그인 (Docker가 설치된 경우)
git clone https://github.com/greymd/docker-zsh-completion.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/docker-zsh-completion

# Kubernetes 자동완성 (kubectl이 설치된 경우)
git clone https://github.com/bonnefoa/kubectl-fzf.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/kubectl-fzf
```

### 2. ~/.zshrc 파일에 플러그인 추가

```bash
plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-z                     # 디렉토리 점프
    command-time              # 명령어 실행 시간
    docker                    # Docker 자동완성
    kubectl                   # Kubernetes 자동완성
    sudo                      # 더블 ESC로 sudo 추가
    history                   # 히스토리 검색 개선
    colored-man-pages         # man 페이지 색상 표시
    extract                   # 압축 파일 자동 추출
)
```

### 3. 사용자 정의 별칭(Aliases) 설정

```bash
# ~/.zshrc 파일 하단에 추가
# 시스템 관리 별칭
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# 시스템 정보 별칭
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps aux'

# 네트워크 별칭
alias ports='netstat -tulanp'
alias ping='ping -c 5'
alias wget='wget -c'

# 개발 관련 별칭
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server 8000'
alias json='python3 -m json.tool'

# Git 별칭
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Docker 별칭 (Docker가 설치된 경우)
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
alias dexec='docker exec -it'
```

### 4. 환경 변수 설정

```bash
# ~/.zshrc 파일에 추가
# PATH 설정
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# 개발 환경 변수
export EDITOR="vim"
export BROWSER="firefox"

# Java 환경 (Java가 설치된 경우)
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
export PATH="$JAVA_HOME/bin:$PATH"

# Node.js 환경 (Node.js가 설치된 경우)
export NODE_PATH="/usr/local/lib/node_modules"

# Python 환경
export PYTHONPATH="$HOME/.local/lib/python3.8/site-packages:$PYTHONPATH"

# 히스토리 설정
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
```

## #08. Powerlevel10k 테마 설치 (고급)

### 1. Powerlevel10k 설치

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### 2. 테마 적용

```bash
# ~/.zshrc 파일에서 테마 변경
ZSH_THEME="powerlevel10k/powerlevel10k"
```

### 3. 폰트 설치 (선택사항)

```bash
# Nerd Fonts 설치 (터미널에서 아이콘 표시용)
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d ~/.local/share/fonts/
fc-cache -fv
```

### 4. Powerlevel10k 설정

```bash
# 설정 마법사 실행
p10k configure
```

## #09. fzf (퍼지 파인더) 설치

### 1. fzf 설치

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### 2. fzf 키 바인딩

- `Ctrl+R`: 명령어 히스토리 검색
- `Ctrl+T`: 파일/디렉토리 검색
- `Alt+C`: 디렉토리 변경

### 3. fzf 사용 예시

```bash
# 파일 검색하여 편집
vim $(fzf)

# 프로세스 검색하여 종료
kill $(ps aux | fzf | awk '{print $2}')

# Git 브랜치 변경
git checkout $(git branch | fzf)
```

## #10. 성능 최적화 및 문제 해결

### 1. zsh 시작 속도 최적화

```bash
# ~/.zshrc 시작 시간 측정
time zsh -i -c exit

# 플러그인별 로딩 시간 확인
zprof  # ~/.zshrc 맨 위에 'zmodload zsh/zprof' 추가 후

# 불필요한 플러그인 비활성화
# plugins 배열에서 사용하지 않는 플러그인 제거
```

### 2. 일반적인 문제 해결

```bash
# 1. 권한 문제 해결
sudo chown -R $(whoami) ~/.oh-my-zsh

# 2. 플러그인 업데이트
cd ~/.oh-my-zsh && git pull
cd ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && git pull
cd ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && git pull

# 3. 설정 파일 백업
cp ~/.zshrc ~/.zshrc.backup

# 4. Oh My Zsh 재설치
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 3. 디버깅 모드

```bash
# zsh 디버깅 모드로 실행
zsh -x

# 설정 파일 문법 검사
zsh -n ~/.zshrc
```

## #11. 유용한 함수 및 스크립트

### 1. 사용자 정의 함수

```bash
# ~/.zshrc 파일에 추가

# 디렉토리 생성 후 이동
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# 파일 백업
backup() {
    cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
}

# 압축 파일 추출
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# 빠른 찾기
ff() {
    find . -type f -name "*$1*"
}

# 프로세스 찾기
psgrep() {
    ps aux | grep "$1" | grep -v grep
}

# IP 주소 표시
myip() {
    curl -s http://checkip.amazonaws.com
}

# 시스템 정보 요약
sysinfo() {
    echo "System Information:"
    echo "==================="
    echo "Hostname: $(hostname)"
    echo "OS: $(lsb_release -d | cut -f2)"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p)"
    echo "Memory: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
    echo "Disk: $(df -h / | awk '/\// {print $3 "/" $2 " (" $5 ")"}')"
    echo "Load: $(uptime | awk -F'load average:' '{print $2}')"
}
```

### 2. 자동 업데이트 스크립트

```bash
# ~/.zshrc에 추가 (주간 자동 업데이트)
update_zsh() {
    echo "Updating Oh My Zsh..."
    cd ~/.oh-my-zsh && git pull

    echo "Updating plugins..."
    for plugin in ~/.oh-my-zsh/custom/plugins/*; do
        if [ -d "$plugin/.git" ]; then
            echo "Updating $(basename $plugin)..."
            cd "$plugin" && git pull
        fi
    done

    echo "Reloading zsh config..."
    source ~/.zshrc
    echo "Update complete!"
}

# 별칭으로 등록
alias zsh-update='update_zsh'
```

이제 Ubuntu zsh 설치 및 설정에 대한 포괄적인 가이드가 완성되었습니다. 기본 설치부터 고급 커스터마이징, 성능 최적화, 문제 해결까지 실무에서 필요한 모든 내용을 포함했습니다.