---
title:  "[CSS] background 속성"
description: "배경 관련 속성은 특정 HTML요소에 배경 색상이나 배경 이미지를 설정하는 속성입니다. 자칫 단순해 보이는 이 기능을 잘 활용하면 웹 페이지의 로딩속도를 향상시키는데 도움이 됩니다."
categories: [05.Frontend,HTML&CSS]
tags: [Web Development,Frontend,CSS]
image: /images/indexs/webdevelopment.png
date: 2022-03-19 13:01:28 +0900
author: Hossam
pin: true
math: true
mermaid: true
---


# CSS 배경(Background)

웹 페이지의 배경을 꾸미는 것은 사용자 경험에 큰 영향을 미칩니다. CSS는 배경에 색상을 채우거나, 이미지를 넣고, 그 이미지를 제어하는 다양한 속성을 제공합니다. 이 문서에서는 CSS 배경 관련 속성들을 실습 예제와 함께 자세히 알아봅니다.

---

## #01. 배경 관련 기본 속성

HTML 요소의 배경을 제어하는 가장 기본적인 속성들을 알아봅니다. 이러한 속성들을 사용하면 배경에 색을 넣거나 이미지를 배치하고, 반복 여부와 위치를 설정할 수 있습니다.

### 1. 주요 배경 속성

| 속성 | 설명 | 값의 예시 |
| --- | --- | --- |
| `background-color` | 요소의 배경 색상을 지정합니다. | `#000000`, `red`, `rgb(255,0,0)` |
| `background-image` | 요소의 배경으로 표시할 이미지를 지정합니다. `url()` 함수를 사용합니다. | `url(img/bg.jpg)` |
| `background-repeat` | 배경 이미지의 반복 방법을 설정합니다. | `repeat`, `no-repeat`, `repeat-x`, `repeat-y` |
| `background-attachment` | 페이지를 스크롤할 때 배경 이미지의 동작을 설정합니다. | `scroll` (기본값), `fixed` |
| `background-position` | 배경 이미지의 시작 위치를 설정합니다. 가로와 세로 위치를 지정합니다. | `right top`, `center`, `50% 50%` |

- **`background-color`**: 배경에 단색을 채웁니다.
- **`background-image`**: 배경에 이미지를 삽입합니다. 색상과 이미지가 함께 지정되면, 이미지가 색상 위에 겹쳐서 나타납니다.
- **`background-repeat`**:
    - `repeat`: 가로와 세로 방향으로 모두 반복합니다. (기본값)
    - `repeat-x`: 가로 방향으로만 반복합니다.
    - `repeat-y`: 세로 방향으로만 반복합니다.
    - `no-repeat`: 이미지를 한 번만 표시하고 반복하지 않습니다.
- **`background-attachment`**:
    - `scroll`: 배경 이미지가 페이지와 함께 스크롤됩니다.
    - `fixed`: 배경 이미지가 뷰포트(viewport)에 고정되어 스크롤을 해도 움직이지 않습니다.
- **`background-position`**: 키워드(top, bottom, left, right, center)나, px, % 같은 단위로 위치를 지정할 수 있습니다.

### 2. 배경 속성 일괄 지정 (Shorthand)

`background` 속성을 사용하면 위의 속성들을 한 번에 지정할 수 있어 코드를 간결하게 만들 수 있습니다. 각 속성값은 공백으로 구분하며, 순서는 크게 중요하지 않지만 일반적으로 다음과 같은 순서로 작성합니다.

```css
/* background: color image attachment position repeat; */
background: #000000 url(img/bg.jpg) fixed right top repeat-x;
```

필요 없는 속성은 생략할 수 있습니다. 예를 들어, 배경 이미지와 색상만 지정하고 싶다면 다음과 같이 작성할 수 있습니다.

```css
background: #000000 url(img/bg.jpg);
```

그러므로 배경 색상을 제외한 모든 속성을 생략할 경우 `background`와 `background-color` 속성이 같은 의미가 됩니다.

