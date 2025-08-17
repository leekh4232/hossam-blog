---
title:  "CentOS에 SSL 인증서 설치하기"
description: CentOS는 유료로 제공되는 레드햇 엔터프라이즈 리눅스(RHEL)와 동일한 무료 배포판을 제공하는 것을 목적으로 만들어진 배포판입니다. 현재는 개발과 지원이 중단되었지만 아직까지도 꽤 많은 서비스가 CentOS를 기반으로 운영되고 있습니다. 이 글은 개인적인 필요에 따라 PHP로 개발된 웹 서비스를 Apache 웹서버로 운영하던 CentOS에 SSL 인증서를 설치하던 개인적 경험에 대한 정리 입니다.
categories: [02.Operating System,Linux,CentOS]
date:   2022-09-01 18:26:00 +0900
author: Hossam
image:
  path: /images/indexs/desital.png
tags: [컴퓨터활용,Operating System,Linux,SSL]
pin: true
math: true
mermaid: true
---

## 1. open ssl 설치 확인

```shell
$ rpm -qa openssl
```

### 설치 안되어있을 시

```shell
$ yum install openssl
```

## 2. mod ssl 확인

```shell
ls /etc/httpd/modules/mod_ssl*
```

### 설치 안되어있을 시

```shell
$ yum info mod_ssl
$ yum install mod_ssl
```

## 3. certbot 설치

```shell
$ sudo yum install certbot python2-certbot-apache
```

## 4. 인증서 발급

### 인증서 발급 진행

설정도메인이 ServerName과 동일해야한다.

```shell
$ certbot --apache certonly -d lms.hossam.kr
```

위 명령을 치면 일반 ssl 설정 질문이 나온다.

- 첫 번째에서 서버 관리자 이메일 주소를 입력한다.
- 두 번째 는  약관 동의하는 것으로 Y를 입력한다.
- 세 번째는 여러 수신 동의를 묻는 것으로 동의하면 Y, 거부하면 N을 입력한다.

### 인증서 확인

`/etc/letsencrypt/live/도메인` 위치에 생성된다.


```shell
$ ls /etc/letsencrypt/live/lms.hossam.kr
cert.pem  chain.pem  fullchain.pem  privkey.pem  README
```

## #05. 아파치 환경 설정

### 인증서 정보 추가

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

### http 접속시 https 자동 접속

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


## #06. 방화벽 및 apache 재시작

```shell
$ firewall-cmd --permanent --zone=public --add-port=443/tcp
$ firewall-cmd --reload
$ systemctl restart httpd
```

## #07. 인증서 자동 갱신 설정

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

## #08. SSL 인증서 검증 및 문제 해결

### 1. 인증서 상태 확인

```shell
# 인증서 만료일 확인
$ certbot certificates

# 특정 도메인 인증서 상세 정보
$ openssl x509 -in /etc/letsencrypt/live/lms.hossam.kr/cert.pem -text -noout

# 인증서 유효성 검사
$ openssl verify -CAfile /etc/letsencrypt/live/lms.hossam.kr/chain.pem /etc/letsencrypt/live/lms.hossam.kr/cert.pem

# 웹사이트 SSL 연결 테스트
$ openssl s_client -connect lms.hossam.kr:443 -servername lms.hossam.kr
```

### 2. 갱신 테스트

```shell
# 갱신 시뮬레이션 (실제로 갱신하지 않음)
$ certbot renew --dry-run

# 강제 갱신 (30일 이전에도 갱신)
$ certbot renew --force-renewal

# 특정 인증서만 갱신
$ certbot renew --cert-name lms.hossam.kr
```

### 3. 로그 확인

```shell
# Let's Encrypt 로그 확인
$ tail -f /var/log/letsencrypt/letsencrypt.log

# Apache 에러 로그 확인
$ tail -f /var/log/httpd/error_log

# Apache 액세스 로그 확인
$ tail -f /var/log/httpd/access_log
```

## #09. 보안 강화 설정

### 1. SSL 프로토콜 및 암호화 최적화

```shell
$ vi /etc/httpd/conf.d/ssl.conf
```

