---
layout: post
title:  "[Mac] OpenJDK 설치하기"
date:   2023-07-13
banner_image: index-mac.jpg
tags: [Mac,JAVA]
---

JDK(Java Development Kit)은 Java 컴파일러와 Java Virtual Machine을 포함하는 자바 프로그래밍의 필수 도구 입니다. 

Oracle JDK와 Open JDK 두 종류가 있지만 Oracle JDK는 라이센스 문제로 인해 최근에는 Open JDK를 주로 사용하고 있습니다.

<!--more-->

# #01. 설치 가능한 JDK 버전 확인하기

```shell
$ brew search jdk
```

아래와 같이 설치 가능한 버전이 표시된다.

![img](/images/posts/2023/0713/jdk1.png)

가장 첫 번째 항목으로 표시되는 `jdk`가 최신버전이며 2023년 07월 기준으로 brew 웹 사이트에서 JDK 20임이 표시되어 있다.

그 외에 설치 가능한 다른 버전들도 표기되어 있다.

![img](/images/posts/2023/0713/jdk2.png)

## 버전별 설치 명령어

| 버전 | 명령어 |
|---|---|
| JDK 20 | brew install openjdk |
| JDK 17 | brew install openjdk@17 |
| JDK 11 | brew install openjdk@11 |
| JDK 8 | brew install openjdk@8 |

그 외의 다른 버전은 아래의 명령으로 저장소를 추가한 후에 확인할 수 있다.

> 2024년 07월 10일 기준 `brew install openjdk`의 기본 버전이 22로 변경되었다.

### 저장소 추가

```shell
$ brew tap AdoptOpenJDK/openjdk
```

> 여기서는 이 과정을 굳이 진행할 필요는 없다.

# #02. JDK 설치하기

```shell
$ brew install openjdk
```

> 2024년 07월 10일 기준 `brew install openjdk`의 기본 버전이 22로 변경되었다.

# #03. 환경변수 설정하기

## 초기화 파일 열기

vi 에디터로 쉘 초기화 파일을 연다

```shell
$ vi ~/.zshrc
```

## 내용 편집하기

brew를 통해 설치한 JDK는 `/opt/homebrew/opt/openjdk` 경로에 위치한다. 이 경로를 `JAVA_HOME` 변수로 추가하고 `$JAVA_HOME/bin` 경로를 `PATH` 환경 변수에 추가한다.

```profile
export JAVA_HOME="/opt/homebrew/opt/openjdk"
export PATH=$PATH:$JAVA_HOME/bin
```

내용을 추가했으면 `ESC`, `:`, `wq`를 차례로 눌러서 저장하고 종료한다.

![img](/images/posts/2023/0713/jdk3.png)

## 초기화 파일 리로드

```shell
$ source ~/.zshrc
```

# #03. 결과 확인하기

아래 명령어를 통해 설치된 JDK 버전이 확인되면 완료된 것이다.

```shell
$ javac --version
```

![img](/images/posts/2023/0713/jdk4.png)