---
layout: post
title:  "[Mac] MacOS의 httpd Virtual Host 설정"
date:   2024-02-20
banner_image: index-mac.jpg
tags: [Mac,PHP]
---

httpd로 PHP구동 환경을 구성한 후 한 번에 여러 개의 웹 사이트를 구동해야 하는 경우가 있다.(외주개발용 사이트와 스터디용 사이트 등) VirtualHost는 하나의 httpd가 호스트이름으로 구분된 여러 개의 사이트를 운영하도록 하는 설정이다.

<!--more-->

# #01. httpd 설정 파일 편집

편집기로 httpd의 설정 파일을 다시 연다

```shell
$ code /opt/homebrew/etc/httpd/httpd.conf
```

아래의 두 구문을 검색하여 주석을 해제한다.

```conf
Include /opt/homebrew/etc/httpd/extra/httpd-vhosts.conf
```

```conf
LoadModule vhost_alias_module lib/httpd/modules/mod_vhost_alias.so
```

![img](/images/posts/2024/0220/vhost01.png)

# #02. vhosts 설정 파일 편집

앞서 include 주석을 해제했던 `httpd-vhosts.conf` 파일을 편집기로 열어서 수정한다.

## [1] VI로 열기

```shell
$ vi /opt/homebrew/etc/httpd/extra/httpd-vhosts.conf
```

## [2] VSCode로 열기

```shell
$ code /opt/homebrew/etc/httpd/extra/httpd-vhosts.conf
```

## [3] 기본값 정리

아래와 같이 기본 내용들이 작성되어 있다. 템플릿으로 활용할 한 블록만 남겨두고 삭제한다.

```conf
<VirtualHost *:8080>
    ServerAdmin webmaster@dummy-host.example.com
    DocumentRoot "/opt/homebrew/opt/httpd/docs/dummy-host.example.com"
    ServerName dummy-host.example.com
    ServerAlias www.dummy-host.example.com
    ErrorLog "/opt/homebrew/var/log/httpd/dummy-host.example.com-error_log"
    CustomLog "/opt/homebrew/var/log/httpd/dummy-host.example.com-access_log" common
</VirtualHost>

<VirtualHost *:8080>
    ServerAdmin webmaster@dummy-host2.example.com
    DocumentRoot "/opt/homebrew/opt/httpd/docs/dummy-host2.example.com"
    ServerName dummy-host2.example.com
    ErrorLog "/opt/homebrew/var/log/httpd/dummy-host2.example.com-error_log"
    CustomLog "/opt/homebrew/var/log/httpd/dummy-host2.example.com-access_log" common
</VirtualHost>
```

## [4] vhost 설정

아래의 형식을 참고하여 가상 호스트를 구성한다.

```conf
<VirtualHost *:포트번호>
    ServerAdmin 관리자이메일
    DocumentRoot "사이트 ROOT 디렉토리 경로"
    ServerName 웹사이트_도메인(가상도 가능함)
    ErrorLog "/opt/homebrew/var/log/httpd/웹사이트_도메인-error_log"
    CustomLog "/opt/homebrew/var/log/httpd/웹사이트_도메인-access_log" common

    <Directory "사이트 ROOT 디렉토리 경로">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

아래는 작성 예시이다.

로그 파일의 경로를 임의의 위치로 변경하는 것도 좋다.

> 주의: 로그파일이 저장되도록 설정한 경로 `/Users/leekh/workspace-php/_logs/httpd`가 미리 생성되어 있어야 한다.

```conf
<VirtualHost *:9909>
    ServerAdmin leekh4232@gmail.com
    DocumentRoot "/Users/leekh/workspace-php"
    ServerName home.hossam.kr
    ErrorLog "/Users/leekh/workspace-php/_logs/httpd/home.hossam.kr-error_log"
    CustomLog "/Users/leekh/workspace-php/_logs/httpd/home.hossam.kr-access_log" common

    <Directory "/Users/leekh/workspace-php">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

# #03. 가상 도메인 설정

Virtual Host로 설정한 `home.hossam.kr`도메인은 실존하는 주소가 아니기 때문에 현재 사용중인 컴퓨터 한정으로 도메인을 가상으로 지정해 주는 작업이 필요하다. 이렇게 하면 개발용 주소와 운영 주소를 구분하여 사용할 수 있다.

관리자 권한을 부여한 편집기로 `/etc/hosts` 파일을 편집한다.

```shell
$ sudo vi /etc/hosts
```

이 파일에 `아이피주소  가상도메인` 형식으로 내용을 추가하면 현재 컴퓨터에서 가상도메인으로 접속했을 때 연결된 아이피 주소를 찾아간다.

이 설정은 실제 도메인의 존재여부보다 우선한다. 예를 들어 `127.0.0.1  www.naver.com`으로 설정한다면 네이버의 존재 여부를 무시하고 해당 도메인은 무조건 로컬 컴퓨터에 접속하게 된다.

아래와 같이 설정하였다.

![img](/images/posts/2024/0220/vhost02.png)

# 04. 결과 확인

## [1] 서비스 재시작

Virtual Host에 설정한 디렉토리를 생성하고 아파치 웹 서버를 재시작한다.

```shell
$ brew services restart httpd
```

재시작 후에 아래 명령어로 서비스가 잘 동작중인지 확인한다. 만약 설정 파일의 내용에 잘못된 부분이 있다면 실행에 문제가 생길 것이다.

```shell
$ brew services list
```

![img](/images/posts/2024/0220/vhost03.png)


## [2] 웹 브라우저로 확인

Virtual Host가 설정된 디렉토리에 임의의 파일을 생성하고 웹 브라우저로 접속해 결과를 확인한다.

Virtual Host설정에서 정의한 도메인으로 접속해야 한다.

![img](/images/posts/2024/0220/vhost04.png)

