---
title:  "Ubuntu의 SSH 서비스 설정"
description: "SSH 서비스는 전송되는 데이터가 암호화 처리되는 보안이 강화된 원격 접속 서비스로서 대부분의 경우 Ubuntu 리눅스를 설치하는 과정에서 기본으로 탑재 됩니다. 과거에 사용되던 텔넷(Telnet) 방식의 경우 모든 데이터가 암호화 되지 않고 전송되어 악의적인 목적을 갖는 공격자가 중간에 패킷을 가로채어 분석 후 해킹을 시도할 수 있으므로 현재는 사용되지 않고 있습니다. SSH는 Telnet의 대안으로 현재 활발히 사용되고 있는 원격접속 방법 입니다."
categories: [02.Operating System,Linux,Ubuntu]
tags: [Operating System,Linux,Ubuntu,SSH]
image: /images/index-ubuntu.png
date: 2022-09-09 10:04:19 +0900
author: Hossam
pin: true
math: true
mermaid: true
---

## #01. SSH의 이해

![ssh](/images/2022/0909/ssh.png)

## #02. SSH 서비스 작동 확인

우분투 리눅스를 설치하는 과정에서 이미 SSH 서비스를 설치하여 사용하고 있으므로 정상 동작 여부만 확인하면 된다.

### 1. SSH 서비스 동작 여부 확인하기

```shell
$ sudo systemctl status sshd
```

![sshd](/images/2022/0909/ssh-status.png)

### 2. 부팅시 자동 실행 여부 확인하기

```shell
$ sudo systemctl list-unit-files | grep sshd
```

![sshd](/images/2022/0909/ssh-list-unit-file.png)

## #03. SSH 보안 설정

- SSH는 기본 포트번호 22번을 사용하고 있기 때문에 이를 임의의 포트로 변경한다.
- 시스템의 모든 권한을 갖는 root계정에 대한 SSH 직접 접속을 차단하고 일반 사용자로만 접근이 가능하도록 해야 한다.

### 1. 환경설정파일 열기

```shell
$ sudo vi /etc/ssh/sshd_config
```

### 2. 환경설정파일에 아래의 내용 추가

> 대소문자 구분과 이름과 값 사이에 `=`표시가 없음에 주의한다.

```text
## 기본 접속 포트 설정
Port 9901

## root 계정의 직접 로그인 차단
PermitRootLogin no
```

### 3. SSH 서비스 재시작

```shell
$ sudo systemctl restart sshd
```

### 4. 방화벽 포트 설정

기본 포트로 사용중이던 22번을 삭제하고 새로 설정한 9901을 허용한다.

```shell
$ sudo ufw delete allow 22
$ sudo ufw allow 9901/tcp
```

![](/images/2022/0909/port.png)

### 5. 방화벽 규칙 다시 로드하기

```shell
$ sudo ufw reload
```

### 6. 방화벽 규칙 확인

```shell
$ sudo ufw status
```

![](/images/2022/0909/9901.png)

## #04. 외부에서의 접속 확인

Window, Mac 등의 호스트 운영체제에서 Ubuntu로 SSH 접속을 시도한다. 이 때 변경된 포트번호를 명시해야 한다.

```shell
$ ssh 계정명@리눅스아이피 -p포트번호
```

#### root로 로그인이 되지 않음을 확인

비밀번호를 올바르게 입력하더라도 권한이 없다는 에러 메시지가 표시된다.

![nologin](/images/2022/0909/noroot.png)

#### 일반 사용자 계정으로 정상 접속 확인

![nologin](/images/2022/0909/loginok.png)


## #05. SSH 인증키를 사용한 로그인 설정

SSH 키는 공개키 암호화 방식을 사용하는 방식이다.

비공개 서버에 접속하기 위해서는 인증절차를 거쳐야 하는데, 네트워크를 통해 비밀번호를 전송하는 기존의 인증 방식은 네트워크 상에서 ID/비밀번호가 그대로 노출되는 문제가 있고, 접속할 때마다 입력해야 하는 번거로움이 있다.

SSH 키는 이와 달리 공개키 암호 방식을 사용하여 서버에서 인증받을 수 있으며, 암호를 생략하고 원격 호스트로 접속할 수 있다.

인증키는 서버에서 생성하거나 접속할 클라이언트 컴퓨터에서 모두 생성할 수 있다.

### 1) 인증키 관련 파일

인증키 이름이 `helloworld` 라고 가정할 경우 인증키와 공개키가 일치해야만 로그인이 이루어진다.

