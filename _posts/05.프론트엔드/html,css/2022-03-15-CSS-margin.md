---
title:  "[CSS] Margin 속성"
description: "margin은 바깥 여백을 의미하는 속성입니다. 사람이 벽에 기대어 있는 상태에서 벽을 밀 경우 사람이 밀려나게 되듯이 박스의 바깥에 여백을 형성하면 그 여백의 크기만큼 박스가 밀려나게 됩니다. padding은 박스의 크기에 관여하는 속성이지만 margin은 박스의 위치에 관여하는 속성입니다."
categories: [05.Frontend,HTML&CSS]
tags: [Web Development,Frontend,CSS]
image: /images/indexs/webdevelopment.png
date: 2022-03-15 13:01:28 +0900
author: Hossam
pin: true
math: true
mermaid: true
---

# [CSS] Margin 속성

## #01. Margin 속성의 기본 개요

박스의 바깥 여백을 설정하는 속성

### 1. 값을 설정하는 형식

padding 속성과 동일한 방법으로 기술한다.

#### 기술하는 값에 따른 구분

| 구분       | 설명                                                      | 예시                           |
| ---------- | --------------------------------------------------------- | ------------------------------ |
| 하나의 값  | 상,하/좌,우 모두 같은 값이 부여된다.                      | `margin: 10px;`                |
| 두 개의 값 | 첫 번째 값은 상,하를 의미. 두 번째 값은 좌,우를 의미한다. | `margin: 10px 20px;`           |
| 네 개의 값 | 상단부터 시계방향으로 회전하면서 부여                     | `margin: 10px 20px 30px 40px;` |

#### 위치에 따른 속성 구분

아래의 속성들은 단 하나의 값만을 갖는다.

| 속성          | 설명        |
| ------------- | ----------- |
| margin-left   | 왼쪽 여백   |
| margin-right  | 오른쪽 여백 |
| margin-top    | 상단 여백   |
| margin-bottom | 하단 여백   |

### 2. 기본 특성 (박스의 위치 설정)

박스는 기본적으로 브라우저의 좌측 상단에 배치된다. 이 상태에서 박스의 위쪽과 왼쪽 바깥에 여백이 형성된다면 벽면을 밀어내기 때문에 결국 박스 자신이 반대로 밀려나게 된다.

여백이 작용하는 방향에 다른 박스가 존재한다면 다른 박스를 밀어낸다.

음수값을 설정할 경우 다른 요소를 끌어당기는 특성을 갖는다.

> 즉, 자신이나 다른 박스의 위치에 영향을 주는 속성이다.

**실습: `/13-CSS-Margin/01-margin.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>01-margin</title>
    <style type="text/css">
        body {
            font-size: 24px;
            line-height: 150%;
            font-weight: bold;
        }

        .box1 {
            background-color: #ff0000;
            width: 200px;
            height: 100px;

            /* 주변을 밀어낸다.*/
            margin: 30px;
            /* 음수값을 부여할 경우 주변을 끌어 당긴다. */
            /* margin: -30px; */
        }

        .box2 {
            background-color: #00ff00;
            width: 150px;
            height: 100px;
        }
    </style>
</head>

<body>
    <div class="box1">박스1</div>
    <div class="box2">박스2</div>
</body>

</html>
```

## #02. margin 겹침 현상

두 요소가 서로 마주보는 방향으로 margin이 작용할 경우 margin 값이 겹쳐진다.

![margin](/images/2022/0314/margin1.png)

**실습: `/13-CSS-Margin/02-double_margin.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>02-double_margin</title>
    <style type="text/css">
        body {
            font-size: 24px;
            line-height: 150%;
            font-weight: bold;
        }

        .box1 {
            background-color: #ff0000;
            width: 200px;
            height: 100px;
            margin: 30px;
        }

        .box2 {
            background-color: #00ff00;
            width: 150px;
            height: 100px;
            margin: 20px;
        }
    </style>
</head>

<body>
    <div class="box1">박스1</div>
    <div class="box2">박스2</div>
</body>

</html>
```

