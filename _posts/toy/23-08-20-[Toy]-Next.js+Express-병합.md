---
layout: post
title:  "[Toy Project] Next.js와 Express 병합"
date:   2023-08-20
banner_image: index-toyproject.jpg
tags: [Toy Project]
---

Backend와 Frontend가 각각 독립적인 시스템으로 구축되어 서로 연동하는 것이 이상적인 형태이겠지만 웹호스팅을 사용하는 경우 두개의 호스팅 계정을 만들지 않은 이상은 하나의 웹 서버안에서 Frontend와 Backend를 모두 처리해야 한다. 그렇기 때문에 우선적으로 구성해야 하는 환경은 Next.js에 백엔드 시스템을 병합하는 것이다.

Next.js 자체적으로 API Route 기능을 제공하기는 하지만 백엔드 시스템으로 사용하기에는 다소 부족한 부분이 있기 때문에 Express를 병합하기로 하였다.

<!--more-->

# #01. 패키지 설치

Express와 미들웨어 패키지들을 아래와 같이 설치하였다.

| 패키지 명 | 설명 |
|--|--|
| express | Node.js 기반으로 백엔드를 구현할 수 있게 하는 패키지(필수) |
| method-override | express에 PUT, DELETE 메서드를 처리할 수 있게 하는 미들웨어 |
| cors | CORS 관련 설정을 처리하는 미들웨어 |
| dotenv | 환경설정파일인 `*.env` 파일을 로드하는 미들웨어 |
| express-fileupload | 파일 업로드 처리 미들웨어 |
| express-session | 세션 사용 미들웨어 |
| express-useragent | 브라우저의 UserAgent 기능 사용 미들웨어 |
| cookie-parser | 쿠키를 처리하는 미들웨어 |
| serve-favicon | favicon 설정 미들웨어 | 
| serve-static | public 폴더 지정 미들웨어 |
| winston | 로그 처리 패키지 |
| winston-daily-rotate-file | 로그 파일을 날짜별로 생성할 수 있게 하는 미들웨어 |
| express-winston | Express로의 HTTP 요청을 로그로 기록할 수 있게 하는 미들웨어 |
| node-schedule | 스케쥴러 사용 패키지 |
| node-thumbnail | 썸네일 이미지 생성 패키지 |
| nodemailer | 메일 발송을 위해 SMTP와 연동할 수 있는 기능을 제공하는 패키지 |
| mysql2 | MySQL Client 패키지 |
| mybatis-mapper | MyBatis의 Node.js 버전 |
| express-mysql-session | DB세션을 사용할 수 있게 하는 미들웨어 | 
| bcrypt | 암호화 처리 패키지 |
| passport | 로그인 및 인증 기능을 제공하는 패키지 |
| passport-local | 로컬 인증 기능을 제공하는 패키지 |
| passport-jwt | jwt 방식 토큰 발생을 가능하게 하는 패키지 |
| fs-file-tree | 특정 폴더의 하위 항목들을 조회하는 패키지 |

일일이 설치하는 과정은 번거롭기 때문에 아래 명령으로 일괄 설치하도록 처리했다.

```shell
$ yarn add express method-override cors dotenv express-fileupload express-session express-useragent cookie-parser serve-favicon serve-static winston winston-daily-rotate-file express-winston node-schedule node-thumbnail nodemailer mysql2 mybatis-mapper express-mysql-session bcrypt passport passport-local passport-jwt fs-file-tree
```

# #02. TLS/SSL 인증서 만들기

막상 개발을 하다 보면 로컬에서도 HTTPS여야만 하는 경우가 자주 있다.

- 로그인, 인증 등을 위해 보안 쿠키(Secure cookie)를 사용해야 하는 경우
- Mixed content 이슈를 디버깅해야 할 때
- HTTP/2 이상의 프로토콜을 사용하고자 할 때
- HTTPS가 요구되는 라이브러리, API 등을 사용할 때
- 호스트네임을 커스터마이즈했을 때

HTTPS를 적용하려면 TLS/SSL 인증서가 필요하다.

인증서는 공인된 실제 인증 기관(Certificate Authority, CA)으로부터 서명된 것이어야 한다.

Express를 로컬 환경에서 HTTPS 상태로 구동하기 위해서 SSL 인증서를 생성한다.

OpenSSL을 사용할 경우 접속시 마다 보안 관련 경고를 봐야하기 때문에 무료로 인증서를 제공해주는 기관으로 유명한 `Let's Encrypt`을 통해 인증서를 생성할 것이다.

## 1. 인증서가 저장될 디렉토리 생성

우선 SSL 인증서가 저장될 디렉토리를 `.ssl`로 생성하고 해당 디렉토리로 이동한다.

```shell
$ mkdir .ssl
$ cd .ssl
```