| 파일            | 설명                                                                                                                                                                                        |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| helloworld      | 클라이언트 운영체제의 `~/.ssh` 디렉토리에 보관되어야 할 인증키 파일                                                                                                                         |
| helloworld.pub  | 서버 운영체제에서 접속할 사용자 계정 홈 디렉토리의 `~/.ssh` 위치에 보관되어야 할 공개키 파일                                                                                                |
| authorized_keys | 서버 운영체제에서 접속할 사용자 계정 홈 디렉토리의 `~/.ssh` 위치에 존재해야 하며 공개키 파일의 내용을 이 파일에 등록해야 한다. 인증키나 공개키 파일이름에 상관 없이 고유한 파일명을 갖는다. |

### 2) 서버 운영체제에서 인증서 생성하기

서버 운영체제에 인증키 생성을 원하는 계정으로 로그인한 후 아래의 명령어를 수행한다.

```shell
$ ssh-keygen
```

![ssk-keygen](/images/2022/0909/ssh-keygen.png)

1. 명령어 입력
2. 인증키 파일의 경로 입력 (따로 입력하지 않을 경우 id_rsa로 파일명이 고정된다. 다른 인증키와 구분하기 위해서는 가급적 파일이름을 지정해 주는 것이 좋다.)
3. 인증키 비밀번호 (입력하지 않고 엔터)
4. 인증키 비밀번호 확인

> 인증키 파일을 클라이언트가 보관하고 인증키를 접속하려는 대상(서버 운영체제, github등)에 보관하는 원리이다.

<div style="page-break-after: always; visibility: hidden">\pagebreak</div>

### 3) 생성된 인증키 확인

`~/.ssh` 폴더 안에 인증키가 생성된 것을 확인한다.

![ssk-keygen](/images/2022/0909/ls.png)

### 4) 공개키 파일의 내용을 `authorized_keys`에 등록

```shell
$ cat ~/.ssh/myserver.pub >> ~/.ssh/authorized_keys
```

### 5) 생성된 인증키 파일을 클라이언트 운영체제에 내려받기

FTP 클라이언트를 사용하여 생성된 인증키 파일을 내려받는다.

![ssk-keygen](/images/2022/0909/download.png)

1. `~/.ssh` 디렉토리는 숨김 상태이므로 FTP 클라이언트에 표시되지 않는다. 직접 폴더 경로를 입력해서 이동해야 한다.
2. 클라이언트 운영체제의 사용자 홈 디렉토리내에 있는 `.ssh` 폴더에 다운로드 받도록 FTP 클라이언트를 조정한다.
3. 인증키 파일을 내려받는다.


### 6) Mac 운영체제에서 인증키를 내려받은 경우

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

![permission](/images/2022/0909/permission.png)

<div style="page-break-after: always; visibility: hidden">\pagebreak</div>

### 7) 클라이언트 운영체제에서 접속 확인

아래의 명령어로 ssh 접속을 시도한다. 인증서가 정상적으로 식별되었다면 비밀번호 입력 없이 바로 로그인이 진행된다.

```shell
$ ssh 계정명@리눅스아이피 -p포트번호 -i인증키경로
```

![nopwd](/images/2022/0909/nopwd.png)

클라이언트 운영체제가 Mac인 경우 이 명령어를 쉘 초기화파일에 alias로 등록하면 더욱 간편하게 사용할 수 있다.

> 서버에서 생성한 공개키 파일(*.pub)파일을 내려받아 이 내용을 github에 등록하면 하나의 인증서로 github과 리눅스 서버를 동시에 접근할 수 있다.

## #06. SSH 고급 보안 설정

### 1. 추가 보안 설정 옵션

```shell
$ sudo vi /etc/ssh/sshd_config
```

다음 설정들을 추가하거나 수정합니다:

```bash
# 프로토콜 버전 지정 (보안상 2만 사용)
Protocol 2

# 최대 인증 시도 횟수 제한
MaxAuthTries 3

# 동시 접속 가능한 세션 수 제한
MaxSessions 2

# 로그인 시간 제한 (초 단위)
LoginGraceTime 60

# 패스워드 인증 비활성화 (키 인증만 허용)
PasswordAuthentication no

# 빈 패스워드 로그인 차단
PermitEmptyPasswords no

# 공개키 인증 활성화
PubkeyAuthentication yes

# 호스트 기반 인증 비활성화
HostbasedAuthentication no

# X11 포워딩 비활성화 (필요시에만 활성화)
X11Forwarding no

# TCP 포워딩 제한
AllowTcpForwarding no

# 특정 사용자만 SSH 접속 허용
AllowUsers user1 user2

# 특정 그룹만 SSH 접속 허용
AllowGroups ssh-users

# 특정 IP 주소에서만 접속 허용
# Match Address 192.168.1.0/24
#     PasswordAuthentication yes
```

### 2. 로그 모니터링 설정

