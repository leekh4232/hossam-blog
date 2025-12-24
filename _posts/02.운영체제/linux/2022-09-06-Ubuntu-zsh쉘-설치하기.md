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

# Ubuntu에 zsh쉘 설치하기

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

맥OS의 경우 `homebrew`를 사용한다. `homebrew`는 `brew ~`명령으로 실행한다.

맥에서는 일단 `sudo`없이 실행하고 Permission 에러(권한에러)가 발생할 경우에만 `sudo`옵션을 사용하자.

```bash
brew -y install zsh curl git
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


## #07. Powerlevel10k 테마 설치 (고급)

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

#### 폰트파일 내려받기

```bash
# Nerd Fonts 설치 (터미널에서 아이콘 표시용)
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
```

#### 압축 해제

```bash
# 압축 해제 폴더 생성하기
mkdir -p ~/.local/share/fonts

# 폰트 압축 해제
unzip FiraCode.zip -d ~/.local/share/fonts/
```

unzip 명령을 사용할 수 없을 경우 아래 명령으로 zip 명령어 설치

```bash
sudo apt-get install -y zip
```

#### 폰트 인식시키기

```bash
# 폰트 캐시(fontconfig cache)를 새로 생성/갱신
fc-cache -fv
```

위 명령을 사용할 수 없을 경우 아래 명령을 실행하여 명령어를 설치해야 함

```bash
sudo apt update && sudo apt install fontconfig
```

### 4. Powerlevel10k 설정

```bash
# 설정 마법사 실행
p10k configure
```

마법사 실행 후 제시되는 항목에 따라 설정을 진행한다.

### 5. Windows 명령 프롬프트로 원격 접속을 수행하는 경우

윈도우 명령프롬프트를 사용해서 원격 접속을 하는 경우 NerdFont를 내려받아 설치해야 한다.

> https://www.nerdfonts.com/font-downloads

Font를 내려 받은 후 명령프롬프트의 환경 설정에서 폰트를 지정해 준다.


## #8. `.zshrc`에 추가할 수 있는 유용한 함수

아래 내용 추가 후 각 함수를 명령어로 사용할 수 있다. `$1`은 명령어 뒤에 전달하는 파라미터임.

```bash
# ~/.zshrc 파일에 추가

# 디렉토리 생성 후 이동
# 사용예 : mkcd hello
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# 파일 백업복사
# 사용예 : backup 원본파일이름
backup() {
    cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
}

# 프로세스 찾기
# 사용예 : psgrep 검색어
psgrep() {
    ps aux | grep "$1" | grep -v grep
}

# IP 주소 표시
# 사용예 : myip
myip() {
    curl -s http://checkip.amazonaws.com
}

# 시스템 정보 요약
# 사용예 : sysinfo
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
