---
layout: post
title:  "[Ubuntu] SSH 서비스 설정"
date:   2022-09-09
banner_image: index-ubuntu.png
tags: [Linux]
---

SSH 서비스는 전송되는 데이터가 암호화 처리되는 보안이 강화된 원격 접속 서비스로서 대부분의 경우 Ubuntu 리눅스를 설치하는 과정에서 기본으로 탑재 됩니다. 과거에 사용되던 텔넷(Telnet) 방식의 경우 모든 데이터가 암호화 되지 않고 전송되어 악의적인 목적을 갖는 공격자가 중간에 패킷을 가로채어 분석 후 해킹을 시도할 수 있으므로 현재는 사용되지 않고 있습니다. SSH는 Telnet의 대안으로 현재 활발히 사용되고 있는 원격접속 방법 입니다.

<!--more-->

# #01. SSH의 이해

![ssh](/images/posts/2022/0909/ssh.png)

# #02. SSH 서비스 작동 확인

우분투 리눅스를 설치하는 과정에서 이미 SSH 서비스를 설치하여 사용하고 있으므로 정상 동작 여부만 확인하면 된다.

## 1. SSH 서비스 동작 여부 확인하기

```shell
$ sudo systemctl status sshd
```

![sshd](/images/posts/2022/0909/ssh-status.png)

## 2. 부팅시 자동 실행 여부 확인하기

```shell
$ sudo systemctl list-unit-files | grep sshd
```

![sshd](/images/posts/2022/0909/ssh-list-unit-file.png)

# #03. SSH 보안 설정

- SSH는 기본 포트번호 22번을 사용하고 있기 때문에 이를 임의의 포트로 변경한다.
- 시스템의 모든 권한을 갖는 root계정에 대한 SSH 직접 접속을 차단하고 일반 사용자로만 접근이 가능하도록 해야 한다.

## 1. 환경설정파일 열기

```shell
$ sudo vi /etc/ssh/sshd_config
```

## 2. 환경설정파일에 아래의 내용 추가

> 대소문자 구분과 이름과 값 사이에 `=`표시가 없음에 주의한다.

```text
# 기본 접속 포트 설정
Port 9901

# root 계정의 직접 로그인 차단
PermitRootLogin no
```

## 3. SSH 서비스 재시작

```shell
$ sudo systemctl restart sshd
```

## 4. 방화벽 포트 설정

기본 포트로 사용중이던 22번을 삭제하고 새로 설정한 9901을 허용한다.

```shell
$ sudo ufw delete allow 22
$ sudo ufw allow 9901/tcp
```

![](/images/posts/2022/0909/port.png)

## 5. 방화벽 규칙 다시 로드하기

```shell
$ sudo ufw reload
```

## 6. 방화벽 규칙 확인

```shell
$ sudo ufw status
```

![](/images/posts/2022/0909/9901.png)

# #04. 외부에서의 접속 확인

Window, Mac 등의 호스트 운영체제에서 Ubuntu로 SSH 접속을 시도한다. 이 때 변경된 포트번호를 명시해야 한다.

```shell
$ ssh 계정명@리눅스아이피 -p포트번호
```

### root로 로그인이 되지 않음을 확인

비밀번호를 올바르게 입력하더라도 권한이 없다는 에러 메시지가 표시된다.

![nologin](/images/posts/2022/0909/noroot.png)

### 일반 사용자 계정으로 정상 접속 확인

![nologin](/images/posts/2022/0909/loginok.png)


# #05. SSH 인증키를 사용한 로그인 설정

SSH 키는 공개키 암호화 방식을 사용하는 방식이다.

비공개 서버에 접속하기 위해서는 인증절차를 거쳐야 하는데, 네트워크를 통해 비밀번호를 전송하는 기존의 인증 방식은 네트워크 상에서 ID/비밀번호가 그대로 노출되는 문제가 있고, 접속할 때마다 입력해야 하는 번거로움이 있다.

SSH 키는 이와 달리 공개키 암호 방식을 사용하여 서버에서 인증받을 수 있으며, 암호를 생략하고 원격 호스트로 접속할 수 있다.

인증키는 서버에서 생성하거나 접속할 클라이언트 컴퓨터에서 모두 생성할 수 있다.

## 1) 인증키 관련 파일

