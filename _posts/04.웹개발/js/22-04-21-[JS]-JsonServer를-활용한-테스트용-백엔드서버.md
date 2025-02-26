---
layout: post
title: "[JS] JsonServer를 활용한 테스트용 백엔드서버"
date: 2022-04-20
banner_image: index-js.png
tags: [Javascript]
---

간단한 JSON 파일 구성만으로 프론트엔드가 Ajax로 연동할 수 있는 테스트 RestfulAPI서버를 구축할 수 있다.

각 테이블간의 참조무결성제약조건은 보장되지 않는다.

<!--more-->

# #01. 설치

```shell
npm install -g json-server
```

`-g` 옵션은 global의 줄임말.

이 옵션이 적용된 경우 특정 폴더에 종속되는 것이 아니라 현재 컴퓨터의 사용자 계정에 대해 전역으로 사용할 수 있도록 설치된다.

설치 위치가 명령어 실행 위치와 상관 없이 사용자 홈 디렉토리 내의 위치로 지정된다.

# #02. 기본 사용 방법

## 1) JSON 데이터 만들기 

아래와 같은 형식으로 JSON 데이터 구성

**Primary Key 역할을 하는 필드의 이름은 반드시 `id`로 지정되어야 한다.**

```json
{
    "테이블1이름": [
        {"컬럼1" : "값", "컬럼2": "값", "컬럼n": "값"},
        {"컬럼1" : "값", "컬럼2": "값", "컬럼n": "값"},
        {"컬럼1" : "값", "컬럼2": "값", "컬럼n": "값"},
        {"컬럼1" : "값", "컬럼2": "값", "컬럼n": "값"}
    ],
    "테이블2이름": [
        {"컬럼1" : "값", "컬럼2": "값", "컬럼n": "값"}
    ],
    "테이블n이름": [
        {"컬럼1" : "값", "컬럼2": "값", "컬럼n": "값"}
    ]
}
```

## 2) json-server 가동하기

```shell
json-server --watch 데이터파일경로 [--port 3001]
```

아래와 같은 형식으로 URL접근이 가능

| Method | 설명 | URL |
|--|--|--|
| GET | 목록(전체)보기 | http://localhost:포트번호/테이블이름  |
| GET | 특정항목(상세)보기 | http://localhost:포트번호/테이블이름/id |
| POST | id를 제외한 항목을 전송하여 데이터 추가 | http://localhost:포트번호/테이블이름 |
| PUT | id를 제외한 항목을 전송하여 데이터 수정 | http://localhost:포트번호/테이블이름/id |
| DELETE | 데이터 삭제 | http://localhost:포트번호/테이블이름/id |

## 3) public 디렉토리 구성

`json-server`를 가동한 디렉토리에 `public`이라는 이름의 폴더를 생성해 놓으면 이 폴더가 웹 서버상의 root 디렉토리로 사용된다.

예를 들어 `/public/img/test.png` 라는 파일이 존재할 경우 아래의 URL로 접근 가능하다.

```
http://localhost:포트번호/img/test.png
```
