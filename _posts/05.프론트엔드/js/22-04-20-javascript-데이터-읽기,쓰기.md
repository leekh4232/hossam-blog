---
title: "Javascript 데이터 읽기,쓰기"
description: ""
categories: [05.Frontend,Javascript]
date: 2022-04-20 11:33:00 +0900
author: Hossam
image: /images/index-js.png
tags: [Web Development,Frontend,Javascript]
pin: true
math: true
mermaid: true
---

Javascript는 웹 브라우저에 사용자 데이터를 저장할 수 있습니다. 이 데이터들은 다음번 웹 사이트 접속시 활용될 수 있기 때문에 사용자 맞춤 기능을 구현하는데 활용됩니다.



## #01. 쿠키

사용자의 웹 브라우저에 저장되는 텍스트 데이터.

모든 사용자가 각각 자신만의 정보를 저장할 수 있기 때문에 개인화 기능을 구현하는데 활용될 수 있다.

정보를 저장하는데 있어 "이름=값; 유효시간; 유효경로; 유효도메인" 으로 설정한다.

이름과 값은 모두 URLEncoding 처리 되어야 한다.(영어,숫자는 제외)

유효시간은 초단위로 기록.

- 설정되지 않으면 브라우저를 닫기 전까지 데이터가 유지
- 0으로 설정하면 즉시 삭제
- 0보다 큰 숫자로 설정하면 해당 초가 지나기 전까지는 브라우저를 재시작 하더라도 저장된 정보가 유지된다.

유효경로는 해당 쿠키값을 읽고 쓸 수 있는 특정 폴더 경로를 지정할 수 있다.

(일반적으로 "/"만 지정하여 사이트 전역에서 쿠키가 유효하게 설정한다.)

쿠키는 기본적으로 저장된 도메인에서만 유효하다.

> ex) www.naver.com에서 저장한 쿠키는 blog.naver.com에서는 식별되지 않는다.

- ".naver.com" 으로 유효도메인을 설정하면 앞에 붙는 호스트이름에 상관없이 쿠키가 공유된다.
- 패밀리사이트간의 정보 공유를 위해 많이 사용된다. (특히 통합로그인)

### 장점

- 대부분의 브라우저가 지원

### 단점

- 매 HTTP요청마다 포함되어 api호출로 서버에 부담. (페이지 이동시마다 백엔드에 무조건 모든 쿠키가 전송됨)
- 쿠키의 용량이 작음 (약 4Kb)
- 암호화 존재 x -> 사용자 정보 도난 위험

### 사용 예

- 오늘 본 상품
- 오늘 하루 이 창 열지 않음.
​

## #02. 웹 스토리지

쿠키의 단점을 보완해 HTML5에서 추가된 기술로 로컬스토리지와 세션스토리지로 구분됨.

### 특징

- 웹스토리지는 Key와 Value 형태로 이루어짐.
- 웹스토리지는 클라이언트에 대한 정보를 저장.
- 웹스토리지는 로컬에만 정보를 저장, 쿠키는 서버와 로컬에 정보를 저장.

| 종류          | 특징                                                         | 사용 예                              |
| ------------- | ------------------------------------------------------------ |
| ​로컬스토리지 | 클라이언트에 대한 정보를 영구적으로 저장                     | 자동 로그인 저장                     |
| 세션스토리지  | 세션 종료 시(브라우저 닫을 경우) 클라이언트에 대한 정보 삭제 | 입력 폼 정보 저장, 비로그인 장바구니 |

### 장점

- 서버에 불필요하게 데이터를 저장하지 않는다. (백엔드에 절대로 전송되지 않는다.)
- 저장 가능한 데이터의 용량이 크다. (약 5Mb, 브라우저마다 차이 존재)

### 단점

- HTML5를 지원하지 않는 브라우저의 경우 사용 불가. (현재는 거의 없다고 봐야 한다.)
