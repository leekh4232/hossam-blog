---
title:  "Windows 서비스 등록"
description: 수동으로 설치한 프로그램들이 윈도우 부팅시에 자동으로 구동되도록 명령프롬프트 상에서 윈도우에 서비스를 등록하는 명령어들 정리.
categories: [Operating System,Windows]
date:   2022-08-26 18:26:00 +0900
author: Hossam
image: /images/index-computing.png
tags: [컴퓨터활용,Operating System,Windows]
pin: true
math: true
mermaid: true
---

## #01. `sc`명령 사용

### 1) 서비스 등록하기

```powershell
sc create 서비스이름 binpath=실행파일경로
```

### 2) 서비스 해제하기

```powershell
sc delete 서비스이름
```

## #02. 자체적인 명령어를 사용하는 경우

### 1) 아파치 웹 서버 서비스 등록하기

아파치 설치 디렉토리 내의 bin 폴더에서 수행

```powershell
httpd.exe -k install
```

### 2) MySQL 서비스 등록하기

MySQL 설치 디렉토리 내의 bin 폴더에서 수행

```powershell
mysqld --install
```