```css
background: #000000; /* background-color와 동일 */
```

### 3. 실습 예제

아래 예제는 `<body>` 태그에 배경 속성을 적용한 모습입니다.
- 배경색은 검은색(`black`)으로 설정했습니다.
- `img/bg.jpg` 이미지를 배경으로 사용하며, 가로 방향(`repeat-x`)으로만 반복합니다.
- `background-attachment: fixed` 속성으로 스크롤을 내려도 배경 이미지는 뷰포트의 `right top` 위치에 고정되어 움직이지 않습니다.

**실습: `/17-CSS-Background/01-BackgroundBasic.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>01-BackgroundBasic</title>
    <style type="text/css">
        body {
            /** 배경 이미지의 경로 지정 */
            background-image: url(img/bg.jpg);
            /** 배경 이미지의 반복 위치 설정 */
            background-repeat: repeat-x;
            /** 스크롤에 따른 반응 */
            background-attachment: fixed;
            /** 배경이미지가 그려지는 시작 위치 */
            background-position: right top;
            /** 색상과 함께 사용될 경우, 색상위에 이미지가 존재 */
            background-color: #000000;

            /** 아래와 같이 일괄지정도 가능함 */
            /* background: #000000 url(img/bg.jpg) fixed right top repeat-x; */
        }
    </style>
</head>

<body>
    <!-- 여기는 작성하실 내용이 없습니다. -->
</body>

</html>
```

---

## #02. 배경 이미지 크기 조절 (`background-size`)

`background-size` 속성은 배경 이미지의 크기를 조절하는 데 사용됩니다. 이미지의 원본 크기를 그대로 사용하거나, 요소에 맞게 크기를 조절할 수 있습니다.

### 1. `background-size` 속성 값

| 값 | 설명 |
| --- | --- |
| `auto` | 기본값. 배경 이미지를 원본 크기 그대로 표시합니다. |
| `<크기>` | `px`, `%` 등의 단위로 가로, 세로 크기를 직접 지정합니다. (`100px 50px`, `50% 75%`) |
| `cover` | 배경 이미지의 비율을 유지하면서, 요소의 전체 영역을 완전히 덮도록 이미지를 확대/축소합니다. 이미지의 일부가 잘릴 수 있습니다. |
| `contain` | 배경 이미지의 비율을 유지하면서, 이미지 전체가 요소 안에 보이도록 크기를 조절합니다. 요소 내에 빈 공간이 생길 수 있습니다. |

- **`<크기>` 지정**:
    - `background-size: 100% 100%;` : 요소의 가로, 세로 크기에 100% 맞춰 이미지를 채웁니다. 이미지의 원본 비율이 왜곡될 수 있습니다.
    - `background-size: 50px 50px;` : 이미지 크기를 50x50 픽셀로 지정합니다. 이미지가 이 크기보다 작거나 크면, 지정된 크기로 조절된 후 `background-repeat` 속성에 따라 반복됩니다.
- **`cover` 와 `contain`**:
    - `cover`는 주로 요소 전체를 배경 이미지로 가득 채우고 싶을 때 사용됩니다. (예: 히어로 이미지)
    - `contain`은 이미지 전체가 반드시 보여야 할 때 사용됩니다. (예: 로고, 아이콘)

> `contain`과 `cover`는 이미지의 원본 비율을 유지한다는 점에서 유사하지만, `cover`는 요소를 완전히 덮기 위해 이미지의 일부가 잘릴 수 있고, `contain`은 이미지 전체가 보이도록 크기를 조절하기 때문에 요소 내에 빈 공간이 생길 수 있다는 차이가 있습니다.

### 2. 실습 예제

아래 예제는 5개의 `<div>` 박스에 동일한 배경 이미지를 적용하고, `background-size` 속성만 다르게 설정하여 각 값의 차이를 보여줍니다.

