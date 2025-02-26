---
layout: post
title: "[JS] HTML,CSS 제어하기"
date: 2022-04-16
banner_image: index-js.png
tags: [Javascript]
---

HTML요소를 자바스크립트 객체로 정의하고 이벤트를 연결하는 과정을 "누가", "언제"에 비유한다면 이벤트가 발생했을 때 호출되는 콜백함수는 "무엇을", "어떻게"에 비유할 수 있습니다. 이 단원에서는 이벤트 발생시 화면에 변화를 줄 수 있는 HTML, CSS 제어 방법에 대해 소개 합니다.

<!--more-->

# #01. 기본 용어

- HTML 태그 : Element
- 값이 있는 속성 : Attribute
- 값이 없는 속성 : Property


# #02. HTML 속성 제어

```javascript
const mytag = document.getElementById("...");

mytag.hasAttribute(name);        //— 속성의 존재 확인.
mytag.getAttribute(name);        //— 속성값을 가져옴.
mytag.setAttribute(name, value); //— 속성값을 변경함.
mytag.removeAttribute(name);     //— 속성값을 제거함.
```

# #03. CSS 제어

## 1) 획득한 객체 CSS속성 접근

```javascript
const mytag = document.getElementById("...");

// 내용 적용하기
mytag.style.css관련_프로퍼티 = "값";

// 적용된 내용 조회하기
const css = mytag.style.css관련_프로퍼티
```

css관련_프로퍼티의 이름 규칙은 css에서 `-`로 표시되던 부분이 없어지고 대문자가 사용된다.

> ex) [css] background-color  --> [js] backgroundColor


## 2) 획득한 객체의 CSS클래스 접근

```javascript
const mytag = document.getElementById("...");

mytag.classList.add(name);      // 클래스 추가 
mytag.classList.remove(name);   // 클래스 제거 
mytag.classList.toggle(name);   // 클래스 on/off
mytag.classList.contains(name); // 해당 클래스가 존재하는지 여부를 boolean으로 반환
```

--------------

# HTML 제어하기 연습문제

## #문제01

아래 화면과 같이 현재 시각을 `yyyy-mm-dd hh:mi:ss` 형식으로 출력하는 웹 페이지를 구현하시오.

년도는 4자리 숫자로 구성되며 월,일,시,분,초는 2자리 숫자 입니다.

출력되는 시간은 매초마다 자동으로 화면상에서 갱신되어야 합니다.

![q1](/images/posts/2022/0416/q1.png)

## #문제2

아래 화면과 같이 off 상태의 버튼이 누를때마다 on/off 의 상태가 변경되도록 CSS를 적용할 수 있는 코드를 작성하세요.

![q2](/images/posts/2022/0416/q2.png)


## #문제3

아래의 화면과 같이 버튼에 따라 과거의 n일 전부터 오늘까지의 범위를 표시하는 웹 페이지를 작성하시오.

![q4](/images/posts/2022/0416/q3.png)