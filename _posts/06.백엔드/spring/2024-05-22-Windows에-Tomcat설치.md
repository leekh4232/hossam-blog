---
title: Windows에 Tomcat 설치하기 (압축파일 방식)
author: hossam
date: 2024-05-22 09:00:00 +0900
categories: [06.Backend,Spring]
tags: [Tomcat, Windows, 설치, 웹서버, Java]
pin: false
math: false
mermaid: false
image:
  path: /images/indexs/coding.png
  alt: Windows Tomcat 설치
---

이번 포스팅에서는 Windows 환경에서 Apache Tomcat을 압축파일을 이용해 설치하는 방법을 알아보겠습니다. 설치 프로그램을 사용하지 않고 직접 압축파일을 다운로드하여 설치하는 방법을 다루겠습니다.

## 사전 요구사항

- JDK가 설치되어 있어야 합니다
- JAVA_HOME 환경변수가 설정되어 있어야 합니다

## 1. Tomcat 다운로드

### 1.1 공식 사이트 접속

Apache Tomcat 공식 웹사이트에 접속합니다.

```
https://tomcat.apache.org/
```

### 1.2 버전 선택

원하는 Tomcat 버전을 선택합니다. 일반적으로 사용되는 버전들:

- **Tomcat 11.x**: Jakarta EE 9+ (최신)
- **Tomcat 10.x**: Jakarta EE 9+ (권장, Cafe24 지원 버전)
- **Tomcat 9.x**: Java EE 8 / Jakarta EE 8 (안정적)
- **Tomcat 8.5.x**: Java EE 7 (레거시 지원)

### 1.3 압축파일 다운로드

선택한 버전 페이지에서 `Core` 섹션의 압축파일을 다운로드합니다:

- **Windows 사용자**: `zip` 파일 다운로드
- 예: `apache-tomcat-10.1.43-windows-x64.zip`

## 2. Tomcat 설치

### 2.1 압축파일 해제

1. 다운로드한 zip 파일을 원하는 위치에 압축 해제합니다
2. 권장 설치 경로: `C:\Users\사용자아이디\apache-tomcat-10.1.43`

```
C:\Users\사용자아이디\apache-tomcat-10.1.43
```

### 2.2 디렉토리 구조 확인

압축 해제 후 다음과 같은 디렉토리 구조를 확인할 수 있습니다:

```
apache-tomcat-10.1.43/
├── bin/           # 실행 파일들
├── conf/          # 설정 파일들
├── lib/           # 라이브러리 파일들
├── logs/          # 로그 파일들
├── temp/          # 임시 파일들
├── webapps/       # 웹 애플리케이션들
└── work/          # 작업 디렉토리
```

## 3. 환경변수 설정

### 3.1 CATALINA_HOME 설정

1. **시스템 속성** 열기: `Win + R` → `sysdm.cpl`
2. **고급** 탭 → **환경 변수** 클릭
3. **시스템 변수**에서 **새로 만들기** 클릭
4. 변수 정보 입력:
   - **변수 이름**: `CATALINA_HOME`
   - **변수 값**: `C:\Users\사용자아이디\apache-tomcat-10.1.43`

### 3.2 Path 환경변수 추가 (선택사항)

편의를 위해 Tomcat의 bin 디렉토리를 Path에 추가할 수 있습니다:

1. **시스템 변수**에서 **Path** 선택 → **편집**
2. **새로 만들기** → `%CATALINA_HOME%\bin` 추가

## 4. Tomcat 실행

### 4.1 명령 프롬프트에서 실행

1. 명령 프롬프트를 **관리자 권한**으로 실행
2. Tomcat bin 디렉토리로 이동:

```shell
cd "C:\Users\사용자아이디\apache-tomcat-10.1.43\bin"
```

3. Tomcat 시작:

```shell
startup.bat
```

### 4.2 서비스 등록 (권장)

Windows 서비스로 등록하면 시스템 시작 시 자동으로 실행됩니다:

```shell
cd "C:\Users\사용자아이디\apache-tomcat-10.1.43\bin"
service.bat install
```

서비스 시작:

```shell
net start Tomcat10
```

## 5. 설치 확인

### 5.1 웹 브라우저에서 확인

브라우저에서 다음 주소로 접속:

```
http://localhost:8080
```

Tomcat 기본 페이지가 표시되면 설치가 성공적으로 완료된 것입니다.

### 5.2 관리자 계정 설정

Tomcat Manager 사용을 위해 관리자 계정을 설정합니다:

1. `conf/tomcat-users.xml` 파일 편집
2. 다음 내용 추가:

```xml
<tomcat-users>
  <role rolename="manager-gui"/>
  <role rolename="admin-gui"/>
  <user username="admin" password="admin123" roles="manager-gui,admin-gui"/>
</tomcat-users>
```

## 6. 주요 설정 파일

### 6.1 server.xml

- 위치: `conf/server.xml`
- 포트 변경, 커넥터 설정 등

### 6.2 web.xml

- 위치: `conf/web.xml`
- 전역 웹 애플리케이션 설정

### 6.3 context.xml

- 위치: `conf/context.xml`
- 데이터베이스 연결 설정 등

## 7. 유용한 명령어

```shell
# Tomcat 시작
startup.bat

# Tomcat 종료
shutdown.bat

# 서비스로 시작
net start Tomcat10

# 서비스 종료
net stop Tomcat10

# 서비스 제거
service.bat remove
```

## 8. 문제 해결

### 8.1 포트 충돌

8080 포트가 사용 중인 경우:

1. `conf/server.xml` 편집
2. Connector 포트 변경:

```xml
<Connector port="8081" protocol="HTTP/1.1" ... />
```

### 8.2 메모리 설정

성능 향상을 위한 JVM 메모리 설정:

1. `bin/catalina.bat` 편집
2. 다음 라인 추가:

```bat
set JAVA_OPTS=-Xms512m -Xmx1024m -XX:PermSize=256m
```
