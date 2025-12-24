---
title:  "Javascript 변수와 데이터 타입"
description: "변수란 데이터를 저장할 수 있는 메모리 상의 공간을 말합니다."
categories: [05.Frontend,Javascript]
date:   2022-03-31 11:33:00 +0900
author: Hossam
image: /images/indexs/js.png
tags: [Web Development,Frontend,Javascript]
pin: true
math: true
mermaid: true
---


## #01. 변수 선언 방법의 발전

JavaScript에서 변수를 선언하는 방법은 ES6를 기점으로 크게 개선되었습니다.

### 1) var (ES5 이전) - 사용 권장하지 않음

```js
var 변수이름 = 값;
```

**var의 문제점:**
- **함수 스코프**: 함수 내부에서만 지역변수
- **호이스팅**: 선언이 끌어올려져 예상치 못한 동작
- **재선언 허용**: 같은 이름의 변수를 여러 번 선언 가능
- **재할당 허용**: 값 변경 가능

```js
// var의 문제점 예시
console.log(x); // undefined (에러가 아님!)
var x = 5;

var x = 10; // 재선언 가능 (문제!)
```

### 2) let (ES6+) - 일반 변수용

```js
let 변수이름 = 값;
```

**let의 특징:**
- **블록 스코프**: `{}` 내부에서만 유효
- **재선언 불가**: 같은 스코프에서 재선언 에러
- **재할당 허용**: 값 변경 가능
- **Temporal Dead Zone**: 선언 전에 사용 불가

```js
let count = 0;
count = 1; // 재할당 가능

// let count = 2; // 에러! 재선언 불가

if (true) {
    let blockVariable = "블록 내부";
    console.log(blockVariable); // 정상 출력
}
// console.log(blockVariable); // 에러! 블록 밖에서 접근 불가
```

### 3) const (ES6+) - 상수용

```js
const 상수이름 = 값;
```

**const의 특징:**
- **블록 스코프**: `{}` 내부에서만 유효
- **재선언 불가**: 같은 스코프에서 재선언 에러
- **재할당 불가**: 값 변경 불가 (immutable)
- **선언과 동시에 초기화 필수**

```js
const PI = 3.14159;
// PI = 3.14; // 에러! 재할당 불가

const config = {
    apiUrl: "https://api.example.com",
    timeout: 5000
};
// config 객체 자체는 변경 불가하지만, 내부 속성은 변경 가능
config.timeout = 10000; // 이것은 가능
```

### 4) 현대적 변수 선언 권장사항

1. **기본적으로 `const` 사용**
2. **값이 변경되어야 할 때만 `let` 사용**
3. **`var`는 사용하지 않기**

```js
// 좋은 예시
const userName = "홍길동";           // 변경되지 않는 값
const users = [];                    // 배열 자체는 변경되지 않음
let currentIndex = 0;                // 값이 변경될 수 있음

// 나쁜 예시
var data = "test";                   // var 사용 지양
```


## #02. 변수 이름 규칙과 명명 규칙

### 1) 기본 규칙

1. **영어, 숫자, 언더바(`_`), `$` 기호만 사용 가능**
2. **첫 글자는 숫자로 시작할 수 없음**
3. **예약어(키워드) 사용 불가**: `let`, `const`, `function`, `if` 등
4. **대소문자를 구분**: `userName`과 `username`은 다른 변수

### 2) 명명 규칙 (Naming Convention)

#### 카멜 케이스 (camelCase) - 일반 변수/함수
```js
const firstName = "홍길동";
const phoneNumber = "010-1234-5678";
const getUserInfo = () => { /* ... */ };
```

#### 파스칼 케이스 (PascalCase) - 생성자 함수/클래스
```js
class UserManager { /* ... */ }
function CreateUser(name) { /* ... */ }
```

#### 스네이크 케이스 (snake_case) - 상수나 설정값
```js
const API_BASE_URL = "https://api.example.com";
const MAX_RETRY_COUNT = 3;
```

#### 케밥 케이스 (kebab-case) - CSS 클래스명, HTML 속성
```css
.user-profile { /* ... */ }
.main-navigation { /* ... */ }
```

### 3) 의미있는 변수명 작성법

```js
// 나쁜 예시
let a = 25;
let data = [];
let temp = true;

// 좋은 예시
let userAge = 25;
let productList = [];
let isAuthenticated = true;

// 더 좋은 예시
const MINIMUM_AGE = 18;
const authenticatedUserList = [];
const hasValidPermission = true;
```

### 4) 변수 타입별 네이밍 패턴