- **`.box1` (Default)**: `background-size`가 설정되지 않아 이미지의 원본 크기대로 표시됩니다. 이미지가 박스보다 크기 때문에 일부만 보입니다.
- **`.box2` (100% 100%)**: 배경 이미지가 박스의 가로, 세로 크기에 맞춰 강제로 늘어나, 이미지 비율이 왜곡됩니다.
- **`.box3` (50px 50px)**: 배경 이미지가 50x50 픽셀 크기로 조절된 후, 박스 영역을 채우기 위해 반복됩니다.
- **`.box4` (cover)**: 이미지 비율을 유지한 채 박스 전체를 덮도록 확대됩니다. `background-position: center center`를 함께 사용하여 이미지의 중앙이 보이도록 했습니다.
- **`.box5` (contain)**: 이미지 비율을 유지한 채 박스 안에 완전히 들어오도록 크기가 조절됩니다. 박스의 남는 공간은 이미지가 반복되어 채워집니다.

**실습: `/17-CSS-Background/02-BackgroundSize.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>02-BackgroundSize</title>
    <style type="text/css">
        div {
            border: 5px solid rgba(255, 0, 255, 0.5);
            margin: 20px auto;
            width: 90%;
            height: 135px;
            color: white;
            text-shadow: 0 1px 1px black;
            font-size: 25px;
            text-align: center;
            padding-top: 10px;
            background-image: url(img/main_content_bg.png);
        }

        .box2 {
            background-size: 100% 100%;
        }

        .box3 {
            background-size: 50px 50px;
        }

        .box4 {
            background-size: cover;
            background-position: center center;
        }

        .box5 {
            background-size: contain;
        }
    </style>
</head>

<body>
    <div class="box1">
        <h2>Default</h2>
    </div>
    <div class="box2">
        <h2>100% 100%</h2>
    </div>
    <div class="box3">
        <h2>50px 50px</h2>
    </div>
    <div class="box4">
        <h2>cover</h2>
    </div>
    <div class="box5">
        <h2>contain</h2>
    </div>
</body>

</html>
```

---

## #03. 스크롤과 배경 이미지 (`background-attachment`)

`background-attachment` 속성은 페이지를 스크롤할 때 배경 이미지가 어떻게 동작할지를 결정합니다. 이 속성을 활용하면 사용자의 스크롤 인터랙션에 따라 동적인 시각 효과를 만들 수 있습니다.

### 1. `background-attachment` 속성 값

| 값 | 설명 |
| --- | --- |
| `scroll` | 기본값. 배경 이미지가 요소를 따라 함께 스크롤됩니다. |
| `fixed` | 배경 이미지가 뷰포트(viewport)에 고정됩니다. 사용자가 스크롤해도 이미지는 움직이지 않습니다. |
| `local` | 요소 내에서 스크롤이 발생할 경우, 이미지가 콘텐츠를 따라 스크롤됩니다. |

이 예제에서는 `fixed` 값을 사용하여, 스크롤 시 배경이 고정되어 보이는 **패럴랙스(Parallax) 효과**를 구현합니다.

### 2. 실습 예제

아래 예제는 여러 개의 `.section`을 배치하여 스크롤이 가능한 긴 페이지를 만듭니다. 홀수 번째 섹션에는 `background-attachment: fixed`를, 짝수 번째 섹션에는 단색 배경을 적용하여 효과를 극대화했습니다.

- **홀수 번째 섹션 (`:nth-child(odd)`)**:
    - 각각 다른 배경 이미지를 가집니다.
    - `background-size: cover`로 설정하여 이미지가 섹션 전체를 덮도록 합니다.
    - `background-attachment: fixed`로 설정하여 스크롤 시 이미지가 뷰포트에 고정되게 합니다.
- **짝수 번째 섹션 (`:nth-child(2n)`)**:
    - 단순한 회색 배경(`background-color: #d5d5d5`)을 가집니다.
    - 이 섹션들은 페이지와 함께 정상적으로 스크롤됩니다.

