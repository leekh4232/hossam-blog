---
layout: post
title:  "VSCode에서 HTML의 Path값을 thymeleaf 형식으로 변환하기 위한 정규표현식"
date:   2024-11-01
banner_image: photo/study-cafe.png
tags: [Tip&Tech]
---

순수 HTML 환경에서 작업한 프로토타입을 SpringBoot MVC 패턴의 View에 적용하는 과정에서 `href="..."`나 `src="..."` 속성에 사용되는 Path값을 `th:href="@{...}`, `th:src="@{...}` 형태로 변환해야 한다. 일일이 처리하는 것은 매우 번거롭기 때문에 VSCode의 replace 기능에 정규표현식을 적용하면 쉽게 처리할 수 있다.

<!--more-->


# VSCode의 정규표현식 바꾸기 기능 사용하기

## 찾을 문자열

`Ctrl+H` (Mac의 경우 `Cmd+Option+F`)를 눌러 Replace창을 띄운 상태에서 `Alt(Option)+R`을 누르면 정규표현식이 활성화 된다.

찾을 문자열 입력 칸에 아래의 표현식을 적용한다.

```regexp
(src=|href=)("|')([^"|']*)("|')
```

## 바꿀 문자열

바꾸기 입력 칸에는 다음의 표현식을 기입한다.

### 쌍따옴표와 홑따옴표를 모두 쌍따옴표로 변경하는 경우

```regexp
th:$1"@{$3}"
```

### 쌍따옴표와 홑따옴표를 그대로 유지하는 경우

```regexp
th:$1$2@{$3}$4
```