---
title: Node.js - Express Middleware
description: "Node.js 환경에서 Express.js 프레임워크의 미들웨어 개념을 이해하고, 다양한 미들웨어를 활용하여 웹 애플리케이션을 구축하는 방법을 학습합니다."
categories: [06.Backend,Node]
date:   2025-09-07 09:00:00 +0900
author: Hossam
image: /images/indexs/node1.png
tags: [Web Development,Backend,Node,Express]
pin: true
math: true
mermaid: true
---

# Node.js - Express Middleware

Express의 가장 강력한 기능 중 하나는 **미들웨어(Middleware)** 입니다. 미들웨어는 요청(request)과 응답(response) 객체 사이에서 작동하는 함수들로, Express 애플리케이션의 핵심을 이룹니다.

이 단원에서는 자주 사용되는 몇 가지 필수 미들웨어를 Express 애플리케이션에 적용하는 방법을 학습합니다.

## 1. serve-favicon

웹 브라우저의 탭이나 북마크에 표시되는 작은 아이콘을 파비콘(Favicon)이라고 합니다. `serve-favicon`은 이 파비콘에 대한 요청을 처리하는 미들웨어입니다.

### 설치

먼저, 패키지를 설치해야 합니다.

```bash
yarn add serve-favicon
```

### 적용하기

`serve-favicon` 미들웨어는 파비콘 파일의 경로를 인자로 받습니다. 일반적으로 애플리케이션의 최상위 레벨에서 한 번만 호출하면 됩니다.

**실습: `/app.js**

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

// 미들웨어로 사용할 모듈 불러오기
import serveFavicon from 'serve-favicon';

/*-----------------------------------------------------------
 * 3) Express 객체 생성 및 설정
 *----------------------------------------------------------*/
// express() 함수는 애플리케이션 함수이며, 이 함수를 호출하여 app이라는 객체를 생성한다.
// app 객체는 서버의 전반적인 설정을 관리한다.
const app = express();

// ... 생략 ...

/** 미들웨어 설정 */
// 1) Favicon 설정
app.use(serveFavicon(process.env.FAVICON_PATH || 'favicon.png'));

// ... 생략 ...
```

### 소스코드 설명

`app.use()`를 사용하여 `serve-favicon` 미들웨어를 애플리케이션에 추가합니다. 파비콘 이미지의 경로는 `.env` 파일에 `FAVICON_PATH`라는 이름으로 정의되어 있으며, `process.env.FAVICON_PATH`를 통해 접근합니다. 이렇게 하면 경로가 변경되더라도 소스 코드를 수정할 필요가 없습니다.

## 2. serve-static

`serve-static`은 HTML, CSS, JavaScript, 이미지와 같은 정적 파일(static files)을 제공하는 미들웨어입니다. Express에 내장되어 있어 별도의 설치가 필요 없으며, `express.static()` 메서드로 사용할 수 있습니다.

### 설치

먼저, 패키지를 설치해야 합니다.

```bash
yarn add serve-static
```

### 적용하기

`express.static()` 미들웨어는 정적 파일이 위치한 디렉토리의 경로를 인자로 받습니다.

**실습: `/app.js`**

```javascript
/*----------------------------------------------------------
 * 2) 필요한 모듈 로드
 *----------------------------------------------------------*/
import logger from './helpers/LogHelper.js';
import utilHelper from './helpers/UtilHelper.js';
import express from 'express';  // Express 모듈 가져오기

// 미들웨어로 사용할 모듈 불러오기
// ... 이전 생략 ...
import serveStatic from 'serve-static';


/*-----------------------------------------------------------
 * 3) Express 객체 생성 및 설정
 *----------------------------------------------------------*/
// express() 함수는 애플리케이션 함수이며, 이 함수를 호출하여 app이라는 객체를 생성한다.
// app 객체는 서버의 전반적인 설정을 관리한다.
const app = express();

/** 미들웨어 설정 */

// ... 이전 생략 ...

// 2) 정적 파일(Static File) 설정
// 정적 파일이란 HTML, CSS, JS, 이미지, 동영상 등과 같이 서버에서 클라이언트로 별도의 처리 없이
// 그대로 전달되는 파일을 말한다. 이러한 파일들은 미들웨어를 이용하여 제공할 수 있다.
app.use("/", serveStatic(process.env.PUBLIC_PATH || "public"));

// ... 이하 생략 ...
```

### 소스코드 설명

`app.use("/", serveStatic(process.env.PUBLIC_PATH))` 코드는 `/` 경로, 즉 웹 사이트의 루트 URL에 접속했을 때 `PUBLIC_PATH`로 지정된 폴더(예: `public`)의 내용을 제공하도록 설정합니다.