```bash
# SSH 접속 로그 확인
$ sudo tail -f /var/log/auth.log | grep ssh

# 실패한 로그인 시도 확인
$ sudo grep "Failed password" /var/log/auth.log

# 성공한 로그인 확인
$ sudo grep "Accepted" /var/log/auth.log

# 특정 IP에서의 접속 시도 확인
$ sudo grep "192.168.1.100" /var/log/auth.log
```

### 3. Fail2Ban으로 침입 차단 시스템 구축

```bash
# Fail2Ban 설치
$ sudo apt update
$ sudo apt install fail2ban

# 설정 파일 생성
$ sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# SSH 보호 설정
$ sudo vi /etc/fail2ban/jail.local
```

Fail2Ban 설정 예시:

```ini
[sshd]
enabled = true
port = 9901
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 600
findtime = 300
```

```bash
# Fail2Ban 서비스 시작
$ sudo systemctl enable fail2ban
$ sudo systemctl start fail2ban

# 상태 확인
$ sudo fail2ban-client status
$ sudo fail2ban-client status sshd
```

## #07. SSH 터널링 및 포트 포워딩

### 1. 로컬 포트 포워딩

```bash
# 로컬 포트 8080을 원격 서버의 80포트로 포워딩
$ ssh -L 8080:localhost:80 user@server.com -p 9901

# 데이터베이스 접속을 위한 포워딩
$ ssh -L 3306:localhost:3306 user@db-server.com -p 9901

# 백그라운드에서 실행
$ ssh -L 8080:localhost:80 user@server.com -p 9901 -N -f
```

### 2. 리모트 포트 포워딩

```bash
# 원격 서버의 8080포트를 로컬 80포트로 포워딩
$ ssh -R 8080:localhost:80 user@server.com -p 9901

# 웹 개발 시 외부에서 로컬 서버 접근 가능하게 설정
$ ssh -R 3000:localhost:3000 user@public-server.com -p 9901
```

### 3. 동적 포트 포워딩 (SOCKS 프록시)

```bash
# SOCKS 프록시 설정
$ ssh -D 8080 user@server.com -p 9901

# 백그라운드에서 실행
$ ssh -D 8080 user@server.com -p 9901 -N -f
```

## #08. SSH 클라이언트 설정 최적화

### 1. SSH 설정 파일 생성

```bash
# 클라이언트 설정 파일 생성
$ vi ~/.ssh/config
```

설정 파일 예시:

```bash
# 기본 설정
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    TCPKeepAlive yes
    Compression yes

# 개발 서버 설정
Host dev-server
    HostName 192.168.1.100
    Port 9901
    User myuser
    IdentityFile ~/.ssh/myserver
    IdentitiesOnly yes

# 운영 서버 설정
Host prod-server
    HostName prod.example.com
    Port 9901
    User deploy
    IdentityFile ~/.ssh/prod-key
    StrictHostKeyChecking yes

# 점프 서버를 통한 접속
Host internal-server
    HostName 10.0.0.100
    Port 22
    User admin
    ProxyJump bastion-server

Host bastion-server
    HostName bastion.example.com
    Port 9901
    User myuser
    IdentityFile ~/.ssh/bastion-key
```

### 2. 간편한 접속 사용법

```bash
# 설정 파일 사용 후 간단한 접속
$ ssh dev-server
$ ssh prod-server
$ ssh internal-server

# 파일 전송도 간단하게
$ scp file.txt dev-server:~/
$ rsync -av ./project/ prod-server:~/app/
```

## #09. 고급 인증 방법

### 1. ED25519 키 생성 (권장)

```bash
# 더 안전한 ED25519 키 생성
$ ssh-keygen -t ed25519 -C "your_email@example.com"

# 키 강도를 높인 RSA 키 생성
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

### 2. SSH 에이전트 사용

```bash
# SSH 에이전트 시작
$ eval "$(ssh-agent -s)"

# 키 추가
$ ssh-add ~/.ssh/myserver
$ ssh-add ~/.ssh/id_ed25519

# 등록된 키 확인
$ ssh-add -l

# 키 삭제
$ ssh-add -d ~/.ssh/myserver

# 모든 키 삭제
$ ssh-add -D
```

### 3. 다중 인증 (MFA) 설정

```bash
# Google Authenticator 설치
$ sudo apt install libpam-google-authenticator

# 사용자별 MFA 설정
$ google-authenticator

# PAM 설정 수정
$ sudo vi /etc/pam.d/sshd
```

PAM 설정에 추가:

```bash
auth required pam_google_authenticator.so
```

SSH 설정 수정:

```bash
$ sudo vi /etc/ssh/sshd_config
```

```bash
ChallengeResponseAuthentication yes
AuthenticationMethods publickey,keyboard-interactive
```

## #10. SSH 성능 최적화

### 1. 압축 및 암호화 최적화

```bash
# 클라이언트 설정에서 압축 활성화
Host *
    Compression yes
    CompressionLevel 6

