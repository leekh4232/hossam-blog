---
title:  "[CSS] position 속성"
description: "Position 속성은 요소의 배치 방법을 결정하는 속성으로 `relative`(상대좌표), `absolute`(절대좌표), `fixed`(고정좌표), `sticky(유동좌표)` 방식이 있습니다. 각 방식에 따라 좌표가 설정되는 기준이 달라집니다."
categories: [05.Frontend,HTML&CSS]
tags: [Web Development,Frontend,CSS]
image: /images/indexs/webdevelopment.png
date: 2022-03-18 13:01:28 +0900
author: Hossam
pin: true
math: true
mermaid: true
---

# [CSS] position 속성

CSS `position` 속성은 웹 페이지에서 요소의 위치를 지정하는 방법을 정의합니다. 이 속성을 사용하면 기본적인 문서 흐름을 벗어나 요소를 자유롭게 배치할 수 있습니다. `position` 속성은 `static`, `relative`, `absolute`, `fixed`, `sticky`와 같은 값을 가질 수 있으며, 각 값에 따라 요소의 동작 방식과 좌표 기준이 달라집니다.

이 교안에서는 각 `position` 값의 특징을 자세히 알아보고, 실습 예제를 통해 어떻게 동작하는지 확인합니다.

---

## #01. `position: static` (기본값)

모든 HTML 요소는 기본적으로 `position: static` 상태입니다. 이 상태에서는 `top`, `right`, `bottom`, `left`, `z-index`와 같은 위치 지정 속성들이 아무런 효과를 발휘하지 못합니다. 요소는 단순히 HTML 마크업 순서(HTML 코딩 순서)에 따라 페이지에 배치됩니다.

`static`은 요소를 특별히 배치할 필요가 없을 때 사용되는 기본값이므로, 별도의 실습 예제는 없습니다. 다른 `position` 값들이 어떻게 `static`의 동작을 변경하는지 이해하는 것이 중요합니다.

---

## #02. `position: relative` (상대 위치)

`position: relative`는 요소를 **원래 자신의 위치(static 상태일 때의 위치)를 기준**으로 상대적으로 이동시킵니다. `top`, `right`, `bottom`, `left` 속성을 사용하여 원래 위치에서 얼마나 떨어질지를 지정할 수 있습니다.

-   **좌표 기준**: 요소 자기 자신의 원래 위치.
-   **공간 차지**: `relative`로 이동하더라도, 원래 있던 공간은 그대로 차지합니다. 다른 요소들은 해당 요소가 이동하지 않은 것처럼 동작하여 레이아웃에 영향을 주지 않습니다.
-   **`z-index`**: `z-index` 속성을 사용하여 요소가 겹칠 때의 쌓임 순서(stacking order)를 제어할 수 있습니다. 값이 클수록 위에 표시됩니다.

### 실습 예제: `relative`를 이용한 요소 배치

아래 예제는 세 개의 박스에 `position: relative`를 적용하여 위치를 조정한 모습입니다.

-   `.box1`은 원래 위치에서 `top: 250px`, `left: 250px` 만큼 이동했으며, `z-index: 1`로 설정되어 `.box2`보다 위에 표시됩니다.
-   `.box2`는 원래 위치에서 `top: 100px`, `left: 100px` 만큼 이동했습니다.
-   `.box3`는 `position`이 설정되지 않아 `static` 상태로 원래 위치에 남아있습니다.

**실습 코드: `/16-CSS-Position/01-포지션속성(1).html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>01-포지션속성(1)</title>
    <style type="text/css">
        * {
            margin: 0;
            padding: 0;
        }

        div {
            width: 300px;
            height: 300px;

            &.box1 {
                background-color: #ff0000;
                position: relative;
                top: 250px;
                left: 250px;
                z-index: 1;
            }

            &.box2 {
                background-color: #00ff00;
                position: relative;
                top: 100px;
                left: 100px;
            }

            &.box3 {
                background-color: #0000ff;
            }
        }
    </style>
</head>

<body>
    <div class="box1">박스1</div>
    <div class="box2">박스2</div>
    <div class="box3">박스3</div>
</body>

</html>
```

---

## #03. `position: absolute` (절대 위치)

`position: absolute`는 요소를 문서의 흐름에서 완전히 제외하고, **가장 가까운 `position` 속성이 `static`이 아닌 조상 요소를 기준**으로 위치를 지정합니다. 만약 조상 중에 위치가 지정된 요소가 없다면, 최상위 요소인 `<body>`를 기준으로 배치됩니다.

즉, 부모 요소에 `position: relative`, `absolute`, `fixed`, `sticky` 중 하나가 설정되어 있으면 그 요소를 기준으로 삼고, 그렇지 않으면 브라우저의 창을 기준으로 삼습니다.