## 2. mkcert 설치

### Windows

윈도우의 경우 아래 URL에서 운영체제에 맞는 실행파일을 내려받는다.

https://github.com/FiloSottile/mkcert/releases

내려받은 파일의 이름을 `mkcert.exe`로 변경한다.


### Mac

```shell
$ brew install mkcert
```

## 3. 키 생성하기

### Root CA 인증서 생성

window의 경우 내려받은 `mkcert.exe` 파일이 위치한 폴더에서 명령어를 수행해야 한다.

```shell
$ mkcert -install
```

윈도우의 경우 아래와 같은 창이 표시되는데, `확인`을 선택하면 된다.

![cert-dialog.png](/images/posts/2023/0820/cert-dialog.png)

### HOST에 대한 인증서 생성

호스트네임은 공백으로 구분하여 인수로 전달할 수 있다. 이 과정에서 mkcert도 해당 인증서에 서명하게 된다.

```shell
$ mkcert "*.hossam.kr" localhost 127.0.0.1 ::1
```

별다른 추가 옵션을 명시하지 않았다면, 현재 명령어를 실행하고 있는 경로에 두 개의 .pem 파일(cert, key)이 생성된다.

![cert-dialog.png](/images/posts/2023/0820/cert-dir.png)

여기서는 해당 파일의 이름들을 아래와 같이 수정하였다.

| 구분 | 원본 파일명 | 변경된 파일명 |
|--|--|--|
| cert | _wildcard.hossam.kr+3.pem | localhost.pem |
| key | _wildcard.hossam.kr+3-key.pem | localhost.key.pem |


# #03. 환경설정 파일 생성

프로젝트 루트 디렉토리에 `.env.development` 파일과 `.env.production` 파일을 생성한다.

`.env.development` 파일은 개발용 환경 변수를 저장하고 있는 파일이고 `.env.production`은 빌드시에 참조되는 환경설정 파일이다.

필요한 설정값들은 관련 작업시마다 추가하기로 하고 일단은 최소한의 값들만 지정해 놓았다.

## 1. .env.developement

```env
################################################
# .env.development
# 개발용 환경설정파일
################################################

# Next.js 환경변수 설정
NEXT_PUBLIC_FRONTEND_URL = "https://localhost:3000"
NEXT_PUBLIC_BACKEND_BASE_URL = "https://localhost:3000/api"
NEXT_PUBLIC_ADMIN_BASE_URL = "https://localhost:3000/admin"

# 작동 포트 번호
PORT = 3000

# BACKEND의 API 기본 경로
BACKEND_BASE_PATH = /api

# SSL 인증서 경로
SSL_CERT_PATH = ./.ssl/localhost.pem
SSL_KEY_PATH = ./.ssl/localhost.key.pem

# serveStatic 설정
PUBLIC_PATH = ./public
FAVICON_PATH = ./favicon.ico

# 쿠키 및 세션 암호화 키
ENCRYPT_KEY = "myweb"

# 업로드 환경 설정
UPLOAD_DIR = ./_files/attach
UPLOAD_TEMP_DIR = ./_files/temp
UPLOAD_URL = /attach
UPLOAD_MAX_COUNT = -1
UPLOAD_MAX_SIZE = 1024*1024*20
UPLOAD_FILE_FILTER = png|jpg|jpeg|gif
UPLOAD_DEBUG = false

# 썸네일 이미지 환경 설정
THUMB_DIR = ./_files/thumbnail
THUMB_URL = /thumbnail
THUMB_SIZE = 480|750|1080
```

## 2. .env.production

```env
################################################
# .env.production
# 배포용 환경설정파일
################################################

# Next.js 환경변수 설정
NEXT_PUBLIC_FRONTEND_URL = "https://localhost:3000"
NEXT_PUBLIC_BACKEND_BASE_URL = "https://localhost:3000/api"
NEXT_PUBLIC_ADMIN_BASE_URL = "https://localhost:3000/admin"

# 작동 포트 번호
PORT = 3000

# BACKEND의 API 기본 경로
BACKEND_BASE_PATH = /api

# SSL 인증서 경로
SSL_CERT_PATH = ./.ssl/localhost.pem
SSL_KEY_PATH = ./.ssl/localhost.key.pem

# serveStatic 설정
PUBLIC_PATH = ./public
FAVICON_PATH = ./favicon.ico

# 쿠키 및 세션 암호화 키(추후 암호화 된 복잡한 문자열로 교체 필요)
ENCRYPT_KEY = "myweb"

# 업로드 환경 설정
UPLOAD_DIR = ./_files/attach
UPLOAD_TEMP_DIR = ./_files/temp
UPLOAD_URL = /attach
UPLOAD_MAX_COUNT = -1
UPLOAD_MAX_SIZE = 1024*1024*20
UPLOAD_FILE_FILTER = png|jpg|jpeg|gif
UPLOAD_DEBUG = false

# 썸네일 이미지 환경 설정
THUMB_DIR = ./_files/thumbnail
THUMB_URL = /thumbnail
THUMB_SIZE = 480|750|1080
```