**실행 결과**
페이지를 스크롤하면, 회색 배경의 짝수 섹션은 위로 스크롤되어 사라지지만, 배경 이미지가 있는 홀수 섹션들은 마치 창문을 통해 다른 풍경을 보는 것처럼 배경이 고정된 상태로 유지됩니다. 이로 인해 입체감과 깊이감이 느껴지는 시각적 효과가 만들어집니다.

**실습: `/17-CSS-Background/03-Attachment.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>03-Attachment</title>
    <style>
        /* 페이지 전체 여백 제거 */
        body {
            padding: 0;
            margin: 0;
        }

        /* 각 섹션*/
        .section {
            height: 640px;

            /* 짝수 번째 섹션에 대한 배경이미지 공통 속성 */
            &:nth-child(2n) {
                background-color: #d5d5d5;
            }

            /* 홀수 번째 섹션에 대한 배경 색상 처리 */
            &:nth-child(odd) {
                background-position: center center;
                background-size: cover;
                background-repeat: no-repeat;
                background-attachment: fixed;
            }

            /* 홀수 번째의 각 요소에 대한 배경이미지 지정 */
            &:nth-child(1) {
                background-image: url(img/bg1.jpg);
            }

            &:nth-child(3) {
                background-image: url(img/bg2.jpg);
            }

            &:nth-child(5) {
                background-image: url(img/bg3.jpg);
            }

            &:nth-child(7) {
                background-image: url(img/bg4.jpg);
            }
        }
    </style>
</head>

<body>
    <div class="section"></div>
    <div class="section"></div>
    <div class="section"></div>
    <div class="section"></div>
    <div class="section"></div>
    <div class="section"></div>
    <div class="section"></div>
</body>

</html>
```

---

## #04. 색상 그라디언트 (CSS Gradients)

CSS 그라디언트는 두 가지 이상의 색상이 부드럽게 전환되는 효과를 만들어내는 이미지의 한 종류입니다. 단색 배경보다 훨씬 다채롭고 생동감 있는 디자인을 구현할 수 있으며, `background-image` 속성에 함수 형태로 사용됩니다.

### 1. 선형 그라디언트 `linear-gradient()`

선형 그라디언트는 색상이 직선을 따라 변하는 그라디언트를 만듭니다. 방향과 색상을 지정하여 다양한 효과를 낼 수 있습니다.

**기본 구문:** `linear-gradient( [ <각도> | to <방향> ], <색상1>, <색상2>, ... )`

- **방향(Direction)**:
    - `to right`: 왼쪽에서 오른쪽으로
    - `to left`: 오른쪽에서 왼쪽으로
    - `to top`: 아래쪽에서 위쪽으로
    - `to bottom`: 위쪽에서 아래쪽으로 (기본값)
    - `to top right`: 왼쪽 아래에서 오른쪽 위 대각선 방향으로
    - 각도(Angle) 값을 직접 사용할 수도 있습니다. (예: `45deg`, `90deg`)

- **색상 지점(Color Stops)**:
    - 전환될 색상들을 쉼표로 구분하여 나열합니다.
    - 각 색상 옆에 위치를 `%`나 `px`로 지정하여 색상 전환 지점을 제어할 수 있습니다. (예: `red 0%`, `blue 50%`, `green 100%`)

### 2. 원형 그라디언트 `radial-gradient()`

원형 그라디언트는 중심점에서부터 바깥쪽으로 색상이 원형 또는 타원형으로 퍼져나가며 변하는 그라디언트를 만듭니다.

**기본 구문:** `radial-gradient( [ <모양> <크기> at <위치> ], <색상1>, <색상2>, ... )`

- **모양(Shape)**:
    - `ellipse`: 타원형 (기본값)
    - `circle`: 원형