-   **좌표 기준**: 가장 가까운 `position`이 `static`이 아닌 조상 요소. 없으면 `<body>`.
-   **공간 차지**: 문서 흐름에서 제외되므로, 원래 있던 공간을 차지하지 않습니다. 다른 요소들은 해당 요소가 없는 것처럼 동작하여 빈자리를 채웁니다.
-   **`z-index`**: `z-index`를 사용하여 쌓임 순서를 제어할 수 있습니다.

### 실습 예제 1: `absolute` 기본 동작

아래 예제는 세 개의 박스에 `position: absolute`를 적용한 모습입니다. 모든 박스는 조상 중에 위치 지정 요소가 없으므로 `<body>`의 좌측 상단을 기준으로 배치됩니다. `z-index` 값이 가장 큰 `.box1`이 제일 위에 표시됩니다.

**실습 코드: `/16-CSS-Position/02-포지션속성(2).html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>02-포지션속성(2)</title>
    <style type="text/css">
        * {
            margin: 0;
            padding: 0;
        }

        div {
            width: 300px;
            height: 300px;

            &.box1 {
                background-color: #ff0000;
                position: absolute;
                left: 250px;
                top: 250px;
                z-index: 100;
            }

            &.box2 {
                background-color: #00ff00;
                position: absolute;
                left: 150px;
                top: 150px;
                z-index: 1;
            }

            &.box3 {
                background-color: #0000ff;
                position: absolute;
                left: 200px;
                top: 200px;
            }
        }
    </style>
</head>

<body>
    <div class="box1">박스1</div>
    <div class="box2">박스2</div>
    <div class="box3">박스3</div>
</body>

</html>
```

### 실습 예제 2: `relative` 부모 안의 `absolute` 자식

`absolute`는 특정 영역 안에서 요소를 자유롭게 배치하고 싶을 때 매우 유용합니다. 부모 요소에 `position: relative`를 적용하고 자식 요소에 `position: absolute`를 적용하면, 자식은 부모 요소를 기준으로 위치를 잡게 됩니다.

아래 예제에서 `.child` 박스는 `position: absolute`로 설정되었고, 부모인 `.parent` 박스는 `position: relative`입니다. 따라서 `.child`는 부모의 우측 상단 모서리를 기준으로 `right: 10px`, `top: 10px` 위치에 배치됩니다.

대부분의 경우 요소의 위치를 position으로 지정할 때는 `absolute` 방식을 사용하며, 이때는 부모 요소에 `relative`를 설정하는 것이 일반적입니다. 부모 요소에게 `absolute`를 설정하게 되면 주변 요소가 부모 요소의 위치를 인식하지 못하게 되어 레이아웃이 깨질 수 있습니다.

**실습 코드: `/16-CSS-Position/03-포지션속성(3).html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>03-포지션속성(3)</title>
    <style type="text/css">
        .parent {
            width: 500px;
            height: 300px;
            margin: auto;
            background-color: #ff00ff;
            /** 부모에게 position속성이 부여되면, 부모를 기준으로 좌표를 설정한다. */
            position: relative;

            .child {
                width: 100px;
                height: 100px;
                background-color: #00ff00;
                /** 기본적으로 absolute 방식은 브라우저의 끝을 기준으로 좌표를 설정한다. */
                position: absolute;
                right: 10px;
                top: 10px;
            }
        }
    </style>
</head>

<body>
    <div class="parent">
        <div class="child"></div>
    </div>
    <h1>Hello World</h1>
</body>

</html>
```

---

## #04. `position: fixed` (고정 위치)

`position: fixed`는 `absolute`와 유사하게 동작하지만, 기준점이 항상 **브라우저 창(Viewport)**이라는 점에서 결정적인 차이가 있습니다. 페이지를 스크롤하더라도 `fixed`로 지정된 요소는 항상 화면의 같은 위치에 고정됩니다.

-   **좌표 기준**: 브라우저 창 (Viewport).
-   **공간 차지**: 문서 흐름에서 제외되므로 공간을 차지하지 않습니다.
-   **주요 용도**: 상단 내비게이션 바, 하단 푸터, 팝업 창 등 화면에 항상 고정되어야 하는 UI 요소에 사용됩니다.

### 실습 예제: 화면에 고정된 타이틀 바

아래 예제는 `#titlebar`에 `position: fixed`를 적용하여 화면 상단에 고정시킨 모습입니다. 페이지를 아래로 스크롤해도 타이틀 바는 항상 `top: 0` 위치를 유지합니다. `#content` 영역은 타이틀 바가 공간을 차지하지 않으므로, 타이틀 바 아래부터 시작되도록 `margin-top: 60px`를 설정했습니다.

