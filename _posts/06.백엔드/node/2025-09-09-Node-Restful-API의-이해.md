---
title: Node.js - Restful API의 이해와 CRUD
description: "RESTful API의 개념과 CRUD(생성, 조회, 수정, 삭제) 작업을 HTTP 메서드와 매핑하여 이해하는 방법을 학습합니다."
categories: [06.Backend,Node]
date:   2025-09-09 09:00:00 +0900
author: Hossam
image: /images/indexs/restapi.png
tags: [Web Development,Backend,Node,Express,Router,Controller,Restful,CRUD]
pin: true
math: true
mermaid: true
---

# RESTful API의 이해와 CRUD

웹 애플리케이션을 개발할 때 클라이언트(웹 브라우저, 모바일 앱 등)와 서버 간의 데이터 통신은 필수적이다. RESTful API는 이러한 통신을 위한 가장 널리 사용되는 아키텍처 스타일 중 하나이다.

## 1. CRUD란?

CRUD는 대부분의 컴퓨터 소프트웨어가 가지는 기본적인 데이터 처리 기능인 **Create(생성)**, **Read(조회)**, **Update(수정)**, **Delete(삭제)**를 묶어서 일컫는 말이다.

-   **Create**: 새로운 데이터를 생성.
-   **Read**: 기존의 데이터를 조회.
-   **Update**: 기존의 데이터를 수정.
-   **Delete**: 기존의 데이터를 삭제.

## 2. RESTful API란?

REST(Representational State Transfer)는 자원(Resource)을 이름(URI)으로 구분하여 해당 자원의 상태(State)를 주고받는 모든 것을 의미한다. REST 아키텍처 스타일을 따르는 API를 RESTful API라고 한다.

### REST의 주요 구성 요소

1.  **자원(Resource)**: URI (Uniform Resource Identifier)
    -   모든 자원은 고유한 ID를 가지며, 이 ID는 서버에 존재하고 클라이언트가 접근할 수 있는 모든 것을 의미한다. (e.g., `/users`, `/users/1`)
2.  **행위(Verb)**: HTTP Method
    -   자원에 대한 행위를 HTTP Method(GET, POST, PUT, DELETE 등)로 표현한다.
3.  **표현(Representation)**:
    -   클라이언트와 서버가 주고받는 자원의 상태를 표현한다. (e.g., JSON, XML)

### RESTful API의 특징

-   **Uniform Interface (일관된 인터페이스)**: URI로 지정한 리소스에 대한 조작을 통일되고 한정적인 인터페이스로 수행한다.
-   **Stateless (무상태성)**: 서버는 클라이언트의 상태를 저장하지 않는다. 각 요청은 독립적으로 처리된다.
-   **Cacheable (캐시 가능)**: HTTP의 캐싱 기능을 적용할 수 있다.
-   **Client-Server 구조**: 클라이언트와 서버가 독립적으로 발전할 수 있다.
-   **Layered System (계층형 구조)**: 서버는 다중 계층으로 구성될 수 있다.

## 3. HTTP Method와 CRUD 매핑

| CRUD   | HTTP Method | 설명                     |
| ------ | ----------- | ------------------------ |
| Create | POST        | 자원 생성                |
| Read   | GET         | 자원 조회                |
| Update | PUT         | 자원 전체 수정           |
| Delete | DELETE      | 자원 삭제                |

*참고: `PATCH` 메서드는 자원의 일부만 수정할 때 사용된다.*

## 4. Express에서의 파라미터 처리

클라이언트가 서버로 데이터를 보낼 때, Express는 다양한 방법으로 파라미터를 수신하고 처리할 수 있다.

### 1) GET 방식 파라미터

#### (1) QueryString

-   URL의 `?` 뒤에 `key=value` 형태로 데이터를 전달하는 방식이다.
-   `req.query` 객체를 통해 접근할 수 있다.
-   **예시 URL**: `/users?id=1`

#### (2) Path (경로) 파라미터

-   URL 경로의 일부로 데이터를 전달하는 방식이다.
-   라우팅 경로에 `:파라미터이름` 형식으로 지정한다.
-   `req.params` 객체를 통해 접근할 수 있다.
-   **예시 URL**: `/users/1`

### 2) POST, PUT, DELETE 방식 파라미터