## #03. 박스의 정렬에 관여

부모박스 안에서 자식 박스의 위치를 설정하고자 하는 경우 margin으로 설정해야 한다.

margin-left를 사용하면 박스가 왼쪽에서 margin값 만큼 떨어지게 된다.

이 현상을 활용하여 박스가 중앙에 배치되도록 margin-left를 부여한다.

**실습: `/13-CSS-Margin/03-inner_margin.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>03-inner_margin</title>
    <style type="text/css">
        body {
            font-size: 24px;
            line-height: 150%;
            font-weight: bold;
        }

        .parent {
            background-color: #ff6600;
            width: 500px;
            height: 250px;
            /** 텍스트 관련 속성은 문장의 정렬에만 관여하며, 자식요소에게도 상속된다. */
            text-align: center;

            .child {
                background-color: #00ff00;
                width: 300px;
                height: 100px;
                /** margin은 박스의 위치를 설정한다. */
                margin-left: 100px;
            }
        }
    </style>
</head>

<body>
    <div class="parent">
        <!-- 부모 박스 안에서 이 박스를 중앙에 배치하고자 하는 경우 -->
        <div class="child">HTML &amp; CSS</div>
    </div>
</body>

</html>
```

## #04. `margin: auto`

부모요소의 width에서 현재 자신의 크기를 뺀 나머지를 자동으로 계산하여 margin에 부여한다.

| 속성 | 설명 |
|---|---|
| margin-left: auto | 박스가 부모의 오른쪽에 배치된다. |
| margin-right: auto | 박스가 부모의 왼쪽에 배치된다. (기본값) |
| left와 right에 모두 auto적용 | 박스가 부모의 가운데 배치된다. |
| margin: auto | 값이 하나인 경우 상,하,좌,우 모두 적용되지만 auto는 상,하에 대해서는 동작하지 않기 때문에 left, right에만 부여한 것과 동일하게 작용한다. |

**실습: `/13-CSS-Margin/04-auto.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>04-auto</title>
    <style type="text/css">
        body {
            font-size: 24px;
            line-height: 150%;
            font-weight: bold;
        }

        .parent {
            background-color: #ff0000;
            width: 800px;
            height: 500px;
            border: 5px solid #0000ff;
            margin: 50px auto;

            .child {
                background-color: #00ff00;
                padding: 10px;
                border: 5px solid #ff00ff;
                width: 500px;
                margin: 50px auto;
            }
        }
    </style>
</head>

<body>
    <!-- 박스를 화면의 가로축 중앙에 배치하는 경우 -->
    <div class="parent">
        <div class="child">박스2</div>
    </div>
</body>

</html>
```

## #05. 음수값의 사용

`margin`에 음수값을 설정할 경우 다른 요소를 끌어당기는 특성을 갖는다.

**실습: `/13-CSS-Margin/05-음수값사용하기.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>05-음수값사용하기</title>
    <style type="text/css">
        body {
            font-size: 24px;
            line-height: 150%;
            font-weight: bold;
            padding: 0;
            margin: 0;
        }

        .menu {
            width: 100%;
            height: 200px;
            background-color: #ff00ff;
            /** 부여된 값 만큼 밖으로 벗어난다. */
            margin-top: -180px;
            /** 애니메이션을 위한 CSS3 코드 (이 속성의 자세한 내용은 CSS 수업 후반부에 소개합니다.) */
            transition: all 0.3s;

            /** 마우스가 올라간 경우, margin값 복귀 */
            &:hover {
                margin-top: 0px;
                background-color: #ffff00;
            }
        }
    </style>
</head>

<body>
    <!-- 마우스 올렸을 때, 등장하는 메뉴 영역 -->
    <div class="menu">
        Menu Area
    </div>
</body>

</html>
```