예를 들어, `public` 폴더 안에 `mynode.html` 파일이 있다면, 사용자는 `http://localhost:3000/mynode.html` 주소로 이 파일에 직접 접근할 수 있습니다.

## 3. method-override

HTML의 `<form>` 태그는 기본적으로 GET과 POST 메서드만 지원합니다. RESTful API를 구현하기 위해 PUT, DELETE와 같은 다른 HTTP 메서드를 사용해야 할 때 `method-override` 미들웨어가 유용합니다. 이 미들웨어는 특정 파라미터를 사용하여 POST 요청을 다른 HTTP 메서드로 변환해 줍니다.

### 설치

```bash
yarn add method-override
```

### 적용하기

`method-override`는 주로 폼 필드의 `_method` 파라미터를 확인하여 요청 메서드를 변경합니다.

**실습: `/app.js`**

```javascript
/*----------------------------------------------------------
 * 2) 필요한 모듈 로드
 *----------------------------------------------------------*/
import logger from "./helpers/LogHelper.js";
import utilHelper from "./helpers/UtilHelper.js";
import express from "express"; // Express 모듈 가져오기

// 미들웨어로 사용할 모듈 불러오기

// ... 생략 ...

import methodOverride from "method-override";

/*-----------------------------------------------------------
 * 3) Express 객체 생성 및 설정
 *----------------------------------------------------------*/
// express() 함수는 애플리케이션 함수이며, 이 함수를 호출하여 app이라는 객체를 생성한다.
// app 객체는 서버의 전반적인 설정을 관리한다.
const app = express();

// ... 생략 ...

/** 미들웨어 설정 */
// ... 생략 ...
// 3) HTTP Method Override 설정
// PUT, DELETE 등의 메서드를 지원하지 않는 클라이언트(예: HTML Form)에서
// 이러한 메서드를 사용하고자 할 때, 실제 요청 메서드를 변경시켜주는 미들웨어
app.use(methodOverride("X-HTTP-Method")); // Microsoft
app.use(methodOverride("X-HTTP-Method-Override")); // Google/GData
app.use(methodOverride("X-Method-Override")); // IBM
app.use(methodOverride("_method")); // HTML Form
```

**HTML 폼 예시**

```html
<!-- DELETE 요청 보내기 -->
<form action="/resource?_method=DELETE" method="POST">
  <button type="submit">Delete Resource</button>
</form>

<!-- PUT 요청 보내기 -->
<form action="/resource?_method=PUT" method="POST">
  <input type="text" name="data" />
  <button type="submit">Update Resource</button>
</form>
```

### 소스코드 설명

`app.use(methodOverride('_method'))` 설정은 들어오는 요청의 쿼리 문자열에서 `_method` 파라미터를 찾습니다. 만약 `?_method=DELETE`가 포함된 POST 요청이 들어오면, 이 미들웨어는 해당 요청의 메서드를 `DELETE`로 변경하여 다음 라우터가 처리하도록 전달합니다.

## 4. express-useragent

`express-useragent`는 클라이언트의 User-Agent 문자열을 파싱하여 브라우저, 운영체제, 디바이스 정보 등을 쉽게 확인할 수 있는 객체로 만들어주는 미들웨어입니다.

### 설치

```bash
yarn add express-useragent
```

### 적용하기

`express-useragent`를 미들웨어로 등록하면, `req` 객체에 `useragent` 속성이 추가됩니다.

**실습: `/app.js`**

```javascript
/*----------------------------------------------------------
 * 2) 필요한 모듈 로드
 *----------------------------------------------------------*/

// 미들웨어로 사용할 모듈 불러오기

// ... 생략 ...
import userAgent from 'express-useragent';

/*-----------------------------------------------------------
 * 3) Express 객체 생성 및 설정
 *----------------------------------------------------------*/
// express() 함수는 애플리케이션 함수이며, 이 함수를 호출하여 app이라는 객체를 생성한다.
// app 객체는 서버의 전반적인 설정을 관리한다.
const app = express();

//... 생략 ...

// 4) User-Agent 설정
// 클라이언트의 환경 정보를 조회할 수 있는 미들웨어
// req.useragent라는 객체가 추가되어 클라이언트의 환경 정보를 조회할 수 있다.
app.use(userAgent.express());

//... 생략 ...

/*----------------------------------------------------------
 * 4) 라우터 객체를 이용한 URL별 분기 처리
 *----------------------------------------------------------*/
//... 생략 ...

router.get("/hello", (req, res, next) => {
    // useragent 미들웨어로 인해 req.useragent 객체가 추가된다.
    logger.debug('UserAgent: ', req.useragent); // <-- userAgent값 확인 테스트 코드

    /**
     * res.send()는 클라이언트에게 응답을 보낸다.
     * 인자로 전달된 내용이 클라이언트의 브라우저에 출력된다.
     */
    res.send("<h1>Hello World</h1>");
});

//... 생략 ...
```

