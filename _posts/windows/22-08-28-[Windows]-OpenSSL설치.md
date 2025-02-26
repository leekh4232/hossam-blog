---
layout: post
title:  "[Windows] OpenSSL 설치"
date:   2022-08-28
banner_image: index-windows.png
tags: [Windows]
---

OpenSSL은 데이터통신을 위한 TLS, SSL 프로토콜을 이용할 수 있는 오픈소스 라이브러리 입니다. http통신을 좀 더 안전하게 하기 위한 프로토콜이라고 이해할 수 있습니다. 이것은 실제 https나 sftp와 같은 표준 프로토콜에 적용된 기술입니다. 백엔드 프로그래밍을 진행하면서 SSL 적용이 필요한 경우 필수적인 라이브러리라 할 수 있습니다.

<!--more-->

# #01. OpenSSL 설치

## [1] 설치 파일 내려 받기

[https://slproweb.com/products/Win32OpenSSL.html](https://slproweb.com/products/Win32OpenSSL.html) 페이지에 접속하여 스크롤을 중간쯤 위치로 이동하면 아래와 같이 버전별로 다운로드 링크가 정리되어 있는 표가 있습니다. 

이 항목들 중에 가장 최신 버전을 받도록 합니다.

`Lite`가 표기된 버전은 일반 사용자용이고 표기되지 않은 버전은 개발자에게 권장되는 버전이므로 여기서는 `Lite`가 표기되지 않은 버전을 기본으로 합니다.

![img](/images/posts/2022/0828/openssl1.png)

## [2] 설치 프로그램 실행하기

내려받은 설치 프로그램을 실행하여 설치를 진행합니다.

설치 과정중에 특별한 설정 항목은 없습니다.

![img](/images/posts/2022/0828/openssl2.png)

설치가 완료된 후에 마지막 화면에서 기부금을 요구하는 체크박스가 표시됩니다.

각자의 판단에 맞게 진행하면 됩니다.

![img](/images/posts/2022/0828/openssl3.png)

# #02. 환경변수 설정

OpenSSL이 설치된 폴더 내의 `bin` 디렉토리를 `PATH`변수에 추가하고 `openssl.cfg` 파일의 경로를 `OPENSSL_CONF` 변수에 추가해야 합니다.

## [1] `PATH` 변수 설정

### (1) 환경변수 설정 화면 열기

#### 컴퓨터 속성 창 열기

윈도우 탐색기의 왼쪽 트리에서 `내 PC`를 마우스로 우클릭하고 `속성`을 선택합니다.

![img](/images/posts/2022/0828/openssl4.png)

#### 고급 시스템 설정 화면 열기

`내 PC`의 속성창 우측 메뉴에서 `고급 시스템 설정`을 클릭합니다.

![img](/images/posts/2022/0828/openssl5.png)

#### 환경변수 설정 화면 열기

`시스템 속성`화면의 하단에 위치한 `환경 변수`버튼을 클릭합니다.

![img](/images/posts/2022/0828/openssl6.png)

### (2) PATH 변수 편집

#### PATH 변수 편집 화면 열기

`환경 변수`화면 하단의 `시스템 변수` 섹션에서 `Path` 항목을 찾아 `편집`버튼을 클릭합니다.

![img](/images/posts/2022/0828/openssl7.png)

#### OpenSSL의 설치 위치 확인

기본 설정대로 설치를 진행하면 `C:\Program Files\OpenSSL-Win64` 위치에 설치됩니다. 이 설치 위치 내의 `bin` 디렉토리의 경로를 확인합니다.

```
C:\Program Files\OpenSSL-Win64\bin
```

![img](/images/posts/2022/0828/openssl8.png)

#### PATH 변수 추가

![img](/images/posts/2022/0828/openssl9.png)

①`환경 변수 편집`화면 우측의 `새로 만들기` 버튼을 클릭하고, ②앞서 확인한 `bin`디렉토리의 경로를 입력한 후, ③확인 버튼을 클릭합니다.

## [2] `OPENSSL_CONF` 변수 추가

`C:\Program Files\OpenSSL-Win64\bin` 폴더 안에는 `openssl.cfg`파일이 위치하고 있습니다. 이 파일의 경로를 `OPENSSL_CONF`라는 새로운 이름의 환경변수로 추가해야 합니다.

![img](/images/posts/2022/0828/openssl10.png)

### (1) 새 시스템 변수 화면 열기

열려 있는 환경 변수 설정 화면의 하단에 있는 `새로 만들기`버튼을 클릭합니다.

![img](/images/posts/2022/0828/openssl11.png)

### (2) 추가할 변수 입력

변수 이름은 `OPENSSL_CONF`로 입력하고 값은 `C:\Program Files\OpenSSL-Win64\bin\openssl.cfg`로 지정합니다. 

미리 해당 파일이 잘 위치하고 있는지 확인하기 바랍니다.

입력이 완료되면 `확인`을 눌러 창을 닫습니다.

![img](/images/posts/2022/0828/openssl12.png)

### (3) 모든 창 닫기

열려 있는 다른 창들의 `확인` 버튼을 눌러 모든 창을 닫습니다.

![img](/images/posts/2022/0828/openssl13.png)

## #03. 결과 확인

명령프롬프트에서 아래 명령을 수행하여 결과를 확인합니다.

만약 결과가 정상적으로 표시되지 않을 경우 환경변수 설정 과정을 되짚어 봐야 합니다.

```shell
$ openssl -v
```

![img](/images/posts/2022/0828/openssl14.png)