- **크기(Size)**: 그라디언트의 크기를 결정합니다.
    - `farthest-corner`: 중심점에서 가장 먼 모서리까지 (기본값)
    - `closest-side`: 중심점에서 가장 가까운 변까지
    - `closest-corner`: 중심점에서 가장 가까운 모서리까지
    - `farthest-side`: 중심점에서 가장 먼 변까지
- **위치(Position)**: `at` 키워드와 함께 그라디언트의 중심점을 지정합니다. (기본값: `center`)

### 3. 실습 예제

아래 예제는 선형 및 원형 그라디언트를 사용하여 다양한 효과를 만드는 방법을 보여줍니다.

- **선형 그라디언트**:
    - `.grad1`: 위에서 아래로 (기본 방향)
    - `.grad2`: 왼쪽에서 오른쪽으로, 3가지 색상
    - `.grad3`: 대각선 방향
    - `.grad4`: 45도 각도 및 색상 지점 지정
- **원형 그라디언트**:
    - `.rgrad1`: 기본적인 타원형 그라디언트
    - `.rgrad2`: 원형 그라디언트
    - `.rgrad3`: 중심점을 왼쪽 상단으로 이동한 원형 그라디언트
    - `.rgrad4`: 크기를 `closest-side`로 지정한 그라디언트

**실습: `/17-CSS-Background/04-gradient.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">
<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>04-gradient (Modern Example)</title>
    <style type="text/css">
        body {
            font-family: sans-serif;
        }
        div {
            width: 220px;
            height: 120px;
            margin: 10px;
            border: 1px solid #ccc;
            display: inline-block;
            color: white;
            font-size: 0.9em;
            text-align: center;
            line-height: 120px;
            text-shadow: 1px 1px 2px black;
        }
        h1, h2 {
            padding-left: 10px;
        }
        /* --- 선형 그라디언트 --- */
        .grad1 {
            background: linear-gradient(#06f, #fff);
        }
        .grad2 {
            background: linear-gradient(to right, #06f, #0f0, #ff0);
        }
        .grad3 {
            background: linear-gradient(to top right, #06f, #fff);
        }
        .grad4 {
            background: linear-gradient(45deg, #06f 30%, #0f0 70%);
        }
        /* --- 원형 그라디언트 --- */
        .rgrad1 {
            background: radial-gradient(#06f, #fff);
        }
        .rgrad2 {
            background: radial-gradient(circle, #06f, #fff);
        }
        .rgrad3 {
            background: radial-gradient(circle at top left, #06f, #fff);
        }
        .rgrad4 {
            background: radial-gradient(closest-side, #06f, #fff);
        }
    </style>
</head>
<body>
    <h1>그라디언트 (Modern Syntax)</h1>

    <h2>선형 그라디언트 (Linear)</h2>
    <div class="grad1">Default (to bottom)</div>
    <div class="grad2">to right, 3 colors</div>
    <div class="grad3">to top right</div>
    <div class="grad4">45deg with stops</div>

    <h2>원형 그라디언트 (Radial)</h2>
    <div class="rgrad1">Default (ellipse)</div>
    <div class="rgrad2">circle</div>
    <div class="rgrad3">circle at top left</div>
    <div class="rgrad4">closest-side</div>
</body>
</html>
```

---

## #05. 이미지 클리핑과 스프라이트 (Image Clipping & Sprites)

웹 페이지에 사용되는 여러 개의 아이콘이나 버튼 이미지를 각각의 파일로 관리하는 대신, 하나의 큰 이미지 파일로 합쳐서 관리할 수 있습니다. 이렇게 합쳐진 이미지를 '이미지 스프라이트(Image Sprite)'라고 하며, 이 스프라이트에서 원하는 부분만 잘라내어 표시하는 기법을 '이미지 클리핑(Image Clipping)'이라고 합니다.

### 1. 이미지 클리핑의 원리: `background-position`