### 소스코드 설명

`app.use(useragent.express())`를 통해 모든 요청에 User-Agent 파싱 기능이 적용됩니다. 이후 `/useragent` 경로로 GET 요청이 들어오면, `req.useragent` 객체에 담긴 정보(예: `isMobile`, `isDesktop`, `browser`, `os`, `platform` 등)가 JSON 형태로 응답됩니다. 이를 통해 디바이스별로 다른 페이지를 보여주거나, 특정 브라우저에 대한 분기 처리를 할 수 있습니다.

## 5. express-winston

`express-winston`은 HTTP 요청 및 응답을 `winston` 로거를 사용하여 기록하는 미들웨어입니다. API 서버의 활동을 모니터링하고 디버깅하는 데 매우 유용합니다.

### 설치

```bash
yarn add express-winston
```

### 적용하기

`express-winston`은 로깅을 위한 `logger`와 에러 처리를 위한 `errorLogger` 두 가지 형태로 사용할 수 있습니다. 여기서는 `logger`를 적용하여 모든 HTTP 요청을 로그로 남겨보겠습니다.

**실습: `/app.js`**

{% raw %}
```javascript
/*----------------------------------------------------------
 * 2) 필요한 모듈 로드
 *----------------------------------------------------------*/
import logger from "./helpers/LogHelper.js";

// ... 생략 ...

// 미들웨어로 사용할 모듈 불러오기

// ... 생략 ...

import expressWinston from 'express-winston';

/*-----------------------------------------------------------
 * 3) Express 객체 생성 및 설정
 *----------------------------------------------------------*/
// express() 함수는 애플리케이션 함수이며, 이 함수를 호출하여 app이라는 객체를 생성한다.
// app 객체는 서버의 전반적인 설정을 관리한다.
const app = express();

// ... 생략 ...

// 5) Express-Winston 설정
// 요청(request)과 응답(response)에 대한 로그를 자동으로 기록하는 미들웨어
app.use(
    expressWinston.logger({
        winstonInstance: logger,    // 로그를 기록할 winston 인스턴스 연결
        meta: false,                // 메타정보 기록 여부 (기본값: true)
        colorize: true,             // 로그 색상화 여부 (기본값: false)
        msg: "[HTTP {{req.method}}/{{res.statusCode}}] {{req.protocol}}://{{req.get('host')}}{{decodeURIComponent(req.url)}} ({{res.responseTime}}ms) ({{(req.headers['x-forwarded-for'] || req.connection.remoteAddress || '').split(',')[0].trim()}},{{req.useragent.os}},{{req.useragent.browser}}-{{req.useragent.version}})"
    })
);

// ... 생략 ...
```
{% endraw %}

### 소스코드 설명

`expressWinston.logger`는 `winston` 로거 인스턴스를 받아 HTTP 요청 정보를 자동으로 로깅하는 미들웨어를 생성합니다. 이 미들웨어는 라우터보다 앞에 위치해야 모든 요청을 가로채서 기록할 수 있습니다. 위 설정은 각 요청에 대해 HTTP 메서드(GET, POST 등)와 URL을 포함한 로그를 `LogHelper.js`에서 설정한 형식과 위치(콘솔, 파일)에 맞게 출력합니다.

## 6. 전체 소스코드

### `/.env`

```env
# ... 이전 내용 생략

# 기본 설정 -> 개발모드(테스트모드) = development | 상용모드=production
NODE_ENV=development

# 서버 가동 포트 번호
PORT=8080

# Favicon 경로 (프로젝트 루트 기준 상대경로)
FAVICON_PATH=favicon.png

# 정적 파일 경로 (프로젝트 루트 기준 상대경로)
PUBLIC_PATH=public
```

### `/app.js`

**07-express/app.js** 파일을 **08-middleware/app.js**로 복사한 후, 위에서 설명한 미들웨어들을 추가하여 완성합니다.

