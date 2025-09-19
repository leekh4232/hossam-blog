---
title:  "[CSS] display 속성"
description: "display속성은 요소를 어떻게 보여줄지를 결정하는 속성으로 block-level과 inline-level의 특징을 결정짓는 속성이기도 합니다. block-level과 inline-level이 각각 다른 기본값을 갖고 있기 때문에 이를 잘 구별하여 사용해야 합니다."
categories: [05.Frontend,HTML&CSS]
tags: [Web Development,Frontend,CSS]
image: /images/indexs/webdevelopment.png
date: 2022-03-16 13:01:28 +0900
author: Hossam
pin: true
math: true
mermaid: true
---

# CSS Display 속성

`display` 속성은 웹 페이지의 레이아웃을 결정하는 가장 기본적인 CSS 속성 중 하나입니다. 모든 HTML 요소는 기본적으로 `block` 또는 `inline` 특성 중 하나를 가지며, `display` 속성은 이 기본값을 변경하여 요소가 화면에 어떻게 보이고 다른 요소와 어떻게 상호작용할지 제어합니다.

이 단원에서는 `display` 속성의 주요 값인 `block`, `inline`, `inline-block`에 대해 집중적으로 학습합니다.

## `display` 속성값의 종류

`display` 속성에는 다양한 값을 사용할 수 있으며, 각 값은 요소의 렌더링 방식에 큰 영향을 줍니다. 아래는 `display` 속성에 사용할 수 있는 주요 값들의 목록입니다.

| 값 | 설명 |
|---|---|
| `block` | 요소를 블록 레벨(Block-Level) 요소처럼 표시합니다. 항상 새로운 줄에서 시작하고, 사용 가능한 전체 너비를 차지합니다. `width`, `height`, `margin`, `padding` 속성을 모두 사용할 수 있습니다. |
| `inline` | 요소를 인라인 레벨(Inline-Level) 요소처럼 표시합니다. 새로운 줄에서 시작하지 않으며, 내용(content)에 필요한 만큼의 너비만 차지합니다. `width`와 `height` 속성은 적용되지 않으며, `margin`은 좌우에만 적용됩니다. |
| `inline-block` | `inline`과 `block`의 특징을 결합한 형태입니다. `inline`처럼 줄바꿈 없이 다른 요소와 나란히 배치되지만, `block`처럼 `width`, `height`, `margin`, `padding` 속성을 모두 사용하여 크기와 여백을 지정할 수 있습니다. |
| `none` | 요소를 화면에서 완전히 제거합니다. 요소가 차지하던 공간도 사라져, 마치 처음부터 없었던 것처럼 렌더링됩니다. |
| `flex` | 플렉스박스(Flexbox) 레이아웃 모델을 활성화합니다. 자식 요소들을 1차원(가로 또는 세로)으로 유연하게 배치하고 정렬할 수 있는 강력한 방법을 제공합니다. |
| `grid` | 그리드(Grid) 레이아웃 모델을 활성화합니다. 행과 열의 2차원 구조로 자식 요소들을 정밀하게 배치할 수 있습니다. |
| `table`, `table-row`, `table-cell` | 요소를 `<table>`, `<tr>`, `<td>` 태그처럼 동작하게 만듭니다. 과거에 레이아웃을 위해 사용되었으나, 지금은 `flex`와 `grid`가 더 현대적이고 효율적인 대안입니다. |

> **학습 범위 안내**
>
> - 이번 단원에서는 `block`, `inline`, `inline-block` 세 가지 핵심 값에 대해 자세히 다룹니다.
> - 다음 단원에서는 현대적인 레이아웃의 표준인 `flex`에 대해 학습할 예정입니다.
> - 그 외 `grid`, `table` 관련 값들은 활용도가 상대적으로 낮아 본 과정에서는 상세히 다루지 않습니다.

---

## #01. `block`과 `inline`의 특징과 변환

HTML 요소는 기본적으로 `block` 또는 `inline` 중 하나의 `display` 값을 가집니다. 예를 들어, `<div>`는 대표적인 `block` 요소이고 `<span>`은 대표적인 `inline` 요소입니다.

`display` 속성을 사용하면 이러한 기본 동작을 바꿀 수 있습니다.

- **`display: block;`**: `inline` 요소를 `block` 요소처럼 동작하게 만듭니다.
  - 줄바꿈이 일어나며, 가로 너비가 100%로 확장됩니다.
  - `width`, `height` 속성을 사용하여 크기를 지정할 수 있게 됩니다.
- **`display: inline;`**: `block` 요소를 `inline` 요소처럼 동작하게 만듭니다.
  - 줄바꿈 없이 다른 요소와 한 줄에 배치됩니다.
  - `width`, `height` 속성이 무시되고, 내용의 크기만큼만 공간을 차지합니다.

아래 실습에서는 `<div>` 태그에 `display: inline;`을, `<span>` 태그에 `display: block;`을 적용하여 각 요소의 기본 동작이 어떻게 변하는지 보여줍니다.

