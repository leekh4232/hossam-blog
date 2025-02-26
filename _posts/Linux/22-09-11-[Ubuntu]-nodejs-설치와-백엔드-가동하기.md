---
layout: post
title:  "[Ubuntu] Node.js 설치와 백엔드 가동하기"
date:   2022-09-11
banner_image: index-ubuntu.png
tags: [Linux]
---

전통적인 웹 프로그래밍 플랫폼은 ASP, PHP, JSP를 많이 사용했지만 최근에는 ASP.NET, Codeigniter(PHP), Laravel(PHP), Spring(Java)등의 Framework가 대세가 되었습니다. 이 흐름에 Javascript도 Node.js를 통해 뛰어들었습니다.

Node.js를 기반으로 구현되는 백엔드 시스템은 Express라는 Framework를 주로 사용합니다. 이 글에서는 Express를 기반으로 구현된 백엔드 시스템을 Ubuntu에서 구동하기 위한 절차를 소개합니다.

<!--more-->

# #01. NVM 설치하기

## 1. NVM이란?

NVM(Node Version Manager)은 Node.js의 버전을 관리하는 도구

협업을 할 때, 또는 다양한 프로젝트를 동시에 진행해야 할 때 다양한 라이브러리/프레임워크/개발툴의 버전 호환 문제를 겪게 되는데 NVM은 이러한 문재를 해결해 준다.

- 컴퓨터에 다양한 버전의 Node.js 를 설치할 수 있게 함
- use 커맨드를 이용해 사용할 Node 버전으로 간단하게 스위칭할수 있음
- 버전 관리가 손쉬움
  - 기본 버전 설정
  - 설치한 버전의 전체 리스트 확인
  - 불필한 버전 삭제

## 2. 리눅스에 NVM 설치하기

### 1) NVM 설치 명령 확인

NVM 공식사이트를 통해 설치 명령어를 확인한다. 

