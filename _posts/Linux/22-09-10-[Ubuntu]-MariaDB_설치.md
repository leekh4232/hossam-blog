---
layout: post
title:  "[Ubuntu] MariaDB 설치"
date:   2022-09-10
banner_image: index-ubuntu.png
tags: [Linux]
---

MariaDB는 MySQL에서 파생된 오픈소스 RDBMS입니다. 오라클이 썬 마이크로 시스템스를 2010년에 72억 달러(약 8조)에 인수해가면서 썬 마이크로시스템즈에 속해 있던 MySQL 역시 오라클 것이 됨에 따라 상업적으로 MySQL을 이용할 시 사용료를 내도록 정책을 변경되었는데, 이 정책에 반발한 MySQL의 원 개발사의 핵심 창업자중 한 명이었던 몬티 와이드니어스가 2009년 동료들과 나와 MySQL의 소스코드를 기반으로한 오픈소스 RDBMS를 개발한 것이 지금의 MariaDB입니다.

MySQL에서 파생된 것이기 때문에 기본적으로 MySQL과 사용방법이 동일하며 더 좋은 성능을 보여준다고 알려져 있습니다.

<!--more-->

# #01. DBMS 설치하기

## 1) 패키지 업데이트

root 권한을 임대하여 진행한다.

```shell
$ sudo apt-get update
```

![apt-get-update](/images/posts/2022/0910/apt-get-update.png)

## 2) 프로그램 설치

root 권한을 임대하여 `mariadb-server`를 설치한다.

```shell
$ sudo apt-get install -y mariadb-server
```

## 3) 설치된 버전 확인

mariadb이지만 아직까지 명령어들은 mysql을 그대로 따르고 있다. `-V`가 대문자임에 주의

```shell
$ mysql -V
```

![mysql-v](/images/posts/2022/0910/mysql-v.png)

## 4) 보안 설정

```shell
$ sudo mysql_secure_installation
```

### root 비밀번호 `[엔터입력]`

설치 초기 단계이므로 비밀번호가 없다. 바로 엔터를 누른다.

![my01](/images/posts/2022/0910/my01.png)

### Unix 인증 방식 적용 여부 `[Y입력]`

![my02](/images/posts/2022/0910/my02.png)

<div style="page-break-after: always; visibility: hidden">\pagebreak</div>

### root 비밀번호 변경 여부 `[Y입력 후 비밀번호 설정]`

![my03](/images/posts/2022/0910/my03.png)

### 익명 사용자 계성 삭제 여부 `[Y입력]`

![my04](/images/posts/2022/0910/my04.png)

### root의 원격 접속 비활성화 `[Y입력]`

![my05](/images/posts/2022/0910/my05.png)

<div style="page-break-after: always; visibility: hidden">\pagebreak</div>

### 테스트 데이터베이스 삭제 여부 `[Y입력]`

![my06](/images/posts/2022/0910/my06.png)

### 설정 테이블 다시 로드하기 `[Y입력]`

![my06](/images/posts/2022/0910/my07.png)

## 5) 서비스 시작하기

정상적인 경우 아무런 결과도 표시되지 않는다.

```shell
sudo systemctl start mariadb
```

## 6) 정상 가동 여부 확인

```shell
$ sudo systemctl status mariadb
```

![my07](/images/posts/2022/0910/my08.png)

## 7) 운영체제 부팅시 서비스 자동 시작 등록

```shell
sudo systemctl enable mariadb
```

## 8) 접속 확인하기

```shell
$ mysql -uroot -p
```

![my10](/images/posts/2022/0910/my10.png)

> 정상 접속이 확인되면 이후 FTP를 통해 백업파일을 서버에 업로드 하고 데이터베이스 복구 및 사용자 계정 생성을 수행합니다.


# #03. MySchool Database 복구하기

> 아래 내용은 제가 진행하는 수업을 수강하는 경우에만 해당됩니다.

## 1. 복구할 데이터베이스 생성

MySQL에 root 계정으로 접속한 상태에서 myschool 데이터베이스를 생성한다.

```SQL
sql> CREATE DATABASE myschool default charset utf8;
```

![create](/images/posts/2022/0910/create.png)

## 2. 데이터베이스 복구하기

`exit` 명령으로 MySQL과의 접속을 해제하고 업로드 한 백업파일을 복원한다.

복원할 파일이 FTP를 통해 사전에 서버에 업로드 되어 있어야 한다.

```shell
$ mysql -uroot -p DATABASE이름 < 백업파일경로
```

![create](/images/posts/2022/0910/rollback.png)

# #04. 계정 설정

## 1. 사용자 계정 생성하기