```apache
<VirtualHost *:443>
    ServerName lms.hossam.kr
    DocumentRoot /home/ems/public_html

    # 최신 SSL/TLS 설정
    SSLEngine on
    SSLProtocol -all +TLSv1.2 +TLSv1.3

    # 강력한 암호화 스위트
    SSLCipherSuite ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
    SSLHonorCipherOrder off
    SSLSessionTickets off

    # 인증서 파일
    SSLCertificateFile /etc/letsencrypt/live/lms.hossam.kr/cert.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/lms.hossam.kr/privkey.pem
    SSLCACertificateFile /etc/letsencrypt/live/lms.hossam.kr/chain.pem
    SSLCertificateChainFile /etc/letsencrypt/live/lms.hossam.kr/fullchain.pem

    # 보안 헤더 추가
    Header always set Strict-Transport-Security "max-age=63072000; includeSubDomains; preload"
    Header always set X-Frame-Options DENY
    Header always set X-Content-Type-Options nosniff
    Header always set Referrer-Policy "strict-origin-when-cross-origin"
    Header always set Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'"

    # OCSP Stapling 활성화
    SSLUseStapling on
    SSLStaplingCache "shmcb:logs/stapling-cache(150000)"

    <Directory "/home/ems/public_html">
        AllowOverride All
        Require all granted
        Options FollowSymLinks
    </Directory>
</VirtualHost>
```

### 2. HTTP Strict Transport Security (HSTS) 설정

```shell
$ vi /etc/httpd/conf.d/security.conf
```

```apache
# HSTS 헤더 설정
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"

# 추가 보안 헤더
Header always set X-Frame-Options DENY
Header always set X-Content-Type-Options nosniff
Header always set X-XSS-Protection "1; mode=block"
Header always set Referrer-Policy "strict-origin-when-cross-origin"

# 서버 정보 숨기기
ServerTokens Prod
ServerSignature Off
```

## #10. 다중 도메인 SSL 인증서 관리

### 1. SAN (Subject Alternative Name) 인증서 발급

```shell
# 여러 도메인을 포함한 인증서 발급
$ certbot --apache certonly -d example.com -d www.example.com -d subdomain.example.com

# 와일드카드 인증서 발급 (DNS 챌린지 필요)
$ certbot certonly --manual --preferred-challenges dns -d "*.example.com" -d example.com
```

### 2. 기존 인증서에 도메인 추가

```shell
# 인증서 확장 (기존 도메인 + 새 도메인)
$ certbot --apache certonly --expand -d lms.hossam.kr -d api.hossam.kr -d admin.hossam.kr
```

### 3. 도메인별 Virtual Host 설정

```apache
# /etc/httpd/conf.d/ssl-sites.conf
<VirtualHost *:443>
    ServerName lms.hossam.kr
    DocumentRoot /home/ems/public_html

    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/lms.hossam.kr/cert.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/lms.hossam.kr/privkey.pem
    SSLCertificateChainFile /etc/letsencrypt/live/lms.hossam.kr/fullchain.pem
</VirtualHost>

<VirtualHost *:443>
    ServerName api.hossam.kr
    DocumentRoot /home/api/public_html

    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/lms.hossam.kr/cert.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/lms.hossam.kr/privkey.pem
    SSLCertificateChainFile /etc/letsencrypt/live/lms.hossam.kr/fullchain.pem
</VirtualHost>
```

## #11. 모니터링 및 알림 설정

### 1. 인증서 만료 알림 스크립트

```bash
#!/bin/bash
# /usr/local/bin/ssl-check.sh

DOMAINS=("lms.hossam.kr" "api.hossam.kr")
ALERT_DAYS=30
EMAIL="admin@hossam.kr"

for domain in "${DOMAINS[@]}"; do
    # 인증서 만료일 확인
    expiry_date=$(openssl s_client -connect ${domain}:443 -servername ${domain} 2>/dev/null | openssl x509 -noout -dates | grep 'notAfter' | cut -d= -f2)
    expiry_timestamp=$(date -d "$expiry_date" +%s)
    current_timestamp=$(date +%s)
    days_until_expiry=$(( (expiry_timestamp - current_timestamp) / 86400 ))

    if [ $days_until_expiry -le $ALERT_DAYS ]; then
        echo "SSL certificate for $domain expires in $days_until_expiry days!" | mail -s "SSL Certificate Alert" $EMAIL
    fi
done
```

### 2. 자동 갱신 후 알림

