---
title:  "[CSS] CSS Flex"
description: "flexbox는 float나 inline-block의 단점을 보완하여 레이아웃 배치 전용 기능으로 고안된 CSS의 새로운 display 특성으로 컨테이너에 적용하는 속성과 아이템에 적용하는 속성으로 나누어 집니다. flexbox를 사용하면 레이아웃 구성에 많은 편의성이 보장되지만 IE는 지원하지 않기 때문에 IE를 고려해야 하는 프로젝트에서는 사용해서는 안됩니다."
categories: [05.Frontend,HTML&CSS]
tags: [Web Development,Frontend,CSS]
image: /images/indexs/webdevelopment.png
date: 2022-03-21 13:01:28 +0900
author: Hossam
pin: true
math: true
mermaid: true
---

# [CSS] Flexbox

`flexbox`는 CSS의 레이아웃 배치 전용 기능으로, 기존의 `float`나 `inline-block`이 가진 한계를 극복하기 위해 설계되었습니다. `flexbox`를 사용하면 복잡한 레이아웃도 손쉽게 구성할 수 있지만, IE(Internet Explorer)에서는 지원되지 않으므로 프로젝트의 브라우저 호환성 요구사항을 반드시 확인해야 합니다.

`flexbox`의 속성은 **컨테이너(부모 요소)**에 적용하는 것과 **아이템(자식 요소)**에 적용하는 것으로 나뉩니다.

## #01. 컨테이너(부모)에 적용하는 속성

### 1. `display: flex` (중요)

`flex` 레이아웃을 시작하려면, 부모 요소의 `display` 속성을 `flex` 또는 `inline-flex`로 설정해야 합니다.

| 값 | 설명 |
|--|--|
| `flex` | - 컨테이너는 **Block 요소**처럼 동작하여 부모의 가로폭을 가득 채웁니다.<br/>- 아이템들은 가로 방향으로 배치되며, 각 아이템은 자신의 내용만큼의 넓이만 차지합니다.<br/>- 아이템의 높이는 컨테이너의 높이만큼 자동으로 늘어납니다. |
| `inline-flex` | - 컨테이너가 **Inline 요소**처럼 동작하여, 자신이 포함하는 아이템들의 넓이만큼만 가로폭을 차지합니다.<br/>- 그 외의 특징은 `flex`와 동일합니다. |

아래 실습에서 `.container1`은 `display: flex`가 적용되어 부모 요소를 가득 채우고, `.container2`는 `display: inline-flex`가 적용되어 내용만큼의 넓이만 차지하는 것을 확인할 수 있습니다.

- `.container1`: `display: flex`가 적용되어 컨테이너는 block 요소처럼 동작하여 가로 전체를 차지합니다.
- `.container2`: `display: inline-flex`가 적용되어 컨테이너는 inline 요소처럼 자신의 내용만큼의 너비만 가집니다.
- 두 컨테이너의 자식 요소들은 모두 가로로 배치됩니다.

**실습: `/14-CSS-Display(2)-Flex/01-1-flex.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>01-1-flex</title>
    <style>
        * {
            box-sizing: border-box;
        }

        .container {
            border: 2px dotted #06f;
            padding: 10px;
            height: 300px;

            .item {
                border: 2px solid #f0f;
                padding: 10px;
                margin: 5px;
                width: 300px;
            }

            &.container1 {
                /* 스스로의 넓이는 부모를 가득 채우고 자식요소를 가로배치 */
                display: flex;
            }

            &.container2 {
                /* 스스로의 넓이를 자식요소의 크기 합으로 고정하고 자식요소를 가로배치 */
                display: inline-flex;
            }
        }
    </style>
</head>

<body>
    <h1>flex</h1>
    <div class="container container1">
        <div class="item">A</div>
        <div class="item">B</div>
        <div class="item">C</div>
    </div>

    <h1>inline-flex</h1>
    <div class="container container2">
        <div class="item">A</div>
        <div class="item">B</div>
        <div class="item">C</div>
    </div>
</body>

</html>
```

### 2. `flex-direction`: 배치 방향 설정 (중요)

`flex-direction` 속성은 아이템이 컨테이너 안에서 배치될 방향을 결정합니다.

