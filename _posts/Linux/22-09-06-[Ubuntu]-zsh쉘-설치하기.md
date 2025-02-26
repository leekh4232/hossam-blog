---
layout: post
title:  "[Ubuntu] zsh쉘 설치하기"
date:   2022-09-06
banner_image: index-ubuntu.png
tags: [Linux]
---

쉘이란 명령어를 입력받아 실행시켜주는 명령어 해석기 입니다. 터미널에 탑재되어 실행되며 bash, bsh, csh 등 다양한 종류가 있습니다. 그 중에서 최근에는 여러가지 편의 기능을 위한 플러그인의 설치가 가능하고 테마도 적용할 수 있는 zsh 쉘이 널리 사용되고 있습니다.

<!--more-->

# #01. 프로그램 설치

zsh 쉘과 curl, git 클라이언트를 설치한다.

프로그램 설치는 root 권한으로만 가능하기 때문에 `sudo` 명령을 사용하여 root의 권한을 임대한 상태로 설치해야 한다.

```bash
sudo apt-get -y install zsh curl git
```

만약 CentOS나 RedHat 계열이라면 `agt-get` 대신 `yum`명령을 사용한다.

```bash
sudo yum -y install zsh curl git
```

# #02. 현재 사용자의 쉘을 zsh로 변경

## 1. 쉘 변경하기

아래의 명령을 사용하여 쉘을 변경한 후 재로그인해야 적용된다.

```bash
chsh -s $(which zsh)
```

> chsh는 change shell의 약자

## 2. 쉘 적용하기

재로그인 후 아래와 같이 쉘 초기 설정에 대한 선택항목이 표시된다. 이후 과정에서 `oh-my-zsh`를 설치하여 설정을 진행할 것이므로 여기서는 `q`를 입력하여 아무런 설정도 진행하지 않음을 선택한다.

![plugin1](/images/posts/2022/0905/first.png)

## 3. 재로그인 후 쉘 확인하기

```
$ echo $SHELL
/usr/bin/zsh
```

# #03. `oh-my-zsh` 설치하기

`oh-my-zsh`는 zsh쉘의 설정을 좀 더 손쉽게 할 수 있도록 하는 보조 도구이다.

```bash
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
```

![oh-my-zsh 설치 완료시 화면](/images/posts/2022/0905/oh-my-zsh.png)

> 설치 완료 후 재로그인해야 적용된다.

# #04. 플러그인 설치

## 1. 문법 강조 플러그인 설치

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

![plugin1](/images/posts/2022/0905/plugin1.png)

## 2. 명령어 자동 완성 플러그인 설치

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

![plugin2](/images/posts/2022/0905/plugin2.png)


# #05. 초기화 파일 수정하기

설치 완료 후 vi에디터로 zsh 설정파일을 연다.

```bash
vi ~/.zshrc
```

## 1. theme 변경

아래와 같이 표시되는 곳을 찾아 사용하고자 하는 테마로 변경한다.

![theme](/images/posts/2022/0905/theme.png)

### 변경후

```bash
ZSH_THEME="af-magic"
```

그 밖에 다양한 테마를 확인하기 위해서는 아래의 URL에 방문해 보도록 하자.

[https://github.com/ohmyzsh/ohmyzsh/wiki/Themes](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)

## 2. 설정 파일의 플러그인 설정 추가

아래와 같이 표시되는 곳을 찾아 설치한 플러그인들의 이름을 추가한다.

![plugin](/images/posts/2022/0905/plugin.png)

### 변경 후

```bash
plugins=(  
	git  
	zsh-syntax-highlighting   # 추가  
	zsh-autosuggestions       # 추가
)
```

## 3. 저장하기

`ESC`키를 눌러 명령어 모드로 전환한 후 `wq`를 입력하고 엔터를 누른다

![save](/images/posts/2022/0905/save.png)

# #06. 설정내용 반영하기

설정 완료 후 다음의 명령어로 설정내용을 반영한다.

```
source ~/.zshrc
```