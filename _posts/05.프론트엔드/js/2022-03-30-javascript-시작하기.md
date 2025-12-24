---
title:  "Javascript 시작하기"
description: "Javascript는 웹 페이지에 생동감을 불어 넣을 수 있는 프로그래밍 언어로서 웹 페이지(HTML) 안에 포함되는 형태로 작성되어 웹 페이지가 브라우저에 의해 열릴 때 자동으로 실행됩니다.

웹 브라우저 밖의 환경에서 자바스크립트를 해석할 수 있는 V8 엔진이 등장한 이후 V8이 설치된 모든 장치에서 실행 가능하기 때문에 현재는 웹 프로그래밍 뿐만 아니라 백엔드(Node.js), 게임(Unity3D), 머신러닝(Tensorflow.js), 모바일 App(React Native), PC용 응용 프로그램 등 다양하게 사용하는 것이 가능해져서 오늘날 가장 많이 사용되는 프로그래밍 언어중 하나로 자리매김 하였습니다."
categories: [05.Frontend,Javascript]
date:   2022-03-30 11:33:00 +0900
author: Hossam
image: /images/indexs/js.png
tags: [Web Development,Frontend,Javascript]
pin: true
math: true
mermaid: true
---


## #01. Javascript의 종류와 발전사

<img src="/images/2022/0330/js-type.png" width="200" />

| 구분              | 설명                                         |
| ----------------- | -------------------------------------------- |
| ES5(ECMAScript 5) | 2009년 발표, 웹 브라우저 표준 JS             |
| ES6(ES2015)       | 2015년 발표, 모던 JS의 시작점               |
| ES2016~ES2022     | 매년 새로운 기능이 추가되는 최신 JS         |
| TypeScript        | Microsoft에서 개발한 정적 타입 JS           |

### JavaScript 버전별 주요 특징

#### ES5 (2009)
- `strict mode` 도입
- `JSON` 객체 지원
- 배열 메서드 확장 (`forEach`, `map`, `filter` 등)

#### ES6/ES2015 (2015) - 모던 JavaScript의 시작
- `let`, `const` 키워드
- 화살표 함수 (`=>`)
- 템플릿 리터럴 (백틱 사용)
- 구조 분해 할당
- 클래스 문법
- 모듈 시스템 (`import`/`export`)
- Promise

#### ES2016 이후
- **ES2017**: `async`/`await`
- **ES2018**: Rest/Spread 연산자 확장
- **ES2019**: `Array.flat()`, `Object.fromEntries()`
- **ES2020**: Optional chaining (`?.`), Nullish coalescing (`??`)
- **ES2021**: `Promise.any()`, 논리 할당 연산자
- **ES2022**: Top-level await, 클래스 필드


## #01. 실행환경 구성

### 1) Node.js

#### 설치확인

윈도우의 경우 명령프롬프트 실행

```
WinKey + R > cmd (엔터)
```

맥의 경우 터미널 실행

```
Cmd + Space > 터미널 검색
```

명령어 수행

```shell
node --version
```

결과값이 출력되지 않을 경우 https://nodejs.org 에서 프로그램 내려받아 설치 필요함.

대부분의 경우 LTS 버전 권장.

Mac M1 버전의 경우 17.1 이상 버전 필요함.

설치 완료 후 열어두었던 명령프롬프트나 터미널을 종료하고 재시작.

앞서 수행한 버전확인 명령어를 통해 설치 완료 확인.



### 2) Visual Studio Code

https://code.visualstudio.com/

#### Javascript 작성에 도움을 주는 Visual Studio Code Extension

| 이름                      | 설명                                                                                                             |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| **JavaScript (ES6) code snippets** | ES6+ 문법 자동완성 기능 제공 |
| **Prettier - Code formatter** | 코드의 줄바꿈, 들여쓰기등을 자동으로 정렬<br/>사용방법: `Ctrl+Shift+P` > `Format Document` |
| **ESLint**                | JavaScript 구문 검사 및 코딩 스타일 통일<br/>터미널에서 `npm install -g eslint` 수행 필요 |
| **Code Runner**           | 설치후 `Ctrl+Alt+N` 단축키로 현재 소스코드 실행<br/>환경설정에서 `Code-runner: Clear Previous Output` 항목 체크 |
| **Auto Rename Tag**       | HTML 태그 이름 변경 시 자동으로 여는 태그와 닫는 태그 동시 수정 |
| **Live Server**           | 웹 페이지의 변경사항을 실시간으로 브라우저에 반영 |
| **Bracket Pair Colorizer** | 괄호 쌍을 색상으로 구분하여 코드 가독성 향상 |
| **GitLens**               | Git 히스토리와 작성자 정보를 코드 라인별로 표시 |

### 추가 개발 도구

#### 브라우저 개발자 도구
- **Chrome DevTools**: 가장 강력한 웹 개발 도구
- **Firefox Developer Tools**: 웹 표준 준수도가 높음
- **Safari Web Inspector**: 맥 사용자에게 최적화

#### 온라인 코드 실행 환경
- **CodePen**: 프론트엔드 코드 테스트에 최적
- **JSFiddle**: 간단한 JavaScript 코드 테스트
- **CodeSandbox**: 프레임워크 프로젝트 구성 가능
- **Repl.it**: 다양한 언어 지원 온라인 IDE



## #02. Hello Javascript

### 1) 소스코드

프로그램 명령어를 저장해 놓은 파일

사용하는 프로그래밍 언어에 따라 확장자가 서로 다르다. (`*.java`, `*.js`, `*.py`, `*.cpp`)