`GET` 방식을 제외한 다른 메서드들은 요청 본문(body)에 데이터를 담아 서버로 전송한다. Express에서 요청 본문을 파싱하기 위해서는 미들웨어 설정이 필요하다.

```javascript
// app.js
// application/json 방식의 Content-Type을 파싱
app.use(express.json());
// application/x-www-form-urlencoded 방식의 Content-Type을 파싱
app.use(express.urlencoded({ extended: true }));
```

> **참고**: `express.json()`과 `express.urlencoded()` 미들웨어는 Express 4.16.0 버전부터 기본 내장되어 별도의 설치 없이 사용할 수 있으며 위의 코드는 이전 포스팅에서 이미 적용되어 있다.

#### (1) FormData (x-www-form-urlencoded)

-   HTML `<form>` 태그를 통해 전송되는 기본 방식이다.
-   `req.body` 객체를 통해 접근할 수 있다.

#### (2) JSON

-   API 통신에서 가장 널리 사용되는 데이터 형식이다.
-   요청 헤더의 `Content-Type`을 `application/json`으로 설정하고, 본문에 JSON 문자열을 담아 전송한다.
-   `req.body` 객체를 통해 접근할 수 있다.

`express.json()` 미들웨어가 요청을 분석하여 `req.body`에 자동으로 객체 형태로 변환해주기 때문에, FormData 방식과 동일한 코드로 JSON 데이터를 처리할 수 있다.

---

## 5. 실습 예제: `UserController`를 사용한 RESTful API 구현

`controllers/UserController.js` 파일의 코드를 통해 실제 Express 환경에서 어떻게 RESTful API가 구현되는지 단계별로 알아봅시다.

### 1단계: 기본 설정 및 데이터 준비

실제 데이터베이스를 연동하기 전에, 간단한 배열을 DB 대용으로 사용합니다.

```javascript
// controllers/UserController.js

import { GET, POST, PUT, DELETE } from '../helpers/RouteHelper.js';

// DB 대용 더미 데이터
const users = [
    { id: 1, name: "홍길동", email: "hong@example.com" },
    { id: 2, name: "김철수", email: "kim@example.com" },
    { id: 3, name: "이영희", email: "leeyh@example.com" },
    // ... (이하 생략)
];
```

### 2단계: 사용자 목록 조회 (Read)

#### 전체 사용자 또는 특정 사용자 조회 (GET /users)

QueryString을 사용하여 특정 사용자를 조회하거나 전체 사용자 목록을 반환합니다.

- **URL**: `/users` (전체), `/users?id=1` (특정 사용자)

```javascript
// controllers/UserController.js

export const getUsers = GET("/users")((req, res, next) => {
    // query parameters
    const { id } = req.query;

    // id가 있으면 해당 사용자만, 없으면 전체 사용자
    let result = [];

    if (id) {
        result.push(users.find(u => u.id === parseInt(id)));
    } else {
        result = users;
    }

    // 결과에 따라 응답
    if (!result || (Array.isArray(result) && result.length === 0)) {
        return res.status(404).json({ message: "사용자를 찾을 수 없습니다." });
    } else {
        res.status(200).json(result);
    }
});
```

#### API 테스트

Postman, Insomnia, curl 등 API 테스트 도구를 사용하여 다음과 같이 요청을 보낼 수 있습니다.

**전체 사용자 조회: `http://localhost:3000/users`**

![img](/images/2025/0907/get.png)

**특정 사용자 조회: `http://localhost:3000/users?id=1`**

![img](/images/2025/0907/get-query.png)


### 3단계: 사용자 상세 조회 (Read)

#### ID로 특정 사용자 조회 (GET /users/:id)

Path 파라미터를 사용하여 특정 ID를 가진 사용자의 정보를 반환합니다.

- **URL**: `/users/1`

```javascript
// controllers/UserController.js

export const getUserById = GET("/users/:id")((req, res, next) => {
    // path parameters
    const userId = req.params.id;

    // id에 해당하는 사용자 조회
    const user = users.find(u => u.id === parseInt(userId));

    // 사용자 존재 여부에 따라 응답
    if (user) {
        res.json(user);
    } else {
        res.status(404).json({ message: "사용자를 찾을 수 없습니다." });
    }
});
```

#### API 테스트