다시 mysql에 root로 로그인 한 후 사용자 계정을 생성한다.

```sql
sql> create user '아이디'@'접근허용호스트' identified by '비밀번호';
```

<div style="page-break-after: always; visibility: hidden">\pagebreak</div>

### 접근허용 호스트 구분

| 호스트 | 설명 |
|---|---|
| `localhost` | 해당 사용자는 반드시 리눅스에 원격접속을 한 상태에서만 MySQL의 이용이 가능하다. |
| 특정 IP 주소 | 리눅스로의 원격 접속을 거치지 않고 지정된 IP를 사용하는 컴퓨터를 통해서 mysql로의 직접 접속이 가능하다. |
| `%` | 로컬, 원격 구분 없이 어디서나 mysql로 접속이 가능하다 |

> 원격지에서 mysql로의 직접 접속이 가능하도록 지정된 경우 리눅스에서 mysql이 사용중인 포트번호에 대한 방화벽을 오픈해야 접속이 가능합니다.

![](/images/posts/2022/0910/user.png)

## 2. 데이터베이스에 대한 사용자 권한 부여하기

```sql
sql> grant all privileges on 데이터베이스이름.* to '아이디'@'접근허용호스트';
```

![](/images/posts/2022/0910/grant.png)


## 3. 데이터베이스에 대한 사용자 권한 제거하기

사용자로부터 권한을 회수하는 일은 거의 발생하지 않지만 필요하다면 아래의 명령을 사용한다.

```sql
sql> revoke all on 데이터베이스이름.* from '아이디'@'접근허용호스트';
```


## 4. 생성된 계정으로 mysql 로그인 확인

`exit` 명령으로 MySQL과의 접속을 해제하고 새로 생성한 아이디를 사용해 MySQL에 접근해 본다.

![](/images/posts/2022/0910/myschool-login.png)


# #05. 외부접속 설정

> 일반적인 실무 시스템에서는 보안상의 이유로 MySQL의 외부접속을 허용하지 않지만 여기서는 실습용 환경이므로 외부 접속을 허용하도록 설정을 진행합니다.

## 1. 포트번호 변경

기본 포트는 일반적으로 알려져 있기 때문에 보안에 불리하므로 임의의 포트로 변경해야 한다.

### 설정파일 열기

```shell
$ sudo vi /etc/mysql/mariadb.conf.d/50-server.cnf
```

### 설정파일에 포트번호 옵션 추가

`[mysqld]` 섹션에 `port = 포트번호`를 추가하고 파일을 저장한 후 vi를 종료한다.

![](/images/posts/2022/0910/mysql-port.png)

`bind-address`라는 설정항목을 찾아 `0.0.0.0`으로 값을 수정한다.

![](/images/posts/2022/0910/bindadd.png)

### 서비스 재시작

```shell
$ sudo systemctl restart mariadb
```

## 2. 방화벽에 포트번호 추가

설정한 포트번호를 방화벽 허용 목록에 추가하고 방화벽을 다시 로드한다.

```shell
$ sudo ufw allow 9903/tcp
$ sudo ufw reload
```

![](/images/posts/2022/0910/mysql-ufw.png)

## 3. 외부 컴퓨터에서 접속 확인

Window, Mac 등의 호스트 컴퓨터에서 MySQL에 접속을 시도한다.

```shell
$ mysql -h리눅스아이피 -P포트번호 -u계정명 -p
```

![](/images/posts/2022/0910/mac.png)


# #06. MariaDB 삭제

## 1. 서비스 중지

```shell
sudo systemctl stop mariadb
```

## 2. 서비스 자동시작 등록 해제

```shell
sudo systemctl disable mariadb
```

## 3. MariaDB 완전 삭제

```shell
$ sudo apt-get purge -y mariadb*
```

## 4. 사이드 패키지 제거

```shell
$ sudo apt autoremove -y
```

## 5. 관련 파일 리스트 확인

아래 명령을 수행하여 출력되는 항목이 없어야 한다.

```shell
$ dpkg -l | grep mariadb
$ dpkg -l | grep mysql
```

만약 출력되는 파일목록이 있다면 아래 명령으로 잔존 파일들을 삭제한다.

```shell
$ sudo apt-get purge -y 파일명
```

예를 들어 아래와 같이 `mysql-common`이라는 항목이 출력될 경우,

![my08](/images/posts/2022/0910/my09.png)

아래의 명령으로 삭제한다

```shell
$ sudo apt-get purge -y mysql-common
```

## 6. 재부팅

삭제를 완료하기 위해서는 시스템 재부팅이 필요하다.

```shell
$ sudo reboot
```