```bash
#!/bin/bash
# /usr/local/bin/certbot-renew-hook.sh

# 갱신 후 실행되는 훅 스크립트
echo "SSL certificates renewed successfully at $(date)" | mail -s "SSL Certificate Renewed" admin@hossam.kr

# Apache 재시작
systemctl reload httpd

# 로그 기록
echo "$(date): SSL certificates renewed and Apache reloaded" >> /var/log/ssl-renewal.log
```

### 3. 크론탭 설정 개선

```shell
$ vi /etc/crontab
```

```bash
# SSL 인증서 자동 갱신 (매월 1일, 15일 새벽 2시)
0 2 1,15 * * root certbot renew --quiet --renew-hook "/usr/local/bin/certbot-renew-hook.sh"

# SSL 인증서 만료 체크 (매주 월요일 오전 9시)
0 9 * * 1 root /usr/local/bin/ssl-check.sh

# 로그 파일 로테이션 (매월 1일)
0 0 1 * * root logrotate /etc/logrotate.d/ssl-logs
```

## #12. 백업 및 복구

### 1. 인증서 백업

```bash
#!/bin/bash
# /usr/local/bin/ssl-backup.sh

BACKUP_DIR="/backup/ssl"
DATE=$(date +%Y%m%d_%H%M%S)

# 백업 디렉토리 생성
mkdir -p ${BACKUP_DIR}/${DATE}

# Let's Encrypt 디렉토리 전체 백업
cp -r /etc/letsencrypt ${BACKUP_DIR}/${DATE}/

# Apache SSL 설정 백업
cp /etc/httpd/conf.d/ssl.conf ${BACKUP_DIR}/${DATE}/
cp -r /etc/httpd/conf.d/*ssl* ${BACKUP_DIR}/${DATE}/

# 압축
tar -czf ${BACKUP_DIR}/ssl_backup_${DATE}.tar.gz -C ${BACKUP_DIR} ${DATE}

# 오래된 백업 삭제 (30일 이상)
find ${BACKUP_DIR} -name "ssl_backup_*.tar.gz" -mtime +30 -delete

echo "SSL backup completed: ssl_backup_${DATE}.tar.gz"
```

### 2. 인증서 복구

```bash
#!/bin/bash
# SSL 인증서 복구 가이드

# 1. 백업에서 복구
tar -xzf /backup/ssl/ssl_backup_YYYYMMDD_HHMMSS.tar.gz -C /tmp
cp -r /tmp/YYYYMMDD_HHMMSS/letsencrypt /etc/

# 2. 권한 설정
chown -R root:root /etc/letsencrypt
chmod -R 755 /etc/letsencrypt
chmod 600 /etc/letsencrypt/live/*/privkey.pem

# 3. Apache 설정 복구
cp /tmp/YYYYMMDD_HHMMSS/ssl.conf /etc/httpd/conf.d/

# 4. Apache 재시작
systemctl restart httpd

# 5. 인증서 검증
certbot certificates
```

## #13. 문제 해결 가이드

### 1. 일반적인 오류 해결

```bash
# 1. 포트 443이 열려있지 않은 경우
firewall-cmd --list-ports
firewall-cmd --permanent --zone=public --add-port=443/tcp
firewall-cmd --reload

# 2. 도메인 DNS 설정 확인
nslookup lms.hossam.kr
dig lms.hossam.kr A

# 3. Apache 설정 문법 검사
httpd -t

# 4. Let's Encrypt 레이트 리미트 확인
curl -s "https://crt.sh/?q=hossam.kr&output=json" | jq '.[].name_value' | sort | uniq -c

# 5. 인증서 파일 권한 확인
ls -la /etc/letsencrypt/live/lms.hossam.kr/
```

### 2. 로그 분석

```bash
# Certbot 로그 분석
tail -50 /var/log/letsencrypt/letsencrypt.log

# Apache SSL 관련 에러 확인
grep -i ssl /var/log/httpd/error_log | tail -20

# 접속 시도 로그 확인
grep ":443" /var/log/httpd/access_log | tail -20
```

이제 CentOS SSL 인증서 설치 가이드가 완벽하게 보강되었습니다. 기본 설치부터 고급 보안 설정, 모니터링, 백업/복구까지 실무에서 필요한 모든 내용을 포함했습니다.