[https://github.com/nvm-sh/nvm#installing-and-updating](https://github.com/nvm-sh/nvm#installing-and-updating)

버전이 변경될시 설치 스크립트의 파일명이 변경될 수 있으므로 가급적 고정된 명령어를 사용하지 말고 공식 사이트를 통해 제시되는 명령어를 확인하는 것이 좋다.

![](/images/posts/2022/0911/install01.png)

### 2) NVM 설치하기

리눅스에 일반 사용자 권한으로 로그인 한 상태로 설치 스크립트를 수행한다. (쉘 스크립트를 wget명령으로 내려받아 실행하는 형태)

> root권한이 아님

![](/images/posts/2022/0911/install02.png)

### 3) 설치 결과 확인

설치 완료를 확인하기 위해 버전을 확인한다.

```shell
$ nvm --version
```

![](/images/posts/2022/0911/install03.png)

## 3. NVM을 사용한 Node 버전 관리

### 1) 최신 버전 설치하기

```shell
$ nvm install
```

### 2) 특정 버전 설치하기

#### 구문 형식

```shell
$ nvm install 버전
```

#### 사용 예시

```shell
$ nvm install 12.22.9
```

### 3) 설치되어 있는 Node 목록 확인하기

버전이 여러개 나오고 특정 버전 앞에 * 표시가 있다면 현재 * 표시 버전이 사용중인 상태임

```shell
$ nvm ls
```

### 4) 특정 버전으로 변경하기

#### 구문 형식

```shell
$ nvm use 버전
```

#### 사용 예시

```shell
$ nvm use 12.22.7
```

### 5) 설치한 특정 노드버전 삭제

#### 구문 형식

```shell
$ nvm uninstall 버전
```

#### 사용 예시

```shell
$ nvm uninstall 12.22.6
```

### 5) node 설치 경로 확인

```shell
$ which node
```


# #02. Node.js 설치하기

## 1. Node.js 설치

NVM을 사용하여 Node를 설치한다. 기본적으로 가장 최신 버전을 설치하게 된다.

```shell
$ nvm install node
```

![](/images/posts/2022/0911/install04.png)

## 2. 설치 결과 확인

node와 npm의 버전을 각각 확인한다.

```shell
$ node --version
$ npm --version
```

![](/images/posts/2022/0911/install05.png)


## 3. Yarn 설치하기

Yarn은 Node.js 자바스크립트 런타임 환경을 위해 페이스북이 2016년 개발한 소프트웨어 패키지 시스템

npm 패키지 관리자의 대안으로서 대형 코드의 일관성, 보안, 성능 문제를 해결하고자 개발됨

```shell
$ npm install -g yarn
```

![](/images/posts/2022/0911/install06.png)

# #03. Express 기반 백엔드 가동하기

## 1) 환경변수 추가하기

백엔드 프로세스에 상용 시스템임을 알리기 위해 쉘 초기화 파일에 환경변수를 추가해야 한다.

vi에디터로 zsh쉘의 초기화 파일을 연다.

```shell
$ vi ~/.zshrc
```

초기화 파일에 NODE_ENV 환경변수를 "production"으로 지정한다.

```
export NODE_ENV="production"
```

## 2) 소스코드 업로드

FTP등의 프로그램을 사용하여 완성된 Express 백엔드 프로젝트를 Linux의 적절한 위치에 업로드한다.

이 때 `node_modules` 디렉토리는 업로드하지 않는다.

`package.json`은 반드시 포함되어야 한다.

여기서는 `~/myweb` 경로에 업로드 하였다.

> git등을 통해 저장소에서 clone받아도 같은 결과를 얻을 수 있다.

![](/images/posts/2022/0911/upload.png)

## 3) 패키지 설치하기

프로젝트 폴더 안에서 `package.json`에 명시된 패키지를 일괄 설치한다.

```shell
$ yarn install
```

![](/images/posts/2022/0911/module.png)

## 4) 포트 개방하기

백엔드에서 사용중인 포트번호에 대한 접근을 허용한다.

### 구문형식

```shell
$ sudo ufw allow 포트번호/tcp
```

### 사용 예시

```shell
$ sudo ufw allow 3001/tcp
```

> 여기서는 3001번 포트를 사용하지만 실제 상용 서비스를 운영하기 위해서는 http 프로토콜의 기본 포트인 80번 포트를 사용해야 한다.

![](/images/posts/2022/0911/port1.png)

## 3) 방화벽 새로고침

```shell
$ sudo ufw reload
```

![](/images/posts/2022/0911/port2.png)

## 4) 방화벽 상태 확인

```shell
$ sudo ufw status
```

![](/images/posts/2022/0911/port3.png)

## 5) 백엔드 시작하기

시작 파일이 위치한 디렉토리에서 프로그램을 가동한다.

```shell
$ node app.js
```

![](/images/posts/2022/0911/node-start.png)

## 6) 백엔드 접속 테스트

Insomnia 등의 클라이언트 프로그램으로 정상 동작을 확인한다.

![](/images/posts/2022/0911/test.png)

## 7) 로그 확인

터미널을 통해 출력되는 로그를 확인한다.

![](/images/posts/2022/0911/log.png)

> 종료를 위해서는 `Ctrl+C`를 누른다. 이 상태에서는 리눅스에서 로그아웃하면 백엔드도 종료된다.

# #04. PM2

PM2는 Node.js 어플리케이션을 쉽게 관리할 수 있게 해주는 Process Manager

Node.js 어플리케이션을 cluster mode 로 실행시킨다거나, 메모리가 넘친다거나, 오류로 인해 프로세스가 종료되는 등의 상황에 직면했을 때 간단한 설정만로도 이러한 처리를 손쉽게 해결할 수 있다.

## 1. PM2 설치하기

```shell
$ npm install -g pm2
```

![](/images/posts/2022/0911/install07.png)

## 2. PM2를 사용한 Express 프로그램 가동하기

```shell
$ pm2 start 시작스크립트이름
```

![](/images/posts/2022/0911/pm2_1.png)


## 2. PM2를 통해 관리되는 Express 프로그램 목록 보기

```shell
$ pm2 list
```

![](/images/posts/2022/0911/pm2_2.png)

## 2. PM2를 통해 관리되는 Express 프로그램중 특정 항목 중지

```shell
$ pm2 stop id번호
```

![](/images/posts/2022/0911/pm2_3.png)


## 2. PM2를 통해 관리되는 Express 프로그램중 특정 항목 시작

한번 가동했던 프로그램은 PM2에 등록되기 때문에 현재 작업중인 디렉토리 위치에 상관 없이 id번호를 통해 시작/중지가 가능하다.

```shell
$ pm2 start id번호
```

![](/images/posts/2022/0911/pm2_4.png)