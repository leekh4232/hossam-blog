---
layout: post
title:  "[Mac] 개발서버 구축기 (6) - Code Server"
date:   2024-07-27
banner_image: index-mac-studio.jpg
tags: [Mac]
---

Mac Studio를 구입하면서 노트북을 처분했다. 나는 대부분 강의실에 있기 때문에 윈도우에서 VSCode를 통해 SSH 원격 접속을 하면 집에 있는 컴퓨터를 사용할 수 있지만 아이패드만 가지고 외출했다가 급히 코드를 확인해야 할 일이 생길 경우를 대비해서 웹 브라우저로 접근 가능한 VSCode를 설치했다.

<!--more-->

# #01. Code-Server 설치

Homebrew를 사용하여 설치한다.

```shell
$ brew install code-server
```

# #02. 서비스 구동 및 정지

```shell
# 시작 스크립트
$ brew services start code-server

# 종료 스크립트
$ brew services stop code-server
```


# #03. 환경설정

`~/.config/code-server/config.yaml` 파일을 열어 다음과 같이 수정한다.

```yaml
bind-addr: home.hossam.kr:9903
auth: password
password: 사용할_비밀번호_설정
cert: /Users/leekh/.ssl/live/home.hossam.kr/fullchain.pem
cert-key: /Users/leekh/.ssl/live/home.hossam.kr/privkey.pem
```

접근 가능한 도메인, 포트번호, 인증방식(password)과 비밀번호, SSL 인증서의 경로를 지정했다.