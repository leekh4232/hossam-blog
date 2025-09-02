---
title:  "Ubuntu 사용자 계정에 Tomcat 설치"
description: "리눅스의 사용자 계정에 종속되는 톰켓 설치 방법입니다. root 권한을 사용하지 않고 사용자별로 개별 웹 사이트를 운영할 수 있기 때문에 권장되는 방법입니다."
categories: [02.Operating System,Linux,Ubuntu]
tags: [Operating System,Linux,Ubuntu,Java,Tomcat]
image: /images/indexs/ubuntu.png
date: 2022-09-14 10:04:19 +0900
author: Hossam
pin: true
math: true
mermaid: true
---

# Ubuntu 사용자 계정에 Tomcat 설치

## #01. 기존의 Tomcat 삭제하기

만약 이전 포스팅을 통해서 Tomcat을 샌드박스 형태로 설치한 상황이라면 아래의 명령어를 순차적으로 수행해서 제거합니다.

```bash
# 부팅시 자동 시작 해제
$ sudo systemctl disable tomcat10

# 서비스 중지
$ sudo systemctl stop tomcat10

# Tomcat10 제거
$ sudo purge -y tomcat10
```

## #02. Tomcat10 설치하기

### 1. Tomcat 내려받기

[https://tomcat.apache.org/download-10.cgi](https://tomcat.apache.org/download-10.cgi)에서 Tomcat의 **tar.gz** 형식의 다운로드 URL을 확인합니다.

> https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.44/bin/apache-tomcat-10.1.44.tar.gz

여기서는 사용자 홈 디렉토리에서 진행합니다.

```bash
$ pwd
/home/leekh
```

리눅스 터미널에 톰켓을 운영할 사용자 계정으로 접속 후 아래의 명령으로 다운로드 받습니다.

```bash
$ wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.44/bin/apache-tomcat-10.1.44.tar.gz
```

### 2. Tomcat 압축 해제

```bash
$ tar -xzvf apache-tomcat-10.1.44.tar.gz
```

압축이 해제된 폴더를 확인합니다.

```bash
$ ls -l
합계 12345
# ...
-rw-r--r--  1 leekh leekh 12345678  3월  3 12:34 apache-tomcat-10.1.44.tar.gz
drwxr-xr-x  9 leekh leekh     4096  3월  3 12:35 apache-tomcat-10.1.44
# ...
```

### 3. Tomcat 서비스 등록하기

#### 서비스 설정 파일 생성

`systemctl` 명령으로 실행할 수 있는 서비스 설정 파일을 직접 생성해야 합니다.

```bash
# vi /etc/systemd/system/생성할서비스이름.service
$ vi /etc/systemd/system/tomcat10-leekh.service
```

VI 에디터가 열리면 다음의 내용을 입력합니다.

```ini
[Unit]
Description={간단한 설명글}
After=network.target

[Service]
Type=forking

User={사용자계정}
Group={사용자그룹, 일반적으로 계정명과 동일}

Environment=CATALINA_HOME={TOMCAT설치경로}
Environment=CATALINA_BASE={TOMCAT설치경로}

ExecStart={TOMCAT설치경로}/bin/startup.sh
ExecStop={TOMCAT설치경로}/bin/shutdown.sh

Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

여기서는 사용자 계정명이 `leekh`이므로 아래와 같이 설정했습니다.

```ini
[Unit]
Description=Tomcat for user leekh
After=network.target

[Service]
Type=forking

User=leekh
Group=leekh

Environment=CATALINA_HOME=/home/leekh/apache-tomcat-10.1.44
Environment=CATALINA_BASE=/home/leekh/apache-tomcat-10.1.44

ExecStart=/home/leekh/apache-tomcat-10.1.44/bin/startup.sh
ExecStop=/home/leekh/apache-tomcat-10.1.44/bin/shutdown.sh

Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

#### 서비스 등록하기

```bash
# 서비스 설정파일 갱신
$ sudo systemctl daemon-reload

# 서비스 부팅시 자동 실행 등록
$ sudo systemctl enable tomcat10-leekh

# 서비스 가동하기
$ sudo systemctl start tomcat10-leekh

# 서비스 동작 확인
$ systemctl status tomcat-leekh
```

이 단계까지 진행하면 리눅스 외부에서 `http://리눅스아이피:8080`으로 접속했을 때 Tomcat의 Welcom 페이지가 표시됩니다. 단, 접속을 위해 8080번 포트의 방화벽을 열어줘야 합니다.

```bash
# 8080번 방화벽 해제
$ sudo ufw allow 8080/tcp

# 방화벽 갱신
$ sudo ufw reload

# 방화벽 상태 확인
$ sudo ufw status
```