| 값 | 설명 |
|--|--|
| `row` | **(기본값)** 아이템을 가로 방향으로 왼쪽에서 오른쪽으로 배치합니다. |
| `row-reverse` | 아이템을 가로 방향으로 오른쪽에서 왼쪽으로 배치합니다. |
| `column` | 아이템을 세로 방향으로 위에서 아래로 배치합니다. |
| `column-reverse` | 아이템을 세로 방향으로 아래에서 위로 배치합니다. |

**실습: `/14-CSS-Display(2)-Flex/01-2-flex-direction.html`**

- `row`: 아이템을 가로 방향으로 왼쪽에서 오른쪽으로 배치합니다. (기본값)
- `row-reverse`: 아이템을 가로 방향으로 오른쪽에서 왼쪽으로 배치합니다.
- `column`: 아이템을 세로 방향으로 위에서 아래로 배치합니다.
- `column-reverse`: 아이템을 세로 방향으로 아래에서 위로 배치합니다.

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>01-2-flex-direction</title>
    <style>
        * {
            box-sizing: border-box;
        }

        .container {
            border: 2px dotted #06f;
            padding: 10px;
            width: 800px;
            display: flex;

            .item {
                border: 2px solid #f0f;
                padding: 10px;
                margin: 5px;
            }

            /* 아이템을 가로 방향으로 왼쪽에서 오른쪽으로 배치합니다. (기본값) */
            &.container1 { flex-direction: row; }
            /* 아이템을 가로 방향으로 오른쪽에서 왼쪽으로 배치합니다. */
            &.container2 { flex-direction: row-reverse; }
            /* 아이템을 세로 방향으로 위에서 아래로 배치합니다. */
            &.container3 { flex-direction: column; }
            /* 아이템을 세로 방향으로 아래에서 위로 배치합니다. */
            &.container4 { flex-direction: column-reverse; }
        }
    </style>
</head>

<body>
    <h1>row</h1>
    <div class="container container1">...</div>
    <h1>row-reverse</h1>
    <div class="container container2">...</div>
    <h1>column</h1>
    <div class="container container3">...</div>
    <h1>column-reverse</h1>
    <div class="container container4">...</div>
</body>

</html>
```

### 3. `flex-wrap`: 줄 바꿈 속성 (중요)

`flex-wrap` 속성은 아이템들이 컨테이너의 가로폭을 초과할 때 줄바꿈을 어떻게 처리할지 결정합니다.

| 값 | 설명 |
|--|--|
| `nowrap` | **(기본값)** 줄바꿈을 하지 않고, 아이템의 크기를 강제로 축소하여 한 줄에 모두 표시합니다. |
| `wrap` | 아이템들이 컨테이너를 벗어나면 다음 줄로 줄바꿈합니다. |
| `wrap-reverse` | 아이템을 역순으로 배치하여 줄바꿈합니다. |

> `flex-direction`과 `flex-wrap`을 한 번에 지정하는 단축 속성으로 `flex-flow`가 있지만, 개별적으로 지정하는 것이 더 명확할 수 있습니다.

**실습: `/14-CSS-Display(2)-Flex/01-3-flex-wrap.html`**

- `nowrap`: 아이템의 총 너비가 컨테이너보다 커도 줄바꿈을 하지 않고, 대신 아이템의 너비를 강제로 줄여서 한 줄에 표시합니다.
- `wrap`: 아이템의 총 너비가 컨테이너보다 크면 줄바꿈을 허용하여 여러 줄로 표시합니다.
- `wrap-reverse`: `wrap`과 동일하게 줄바꿈을 하지만, 아이템을 아래에서 위 순서로 배치합니다.

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>01-3-flex-wrap</title>
    <style>
        .container {
            border: 2px dotted #06f;
            padding: 10px;
            width: 800px;
            display: flex;

            .item {
                border: 2px solid #f0f;
                padding: 10px;
                margin: 5px;
                width: 300px;
            }

            /* 줄바꿈을 하지 않고 아이템의 크기가 컨테이너에 맞게 강제로 축소된다. */
            &.container1 { flex-wrap: nowrap; }
            /* 줄바꿈을 한다. */
            &.container2 { flex-wrap: wrap; }
            /* 줄바꿈을 하지만 아이템의 행을 역순으로 배치한다. */
            &.container3 { flex-wrap: wrap-reverse; }
        }
    </style>
</head>

<body>
    <h1>nowrap</h1>
    <div class="container container1">...</div>
    <h1>wrap</h1>
    <div class="container container2">...</div>
    <h1>wrap-reverse</h1>
    <div class="container container3">...</div>
</body>

</html>
```

