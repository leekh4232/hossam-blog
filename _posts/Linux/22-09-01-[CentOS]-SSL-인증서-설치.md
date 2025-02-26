---
layout: post
title:  "[CentOS] CentOS에 SSL 인증서 설치하기"
date:   2022-09-01
banner_image: index-desital.png
tags: [Linux]
---

CentOS는 유료로 제공되는 레드햇 엔터프라이즈 리눅스(RHEL)와 동일한 무료 배포판을 제공하는 것을 목적으로 만들어진 배포판입니다. 현재는 개발과 지원이 중단되었지만 아직까지도 꽤 많은 서비스가 CentOS를 기반으로 운영되고 있습니다.

이 글은 개인적인 필요에 따라 PHP로 개발된 웹 서비스를 Apache 웹서버로 운영하던 CentOS에 SSL 인증서를 설치하던 개인적 경험에 대한 정리 입니다.

<!--more-->

# 1. open ssl 설치 확인

```shell
$ rpm -qa openssl
```

## 설치 안되어있을 시

```shell
$ yum install openssl
```

# 2. mod ssl 확인

```shell
ls /etc/httpd/modules/mod_ssl*
```

## 설치 안되어있을 시

```shell
$ yum info mod_ssl
$ yum install mod_ssl
```

# 3. certbot 설치

```shell
$ sudo yum install certbot python2-certbot-apache
```

# 4. 인증서 발급

## 인증서 발급 진행

설정도메인이 ServerName과 동일해야한다.

```shell
$ certbot --apache certonly -d lms.hossam.kr
```

위 명령을 치면 일반 ssl 설정 질문이 나온다.

- 첫 번째에서 서버 관리자 이메일 주소를 입력한다.
- 두 번째 는  약관 동의하는 것으로 Y를 입력한다.
- 세 번째는 여러 수신 동의를 묻는 것으로 동의하면 Y, 거부하면 N을 입력한다.

## 인증서 확인

`/etc/letsencrypt/live/도메인` 위치에 생성된다.


```shell
$ ls /etc/letsencrypt/live/lms.hossam.kr
cert.pem  chain.pem  fullchain.pem  privkey.pem  README
```

# #05. 아파치 환경 설정

## 인증서 정보 추가

```shell
$ vi /etc/httpd/conf.d/ssl.conf
```

```
<VirtualHost *:443>
	ServerName lms.hossam.kr
	DocumentRoot /home/ems/public_html
  
	SSLEngine on
	SSLProtocol all -SSLv2
	SSLCipherSuite ALL:!ADH:!EXPORT:!SSLv2:RC4+RSA:+HIGH:+MEDIUM:+LOW

    SSLCertificateFile /etc/letsencrypt/live/lms.hossam.kr/cert.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/lms.hossam.kr/privkey.pem
    SSLCACertificateFile /etc/letsencrypt/live/lms.hossam.kr/chain.pem
    SSLCertificateChainFile /etc/letsencrypt/live/lms.hossam.kr/fullchain.pem

	SetEnvIf User-Agent ".*MSIE.*" nokeepalive ssl-unclean-shutdown

	<Directory "/home/ems/public_html">
		AllowOverride All
		Require all granted
		Options FollowSymLinks
	</Directory>
</VirtualHost>
```

## http 접속시 https 자동 접속

```shell
$ vi /etc/httpd/conf.d/vhost.conf
```

```
<VirtualHost *:80>
	ServerName lms.hossam.kr
    ...
    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI} [R,L]
    ...
</VirtualHost>
```


# #06. 방화벽 및 apache 재시작

```shell
$ firewall-cmd --permanent --zone=public --add-port=443/tcp
$ firewall-cmd --reload
$ systemctl restart httpd
```

# #07. 인증서 자동 갱신 설정

인증서 갱신 명령은 `certbot renew`이다. 이 명령을 주기적으로 자동 실행될 수 있도록 아래와 같이 배치작업을 등록한다.

```shell
$ vi /etc/crontab
```

아래 내용 추가

```
0 4 15 */2 * certbot renew
```

파일 저장 후 서비스 재시작

```shell
$ systemctl restart crond
```