```js
// 불린값 - is, has, can, should 접두사
const isVisible = true;
const hasPermission = false;
const canEdit = true;
const shouldUpdate = false;

// 배열 - 복수형 또는 List 접미사
const users = [];
const productList = [];
const itemCollection = [];

// 객체 - 명사형
const userInfo = {};
const apiResponse = {};
const configSettings = {};

// 함수 - 동사형 시작
const getUserName = () => {};
const validateInput = () => {};
const calculateTotal = () => {};
## #03. JavaScript 데이터 타입 (Data Types)

JavaScript는 **동적 타입 언어**로, 변수에 값을 할당할 때 데이터 타입이 결정됩니다.

### 1) 원시 타입 (Primitive Types)

#### Number - 숫자형
```js
const age = 25;              // 정수
const price = 99.99;         // 실수
const temperature = -10;     // 음수
const scientific = 1.23e5;   // 과학적 표기법 (123000)

// 특수 숫자값
const infinity = 1 / 0;      // Infinity
const negInfinity = -1 / 0;  // -Infinity
const notNumber = "abc" / 2; // NaN (Not a Number)
```

#### String - 문자열
```js
const singleQuote = '안녕하세요';
const doubleQuote = "Hello World";
const templateLiteral = `이름: ${name}, 나이: ${age}`; // ES6+

// 문자열 메서드
const text = "JavaScript";
console.log(text.length);        // 10
console.log(text.toUpperCase()); // JAVASCRIPT
console.log(text.slice(0, 4));   // Java
```

#### Boolean - 불린형
```js
const isActive = true;
const isComplete = false;

// Falsy 값들 (false로 평가됨)
console.log(Boolean(false));     // false
console.log(Boolean(0));         // false
console.log(Boolean(-0));        // false
console.log(Boolean(0n));        // false
console.log(Boolean(""));        // false
console.log(Boolean(null));      // false
console.log(Boolean(undefined)); // false
console.log(Boolean(NaN));       // false

// Truthy 값들 (true로 평가됨)
console.log(Boolean(1));         // true
console.log(Boolean("hello"));   // true
console.log(Boolean([]));        // true
console.log(Boolean({}));        // true
```

#### Undefined - 정의되지 않음
```js
let value;                    // 선언만 하고 할당하지 않음
console.log(value);           // undefined

const obj = {};
console.log(obj.notExist);    // undefined
```

#### Null - 의도적인 빈 값
```js
let data = null;              // 의도적으로 비어있음을 표현
console.log(data);            // null

// null vs undefined
console.log(null == undefined);  // true (값 비교)
console.log(null === undefined); // false (타입까지 비교)
```

#### Symbol - 고유 식별자 (ES6+)
```js
const sym1 = Symbol('id');
const sym2 = Symbol('id');
console.log(sym1 === sym2);   // false (고유함)

// 객체 속성의 고유 키로 사용
const obj = {
    [sym1]: 'value1',
    [sym2]: 'value2'
};
```

#### BigInt - 큰 정수 (ES2020+)
```js
const bigNumber = 123456789012345678901234567890n;
const anotherBig = BigInt("123456789012345678901234567890");

console.log(bigNumber);       // 123456789012345678901234567890n
console.log(typeof bigNumber); // bigint
```

### 2) 참조 타입 (Reference Types)

#### Object - 객체
```js
// 객체 리터럴
const person = {
    name: "홍길동",
    age: 30,
    isStudent: false,
    address: {
        city: "서울",
        district: "강남구"
    }
};

// 점 표기법과 대괄호 표기법
console.log(person.name);        // "홍길동"
console.log(person['age']);      // 30
```

#### Array - 배열
```js
const fruits = ["사과", "바나나", "오렌지"];
const numbers = [1, 2, 3, 4, 5];
const mixed = [1, "hello", true, null, {name: "test"}];

// 배열 메서드 (ES6+)
const doubled = numbers.map(num => num * 2);     // [2, 4, 6, 8, 10]
const filtered = numbers.filter(num => num > 3); // [4, 5]
const found = numbers.find(num => num === 3);    // 3
```

#### Function - 함수
```js
// 함수 선언문
function greet(name) {
    return `안녕하세요, ${name}님!`;
}

// 함수 표현식
const add = function(a, b) {
    return a + b;
};

// 화살표 함수 (ES6+)
const multiply = (a, b) => a * b;

// 즉시 실행 함수 (IIFE)
(function() {
    console.log("즉시 실행됩니다!");
})();
```

### 3) 타입 확인 방법

#### typeof 연산자
```js
console.log(typeof 42);          // "number"
console.log(typeof "hello");     // "string"
console.log(typeof true);        // "boolean"
console.log(typeof undefined);   // "undefined"
console.log(typeof Symbol());    // "symbol"
console.log(typeof 123n);        // "bigint"

// 주의사항
console.log(typeof null);        // "object" (버그이지만 호환성 유지)
console.log(typeof []);          // "object"
console.log(typeof {});          // "object"
console.log(typeof function(){}); // "function"
```

#### 더 정확한 타입 확인
```js
// Array.isArray() - 배열 확인
console.log(Array.isArray([]));     // true
console.log(Array.isArray({}));     // false