### 4. `justify-content`: 주 축(main-axis) 정렬 (중요)

`justify-content` 속성은 주 축(main-axis)을 기준으로 아이템들을 정렬합니다. `flex-direction`이 `row`일 때는 가로 정렬, `column`일 때는 세로 정렬을 의미합니다.

| 값 | 설명 |
|--|--|
| `flex-start` | 아이템을 주 축의 시작점으로 정렬합니다. |
| `flex-end` | 아이템을 주 축의 끝점으로 정렬합니다. |
| `center` | 아이템을 주 축의 중앙으로 정렬합니다. |
| `space-between` | 첫 번째와 마지막 아이템을 양 끝에 붙이고, 나머지 아이템들 사이에 균일한 간격을 만듭니다. |
| `space-around` | 모든 아이템의 둘레(around)에 균일한 간격을 만듭니다. |
| `space-evenly` | 모든 아이템의 사이와 양 끝에 균일한 간격을 만듭니다. |

**실습: `/14-CSS-Display(2)-Flex/01-4-justify-content.html`**

- `flex-start`: 아이템들을 컨테이너의 시작 부분(왼쪽)으로 정렬합니다.
- `flex-end`: 아이템들을 컨테이너의 끝 부분(오른쪽)으로 정렬합니다.
- `center`: 아이템들을 컨테이너의 중앙으로 정렬합니다.
- `space-between`: 첫 번째와 마지막 아이템을 양 끝에 붙이고, 나머지 아이템들 사이의 간격을 균등하게 분배합니다.
- `space-around`: 모든 아이템의 양쪽에 동일한 간격을 주어 정렬합니다.
- `space-evenly`: 모든 아이템 사이 및 양 끝과의 간격을 모두 동일하게 만듭니다.

```html
<!DOCTYPE html>
<html lang="ko" translate="no">
<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>01-4-justify-content</title>
    <style>
        .container {
            border: 2px dotted #06f;
            padding: 10px;
            width: 800px;
            display: flex;

            .item {
                border: 2px solid #f0f;
                padding: 10px;
                margin: 5px;
                width: 100px;
            }

            /* 아이템들을 시작점으로 정렬한다. */
            &.container1 { justify-content: flex-start; }
            /* 아이템들을 끝점으로 정렬한다. */
            &.container2 { justify-content: flex-end; }
            /* 아이템들을 가운데로 정렬한다. */
            &.container3 { justify-content: center; }
            /* 아이템들의 “사이(between)”에 균일한 간격을 만들어 준다. */
            &.container4 { justify-content: space-between; }
            /* 아이템들의 “둘레(around)”에 균일한 간격을 만들어 준다. */
            &.container5 { justify-content: space-around; }
            /* 아이템들의 사이와 양 끝에 균일한 간격을 만들어 준다. */
            &.container6 { justify-content: space-evenly; }
        }
    </style>
</head>
<body>
    <h1>flex-start</h1>
    <div class="container container1">...</div>
    <h1>flex-end</h1>
    <div class="container container2">...</div>
    <h1>center</h1>
    <div class="container container3">...</div>
    <h1>space-between</h1>
    <div class="container container4">...</div>
    <h1>space-around</h1>
    <div class="container container5">...</div>
    <h1>space-evenly</h1>
    <div class="container container6">...</div>
</body>
</html>
```

### 5. `align-content`: 여러 행 정렬 (중요)

`align-content` 속성은 `flex-wrap: wrap`이 설정되어 아이템이 여러 줄로 표시될 때, 교차 축(cross-axis) 방향의 정렬을 결정합니다.