이미지 클리핑은 `background-position` 속성의 동작 원리를 응용한 것입니다. 이 속성은 요소의 배경 안에서 이미지의 시작 위치를 지정합니다.

- **기본값**: `0 0` 또는 `left top`. 이미지의 왼쪽 상단 모서리가 요소의 왼쪽 상단 모서리에 맞춰집니다.
- **양수 값 (`x y`)**: `background-position: 70px 50px;`
  - 이미지를 오른쪽으로 70px, 아래쪽으로 50px 이동시킵니다.
  - 결과적으로 이미지의 왼쪽과 윗부분이 잘려나가고, 이미지의 안쪽 부분이 요소의 왼쪽 상단에 보이게 됩니다.
- **음수 값 (`-x -y`)**: `background-position: -70px -50px;`
  - 이미지를 왼쪽으로 70px, 위쪽으로 50px 이동시킵니다.
  - 이것이 바로 **스프라이트 기법의 핵심 원리**입니다. 요소는 그대로 있고 배경 이미지만 움직여서, 스프라이트 이미지의 원하는 부분(예: 특정 아이콘)을 요소의 보이는 영역 안으로 가져올 수 있습니다.

### 2. 이미지 스프라이트 (Image Sprite) 기법

- **정의**: 여러 개의 이미지를 하나의 파일로 모아놓은 이미지. (주로 아이콘, 버튼 등)
- **장점**: 웹 페이지 로딩 시 서버에 보내는 HTTP 요청 횟수를 줄여줍니다. 10개의 아이콘을 위해 10번 요청할 것을, 단 한 번의 요청으로 끝낼 수 있어 성능 향상에 큰 도움이 됩니다.
- **구현 방법**:
    1. 아이콘을 표시할 요소(예: `div`)의 `width`와 `height`를 아이콘 크기에 맞게 지정합니다.
    2. `background-image`로 스프라이트 이미지를 불러옵니다.
    3. `background-repeat: no-repeat;` 로 이미지가 반복되지 않게 설정합니다.
    4. `background-position`에 음수 값을 주어, 보여주고자 하는 아이콘이 요소의 `0 0` 위치에 오도록 배경 이미지를 이동시킵니다.

### 3. 실습 예제

아래 예제는 `background-position` 값에 따라 `div` 박스에 보이는 배경 이미지의 부분이 어떻게 달라지는지 보여줍니다.

- **`.box1`**: `background-position`이 지정되지 않아 기본값인 `0 0`이 적용됩니다. 배경 이미지의 왼쪽 상단이 그대로 표시됩니다.
- **`.box2`**: `background-position: 70px 50px;`가 적용되어, 배경 이미지가 오른쪽 아래로 이동한 모습입니다.
- **`.box3`**: `background-position: -70px -50px;`가 적용되어, 배경 이미지가 왼쪽 위로 이동하면서 보이지 않던 다른 부분이 표시됩니다. 이것이 스프라이트 기법에서 아이콘을 선택하는 원리입니다.

**실습: `/17-CSS-Background/05-ImageClipping.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>05-ImageClipping</title>
    <style type="text/css">
        div {
            border: 5px solid red;
            width: 480px;
            height: 150px;
            margin: 5px auto;
            background: url(img/main_content_bg.png) no-repeat;

            &.box2 {
                background-position: 70px 50px;
            }

            &.box3 {
                background-position: -70px -50px;
            }
        }
    </style>
</head>

<body>
    <div class="box1"></div>
    <div class="box2"></div>
    <div class="box3"></div>
</body>

</html>
```

---

## #06. 실전 예제: 이미지 스프라이트 활용 (네이버 아이콘)

앞서 배운 이미지 스프라이트 기법을 실제 웹사이트에서 사용하는 아이콘에 적용하는 예제입니다. 이 예제는 네이버의 스프라이트 이미지에서 '네이버 웨일' 아이콘을 정확히 잘라내어 표시하는 방법을 보여줍니다.

### 1. IR (Image Replacement) 기법

