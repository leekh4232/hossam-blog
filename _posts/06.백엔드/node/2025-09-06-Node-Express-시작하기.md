---
title: Node.js - Express 시작하기
description: "Node.js 환경에서 Express.js 프레임워크를 사용하여 웹 애플리케이션을 구축하는 방법을 학습합니다."
categories: [06.Backend,Node]
date:   2025-09-06 09:00:00 +0900
author: Hossam
image: /images/indexs/node1.png
tags: [Web Development,Backend,Node,Express]
pin: true
math: true
mermaid: true
---

# Node.js - Express 시작하기

Node.js는 웹 서버를 구축하는 데 강력한 기반을 제공하지만, HTTP 요청을 처리하고, 라우팅을 관리하며, 응답을 구성하는 등의 작업을 처음부터 구현하는 것은 복잡하고 시간이 많이 소요될 수 있습니다. Express.js는 이러한 과정을 간소화하여 개발자가 비즈니스 로직에 더 집중할 수 있도록 돕는 Node.js의 대표적인 웹 프레임워크입니다.

## 1. 백엔드 구조의 이해 (Express)

### 웹 프레임워크란?

웹 프레임워크는 웹 애플리케이션 개발을 위한 기본적인 구조와 틀을 제공하는 소프트웨어입니다. 웹 프레임워크를 사용하면 개발자는 라우팅, 데이터베이스 연동, 세션 관리 등 웹 개발에 필요한 공통적인 기능들을 직접 구현할 필요 없이, 미리 만들어진 모듈과 구조를 활용하여 빠르고 효율적으로 애플리케이션을 구축할 수 있습니다.

Express는 특별히 무언가를 강제하지 않는 최소한의 기능만을 갖춘(Unopinionated) 프레임워크로, 유연성이 매우 높다는 특징이 있습니다. 개발자는 필요한 기능을 미들웨어(Middleware) 형태로 추가하여 자신만의 방식으로 서버를 구성할 수 있습니다.

### 요청-응답(Request-Response) 모델

웹 서버는 클라이언트(주로 웹 브라우저)의 요청(Request)을 받아, 그에 따른 처리를 한 후 응답(Response)을 보내는 구조로 동작합니다.

- **요청 (Request)**: 클라이언트가 서버로 보내는 정보입니다. HTTP 메서드(GET, POST 등), URL, 헤더, 본문(Body) 등으로 구성됩니다.
- **응답 (Response)**: 서버가 클라이언트로 보내는 결과입니다. 상태 코드(200 OK, 404 Not Found 등), 헤더, 데이터(HTML, JSON 등)로 구성됩니다.

Express는 이러한 요청과 응답 객체를 추상화하여 `req`와 `res`라는 객체로 제공하며, 개발자는 이 객체들을 통해 클라이언트와 상호작용합니다.

## 2. Express 기본 구성

Express를 사용하여 웹 서버를 구축하는 과정은 매우 간단합니다. 먼저 프로젝트를 설정하고, Express 모듈을 설치한 후, 기본적인 서버 코드를 작성합니다.

### 프로젝트 시작 및 Express 설치

Node.js 프로젝트를 시작하기 위해 Express를 설치해야 합니다.

```bash
$ yarn add express
```

### Hello, Express!

가장 기본적인 Express 서버는 몇 줄의 코드로 만들 수 있습니다. 다음은 8080 포트에서 "Hello World"를 응답하는 간단한 웹 서버 예제입니다.

**실습: `/.env`**

```env
# ... 이전 내용 생략 ...

# 기본 설정 -> 개발모드(테스트모드) = development | 상용모드=production
NODE_ENV=development

# 서버 가동 포트 번호
PORT=8080
```

**실습: `/app.js`**

> `app.js`는 백엔드 서버의 진입점(Entry Point)입니다. 그러므로 프로젝트의 최상위 경로에 위치시킵니다. 앞으로 매 포스팅에서 이 파일을 지속적으로 발전시켜 나가게 됩니다.