| 값 | 설명 |
|--|--|
| `stretch` | **(기본값)** 아이템의 높이를 늘려 교차 축 방향으로 컨테이너를 가득 채웁니다. |
| `flex-start` | 아이템들을 교차 축의 시작점으로 정렬합니다. |
| `flex-end` | 아이템들을 교차 축의 끝점으로 정렬합니다. |
| `center` | 아이템들을 교차 축의 중앙으로 정렬합니다. |
| `space-between` | 첫 번째와 마지막 줄을 양 끝에 붙이고 나머지 줄 사이에 균일한 간격을 만듭니다. |
| `space-around` | 모든 줄의 둘레에 균일한 간격을 만듭니다. |
| `space-evenly` | 모든 줄의 사이와 양 끝에 균일한 간격을 만듭니다. |

**실습: `/14-CSS-Display(2)-Flex/01-5-align-content.html`**

- 이 속성은 `flex-wrap: wrap`이 설정되어 아이템이 **여러 줄**일 때만 효과가 있습니다.
- `stretch`: 아이템의 높이를 늘려 컨테이너의 교차 축(세로)을 가득 채웁니다.
- `flex-start`: 아이템들을 컨테이너의 교차 축 시작점(위)으로 정렬합니다.
- `flex-end`: 아이템들을 컨테이너의 교차 축 끝점(아래)으로 정렬합니다.
- `center`: 아이템들을 교차 축의 중앙으로 정렬합니다.
- `space-between`, `space-around`, `space-evenly`: 줄들 사이의 간격을 조절합니다.

```html
<!DOCTYPE html>
<html lang="ko" translate="no">
<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>01-5-align-content</title>
    <style>
        .container {
            border: 2px dotted #06f;
            padding: 10px;
            width: 800px;
            height: 400px;
            display: flex;
            flex-wrap: wrap;

            .item {
                border: 2px solid #f0f;
                padding: 10px;
                margin: 5px;
                width: 300px;
            }

            /* 아이템들이 세로축 방향으로 끝까지 늘어난다. */
            &.container1 { align-content: stretch; }
            /* 아이템들을 시작점으로 정렬(위) */
            &.container2 { align-content: flex-start; }
            /* 아이템들을 끝으로 정렬(아래) */
            &.container3 { align-content: flex-end; }
            /* 아이템들을 가운데로 정렬 */
            &.container4 { align-content: center; }
            /* 아이템들의 “사이(between)”에 균일한 간격을 만들어 준다. */
            &.container5 { align-content: space-between; }
            /* 아이템들의 “둘레(around)”에 균일한 간격을 만들어 준다. */
            &.container6 { align-content: space-around; }
            /* 아이템들의 사이와 양 끝에 균일한 간격을 만들어 준다. */
            &.container7 { align-content: space-evenly; }
        }
    </style>
</head>
<body>
    <h1>stretch</h1>
    <div class="container container1">...</div>
    ...
</body>
</html>
```

### 6. `align-items`: 교차 축(cross-axis) 정렬

`align-items` 속성은 한 줄일 때의 아이템들을 교차 축(cross-axis) 방향으로 정렬합니다.

| 값 | 설명 |
|--|--|
| `stretch` | **(기본값)** 아이템의 높이를 늘려 교차 축 방향으로 컨테이너를 가득 채웁니다. |
| `flex-start` | 아이템을 교차 축의 시작점으로 정렬합니다. |
| `flex-end` | 아이템을 교차 축의 끝점으로 정렬합니다. |
| `center` | 아이템을 교차 축의 중앙으로 정렬합니다. |
| `baseline` | 아이템을 텍스트의基선(baseline)에 맞춰 정렬합니다. |

**실습: `/14-CSS-Display(2)-Flex/01-6-align-items.html`**

- 이 속성은 아이템이 **한 줄**일 때 교차 축(세로)의 정렬 상태를 제어합니다.
- `stretch`: 아이템의 높이를 컨테이너에 꽉 채웁니다.
- `flex-start`: 아이템을 교차 축의 시작점(위)으로 정렬합니다.
- `flex-end`: 아이템을 교차 축의 끝점(아래)으로 정렬합니다.
- `center`: 아이템을 교차 축의 중앙으로 정렬합니다.
- `baseline`: 아이템 안의 텍스트의 기준선(baseline)에 맞춰 정렬합니다.