일반적인 메모장용 텍스트파일의 확장자를 강제로 수정해서 사용한다.

### 2) 주석문

프로그램 소스코드 안에 명시하는 필기.

소스코드에 대한 부연 설명을 작성하는 용도.

#### 한 줄 전용

`//` 를 명시하고 그 뒤에 주석 내용을 작성한다. 여러 줄을 지정해야 할 경우 모든 행 앞에 `//`가 붙는다.


```javascript
// 여기는 주석입니다.
// 여기는 주석입니다.
// 여기는 주석입니다.
// 여기는 주석입니다.
```

#### 여러줄 처리

`/*`과 `*/` 사이에 주석 내용을 작성한다. 이 안에서는 줄바꿈이 자유롭다.

```javascript
/*
여기는 주석입니다.
여기는 주석입니다.
여기는 주석입니다.
여기는 주석입니다.
*/
```

### 3) 첫 번째 Javascript program

#### JS가 HTML안에 존재하는 경우.

원래 JS는 HTML에 기생하는 존재.

##### simple.html

```html
<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Document</title>
    </head>
    <body>
        <h1>simple.html</h1>

        <!-- JS코드 영역을 의미하는 태그. HTML내 어느 곳에나 존재 가능함. -->
        <script>
            console.log("Hello World");
        </script>
    </body>
</html>
```


### JS코드와 HTML을 분리

하나의 파일에 HTML(뼈대) + CSS(옷) + JS(동작)가 혼합되면서 코드가 복잡해지고 길어진다. (스파게티 코드)

CSS와 JS를 별도의 파일로 분리하는 것이 바람직.

#### 확장자가 `*.js`인 파일이 순수 JS코드만 작성

##### HelloWorld.js

```js
// 메시지 그룹핑
console.group("MyMessage1");
console.log("안녕하세요. Javascript1");
console.log("안녕하세요. Javascript2");
console.log("안녕하세요. Javascript3");
console.groupEnd();

console.group("MyMessage2"); // 출력하는 내용을 그룹으로 묶음
console.log("안녕하세요. Javascript4");

console.group("MyMessage2-1"); // 그룹안에 하위그룹 생성
console.log("안녕하세요. Javascript5");
console.log("안녕하세요. Javascript6");
console.groupEnd(); // 하위 그룹으로 묶기 끝!!
console.groupEnd(); // 그룹으로 묶기 끝!!
```

#### JS파일을 참조하는 HTML

##### HelloWorld.html

```html
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <h1>HelloWorld.html</h1>

    <!-- 별도의 JS파일을 참조함 -->
    <script src="HelloWorld.js"></script>
</body>
</html>
```


### 4) JS 소스코드 작성시 주의 사항

1. 대소문자를 업격히 구분한다.
2. 줄바꿈과 띄어쓰기는 개발자가 코드를 읽기 수월하게 하기 위한 용도일 뿐 실행에는 아무런 영향이 없다.



### 5) JS 파일 직접 실행

#### 명령프롬프트(win)를 통한 실행

- `WinKey+R` -> cmd `(엔터)` 로 명령프롬프트 실행
- 소스파일이 존재하는 폴더로 이동 `cd 폴더경로`
    - 폴더 위치가 C드라이브가 아닌 경우 `/d` 옵션 적용 -> `cd /d 폴더경로`
- `node 파일이름` 명령으로 코드 실행

![img2](/images/2022/0330/002.png)

#### VSCode를 통한 실행

- `Code Runner` 확장 익스텐션 설치

![img2](/images/2022/0330/003.png)

- 코드 창에서 `Ctrl + Alt + N` 으로 실행
- 원하는 부분만 드래그 후 부분 실행 가능함.

##### 실행시 이전 출력 내용 삭제 설정

![img2](/images/2022/0330/004.png)



## #03. 프로그램 소스코드가 실행되는 과정

### 1) 컴파일 언어

반드시 기계어로 컴파일되어야만 실행시킬 수 있는 프로그래밍 언어

1. 개발자가 프로그램 소스코드를 작성.
2. 작성한 소스코드를 2진수(바이너리, 기계어) 형태로 변환 -> `컴파일(compile)`
   - 소스코드를 컴파일 해 주는 소프트웨어 -> `컴파일러(compiler)`
3. `컴파일`된 바이너리를 실행한다.
   - 한번 컴파일된 파일은 2진수 형태로 저장되어 있기때문에 재실행시 컴퓨터가 해석할 필요가 없다.
   - 컴파일된 결과물은 독립 실행이 가능한 형태이기 때문에 별다른 도구가 필요 없다.

> C, C++, Java 등


### 2) 인터프리터 언어

컴파일러를 거쳐서 기계어로 변환되지 않고 바로 실행되는 프로그래밍 언어

1. 컴파일을 거치지 않고 매 실행시마다 소스코드를 해석하는 과정이 반복적으로 수행되는 형태.
2. 컴파일을 하지 않는다는 간편함 때문에 상대적으로 배우기 쉽다.
3. 컴파일 언어보다는 실행속도가 느리다.
   - 대용량 서비스에 적용하는 것은 적합하지 않다.
4. 컴파일을 하지 않는 대신 실행을 하기위해 해석기가 매번 필요하다.
   - Javascript코드는 실행하기 위해서 반드시 Node나 웹브라우저가 필요하다.

> Javascript, Python

#### 스크립트 언어

인터프리터 방식에서 사용하기 위해 고안된 프로그래밍 언어.