{% raw %}
```javascript
/*----------------------------------------------------------
 * 1) 환경설정 파일 로드
 *----------------------------------------------------------*/
import dotenv from "dotenv";
dotenv.config(); // .env 파일의 내용을 process.env에 로드

/*----------------------------------------------------------
 * 2) 필요한 모듈 로드
 *----------------------------------------------------------*/
import logger from "./helpers/LogHelper.js";
import utilHelper from "./helpers/UtilHelper.js";
import express from "express"; // Express 모듈 가져오기

// 미들웨어로 사용할 모듈 불러오기
import serveFavicon from "serve-favicon";
import serveStatic from "serve-static";
import methodOverride from "method-override";
import userAgent from "express-useragent";
import expressWinston from "express-winston";

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
app.use(express.urlencoded({ extended: true }));

/** 미들웨어 설정 */
// 1) Favicon 설정
app.use(serveFavicon(process.env.FAVICON_PATH || 'favicon.png'));

// 2) 정적 파일(Static File) 설정
// 정적 파일이란 HTML, CSS, JS, 이미지, 동영상 등과 같이 서버에서 클라이언트로 별도의 처리 없이
// 그대로 전달되는 파일을 말한다. 이러한 파일들은 미들웨어를 이용하여 제공할 수 있다.
app.use("/", serveStatic(process.env.PUBLIC_PATH || "public"));

// 3) HTTP Method Override 설정
// PUT, DELETE 등의 메서드를 지원하지 않는 클라이언트(예: HTML Form)에서
// 이러한 메서드를 사용하고자 할 때, 실제 요청 메서드를 변경시켜주는 미들웨어
app.use(methodOverride("X-HTTP-Method")); // Microsoft
app.use(methodOverride("X-HTTP-Method-Override")); // Google/GData
app.use(methodOverride("X-Method-Override")); // IBM
app.use(methodOverride("_method")); // HTML Form

// 4) User-Agent 설정
// 클라이언트의 환경 정보를 조회할 수 있는 미들웨어
// req.useragent라는 객체가 추가되어 클라이언트의 환경 정보를 조회할 수 있다.
app.use(userAgent.express());

// 5) Express-Winston 설정
// 요청(request)과 응답(response)에 대한 로그를 자동으로 기록하는 미들웨어
app.use(
    expressWinston.logger({
        winstonInstance: logger,    // 로그를 기록할 winston 인스턴스 연결
        meta: false,                // 메타정보 기록 여부 (기본값: true)
        colorize: true,             // 로그 색상화 여부 (기본값: false)
        msg: "[HTTP {{req.method}}/{{res.statusCode}}] {{req.protocol}}://{{req.get('host')}}{{decodeURIComponent(req.url)}} ({{res.responseTime}}ms) ({{(req.headers['x-forwarded-for'] || req.connection.remoteAddress || '').split(',')[0].trim()}},{{req.useragent.os}},{{req.useragent.browser}}-{{req.useragent.version}})"
    })
);

/*----------------------------------------------------------
 * 4) 라우터 객체를 이용한 URL별 분기 처리
 *----------------------------------------------------------*/
const router = express.Router(); // 라우터 객체 생성
app.use(router); // 모든 요청은 router 객체를 거치도록 설정

/** 요청(request)에 대한 응답(response) 설정 */
// app.get(path, callback)은 특정 경로(path)로의 GET 요청에 대해 어떻게 응답할지를 정의하는 라우팅 메서드이다.
// 요청 종류에 따라 post, put, delete 메서드를 사용할 수 있다.
//
// - path: 클라이언트가 요청하는 URL 경로
// - callback: 요청이 들어왔을 때 실행될 함수. req(요청 객체), res(응답 객체), next(다음 미들웨어 함수)를 인자로 받는다.
//
// next 매개변수는 현재 미들웨어 함수가 작업을 완료한 후 다음 미들웨어 함수로 제어를 전달하는 데 사용된다.
// 이 예제에서는 사용하지 않으므로 생략 가능.
router.get("/hello", (req, res, next) => {
    // useragent 미들웨어로 인해 req.useragent 객체가 추가된다.
    logger.debug('UserAgent: ', req.useragent);

    /**
     * res.send()는 클라이언트에게 응답을 보낸다.
     * 인자로 전달된 내용이 클라이언트의 브라우저에 출력된다.
     */
    res.send("<h1>Hello World</h1>");
});

router.get("/world", (req, res, next) => {
    const data = {
        name: "Express",
        type: "Framework",
    };
    res.json(data); // JSON 형식으로 응답
});

/*----------------------------------------------------------
 * 5) 설정한 내용을 기반으로 서버 구동 시작
 *----------------------------------------------------------*/
const port = process.env.HTTP_PORT || 8080;
const myip = utilHelper.myip();

app.listen(port, () => {
    logger.info("+----------------------------------------------+");
    logger.info("|            Express Backend Server            |");
    logger.info("+----------------------------------------------+");

    myip.forEach((v, i) => {
        logger.info(`Backend Address (${i + 1}) : http://${v}:${port}`);
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
{% endraw %}