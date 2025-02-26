---
layout: post
title:  "[Ubuntu] Tomcat9 설치"
date:   2022-09-13
banner_image: index-ubuntu.png
tags: [Linux]
---

Tomcat은 Java 기반의 웹 프로그램을 구동할 수 있는 웹 서버 입니다. Visual Studio Code를 기반으로 Spring 웹 개발 설정을 할 경우 웹 서버가 내장되어 있기 때문에 별도의 설치가 필요 없지만 개발이 완료된 후 실제 서비스를 위해서는 반드시 설치해야 합니다.

<!--more-->

# #01. Tomcat 설치하기

## 1) apt 업데이트

아래의 명령을 실행하여 apt의 패키지 리스트를 업데이트 합니다.

```shell
$ sudo apt-get update
```

## 2) 설치 가능한 Tomcat 목록 확인하기

아래의 명령은 설치 가능한 Tomcat의 목록을 보여줍니다.

```shell
$ sudo apt-cache search tomcat
```

![img](/images/posts/2022/0913/tomcat1.png)

가장 최신 버전이 `tomcat9`으로 확인 됩니다. 설치 가능한 패키지 중에서 Tomcat 엔진 (`tomcat9`), 관리자 기능 (`tomcat9-admin`), 공통 파일(`tomcat9-common`)을 설치하도록 하겠습니다.

## 3) 설치하기

Tomcat 엔진 (`tomcat9`), 관리자 기능 (`tomcat9-admin`), 공통 파일(`tomcat9-common`)을 일괄 설치하기 위해서 패키지 이름을 공백으로 구분한 설치 명령어를 입력합니다.

```shell
$ sudo apt-get install -y tomcat9 tomcat9-admin tomcat9-common
```

## 4) Tomcat 구동 확인

`Tomcat9`은 설치가 완료되면 자동으로 서비스가 시작됩니다.

서비스의 상태를 확인해 보기 위해서 아래의 명령어를 수행합니다.

```shell
$ sudo systemctl status tomcat9
```

출력 결과를 보면 서비스 시작에 실패했음을 확인할 수 있습니다.

![img](/images/posts/2022/0913/tomcat2.png)

위의 출력 결과를 확인하면 `/usr/libexec/tomcat9/tomcat-start.sh` 파일에서 `JAVA_HOME`의 위치를 찾지 못하기 때문에 에러가 났다는 것을 확인할 수 있습니다.

## 5) JAVA_HOME 설정

`/usr/libexec/tomcat9/tomcat-start.sh` 파일을 열어서 `JAVA_HOME` 환경변수를 추가해 줍니다.

```shell
sudo vi /usr/libexec/tomcat9/tomcat-start.sh
```

파일을 열고 다음의 구문을 `set -e` 구문 아래에 추가합시다.

```shell
export JAVA_HOME=/usr/lib/jvm/java-19-openjdk-arm64
export PATH=$PATH:$JAVA_HOME/bin
```

### 주의!!!

> SpringBoot 가동을 목적으로 한다면 JDK 17이 설치되어 있을 수 있습니다. 그 경우 JAVA_HOME 환경 변수의 경로를 설치된 환경에 맞게 수정해야 합니다.


![img](/images/posts/2022/0913/tomcat3.png)


## 6) 서비스 재시작 및 확인

서비스를 재시작 합니다.

```shell
$ sudo systemctl restart tomcat9
```

서비스의 가동 상태를 확인합니다.

```shell
$ sudo systemctl state tomcat9
```

![img](/images/posts/2022/0913/tomcat4.png)

## 7) 시스템 부팅시 자동 실행 등록

```shell
$ sudo systemctl enable tomcat9
```

아래 명령으로 등록 결과를 확인합니다.

```shell
$ sudo systemctl list-unit-files | grep tomcat
```

![img](/images/posts/2022/0913/tomcat5.png)


# #02. Linux 외부에서의 접속을 위한 설정

## 1) 방화벽 포트 열기

Tomcat은 기본적으로 `8080`번 포트를 사용하므로 `8080`번에 대한 외부 접근을 허용하도록 하겠습니다.

```shell
$ sudo ufw allow 8080/tcp
```

방화벽을 다시 로드 합니다.

```shell
$ sudo ufw reload
```

## 2) 결과 확인

호스트 컴퓨터 등의 리눅스 이외의 컴퓨터에서 웹브라우저를 통해 톰켓에 접속해 봅니다.

```text
http://리눅스아이피주소:8080
```

![img](/images/posts/2022/0913/tomcat6.png)

# #03. Tomcat Manager 접근을 위한 설정

## 1) 사용자 계정 파일 설정

vi 에디터로 `tomcat-users.xml` 파일을 엽니다.

```shell
$ sudo vi /etc/tomcat9/tomcat-users.xml
```

파일의 맨 하단에 있는 `</tomcat-users>` 바로 위에 다음과 같은 구문을 추가합니다. 권한 생성, 아이디 및 비밀번호 지정 등의 내용 입니다.

```xml
<role rolename="manager"/>
<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<role rolename="manager-jmx"/>
<role rolename="manager-status"/>
<user username="admin" password="admin" roles="manager-gui,manager-script,manager-jmx,manager-status" />
```

![img](/images/posts/2022/0913/tomcat7.png)

## 2) `context.xml` 파일 수정

vi 에디터로 `context.xml` 파일을 수정해야 합니다.

```shell
$ sudo vi /usr/share/tomcat9-admin/manager/META-INF/context.xml
```

파일을 연 후 중간에 있는 `<Value>` 태그 라인을 통째로 주석처리 합니다.

![img](/images/posts/2022/0913/tomcat8.png)

## 3) 서비스 재가동

```shell
sudo systemctl restart tomcat9
```

## 4) 접근 확인

이제 `http://리눅스아이피:8080/manager` 주소로 접속해 봅니다.

`tomcat-users.xml` 파일에 설정한 아이디와 비밀번호로 로그인이 되면 아래와 같이 war 파일을 업로드 하여 웹 프로그램을 설치할 수 있는 관리 패널이 나타납니다.

![img](/images/posts/2022/0913/tomcat9.png)