# 빠른 암호화 알고리즘 사용
Host fast-server
    Ciphers aes128-gcm@openssh.com,aes128-ctr
    MACs hmac-sha2-256-etm@openssh.com
    KexAlgorithms curve25519-sha256@libssh.org
```

### 2. 연결 재사용 설정

```bash
# 마스터 연결 설정
Host *
    ControlMaster auto
    ControlPath ~/.ssh/master-%r@%h:%p
    ControlPersist 10m
```

### 3. 네트워크 최적화

```bash
# 서버 설정 최적화
$ sudo vi /etc/ssh/sshd_config
```

```bash
# TCP keepalive 설정
TCPKeepAlive yes
ClientAliveInterval 60
ClientAliveCountMax 3

# DNS 조회 비활성화 (속도 향상)
UseDNS no

# GSSAPI 인증 비활성화
GSSAPIAuthentication no
```

## #11. 문제 해결 및 디버깅

### 1. 연결 문제 진단

```bash
# 상세한 디버그 정보로 연결
$ ssh -vvv user@server.com -p 9901

# 네트워크 연결 테스트
$ telnet server.com 9901
$ nc -zv server.com 9901

# 공개키 인증 테스트
$ ssh -T git@github.com
```

### 2. 일반적인 오류 해결

```bash
# 1. Permission denied (publickey) 오류
# 키 권한 확인
$ chmod 700 ~/.ssh
$ chmod 600 ~/.ssh/id_rsa
$ chmod 644 ~/.ssh/id_rsa.pub

# 2. Host key verification failed 오류
# Known hosts 파일에서 호스트 제거
$ ssh-keygen -R server.com

# 3. Connection timeout 오류
# 방화벽 및 포트 확인
$ sudo ufw status
$ sudo netstat -tlnp | grep :9901

# 4. Too many authentication failures 오류
# IdentitiesOnly 옵션 사용
$ ssh -o IdentitiesOnly=yes -i ~/.ssh/mykey user@server.com
```

### 3. 로그 분석 및 모니터링

```bash
# SSH 서비스 로그 실시간 모니터링
$ sudo journalctl -u ssh -f

# 연결 통계 확인
$ sudo ss -tuln | grep :9901

# 현재 SSH 세션 확인
$ who
$ w

# SSH 연결 기록 확인
$ last | grep ssh
```

## #12. 자동화 스크립트

### 1. SSH 백업 스크립트

```bash
#!/bin/bash
# ssh-backup.sh

BACKUP_DIR="/backup/ssh"
DATE=$(date +%Y%m%d_%H%M%S)

# 백업 디렉토리 생성
mkdir -p ${BACKUP_DIR}

# SSH 설정 백업
sudo cp -r /etc/ssh ${BACKUP_DIR}/ssh_config_${DATE}
cp -r ~/.ssh ${BACKUP_DIR}/user_ssh_${DATE}

# 압축
tar -czf ${BACKUP_DIR}/ssh_backup_${DATE}.tar.gz -C ${BACKUP_DIR} ssh_config_${DATE} user_ssh_${DATE}

# 정리
rm -rf ${BACKUP_DIR}/ssh_config_${DATE} ${BACKUP_DIR}/user_ssh_${DATE}

echo "SSH 설정이 ${BACKUP_DIR}/ssh_backup_${DATE}.tar.gz 에 백업되었습니다."
```

### 2. SSH 보안 검사 스크립트

```bash
#!/bin/bash
# ssh-security-check.sh

echo "SSH 보안 설정 검사 시작..."

# 1. 기본 포트 사용 여부 확인
if grep -q "^Port 22" /etc/ssh/sshd_config; then
    echo "⚠️  기본 포트 22를 사용하고 있습니다."
else
    echo "✅ 사용자 정의 포트를 사용하고 있습니다."
fi

# 2. Root 로그인 허용 여부 확인
if grep -q "^PermitRootLogin yes" /etc/ssh/sshd_config; then
    echo "⚠️  Root 로그인이 허용되어 있습니다."
else
    echo "✅ Root 로그인이 차단되어 있습니다."
fi

# 3. 패스워드 인증 확인
if grep -q "^PasswordAuthentication yes" /etc/ssh/sshd_config; then
    echo "⚠️  패스워드 인증이 활성화되어 있습니다."
else
    echo "✅ 패스워드 인증이 비활성화되어 있습니다."
fi

# 4. Fail2Ban 상태 확인
if systemctl is-active --quiet fail2ban; then
    echo "✅ Fail2Ban이 실행 중입니다."
else
    echo "⚠️  Fail2Ban이 설치되지 않았거나 실행되지 않고 있습니다."
fi

echo "SSH 보안 검사 완료."
```