인증키 이름이 `helloworld` 라고 가정할 경우 인증키와 공개키가 일치해야만 로그인이 이루어진다.

| 파일 | 설명 |
|---|---|
| helloworld | 클라이언트 운영체제의 `~/.ssh` 디렉토리에 보관되어야 할 인증키 파일 |
| helloworld.pub | 서버 운영체제에서 접속할 사용자 계정 홈 디렉토리의 `~/.ssh` 위치에 보관되어야 할 공개키 파일 |
| authorized_keys | 서버 운영체제에서 접속할 사용자 계정 홈 디렉토리의 `~/.ssh` 위치에 존재해야 하며 공개키 파일의 내용을 이 파일에 등록해야 한다. 인증키나 공개키 파일이름에 상관 없이 고유한 파일명을 갖는다. |

## 2) 서버 운영체제에서 인증서 생성하기

서버 운영체제에 인증키 생성을 원하는 계정으로 로그인한 후 아래의 명령어를 수행한다.

```shell
$ ssh-keygen
```

![ssk-keygen](/images/posts/2022/0909/ssh-keygen.png)

1. 명령어 입력
2. 인증키 파일의 경로 입력 (따로 입력하지 않을 경우 id_rsa로 파일명이 고정된다. 다른 인증키와 구분하기 위해서는 가급적 파일이름을 지정해 주는 것이 좋다.)
3. 인증키 비밀번호 (입력하지 않고 엔터)
4. 인증키 비밀번호 확인

> 인증키 파일을 클라이언트가 보관하고 인증키를 접속하려는 대상(서버 운영체제, github등)에 보관하는 원리이다.

<div style="page-break-after: always; visibility: hidden">\pagebreak</div>

## 3) 생성된 인증키 확인

`~/.ssh` 폴더 안에 인증키가 생성된 것을 확인한다.

![ssk-keygen](/images/posts/2022/0909/ls.png)

## 4) 공개키 파일의 내용을 `authorized_keys`에 등록

```shell
$ cat ~/.ssh/myserver.pub >> ~/.ssh/authorized_keys
```

## 5) 생성된 인증키 파일을 클라이언트 운영체제에 내려받기

FTP 클라이언트를 사용하여 생성된 인증키 파일을 내려받는다.

![ssk-keygen](/images/posts/2022/0909/download.png)

1. `~/.ssh` 디렉토리는 숨김 상태이므로 FTP 클라이언트에 표시되지 않는다. 직접 폴더 경로를 입력해서 이동해야 한다.
2. 클라이언트 운영체제의 사용자 홈 디렉토리내에 있는 `.ssh` 폴더에 다운로드 받도록 FTP 클라이언트를 조정한다.
3. 인증키 파일을 내려받는다.


## 6) Mac 운영체제에서 인증키를 내려받은 경우

만약 `.ssh` 폴더가 없다면 직접 생성한다.

```shell
$ mkdir ~/.ssh
```

폴더 생성 후 이 폴더의 접근 퍼미션을 `0700`으로 설정해야 한다. (윈도우에서는 퍼미션 설정을 생략한다.)

```shell
$ chmod 0700 ~/.ssh
```

`~/.ssh/myserver` 위치로 인증키를 내려받았다면 인증키 파일의 접근 퍼미션을 `0600`으로 설정해야 한다. (윈도우에서는 퍼미션 설정을 생략한다.)

```shell
$ chmod 0600 ~/.ssh/myserver
```

![permission](/images/posts/2022/0909/permission.png)

<div style="page-break-after: always; visibility: hidden">\pagebreak</div>

## 7) 클라이언트 운영체제에서 접속 확인

아래의 명령어로 ssh 접속을 시도한다. 인증서가 정상적으로 식별되었다면 비밀번호 입력 없이 바로 로그인이 진행된다.

```shell
$ ssh 계정명@리눅스아이피 -p포트번호 -i인증키경로
```

![nopwd](/images/posts/2022/0909/nopwd.png)

클라이언트 운영체제가 Mac인 경우 이 명령어를 쉘 초기화파일에 alias로 등록하면 더욱 간편하게 사용할 수 있다.

> 서버에서 생성한 공개키 파일(*.pub)파일을 내려받아 이 내용을 github에 등록하면 하나의 인증서로 github과 리눅스 서버를 동시에 접근할 수 있다.