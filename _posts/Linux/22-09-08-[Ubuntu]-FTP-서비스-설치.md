---
layout: post
title:  "[Ubuntu] FTP 서비스 설치"
date:   2022-09-08
banner_image: index-ubuntu.png
tags: [Linux]
---

FTP (File Transfer Protocal)은 안정적인 파일 전송이 가능한 파일 전송 프로토콜로서 리눅스 서버에 파일을 업로드 하기 위해 사용되는 가장 기본적인 서비스 중 하나 입니다. FTP는 기본적으로 21번 포트를 사용하지만 보안을 위해 다른 포트로 변경하여 사용할 수 도 있습니다. 하지만 어떤 포트를 사용하던지 해당 포트에 대한 방화벽 허용 설정이 필요합니다.

<!--more-->

# #01. FTP 서비스 개요

## 1. FTP 서비스의 종류

| 구분 | OS | 종류 |
|---|---|---|
| Server | Linux | vsftpd, proftpd 등 |
| Client | Linux | ncftp, lftp 등 |
| Client | Window | 알FTP 혹은 알드라이브(무료) |
| Client | MacOS | CyberDuck(유료) |
| Client | 공용 | FileZila(무료,유료) |

> 리눅스에서 구동 가능한 서버의 경우 proftpd가 설정이 더 쉽지만 성능은 vsftpd이 더 좋다.

## 2. FTP에 접속이 가능한 사용자

### 1) 일반 사용자

- 대부분의 FTP 서버는 리눅스 운영체제의 사용자 계정을 그대로 사용함.
- 각 사용자 별로 자신의 홈디렉토리에 접속하게 되고 그 안에서만 파일 작업이 가능함

### 2) 익명 사용자

- 모든 FTP 서버에 기본적으로 등록되어 있음
- ID는 anonymous로 고정되어 있고 비밀번호는 없음.
- 보안에 좋지 않으므로 실무에서 사용하는 FTP 서버에서는 익명사용자의 접속을 차단함

## 3. FTP 전송모드

### 1) 액티브 모드

접속과 데이터 전송에 각각 하나씩의 포트만을 사용한다.

- 접속 기본 포트: 21
- 데이터 전송 기본 포트: 20

### 2) 패시브 모드

데이터 접속에는 하나의 포트를 사용하지만 데이터 전송에는 여러 개의 포트를 사용할 수 있으므로 전송 효율이 좋다.

- 접속 기본 포트: 21
- 데이터 전송 포트: 1024번 이후 설정값에 따름

# #02. vsfptd 서비스 설치하기

## 1. 서비스 패키지 설치

```shell
$ sudo apt-get install vsftpd
```

![vsftpd](/images/posts/2022/0908/vs1.png)

## 2. 환경설정

### 1) 디렉토리 접근 설정

- 기본적으로 vsftpd는 일반 유저가 자신의 홈 디렉토리에 접속한 후 상위 디렉토리로 이동이 가능함
- 이는 시스템의 전체 디렉토리를 열람할 수 있다는 의미이므로 보안에 매우 좋지 않은 결과를 가져옴
- 그러므로 자신의 홈 디렉토리보다 상위 디렉토리로는 접근하지 못하도록 설정해야 함

### 2) 접속 포트 변경

- FTP의 기본 접속 포트 21번은 일반적으로 널리 알려져 있는 포트이기 때문에 이를 임의의 값으로 변경하여 악의적인 사용자가 쉽게 유추할 수 없도록 해야 함

### 3) 패시브 모드 설정

- 기본적으로 액티브 모드 이므로 패시브 모드로 변경하여 전송 효율을 높이는 것이 좋음


### 4) 설정파일 수정하기

root 권한을 사용하여 `/etc/vsftpd.conf` 파일을 vi 편집기로 수정한다.

```shell
$ sudo vi /etc/vsftpd.conf
```

설정 파일의 맨 아래에 설정항목을 추가 기입하고 파일을 저장한다.

```env
# 각 유저가 자신의 홈디렉토리까지만 접근 가능하도록 제한함
chroot_local_user=YES

# 자신의 홈 디렉토리에 대한 쓰기 권한 허용
allow_writeable_chroot=YES
write_enable=YES

# 파일,폴더 기본 퍼미션 설정
local_umask=022
file_open_mode=0644

# 접속 포트번호 설정(기본값 21)
listen_port=9902

# 패시브모드 활성화
pasv_enable=YES

# 패시브모드 전송 포트 범위 설정
pasv_min_port=10100
pasv_max_port=10200
```

![config](/images/posts/2022/0908/config.png)

## 3. 서비스 가동하기

환경설정 파일에 문제가 없고 정상 실행되는 경우 아무런 출력 결과가 없다.

```shell
$ sudo systemctl start vsftpd
```

## 4. 서비스 동작 여부 확인하기

```shell
$ sudo systemctl status vsftpd
```

![vsftpd](/images/posts/2022/0908/vs2.png)

## 5. 부팅시 자동실행 등록

```shell
$ sudo systemctl enable vsftpd
```

![vsftpd](/images/posts/2022/0908/enable.png)

## 6. 방화벽 포트 설정

접속포트로 설정한 9902 TCP 포트와 전송포트로 설정한 10100~10200 TCP 포트를 오픈해야 한다.

```shell
$ sudo ufw allow 9902/tcp
$ sudo ufw allow 10100:10200/tcp
```

## 7. 방화벽 규칙 다시 로드하기

설정한 규칙을 적용하기 위해서는 반드시 수행해야 한다.

```shell
$ sudo ufw reload
```

## 8. 방화벽 규칙 확인

설정이 잘 적용되었는지 확인한다.

```shell
$ sudo ufw status
```

![ftp](/images/posts/2022/0908/ftpport.png)


# #03. FTP 클라이언트를 사용하여 접속 확인하기

## 1. FileZilla 클라이언트 설치하기

[https://filezilla-project.org/download.php?type=client](https://filezilla-project.org/download.php?type=client)사이트에 접속하여 클라이언트 프로그램을 내려 받아 설치한다.

![filezilla](/images/posts/2022/0908/filezilla.png)

## 2. FileZilla를 사용한 파일 업로드

- 서버의 접속 정보를 입력하고 **빠른접속** 버튼을 누른다
- 왼쪽이 로컬컴퓨터, 오른쪽이 리눅스 서버를 의미한다.
- 업로드 혹은 다운로드 할 파일을 끌어넣기 하거나 더블클릭하여 전송한다.
- 한글 파일은 파일명이 깨질 수 있으니 주의해야 한다.

![upload](/images/posts/2022/0908/filezilla_upload.png)

# #04. vsftpd 삭제

알 수 없는 오류 등의 원인으로 vsftpd를 재설치 하기 위해서는 아래의 과정을 수행한다.

## 1. 서비스 중지

```shell
sudo systemctl stop vsftpd
```

## 2. 부팅시 자동실행 등록 해제

```shell
sudo systemctl disable vsftpd
```

## 3. 설정파일과 서비스 삭제

```shell
sudo apt-get purge -y vsftpd
```