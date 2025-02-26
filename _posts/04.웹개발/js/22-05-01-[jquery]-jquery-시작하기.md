---
layout: post
title:  "[jQuery] jQuery 시작하기"
date:   2022-05-01
banner_image: index-jquery.png
tags: [jQuery]
---

명성이 예전같지는 않지만 jQuery는 HTML과 CSS를 제어하고 다양한 효과를 구현하기 위해 사용되는 가장 대표적인 Javascript 라이브러리 중 하나 입니다. 최근에는 순정 자바스크립트를 사용하자는 **바닐라JS**, Virtual DOM을 내세운 **React.js** 등에게 점점 그 자리를 내주고 있지만 여전히 강력한 Javascript 도구임에는 틀림이 없습니다.

간단한 기능을 구현하기 위해서 부조건 React.js 등을 사용하는 것은 오히려 프로그램 복잡도를 높이기만 하는 비효율적 작업이 될 수 있습니다. 간단한 단일 페이지 등의 기능은 여전히 jQuery 등을 사용하면 빠르게 구현 가능합니다.

주의할 점은 **바닐라JS**의 이해 없이 jQuery로 직행하는 것은 올바른 접근이 아니라는 것 입니다. 기초에 대한 이해 없이 jQuery를 바로 사용하는 것은 필요할 때 적절한 응용력을 발휘할 수 없게 합니다. 이점에 유의하면서 jQuery를 적절한 상황에서 사용한다면 분명 좋은 도구로서의 역할을 할 겁니다.

<!--more-->

# #01. jQuery 초기화

## 예전 스타일

```html
<!DOCTYPE html>
<html lang="ko">
<head>
    ... meta태그 설정 및 CSS 처리 ...
</head>

<body>
    ... HTML 태그 ...

    <!-- jQuery 참조 -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <!-- 개발자 작성 영역 -->
    <script type="text/javascript">
    /** 모든 곳에서 인식할 변수 및 함수 정의 영역 */

    /** jQuery 구현 부분 */
    $(function() {
        // 이 영역이 페이지 로딩이 완료된 후 실행된다.
        // <script> 태그가 body 종료 직전에 있을 경우 생략 가능
    });
    </script>
</body>
</html>
```

## 화살표 함수 적용

```html
<!DOCTYPE html>
<html lang="ko">
<head>
    ... meta태그 설정 및 CSS 처리 ...
</head>

<body>
    ... HTML 태그 ...

    <!-- jQuery 참조 -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <!-- 개발자 작성 영역 -->
    <script type="text/javascript">
    /** 모든 곳에서 인식할 변수 및 함수 정의 영역 */

    /** jQuery 구현 부분 ==> 화살표 함수 사용 */
    $(() => {
        // 이 영역이 페이지 로딩이 완료된 후 실행된다.
    });
    </script>
</body>
</html>
```

## 초기화 함수 없이 바로 적용하기

javascript 코드를 body태그 종료 직전에 삽입하는 경우 HTML에 대한 로딩이 모두 이루어진 이후에 Javascript가 동작하기 때문에 별도의 초기화 함수 없이 바로 코드를 진행해도 된다.


```html
<!DOCTYPE html>
<html lang="ko">
<head>
    ... meta태그 설정 및 CSS 처리 ...
</head>

<body>
    ... HTML 태그 ...

    <!-- jQuery 참조 -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <!-- 개발자 작성 영역 -->
    <script type="text/javascript">
    // 이 영역이 페이지 로딩이 완료된 후 실행된다.
    </script>
</body>
</html>
```

# #02. HTML 요소 접근

## HTML요소를 jQuery객체로 생성

```javascript
const obj = $("CSS셀렉터");
```

- 대상 요소를 지정할 수 있는 CSS셀렉터를 사용한다.
- jQuery에서 사용한 CSS셀렉터가 반드시 `<style>`태그에 정의되어 있어야 하는 것은 아니다.
- 혼란을 피하기 위해 CSS에서는 class형식으로만 셀렉터를 구성하고 Javascript 에서는 가급적 id속성만으로 대상을 지정한다.

## HTML요소 내의 내용 제어

`html()`함수는 파라미터가 있을 경우 설정(setter), 파라미터가 없을 경우 리턴(getter)의 기능을 한다.

### 요소 안에 내용을 설정하기

```javascript
$("#foo").html(설정할 내용);
```

### 요소 안의 내용을 가져오기

```javascript
const content = $("#foo").html();
```
