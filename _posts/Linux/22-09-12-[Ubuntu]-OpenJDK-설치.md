---
layout: post
title:  "[Ubuntu] OpenJDK 설치"
date:   2022-09-12
banner_image: index-ubuntu.png
tags: [Linux]
---

Java로 개발된 프로그램이 구동되기 위해서는 구동 환경에 맞는 Java Virtual Machine이 미리 설치되어 있어야 합니다. JDK에는 Java Compiler와 Java Virtual Machine이 포함되어 있기 때문에 Java로 구현된 프로그램을 구동하기 위해서는 사전에 반드시 설치되어야 하는 요소 입니다.

<!--more-->

# #01. apt 업데이트

아래의 명령을 실행하여 apt의 패키지 리스트를 업데이트 합니다.

```shell
$ sudo apt-get update
```

# #02. 설치 가능한 JDK 목록 확인하기

아래의 명령은 설치 가능한 OpenJDK의 목록을 보여줍니다.

```shell
$ sudo apt-cache search openjdk
```

하지만 JDK외에 Document, Source등의 목록도 함께 보여주기 때문에 출력 결과가 너무 길어서 내용을 확인하기 어렵습니다. JDK만 확인하기 위해 `| grep Developement`를 적용하여 결과를 필터링 합니다.

```shell
$ sudo apt-cache search openjdk | grep Development
```

현재 확인되는 가장 최신 버전은 `JDK 19`로 나타납니다. 이 버전을 설치하도록 하겠습니다.

![jdk1](/images/posts/2022/0912/jdk1.png)

## 주의!!!

> 여기서는 JDK 19를 설치하지만 SpringBoot 가동을 목적으로 한다면 JDK 17버전이 더 안정적입니다.

# #03. JDK 설치하기

아래 명령으로 JDK를 설치합니다. 다소 시간이 소요됩니다.

```shell
$ sudo apt-get install openjdk-19-jdk
```

# #04. 환경변수 설정하기

## 1. JDK 설치 경로 확인

### `java` 명령어의 위치 찾기

아래의 명령은 `java`라는 이름을 갖는 파일의 위치를 표시합니다.

```shell
$ which java
```

해당 명령어의 경로가 출력됩니다.

![jdk2](/images/posts/2022/0912/jdk2.png)

### 출력 결과에 대한 파일 종류 확인

출력된 경로에 대한 `ls -l` 명령을 수행하여 파일 종류를 확인해 봅니다.

```shell
$ ls -l /usr/bin/java
```

파일 목록을 확인해 보니 링크파일임을 확인할 수 있습니다.

![jdk3](/images/posts/2022/0912/jdk3.png)

### 링크 파일의 실제 위치 확인

`readlink -f 링크파일경로` 명령어는 링크 파일이 가르키는 원본 파일의 위치를 출력합니다.

리눅스 명령어 사용시 파라미터를 전달해야 할 경우 `$(명령어)` 형식을 사용하면 다른 명령어의 출력 결과를 파라미터값으로 사용할 수 있습니다.

```shell
$ readlink -f $(which java)
```

이제 아래와 같이 JAVA 명령어의 실제 경로를 확인할 수 있습니다.

![jdk4](/images/posts/2022/0912/jdk4.png)

위의 출력 결과를 통해 다음과 같이 값을 확인하였습니다.

| 환경변수 | 경로 |
|:--:|--|
| JAVA_HOME | `/usr/lib/jvm/java-19-openjdk-arm64` |
| PATH | `/usr/lib/jvm/java-19-openjdk-arm64/bin` |

### 쉘 초기화 파일에 환경변수 추가

vi 에디터로 쉘 초기화 파일을 편집합니다.

#### bash-shell을 사용할 경우

```shell
$ vi ~/.bashrc
```

#### zsh-shell을 사용할 경우

```shell
$ vi ~/.zshrc
```

#### 초기화 파일 수정

초기화 파일의 맨 아래에 아래와 같이 입력하고 저장합니다.

> 각자의 환경에서 출력되는 값을 확인하세요. 본 포스팅의 경로와 다를 수 있습니다.<br/>
> 본 포스팅을 위해 작업을 진행한 장비는 MacOS에 탑재된 Parallels VM 환경이므로 CPU의 종류가 ARM64 입니다.<br/>
> 윈도우 OS 기반인 경우 CPU의 종류가 다르기 때문에 jdk의 버전 명이 다를 수 있음에 유의하시기 바랍니다.

```shell
export JAVA_HOME=/usr/lib/jvm/java-19-openjdk-arm64
export PATH=$PATH:$JAVA_HOME/bin
```

### 쉘 초기화 파일 reload

#### bash-shell을 사용할 경우

```shell
$ source ~/.bashrc
```

#### zsh-shell을 사용할 경우

```shell
$ source ~/.zshrc
```

# #04. 설치 결과 확인

아래의 명령어로 javac의 버전을 확인해 봅니다.

```shell
$ javac --version
```

![jdk5](/images/posts/2022/0912/jdk5.png)