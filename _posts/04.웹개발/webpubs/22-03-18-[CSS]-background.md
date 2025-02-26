---
layout: post
title:  "[CSS] background 속성"
date:   2022-03-18
banner_image: index-webdevelopment.png
tags: [Web Publishing]
---

배경 관련 속성은 특정 HTML요소에 배경 색상이나 배경 이미지를 설정하는 속성입니다. 자칫 단순해 보이는 이 기능을 잘 활용하면 웹 페이지의 로딩속도를 향상시키는데 도움이 됩니다.

<!--more-->


# #01. 배경 관련 속성

| 속성 | 설명 |
|------|------|
| background-color | 배경색상 지정 |
| background-image | 배경이미지.<br/>url("파일경로");<br/>**외부 css파일에서 명시할 경우 파일 경로는 html기준이 아닌 css파일 기준이 된다.** |
| background-repeat | 배경이미지 반복 설정<br/>repeat, repeat-x, repeat-y, no-repeat |
| background-attachment |  스크롤에 따른 배경 이미지 처리<br/>scroll, fixed |
| background-position | 배경이미지 위치.<br/>left, right, top, bottom, center, px값<br/>가로와 세로를 공백으로 구분하여 지정  |
| background-size | `가로축크기 세로축크기`를 공백으로 구분하여 지정한다.<br/>- px단위 값: 배경이미지의 크기를 절대값으로 설정<br/>- %단위 값: 자신이 표시될 박스 크기에 기준하여 백분율로 설정<br/>- cover: 가로우선<br/>- contain: 세로우선<br/>
| background | 위의 다섯가지 속성을 공백으로 구분하여 일괄 명시. 불필요한 요소는 생략 가능. |

   
# #02. 배경관련 속성 활용

## 1) 이미지에 텍스트가 포함된 경우

1. 원본 텍스트를 HTML안에 명시.
1. 이미지는 그 안에 배경으로 설정
1. 원본 텍스트를 text-indent 속성으로 화면에서 멀리 떨어지게 설정.

## 2) 이미지 클립핑

1. 아이콘, 버튼 등의 이미지를 하나의 이미지 파일에 모두 모아 놓기.
1. 표시할 항목의 크기와 동일한 박스를 준비. 그 안에 배경이미지로 설정.
1. background-position 속성으로 이미지를 표시하고자 하는 위치까지 이동.


## 3) background 속성의 중첩 사용
- 콤마(,)로 구분하여 여러 겹의 배경을 지정할 수 있음.
- 마지막에 명시된 항목이 가장 뒤에 배치된다.

```css
background: url(img/btn_a.png) right 0 repeat-y,
            url(img/menu.png) no-repeat,
            url(img/menu_bg.png) repeat-x;
```

# #03. 그라디언트 색상 처리

## 1) webkit 계열 브라우저의 경우

```css
/* -webkit-gradient:(유형, 시작위치 끝위치, 시작색상, 종료색상); */
background: -webkit-gradient(linear, left bottom, right top, from(#06f), to(#fff));
```

## 2) mozila 계열 브라우저의 경우

```css
/* -moz-유형-gradient:(시작위치 [각도], 시작색상, 종료색상); */
background: -moz-linear-gradient(bottom 45deg, #06f, #fff);
```