Postman, Insomnia, curl 등 API 테스트 도구를 사용하여 다음과 같이 요청을 보낼 수 있습니다.

**특정 사용자 조회: `http://localhost:3000/users/1`**

![img](/images/2025/0907/get-path.png)

### 4단계: 신규 사용자 추가 (Create)

#### (POST /users)

요청의 Body에 포함된 `name`과 `email` 정보를 사용하여 새로운 사용자를 생성합니다. FormData와 JSON 방식 모두 처리 가능합니다.

- **URL**: `/users`
- **Method**: `POST`
- **Body (JSON 예시)**: `{ "name": "새사용자", "email": "new@example.com" }`

```javascript
// controllers/UserController.js

export const createUser = POST("/users")((req, res, next) => {
    // formData 혹은 json 파라미터 받기
    const { name, email } = req.body;

    // 필수 값 체크
    if (!name || !email) {
        return res.status(400).json({ message: "이름과 이메일은 필수입니다." });
    }

    const userData = { name, email };

    // 새로운 사용자 생성
    const newUser = {
        id: Date.now(),
        ...userData,
    };

    users.push(newUser);

    // 생성된 사용자 정보 반환 (상태 코드 201)
    res.status(201).json(newUser);
});
```

#### API 테스트

Postman, Insomnia, curl 등 API 테스트 도구를 사용하여 다음과 같이 요청을 보낼 수 있습니다.

**신규 사용자 추가: `http://localhost:3000/users`**

![img](/images/2025/0907/post.png)

추가된 데이터를 확인하기 위해서 GET `/users` 요청을 다시 보내서 결과를 확인할 수 있습니다.

![img](/images/2025/0907/post-get.png)


### 5단계: 사용자 정보 수정 (Update)

#### (PUT /users/:id)

Path 파라미터로 수정할 사용자를 지정하고, Body의 정보로 데이터를 갱신합니다.

- **URL**: `/users/1`
- **Method**: `PUT`
- **Body (JSON 예시)**: `{ "name": "홍길동수정", "email": "hong_rev@example.com" }`

```javascript
// controllers/UserController.js

export const updateUser = PUT("/users/:id")((req, res, next) => {
    const userId = req.params.id;
    const { name, email } = req.body;

    if (!name || !email) {
        return res.status(400).json({ message: "이름과 이메일은 필수입니다." });
    }

    const userData = { name, email };

    const idx = users.findIndex(u => u.id === parseInt(userId));
    if (idx === -1) {
        return res.status(404).json({ message: "사용자를 찾을 수 없습니다." });
    }

    users.splice(idx, 1, { id: parseInt(userId), ...userData });

    res.json({ id: parseInt(userId), ...userData });
});
```

#### API 테스트

Postman, Insomnia, curl 등 API 테스트 도구를 사용하여 다음과 같이 요청을 보낼 수 있습니다.

**사용자 정보 수정: `http://localhost:3000/users/1`**

![img](/images/2025/0907/put.png)

수정된 데이터를 확인하기 위해서 GET `/users` 요청을 다시 보내서 결과를 확인할 수 있습니다.

![img](/images/2025/0907/put-get.png)


### 6단계: 사용자 삭제 (Delete)

#### (DELETE /users/:id)

Path 파라미터로 삭제할 사용자를 지정하여 배열에서 제거합니다.

- **URL**: `/users/1`
- **Method**: `DELETE`

```javascript
// controllers/UserController.js

export const deleteUser = DELETE("/users/:id")((req, res, next) => {
    const userId = req.params.id;

    const idx = users.findIndex(u => u.id === parseInt(userId));
    if (idx === -1) {
        return res.status(404).json({ message: "사용자를 찾을 수 없습니다." });
    }

    users.splice(idx, 1);

    res.json({ message: "사용자가 삭제되었습니다." });
});
```

#### API 테스트

Postman, Insomnia, curl 등 API 테스트 도구를 사용하여 다음과 같이 요청을 보낼 수 있습니다.

**사용자 삭제: `http://localhost:3000/users/1`**

![img](/images/2025/0907/delete.png)

수정된 데이터를 확인하기 위해서 GET `/users` 요청을 다시 보내서 결과를 확인할 수 있습니다.

![img](/images/2025/0907/delete-get.png)