**실습 코드: `/16-CSS-Position/04-포지션속성(4).html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>04-포지션속성(4)</title>
    <style type="text/css">
        /* 전체 여백 제거 */
        * {
            margin: 0;
            padding: 0;
        }

        /* 타이틀 바 */
        .titlebar {
            background-color: #0066ff;
            /* 스크롤에 상관 없이 화면상에서 고정된 위치를 유지한다. */
            position: fixed;
            left: 0;
            top: 0;
            /** fixed로 위치가 지정되면 크기를 명시적으로 부여해야 한다. */
            width: 100%;
            height: 60px;

            /* 타이틀 바 > 제목 */
            h1 {
                color: #fff;
                font-size: 24px;
                font-weight: bold;

                /* 부모를 기준으로 100%이므로 부모 요소인 60px과 동일해 진다. */
                height: 100%;

                /* 텍스트를 박스 중앙에 배치 */
                display: flex;
                justify-content: center;
                align-items: center;
            }
        }

        /* 내용 영역 */
        .content {
            font-size: 20px;
            height: 5000px;
            background: #eee;

            /* titlebar의 position 속성에 의해 titlebar뒤에 가려진다.
               가려진 높이 만큼 밀어내야 한다. */
            margin-top: 60px;
        }
    </style>
</head>

<body>
    <div class="titlebar">
        <h1>TitleBar</h1>
    </div>
    <div class="content">
        <p>내용영역 (1)</p>
        <p>내용영역 (2)</p>
        <p>내용영역 (3)</p>
        <p>내용영역 (4)</p>
        <p>내용영역 (5)</p>
    </div>
</body>

</html>
```

---

## #05. `position: sticky` (스티키 위치)

`position: sticky`는 `static`과 `fixed`의 특징을 결합한 하이브리드형 위치 지정 방식입니다. 평소에는 `static`처럼 문서 흐름에 따라 배치되지만, 스크롤 위치가 특정 지점(임계점)에 도달하면 `fixed`처럼 화면에 고정됩니다.

-   **동작 방식**: 스크롤 위치에 따라 `static`과 `fixed` 사이를 전환합니다.
-   **필수 속성**: `top`, `right`, `bottom`, `left` 중 하나 이상을 반드시 설정해야 "고정될 위치(임계점)"를 지정할 수 있습니다.
-   **주요 용도**: 스크롤에 따라 움직이는 목차, 특정 섹션의 헤더 등 사용자에게 중요한 정보를 계속 보여주고 싶을 때 유용합니다.

### 주의사항

**부모 요소의 `overflow` 속성**: 부모(또는 조상) 요소에 `overflow: hidden | scroll | auto`가 설정되어 있으면 `sticky`가 동작하지 않을 수 있습니다. 또한 `sticky` 요소의 부모는 명시적인 높이(`height`) 값을 가지고 있어야 합니다. 이를 방지하기 위해서는 **부모 요소를 갖지 않는 최상위 요소에만 `sticky`를 적용**해야 합니다.

> 요약하면 `sticky`를 사용하는 요소는 부모 요소가 없어야 합니다.

### 실습 예제: 스크롤에 따라 고정되는 메뉴 바

아래 예제에서 `.navbar`는 `position: sticky`와 `top: 0`으로 설정되었습니다. 페이지를 스크롤하면, 메뉴 바는 상단 영역(`header`)과 함께 스크롤되다가 화면 상단(`top: 0`)에 닿는 순간 그 자리에 고정됩니다.

**실습 코드: `/16-CSS-Position/05-sticky.html`**

```html
<!DOCTYPE html>
<html lang="ko" translate="no">

<head>
    <meta charset="UTF-8">
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>05-sticky</title>
    <style>
        body {
            margin: 0;
            padding: 0;
        }

        h1 {
            font-size: 30px;
            text-align: center;
            color: white;
        }

        .header {
            padding: 80px;
            background: #1abc9c;
        }

        .navbar {
            padding: 5px;
            background-color: #333;

            /** 스크롤에 따라 이동하다가 top 속성에 지정된 높이에 다다르면 fixed의 특성을 보임 */
            position: sticky;
            top: 0;
        }

        .content {
            padding: 50px;
            background-color: #ccc;
            height: 5000px;
        }
    </style>
</head>

<body>
    <header class="header">
        <h1>상단 영역</h1>
    </header>

    <nav class="navbar">
        <h1>메뉴바 영역</h1>
    </nav>

    <div class="content">
        <h1>내용 영역</h1>
        <h1>내용 영역</h1>

        ... 적당히 많이 넣으세요 ...

        <h1>내용 영역</h1>
        <h1>내용 영역</h1>
    </div>
</body>

</html>
```