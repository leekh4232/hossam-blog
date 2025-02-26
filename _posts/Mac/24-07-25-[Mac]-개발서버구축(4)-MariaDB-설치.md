---
layout: post
title:  "[Mac] 개발서버 구축기 (4) - MariaDB 설치"
date:   2024-07-25
banner_image: index-mac-studio.jpg
tags: [Mac]
---

mariaDB는 MySQL 서버에서 사용되던 데이터 파일들이 서로 호환된다. MySQL Connector(Java 및 C 클라이언트 라이브러러 등)는 모두 MariaDB에서 변경없이 사용 가능하기 때문에 MySQL 클라이언트 프로그램은 그대로 MariaDB 서버의 연결에 사용할 수 있다. MariaDB와 MySQL은 기능이나 성능에서 큰 차이점을 보이지는 않는다. MySQL은 오라클이 MariaDB는 Monty Program AB가 이끌고 있으므로 앞으로 점점 차이점이 두드러지겠지만 현재까지는 거의 동일하다고 봐도 좋다. 그래서 이번 개발 머신에는 MariaDB를 설치해 보았다.

<!--more-->

# #01 Maria DB 설치

Homebrew를 통해 설치한다.

```shell
$ brew install mariadb
```

# #02. 서비스 등록 및 삭제

## 1. 서비스 등록하기

```shell
$ brew services start mariadb
```

## 2. 서비스 등록 해제

```shell
$ brew services stop mariadb
```

## 3. 서비스 시작하기

> brew로 서비스에 등록했다면 이건 안해도 되는 듯

```shell
$ mysql.server start
```

# #03. 기본 설정 시작

```shell
$ sudo mysql_secure_installation
```

# #04. 포트번호 변경

외부에서도 작업이 가능하도록 mariadb의 원격 접속을 허용할 계획이다. 기본 포트는 보안에 좋지 않기 때문에 포트번호를 임의의 포트로 변경하였다.

## 1. `my.cnf` 파일 찾기

설정 파일의 위치를 찾기 위해 다음의 명령어를 수행한다.

```shell
$ mysqld --verbose --help | grep -A 1 'Default options'
```

아래와 같이 `my.cnf` 파일의 경로가 표시된다.

```
2024-12-01 10:43:17 0 [Warning] Setting lower_case_table_names=2 because file system for /opt/homebrew/var/mysql/ is case insensitive
Default options are read from the following files in the given order:
/opt/homebrew/etc/my.cnf ~/.my.cnf
```

## 2. `my.cnf` 파일 수정

vi 편집기로 설정 파일을 열고 아래의 내용을 추가한다.

```shell
[mysqld]
port=변경할포트번호
```

## 3. 서비스 재시작

```shell
$ brew services restart mariadb
```