// Object.prototype.toString.call() - 정확한 타입
const getType = (value) => Object.prototype.toString.call(value).slice(8, -1);

console.log(getType([]));           // "Array"
console.log(getType({}));           // "Object"
console.log(getType(null));         // "Null"
console.log(getType(new Date()));   // "Date"
```

### 4) 타입 변환 (Type Conversion)

#### 명시적 변환
```js
// 문자열로 변환
String(123);          // "123"
(123).toString();     // "123"
123 + "";            // "123"

// 숫자로 변환
Number("123");        // 123
parseInt("123px");    // 123
parseFloat("12.34");  // 12.34
+"123";              // 123

// 불린으로 변환
Boolean(1);          // true
Boolean(0);          // false
!!1;                 // true
```

#### 암시적 변환 (주의 필요!)
```js
"5" + 3;             // "53" (문자열 연결)
"5" - 3;             // 2 (숫자 연산)
"5" * 3;             // 15 (숫자 연산)
true + 1;            // 2
false + 1;           // 1
```

### 5) ES6+ 새로운 기능들

#### 구조 분해 할당 (Destructuring)
```js
// 배열 구조 분해
const [first, second, third] = ["a", "b", "c"];

// 객체 구조 분해
const {name, age} = person;
const {name: userName, age: userAge} = person; // 새로운 변수명
```

#### 스프레드 연산자 (Spread Operator)
```js
const arr1 = [1, 2, 3];
const arr2 = [...arr1, 4, 5];     // [1, 2, 3, 4, 5]

const obj1 = {a: 1, b: 2};
const obj2 = {...obj1, c: 3};     // {a: 1, b: 2, c: 3}
```

#### 옵셔널 체이닝 (ES2020+)
```js
const user = {
    profile: {
        address: {
            city: "서울"
        }
    }
};

// 안전한 접근
console.log(user?.profile?.address?.city);     // "서울"
console.log(user?.profile?.phone?.number);     // undefined (에러 없음)
```

#### Nullish Coalescing (ES2020+)
```js
const value1 = null ?? "기본값";      // "기본값"
const value2 = 0 ?? "기본값";         // 0 (0은 falsy이지만 null/undefined 아님)
const value3 = "" ?? "기본값";        // "" (빈 문자열도 null/undefined 아님)
```

## #04. 현대적 문자열 처리와 출력

### 1) 템플릿 리터럴 (Template Literals) - ES6+

```js
const name = "홍길동";
const age = 25;
const city = "서울";

// 기존 방식 (문자열 연결)
const oldWay = "안녕하세요, " + name + "님! 나이는 " + age + "세이고 " + city + "에 살고 있습니다.";

// 템플릿 리터럴 (권장)
const newWay = `안녕하세요, ${name}님! 나이는 ${age}세이고 ${city}에 살고 있습니다.`;

// 다중 라인 문자열
const multiLine = `
    첫 번째 줄
    두 번째 줄
    세 번째 줄
`;

// 표현식 사용
const calculation = `10 + 20 = ${10 + 20}`;
const conditional = `상태: ${age >= 18 ? '성인' : '미성년자'}`;
```

### 2) 최신 콘솔 출력 방법

```js
const user = {
    name: "김철수",
    age: 28,
    skills: ["JavaScript", "React", "Node.js"]
};

// 기본 출력
console.log("Hello World");

// 여러 값 출력
console.log("이름:", user.name, "나이:", user.age);

// 템플릿 리터럴 활용
console.log(`사용자 정보: ${user.name} (${user.age}세)`);

// 객체 출력 (개발자 도구에서 확장 가능)
console.log("사용자 정보:", user);

// 테이블 형태 출력
console.table(user.skills);

// 그룹화된 출력
console.group("사용자 정보");
console.log("이름:", user.name);
console.log("나이:", user.age);
console.log("스킬:", user.skills);
console.groupEnd();

// 조건부 출력
console.assert(user.age >= 18, "사용자는 성인이어야 합니다");

// 시간 측정
console.time("작업시간");
// ... 어떤 작업 ...
console.timeEnd("작업시간");

// 경고 및 에러
console.warn("이것은 경고 메시지입니다");
console.error("이것은 에러 메시지입니다");
```

### 3) 디버깅을 위한 고급 출력

```js
// 변수명과 값을 함께 출력하는 트릭
const username = "admin";
const userLevel = 5;

console.log({username, userLevel}); // {username: "admin", userLevel: 5}

// 조건부 로깅
const DEBUG = true;
DEBUG && console.log("디버그 정보:", user);

// 함수 호출 추적
console.trace("함수 호출 경로");

// 성능 측정
const startTime = performance.now();
// ... 작업 수행 ...
const endTime = performance.now();
console.log(`작업 시간: ${endTime - startTime}ms`);
```