```html
<!DOCTYPE html>
<html lang="ko" translate="no">
<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>01-6-align-items</title>
    <style>
        .container {
            border: 2px dotted #06f;
            padding: 10px;
            width: 800px;
            display: flex;

            .item {
                border: 2px solid #f0f;
                padding: 10px;
                margin: 5px;
                width: 200px;
            }

            /* 아이템들이 수직축 방향으로 끝까지 늘어난다. */
            &.container1 { align-items: stretch; }
            /* 아이템들을 시작점으로 정렬 */
            &.container2 { align-items: flex-start; }
            /* 아이템들을 끝으로 정렬 */
            &.container3 { align-items: flex-end; }
            /* 아이템들을 가운데로 정렬 */
            &.container4 { align-items: center; }
            /* 아이템들을 텍스트 베이스라인 기준으로 정렬 */
            &.container5 { align-items: baseline; }
        }
    </style>
</head>
<body>
    <h1>stretch</h1>
    <div class="container container1">...</div>
    ...
</body>
</html>
```

## #02. 아이템(자식)에 적용하는 속성

### 1. `flex-basis`: 아이템의 기본 크기

`flex-basis`는 아이템의 기본 크기를 설정합니다. `flex-direction`이 `row`일 때는 너비, `column`일 때는 높이를 의미합니다. `width`나 `height`보다 우선 적용됩니다.

-   **`auto` (기본값)**: 아이템의 `width`나 `height` 값을 사용합니다.
-   **`content`**: 내용(content)의 크기를 사용합니다.
-   **단위 값 (px, %, rem 등)**: 지정된 값으로 기본 크기를 설정합니다.

**실습: `/14-CSS-Display(2)-Flex/02-1-flex-basis.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">
<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>02-1-flex-basis</title>
    <style>
        .container {
            border: 2px dotted #06f;
            padding: 10px;
            width: 500px;
            display: flex;
            flex-wrap: wrap;

            .item {
                border: 2px solid #f0f;
                padding: 10px;
                margin: 5px;

                &.item100px {
                    flex-basis: 100px;
                }
            }
        }
    </style>
</head>
<body>
    <h1>flex-basis: 100px;</h1>
    <div class="container">
        <div class="item item100px">Normal Contents.</div>
        <div class="item item100px">Very~~~ Very~~~ Long Contents.</div>
        <div class="item item100px">Short.</div>
    </div>
</body>
</html>
```

### 2. `flex-grow`: 아이템 확장 비율

`flex-grow`는 컨테이너에 여유 공간이 있을 때, 아이템이 얼마나 늘어날지를 결정하는 비율입니다.

-   **`0` (기본값)**: 아이템이 늘어나지 않습니다.
-   **`1` 이상의 숫자**: 숫자가 클수록 더 많은 여유 공간을 차지합니다. 예를 들어, 모든 아이템에 `flex-grow: 1`을 주면 여유 공간을 균등하게 나눠 가집니다.

**실습: `/14-CSS-Display(2)-Flex/02-2-flex-grow.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">
<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>02-2-flex-grow</title>
    <style>
        .container {
            border: 2px dotted #06f;
            padding: 10px;
            width: 500px;
            display: flex;

            .item {
                border: 2px solid #f0f;
                padding: 10px;
                margin: 5px;

                &.grow1 { flex-grow: 1; }
                &.item1 { flex-grow: 1; }
                &.item2 { flex-grow: 3; }
            }
        }
    </style>
</head>
<body>
    <h1>grow1</h1>
    <div class="container">
        <div class="item grow1">...</div>
    </div>
    <h1>1:3:1</h1>
    <div class="container">
        <div class="item item1">A</div>
        <div class="item item2">B</div>
        <div class="item item1">C</div>
    </div>
</body>
</html>
```

### 3. `flex-shrink`: 아이템 축소 비율

`flex-shrink`는 컨테이너 공간이 부족할 때, 아이템이 얼마나 줄어들지를 결정하는 비율입니다.

-   **`1` (기본값)**: 공간이 부족하면 아이템이 `flex-basis`보다 작아집니다.
-   **`0`**: 아이템이 줄어들지 않고 고정 크기를 유지하려고 합니다.