# #04. Backend를 위한 컨트롤러 생성

Express의 컨트롤러는 최대한 Spring에서의 경험을 재현하려고 노력했다.

어노테이션이 가능하면 더 좋겠지만 아직 어노테이션을 정식으로 지원하지는 않는 것 같았다.

babel을 사용하면 가능하지만 웹 호스팅 환경에 적용이 가능할지 확신이 없었기 때문에 순수 Javascript Class 문법만으로 해결하도록 정의했다.

## 1. /backend/helpers/BaseController.js

모든 컨트롤러 클래스가 상속받아야 하는 기본 컨트롤러이다.

내부적으로 Express의 Router를 생성하고 `addRoute()` 메서드를 통해 전달되는 콜백함수를 Router에 등록한다.

```js
const express = require("express");

class BaseController {
    #app;
    #router;
    static #current = null;

    constructor(app) {
        this.#app = app;
        this.#router = express.Router();
    }

    get router() {
        return this.#router;
    }

    get app() {
        return this.#app;
    }

    addRoute(method, url, cb) {
        this.#router[method.toLowerCase()](url, cb);
    }
}

module.exports = BaseController;
```

## 2. /backend/controllers/Sample.js

기본 컨트롤러에 대한 샘플 클래스이다.

생성자에서 부모 클래스(BaseController)가 갖고 있는 `addRouter()` 메서드에 HTTP Method과 라우팅 처리할 URL, 그리고 콜백함수를 전달하여 Express Router 설정을 수행하도록 한다.

```js
const BaseController = require("../helpers/BaseController");

class Sample extends BaseController {
    constructor(app) {
        super(app);
        this.addRoute("get", "/sample/hello_world", this.helloWorld);
    }

    helloWorld(req, res) {
        res.send({msg: "Hello World!"});
    }
}

module.exports = app => new Sample(app).router;
```

## 3. /backend/app.js

Express의 본체가 되는 파일이다. 필요한 패키지를 참조하고 미들웨어를 구성한다.

주석으로 섹션을 구분해 놓았다.

`4) 라우터 설정` 부분에서 `controllers` 폴더 하위 항목들을 스캔하여 미들웨어로 추가한다.

이 때 설정파일에서 명시하고 있는 기본 URL의 하위 경로로 포함되도록 처리한다.

`5) 설정한 내용을 기반으로 서버 구동 시작` 섹션에서는 앞서 준비해 둔 SSL 인증서를 사용하여 HTTPS 형태로 구동한다.

```js
/**
 * Backend Server Core
 *
 * Express 기반 백엔드 서버 본체.
 * 이 파일을 루트 디렉토리의 app.js에서 참조하여 백엔드를 가동한다.
 *
 * author : Lee Kwang-Ho (leekh4232@gmail.com)
 */

/*----------------------------------------------------------
 * 1) 패키지 참조
 *----------------------------------------------------------*/
const https = require("https");
const fs = require("fs");
const {resolve, join} = require("path");
const express = require("express");
const userAgent = require("express-useragent");
const serveStatic = require("serve-static");
const serveFavicon = require("serve-favicon");
const methodOverride = require("method-override");
const cookieParser = require("cookie-parser");
const expressSession = require("express-session");
const fileUpload = require("express-fileupload");
const cors = require("cors");
const fsFileTree = require("fs-file-tree");

/*-----------------------------------------------------------
 * 2) Express 객체 생성 및 Helper 로드
 *----------------------------------------------------------*/
const app = express();

/*----------------------------------------------------------
 * 3) 미들웨어 연결
 *----------------------------------------------------------*/
// POST 요청 처리 (Express 4.16.0 이상 버전부터 body-parser 패키지가 내장되어 있음)
app.use(express.json())
app.use(express.urlencoded({extended: true}))

app.use(userAgent.express());

app.use(methodOverride("X-HTTP-Method"));
app.use(methodOverride("X-HTTP-Method-Override"));
app.use(methodOverride("X-Method-Override"));

app.use(cookieParser(process.env.ENCRYPT_KEY));

app.use(serveFavicon(process.env.FAVICON_PATH));
app.use("/", serveStatic(process.env.PUBLIC_PATH));

app.use(
    fileUpload({
        limits: { fileSize: process.env.UPLOAD_FILE_SIZE_LIMIT },
        useTempFiles: true,
        tempFileDir: process.env.UPLOAD_TEMP_DIR,
        createParentPath: true,
        debug: false,
    })
);

app.use(
    expressSession({
        secret: process.env.ENCRYPT_KEY,
        resave: false,
        saveUninitialized: false
    })
);

app.use(
    cors({
        origin: process.env.NEXT_PUBLIC_FRONTEND_URL,
        credentials: true,
    })
);

/*----------------------------------------------------------
 * 4) 라우터 설정
 *----------------------------------------------------------*/
const router = express.Router();
app.use(router);

// `controllers` 디렉토리 내의 모든 컨트롤러를 불러와서 라우터에 연결
const currentPath = resolve(__dirname);
const pathLen = currentPath.length;
const controllerPath = join(currentPath, "controllers");
const controllers = fsFileTree.sync(controllerPath);

function initController(con) {
    for (let key in con) {
        if (key.indexOf(".js") > -1) {
            const item = con[key];
            const js = item.path.replace(pathLen, ".");
            console.log(js);
            app.use(process.env.BACKEND_BASE_PATH, require(js)(app));
        } else {
            initController(con[key]);
        }
    }
}

initController(controllers);

/*----------------------------------------------------------
 * 5) 설정한 내용을 기반으로 서버 구동 시작
 *----------------------------------------------------------*/
const keyFile = fs.readFileSync(process.env.SSL_KEY_PATH);
const certFile = fs.readFileSync(process.env.SSL_CERT_PATH);
const options = {
    key: keyFile,
    cert: certFile
};

const httpsServer = https.createServer(options, app);
httpsServer.listen(process.env.PORT, function () {
    console.log("HTTPS server listening on port " + process.env.PORT);
});

process.on("exit", function () {
    console.log("Server is shutdown");
});

process.on("SIGINT", () => {
    process.exit();
});

module.exports = app;
```