**실습: `/14-CSS-display(1)/01-block,inline.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>01-block,inline</title>
    <style type="text/css">
        body {
            font-size: 24px;
            line-height: 150%;
            font-weight: bold;
        }

        div, span {
            width: 300px;
            height: 150px;
        }

        div {
            background-color: #ff6600;
            display: inline;
        }

        span {
            background-color: #ff00ff;
            display: block;
        }
    </style>
</head>

<body>
    <div>DIV태그(1)</div>
    <div>DIV태그(2)</div>
    <span>SPAN태그(1)</span>
    <span>SPAN태그(2)</span>
</body>

</html>
```

- **`<div>` 태그**: `display: inline;`이 적용되자 `width: 300px`, `height: 150px` 설정이 무시되고, 내용의 크기만큼만 공간을 차지하며 옆으로 나란히 배치됩니다.
- **`<span>` 태그**: `display: block;`이 적용되자 `width: 300px`, `height: 150px` 설정이 적용되고, 각 요소가 한 줄 전체를 차지하며 줄바꿈이 일어납니다.

---

## #02. `inline-block`의 이해와 활용

`display: inline-block;`은 `inline`과 `block`의 장점을 결합한 속성입니다.

- **`inline`의 특징**: 줄바꿈 없이 다른 요소들과 한 줄에 나란히 배치됩니다.
- **`block`의 특징**: `width`, `height`, `margin`, `padding` 속성을 모두 사용하여 크기와 여백을 자유롭게 지정할 수 있습니다.

이러한 특성 덕분에 `inline-block`은 수평 내비게이션 메뉴나 여러 개의 아이템을 가로로 정렬할 때 매우 유용하게 사용됩니다.

아래 실습에서는 여러 개의 `.box` 요소를 `display: inline-block;`으로 설정하여 가로로 나열하고 있습니다. 부모 요소인 `.container`에 `text-align: center;`를 적용하면 `inline-block` 요소들이 중앙에 정렬되는 것도 확인할 수 있습니다.

> **`inline-block` 사용 시 주의사항**
>
> `inline-block` 요소들 사이에는 HTML 코드상의 줄바꿈이나 공백 문자가 약 `4px` 정도의 시각적 간격으로 렌더링될 수 있습니다. 이 간격을 제거하기 위해 `margin: 0 -4px;`과 같은 트릭을 사용하거나, 부모 요소에 `font-size: 0;`을 설정하는 방법을 사용하기도 합니다.

**실습: `/14-CSS-display(1)/02-inline-block.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>02-inline-block</title>
    <style type="text/css">
        body {
            font-size: 24px;
            line-height: 150%;
            font-weight: bold;
        }

        .container {
            text-align: center;

            .box {
                width: 400px;
                height: 300px;
                display: inline-block;
                box-sizing: border-box;
                margin: 0 -4px;

                &:nth-child(odd) {
                    background-color: #ff6600;
                }

                &:nth-child(2n) {
                    background-color: #0066ff;
                }
            }
        }
    </style>
</head>

<body>
    <div class="container">
        <div class="box">1</div>
        <div class="box">2</div>
        <div class="box">3</div>
        <div class="box">4</div>
        <div class="box">5</div>
        <div class="box">6</div>
        <div class="box">7</div>
        <div class="box">8</div>
    </div>
</body>

</html>
```

---

## #03. 링크(`<a>`) 요소에 `display` 속성 활용하기

`<a>` 태그는 대표적인 `inline` 요소입니다. 따라서 기본적으로 `width`와 `height`를 가질 수 없어, 텍스트가 있는 영역에만 링크가 활성화됩니다.

사용자 경험을 개선하기 위해 `<a>` 태그에 `display: block;` 또는 `display: inline-block;`을 적용하여 클릭 가능한 영역을 넓힐 수 있습니다.

### 1. 세로 메뉴 만들기

`<a>` 태그에 `display: block;`을 적용하면, 요소가 `block` 요소처럼 변해 가로 너비 전체를 차지하게 됩니다. 이를 통해 메뉴 항목의 어느 곳을 클릭해도 링크가 동작하는 세로 메뉴를 쉽게 만들 수 있습니다.

**실습: `/14-CSS-display(1)/03-link-display.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>03-link-display</title>
    <style type="text/css">
        .link {
            font-size: 14px;
            line-height: 40px;
            padding: 0 15px;
            color: #222;
            text-decoration: none;
            display: block;
            width: auto;
            height: 40px;
            border-bottom: 1px dotted #cccccc;

            /** :first-child --> 여러개의 요소 중에서 첫 번째 요소 */
            &:first-child {
                border-top: 1px dotted #cccccc;
            }

            /** :last-child --> 여러개의 요소 중에서 마지막 요소 */
            &:hover {
                /** 마우스 오버시 배경색상 변경 */
                background-color: #ffff00;
            }
        }
    </style>
</head>

<body>
    <a href="#" class="link">메뉴항목1</a>
    <a href="#" class="link">메뉴항목2</a>
    <a href="#" class="link">메뉴항목3</a>
    <a href="#" class="link">메뉴항목4</a>
</body>

</html>
```

### 2. 복잡한 구조의 링크 만들기