**실습: `/14-CSS-Display(2)-Flex/02-3-flex-shrink.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">
<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>02-3-flex-shrink</title>
    <style>
        .container {
            border: 2px dotted #06f;
            padding: 10px;
            display: flex;

            &.w250px { width: 250px; }

            .item {
                border: 2px solid #f0f;
                padding: 10px;
                margin: 5px;

                &.left {
                    flex-shrink: 0;
                    flex-basis: 100px;
                }
                &.right {
                    flex-grow: 1;
                }
            }
        }
    </style>
</head>
<body>
    <h1>container width 250px</h1>
    <div class="container w250px">
        <div class="item left">넓이가 고정된 영역</div>
        <div class="item right">Very~~~ Very~~~ Long Contents.</div>
    </div>
</body>
</html>
```

### 4. `flex`: 단축 속성

`flex`는 `flex-grow`, `flex-shrink`, `flex-basis`를 한 번에 설정하는 단축 속성입니다.

| 예시 | 설명 |
|--|--|
| `flex: 1;` | `flex: 1 1 0;`와 같습니다. |
| `flex: 1 500px;` | `flex: 1 1 500px;`와 같습니다. |
| `flex: 1 1 auto;` | `flex-grow: 1`, `flex-shrink: 1`, `flex-basis: auto`를 의미합니다. |

**실습: `/14-CSS-Display(2)-Flex/02-4-flex.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">
<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>02-4-flex</title>
    <style>
        .container {
            border: 2px dotted #06f;
            padding: 10px;
            display: flex;

            .item {
                border: 2px solid #f0f;
                padding: 10px;
                margin: 5px;

                &.flex1 { flex: 1; }
                &.flex2 { flex: 2; }
            }
        }
    </style>
</head>
<body>
    <h1>flex 1:2:1</h1>
    <div class="container">
        <div class="item flex1">Normal Contents.</div>
        <div class="item flex2">Very~~~ Very~~~ Long Contents.</div>
        <div class="item flex1">Short</div>
    </div>
</body>
</html>
```

## #03. Flexbox 활용 예제

### 1. 박스 중앙 배치

`flex`를 사용하면 아이템을 수평, 수직 중앙에 매우 쉽게 배치할 수 있습니다.

-   `justify-content: center;` : 가로 중앙 정렬
-   `align-items: center;` : 세로 중앙 정렬

**실습: `/14-CSS-Display(2)-Flex/03-1-박스중앙배치.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">
<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>03-1-박스중앙배치</title>
    <style>
        .box {
            border: 5px dotted #06f;
            height: 300px;
            display: flex;
            justify-content: center;
            align-items: center;

            .item {
                border: 5px solid #f0f;
                width: 360px;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="box">
        <div class="item">아이템</div>
    </div>
</body>
</html>
```

### 2. 정렬이 다른 메뉴

`justify-content: space-between;`을 사용하면 메뉴 항목들을 양쪽 끝으로 정렬할 수 있습니다.

**실습: `/14-CSS-Display(2)-Flex/03-2-정렬이_다른_메뉴.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">
<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>03-2-정렬이_다른_메뉴</title>
    <style>
        .tablist {
            border: 1px solid rgba(0, 0, 0, 0.12);
            display: flex;
            justify-content: space-between;

            .tab {
                height: 50px;
                display: flex;
                align-items: center;
            }
        }
    </style>
</head>
<body>
    <ul class="tablist">
        <li><a href="#" class="tab">...</a></li>
        <li><a href="#" class="tab">정렬이 다른 메뉴</a></li>
        <li><a href="#" class="tab">...</a></li>
    </ul>
</body>
</html>
```

### 3. 네비게이션 바

`flex`를 활용하여 로고, 검색창, 메뉴 등으로 구성된 복잡한 네비게이션 바를 쉽게 만들 수 있습니다. `margin-left: auto;`를 특정 아이템에 적용하면 해당 아이템을 오른쪽 끝으로 밀어낼 수 있습니다.

**실습: `/14-CSS-Display(2)-Flex/03-3-네비게이션박스.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">
<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>03-3-네비게이션박스</title>
    <style>
        .header-container {
            display: flex;
            max-width: 1000px;
            margin: auto;

            .gnb {
                margin-left: auto;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-container">
            <div class="logo">logo</div>
            <div class="search">...</div>
            <div class="gnb">gnb</div>
        </div>
    </header>
</body>
</html>
```
