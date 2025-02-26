---
layout: post
title:  "[CSS] display 속성"
date:   2022-03-15
banner_image: index-webdevelopment.png
tags: [Web Publishing]
---

display속성은 요소를 어떻게 보여줄지를 결정하는 속성으로 block-level과 inline-level의 특징을 결정짓는 속성이기도 합니다.

block-level과 inline-level이 각각 다른 기본값을 갖고 있기 때문에 이를 잘 구별하여 사용해야 합니다.

<!--more-->

# #01. display 속성값의 종류

| 값 | 설명 |
|---|---|
| block | Block-Level요소의 기본 값.<br/>어떤 요소를 문단처럼 구성할 수 있도록 한다. (줄바꿈)<br/>**width, height가 적용된다.** |
| inline | Inline-Level요소의 기본 값.<br/>어떤 요소를 문장처럼 구성할 수 있도록 한다. (줄바꿈 안함)<br/>**width, height를 적용할 수 없다.** |
| inline-block | 크기 지정이 가능한 문장요소 |
| none | 어떤 요소를 화면 표시하지 않도록 숨긴다. |
| flex | 아이템들을 가로 방향 혹은 세로 방향으로(1차원 배치) 배치할 수 있는 방식으로 요소의 크기가 불분명하거나 동적인 경우에도 각 요소를 정렬할 수 있는 효율적인 방법을 제공한다. |


# #02. display 속성의 응용

## 1) 링크의 영역을 확장하기

1. `<a>`태그에게 width, height를 부여하면 그 만큼 클릭 가능한 영역이 확장
1. `<a>` 태그가 inline-level이므로 display속성을 block으로 지정해야만 처리가 가능.

## 2) 목록정의 요소

1. `<ul>`,`<ol>`에게 `list-style: none;` `padding: 0;` `margin: 0`을 부여하면<br/>2중으로 중첩된 `<div>`요소와 같이 초기화 된다.
1. 이후부터 `<li>`요소의 display 속성을 조절하여 메뉴를 배치할 수 있다.

> flex 속성은 17단원에서 따로 진행합니다.