```javascript
/*----------------------------------------------------------
 * 1) 환경설정 파일 로드
 *----------------------------------------------------------*/
import dotenv from 'dotenv';
dotenv.config();  // .env 파일의 내용을 process.env에 로드


/*----------------------------------------------------------
 * 2) 필요한 모듈 로드
 *----------------------------------------------------------*/
import logger from './helpers/LogHelper.js';
import utilHelper from './helpers/UtilHelper.js';
import express from 'express';  // Express 모듈 가져오기


/*-----------------------------------------------------------
 * 3) Express 객체 생성 및 설정
 *----------------------------------------------------------*/
// express() 함수는 애플리케이션 함수이며, 이 함수를 호출하여 app이라는 객체를 생성한다.
// app 객체는 서버의 전반적인 설정을 관리한다.
const app = express();

// JSON, URL-encoded 데이터 처리 설정
// 클라이언트에서 서버로 요청할 때 JSON 또는 URL-encoded 형식의 데이터를 보낼 수 있다.
app.use(express.json());

// URL-encoded 데이터의 경우 확장된 문법을 사용할지 여부를 설정한다.
// true로 설정하면 qs 모듈을 사용하여 중첩된 객체 표현을 허용한다.
// false로 설정하면 querystring 모듈을 사용하여 단순한 객체 표현만 허용한다.
app.use(express.urlencoded({extended: true}));


/*----------------------------------------------------------
 * 4) 라우터 객체를 이용한 URL별 분기 처리
 *----------------------------------------------------------*/
const router = express.Router();  // 라우터 객체 생성
app.use(router);                  // 모든 요청은 router 객체를 거치도록 설정

/** 요청(request)에 대한 응답(response) 설정 */
// app.get(path, callback)은 특정 경로(path)로의 GET 요청에 대해 어떻게 응답할지를 정의하는 라우팅 메서드이다.
// 요청 종류에 따라 post, put, delete 메서드를 사용할 수 있다.
//
// - path: 클라이언트가 요청하는 URL 경로
// - callback: 요청이 들어왔을 때 실행될 함수. req(요청 객체), res(응답 객체), next(다음 미들웨어 함수)를 인자로 받는다.
//
// next 매개변수는 현재 미들웨어 함수가 작업을 완료한 후 다음 미들웨어 함수로 제어를 전달하는 데 사용된다.
// 이 예제에서는 사용하지 않으므로 생략 가능.
router.get('/hello', (req, res, next) => {
    /**
     * res.send()는 클라이언트에게 응답을 보낸다.
     * 인자로 전달된 내용이 클라이언트의 브라우저에 출력된다.
     */
    res.send('<h1>Hello World</h1>');
});

router.get('/world', (req, res, next) => {
    const data = {
        name: "Express",
        type: "Framework",
    };
    res.json(data);  // JSON 형식으로 응답
});


/*----------------------------------------------------------
 * 5) 설정한 내용을 기반으로 서버 구동 시작
 *----------------------------------------------------------*/
const port = process.env.PORT || 8080;
const myip = utilHelper.myip();

app.listen(port, () => {
    logger.info("+----------------------------------------------+");
    logger.info("|            Express Backend Server            |");
    logger.info("+----------------------------------------------+");

    myip.forEach((v, i) => {
        logger.info(`Backend Address (${i+1}) : http://${v}:${port}`);
    });
});


/*----------------------------------------------------------
 * 6) 종료 이벤트 처리
 *----------------------------------------------------------*/
// SIGINT 신호 처리
// 사용자가 CTRL+C를 눌러 서버를 강제로 종료할 때 프로세스를 정상적으로 종료시킨다.
process.on("SIGINT", () => {
    process.exit();
});

// 프로세스 종료 이벤트 처리
// 서버가 종료될 때 로그를 남긴다.
process.on("exit", function () {
    logger.info("Server is shutdown");
});
```

위 코드를 실행하고 웹 브라우저에서 `http://localhost:8080/hello`로 접속하면 "Hello World"라는 메시지를 확인할 수 있습니다.

또한 `http://localhost:8080/world`로 접속하면 JSON 형식의 데이터를 확인할 수 있습니다.