배경 이미지로 의미 있는 아이콘이나 버튼을 표시할 때, `<img>` 태그와 달리 `background-image`는 스크린 리더나 검색 엔진이 그 의미를 파악할 수 없습니다. 이를 보완하기 위해 **IR(Image Replacement)** 기법을 사용합니다.

- **목적**: 시각적으로는 이미지를 보여주되, 코드에는 스크린 리더와 검색 엔진을 위한 텍스트를 숨겨두어 웹 접근성과 SEO를 향상시킵니다.
- **방법**:
    1.  의미를 전달할 요소(예: `<a>`, `<div>`) 안에 `<span>` 등으로 텍스트(예: "네이버 웨일")를 작성합니다.
    2.  CSS를 사용하여 이 텍스트를 화면 밖으로 밀어내거나 숨깁니다.

> **어떤 숨김 처리 방식이 좋을까?**
>
> - **`display: none;` 또는 `visibility: hidden;`**: 이 방식은 텍스트를 시각적으로 숨길 뿐만 아니라, 스크린 리더에서도 완전히 제외시켜 버리는 경우가 많아 IR 기법에 적합하지 않습니다. (하지만 많이 사용됩니다.)
> - **`text-indent: -9999px;`**: **가장 보편적이고 안정적인 방법입니다.** 텍스트를 화면 밖 아주 먼 곳으로 밀어내어 시각적으로는 보이지 않지만, 스크린 리더는 정상적으로 읽을 수 있습니다.

### 2. 실습 예제 분석

이 예제는 `<a>` 태그를 사용하여 클릭 가능한 '네이버 웨일' 아이콘을 만듭니다.

- **HTML 구조**: `<a>` 태그 안에 스크린 리더가 읽을 수 있는 "네이버 웨일" 텍스트를 `<span>`으로 감싸 포함했습니다.
- **CSS (`.naver-icon`)**:
    - `display: block;`: `<a>` 태그는 기본적으로 인라인(inline) 요소이므로, `width`와 `height`를 적용하기 위해 블록(block) 요소로 변경합니다.
    - `width: 84px; height: 72px;`: 스프라이트 이미지에서 '네이버 웨일' 아이콘이 차지하는 실제 크기를 지정합니다. 이 크기가 아이콘을 잘라내는 '창'의 역할을 합니다.
    - `background-image`: 네이버의 메인 스프라이트 이미지(`sp_main.59f2144d.png`)를 배경으로 지정합니다.
    - `background-position: -410px -520px;`: 스프라이트 이미지를 왼쪽으로 410px, 위쪽으로 520px 만큼 이동시켜, `84x72` 크기의 `<a>` 요소 안에는 정확히 '네이버 웨일' 아이콘만 보이게 합니다.
- **CSS (`.hidden`)**:
    - `display: none;`을 사용하여 "네이버 웨일" 텍스트를 숨겼습니다. 위에서 설명했듯이, 이는 접근성 면에서 아쉬운 점이 있으므로 `text-indent` 방식을 사용하는 것이 더 권장됩니다.

**실습: `/17-CSS-Background/06-NaverIcon.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>06-NaverIcon</title>
    <style>
        .naver-icon {
            display: block;
            width: 84px;
            height: 72px;
            background-image: url(img/sp_main.59f2144d.png);
            background-repeat: no-repeat;
            background-position: -410px -520px;
        }

        .hidden {
            display: none;
        }

        .indent {
            text-indent: -9999px;
            overflow: hidden;
        }
    </style>
</head>

<body>
    <h1>네이버 아이콘 예제</h1>
    <h2>텍스트를 hidden 처리하는 경우</h2>
    <a href="#" class="naver-icon"><span class="hidden">네이버 웨일</span></a>
    <h2>텍스트를 text-indent로 처리하는 경우</h2>
    <a href="#" class="naver-icon indent">네이버 웨일</a>
</body>

</html>
```