# #05. Next.js와 Express를 하나의 포트에서 가동

프로젝트 루트에 `index.js`를 추가하고 아래의 내용을 구성한다.

## 1. Entry Point 구성

```js
/**
 * Fullstack Framework Core - Next.js + Express
 * author : Lee Kwang-Ho
 */
const dev = process.env.NODE_ENV !== "production";
const configFile = dev ? ".env.development" : ".env.production";
const configFilePath = `${__dirname}/${configFile}`;
require("dotenv").config({ path: configFilePath.replace(/\\/g, "/").replace(new RegExp("//"), "/") });

const backend = require("./backend/app");
const next = require("next");

const app = next({ dev });
const handler = app.getRequestHandler();

(async () => {
    try {
        await app.prepare();
        backend.set("trust proxy", true);
        backend.get("*", (req, res) => {
            return handler(req, res);
        });
    } catch (ex) {
        console.error("");
        console.error("--------------------------------------------------");
        console.error(`${ex.name} Error (${ex.number})`);
        console.error(`${ex.message}`);
        console.error(`>>> ${ex.fileName}(Line: ${ex.lineNumber}, Column: ${ex.columnNumber})`);
        console.error("--------------------------------------------------\n");
    }
})();
```

## 2. 실행 스크립트 추가

`package.json` 파일의 `scripts` 섹션 하위에 `fs`와 `fs.watch` 항목을 추가한다.

```json
{
    "name": "myweb",
    "version": "0.1.0",
    "private": true,
    "scripts": {
        "dev": "next dev",
        "fs": "node index.js",          // <-- 추가
        "fs.watch": "nodemon index.js", // <-- 추가
        "build": "next build",
        "start": "next start",
        "lint": "next lint"
    },
}
```

### 단독 실행

```shell
$ yarn start fs
```

### Nodemon을 통한 실행

```shell
$ yarn start fs.watch
```

# #06. 돌발상황

프로젝트를 구성하면서 `node_modules` 폴더의 용량 관리때문에 `yarn berry`를 적용해 놓았었다.

React나 Next 단독 프로젝트를 진행하는 동안은 문제가 없었지만 Express 등의 순수 Node.js 애플리케이션을 구현할 때는 `yarn berry`가 Package를 찾지 못하는 문제가 발생하였다.

하루 정도 시간을 들여서 원인을 찾고자 했지만 결국 찾지 못하고 다시 `node_modules`를 등장시켰다.

하지만 `yarn berry`를 포기한 것은 아니기 때문에 추후에 좀 더 살펴보도록 해야겠다.

`.yarnrc.yml` 파일에 아래 구문을 추가한다.

```yml
nodeLinker: node-modules
```

다시 패키지를 설치한다.

```shell
$ yarn install
```

이제 프로젝트를 가동하여 결과를 확인한다.

| 구분 | URL |
|---|---|
| 프론트엔드 | https://localhost:3000 |
| 백엔드 | https://localhost:3000/api/sample/hello_world |

![bw](/images/posts/2023/0820/cert-bw.png)

![bk](/images/posts/2023/0820/cert-bk.png)