`<a>` 태그는 `inline` 요소이므로 원칙적으로 내부에 `<div>`나 `<p>` 같은 `block` 요소를 포함할 수 없습니다. 하지만 제목과 설명처럼 여러 줄로 구성된 복잡한 내용을 하나의 링크로 묶고 싶을 때가 있습니다.

이때 `<a>` 태그 내부에 `<span>` 태그를 사용하고, 이 `<span>` 태그에 `display: block;`을 적용하면 문단처럼 보이게 만들 수 있습니다.

아래 실습은 `<a>` 태그 안에 제목(`subject`)과 설명(`desc`)을 담은 두 개의 `<span>` 태그를 넣고, 각 `<span>`을 `display: block;`으로 처리하여 여러 줄로 구성된 게시물 목록 형태의 링크를 구현한 예제입니다.

**실습: `/14-CSS-display(1)/04-link-display(2).html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>04-link-display(2)</title>
    <style type="text/css">
        .link {
            font-size: 16px;
            padding: 10px 15px;
            color: #222;
            text-decoration: none;
            display: block;
            width: auto;
            height: auto;
            border-bottom: 1px dotted #cccccc;

            /** :first-child --> 여러개의 요소 중에서 첫 번째 요소 */
            &:first-child {
                border-top: 1px dotted #cccccc;
            }

            /** :last-child --> 여러개의 요소 중에서 마지막 요소 */
            &:hover {
                /** 마우스 오버시 배경색상 변경 */
                background-color: #ffff00;
            }

            /* 링크 안의 <span>태그를 block-level요소로 변경하고 말줄임 처리 추가 */
            span {
                display: block;
                white-space: nowrap;
                text-overflow: ellipsis;
                overflow: hidden;

                /* 제목부분 강조하기 */
                &.subject {
                    font-weight: bold;
                    font-size: 16px;
                    padding-bottom: 5px;
                }

                /* 내용부분 글자 크기 */
                &.desc {
                    font-size: 12px;
                }
            }
        }
    </style>
</head>

<body>
    <!--
            링크는 HTML 분류상 inline-level 요소이기 때문에, block-level을 포함할 수 없다.
            즉, 링크 안에서 여러개의 문단을 구성하기 위해서는 <span>만 사용할 수 있다.
            <span>을 문단처럼 적용하기 위하여, display 속성을 block으로 부여한다.
        -->
    <a href="#" class="link">
        <span class="subject">HTML</span>
        <span class="desc">웹 페이지를 제작하기 위한 뼈대를 구성하는 언어</span>
    </a>
    <a href="#" class="link">
        <span class="subject">CSS</span>
        <span class="desc">HTML로 구성된 뼈대에 옷을 입히는 언어</span>
    </a>
    <a href="#" class="link">
        <span class="subject">JavaScript</span>
        <span class="desc">동적인 기능을 추가는 언어</span>
    </a>
</body>

</html>
```

---

## #04. 목록(`<ul>`, `<li>`) 요소에 `display` 속성 활용하기

`<ul>`, `<li>`와 같은 목록 요소는 기본적으로 `display: block;`입니다. `<li>` 요소는 수직으로 나열되며, 각 항목 앞에 불릿(bullet)이 표시됩니다.

`display` 속성을 활용하면 이러한 목록을 다양한 형태로 변형할 수 있습니다. 예를 들어, `<li>` 요소에 `display: inline-block;`을 적용하면 세로 목록을 가로 내비게이션 메뉴로 쉽게 바꿀 수 있습니다.

아래 실습에서는 `<ul>`과 `<li>`의 기본 스타일(list-style, padding, margin)을 초기화한 후, `<li>` 안의 `<a>` 태그에 `display: block;`을 적용하여 각 목록 항목 전체가 클릭 가능한 링크가 되도록 만들었습니다.

**실습: `/14-CSS-display(1)/05-목록정의요소.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>05-목록정의요소</title>
    <style type="text/css">
        a {
            text-decoration: none;
            color: #222;
            font-size: 16px;
        }

        /** 목록 정의 초기화 */
        ul {
            list-style: none;
            padding: 0;
            margin: 0;

            li {
                border-bottom: 1px solid #cccccc;

                &:first-child {
                    border-top: 1px solid #cccccc;
                }
            }

            a {
                /** 링크의 박스화 --> 하나의 목록 안을 전체 클릭 가능하게 한다. */
                display: block;
                padding: 10px 15px;
                width: auto;

                &:hover {
                    background-color: #00ff0080;
                }
            }
        }
    </style>
</head>

<body>
    <h1>서비스 목록</h1>
    <ul>
        <li><a href="#">메일</a></li>
        <li><a href="#">블로그</a></li>
        <li><a href="#">카페</a></li>
        <li><a href="#">쇼핑</a></li>
        <li><a href="#">지식인</a></li>
    </ul>
</body>

</html>
```

만약 이 목록을 가로로 만들고 싶다면, `li { display: inline-block; }`을 추가하기만 하면 됩니다. 이처럼 `display` 속성은 기존 요소의 구조적 한계를 넘어 다양한 레이아웃을 구현할 수 있게 해주는 핵심적인 도구입니다.
