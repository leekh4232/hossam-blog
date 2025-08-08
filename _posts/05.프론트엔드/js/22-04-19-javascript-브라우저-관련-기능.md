---
title: "Javascript 브라우저 관련 기능"
description: ""
categories: [05.Frontend,Javascript]
date: 2022-04-19 11:33:00 +0900
author: Hossam
image: /images/indexs/js.png
tags: [Web Development,Frontend,Javascript]
pin: true
math: true
mermaid: true
---

HTML 태그외에 웹 브라우저와 직접적으로 연관되는 기능들



## window 내장 객체

브라우저의 새창,팝업 열기/닫기 기능 제공

### a.html을 새 창(새 탭)으로 열기

```javascript
window.open('a.html');
```

### a.html을 팝업으로 열기

```javascript
// window.open('URL', '창이름', '옵션');
window.open('a.html','mywin','width=500, height=300, scrollbars=no,
                    toolbar=no, menubar=no, status=no, location=no');
```
- 창 이름
	- 부여하지 않을 경우 매번 새 팝업창이 생성됨
	- 부여할 경우 한번 사용한 팝업창을 재사용함
- 옵션
	- 창 크기 관련 : width, height
		- 창의 가로, 세로 크기를 정수로 지정
	- 창 모양 관련 : scrollbars, toolbar, menubar, status, location
		- yes / no로 값을 지정
		- location의 경우 피싱 사이트 방지를 위해서 동작하지 않음.


### 현재 창 닫기

```javascript
window.close();
// 혹은
self.close();
```



## navigator 내장객체

웹 브라우저의 정보 조회 기능.

| 기능                  | 설명                                          |
| --------------------- | --------------------------------------------- |
| navigator.appName     | 브라우저 이름                                 |
| navigator.appCodeName | 브라우저 코드명                               |
| navigator.platform    | 플랫폼 정보                                   |
| navigator.appVersion  | 브라우저 버전                                 |
| navigator.userAgent   | 사용자 정보 (가장 포괄적인 정보를 담고 있다.) |

웹 브라우저의 이름, 버전정보, 운영체제 정보 등이 포함된 문자열 값.

```javascript
var agent = navigator.userAgent;
```

이 값에 특정 단어가 포함되어 있는지 여부를 판단하여 브라우저나 운영체제 종류, 모바일/PC 여부 등을 확인할 수 있다.
```javascript
var agent = navigator.userAgent;

if (agent.indexOf('검사할단어') > -1) {
	... 처리내용 ...
}
```

<img src="/images/2022/0419/UserAgent-iphone.jpg" width="30%" />