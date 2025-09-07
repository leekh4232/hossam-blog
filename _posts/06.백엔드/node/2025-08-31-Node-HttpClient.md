---
title: Node.js HTTP 클라이언트 구현하기
description: "Node.js 환경에서 내장 fetch API를 사용하여 다른 서버와 통신하는 HTTP 클라이언트를 구현하는 방법을 학습합니다."
categories: [06.Backend,Node]
date:   2025-08-31 09:00:00 +0900
author: Hossam
image: /images/indexs/node1.png
tags: [Web Development,Backend,Node,HTTP,fetch]
pin: true
math: true
mermaid: true
---

# Node.js HTTP 클라이언트 구현하기

백엔드 애플리케이션은 종종 다른 서버의 API를 호출하여 데이터를 가져오거나, 특정 기능을 수행해야 합니다. 예를 들어, 소셜 로그인을 위해 OAuth 인증 서버와 통신하거나, 날씨 정보를 얻기 위해 공공 API를 호출하는 경우가 있습니다. 이처럼 다른 서버와 HTTP 통신을 하는 프로그램을 'HTTP 클라이언트'라고 부릅니다.

과거 Node.js에서는 `axios`, `node-fetch`와 같은 외부 라이브러리를 사용해야 했지만, 최신 버전(v18부터)에서는 브라우저 환경과 동일한 `fetch` API가 내장되어 별도의 설치 없이 HTTP 클라이언트를 구현할 수 있습니다.

이번 시간에는 내장 `fetch` API를 사용하여 HTTP 클라이언트를 구현하는 방법을 단계별로 학습합니다.

## 1. fetch를 이용한 기본 GET 요청

가장 기본적인 `GET` 요청을 통해 외부 API로부터 데이터를 가져오는 예제입니다. `fetch`의 기본 사용법과 `async/await`를 이용한 비동기 처리 방법을 학습합니다.

### 주요 개념
- `fetch(url)`: 지정된 URL로 HTTP 요청을 보냅니다. Promise를 반환합니다.
- `await`: Promise가 처리될 때까지 기다립니다.
- `response`: `fetch` 요청의 응답 객체입니다. HTTP 상태, 헤더 등 다양한 정보를 담고 있습니다.
- `response.ok`: HTTP 상태 코드가 200-299 범위에 있는지 여부를 나타내는 boolean 값입니다.
- `response.json()`: 응답 본문(body)을 JSON으로 파싱하여 JavaScript 객체로 변환합니다. 이 과정 역시 Promise를 반환합니다.

### 실습: 기본적인 GET 요청

**`/05-HttpClient/01-simple_get.js`**
```javascript
// 1. 비동기 처리를 위한 즉시 실행 함수
(async () => {
    // 2. 데이터를 요청할 URL
    // -> https://jsonplaceholder.typicode.com/posts/1
    const url = 'https://jsonplaceholder.typicode.com/posts/1';

    // 3. fetch() 함수를 사용해 데이터 요청
    // `await` 키워드를 사용하므로, 요청이 완료될 때까지 코드 실행이 기다린다.
    let response;
    try {
        response = await fetch(url);
    } catch (err) {
        console.error('네트워크 에러', err);
        return;
    }

    // 4. 응답(response) 객체 확인
    // -> 응답 객체는 HTTP 상태 코드, 헤더 등 다양한 정보를 포함한다.
    console.log('Response Status:', response.status);       // HTTP 상태 코드 (200, 404 등)
    console.log('Response OK:', response.ok);             // HTTP 상태 코드가 200-299 범위에 있는지 여부 (true/false)
    console.log('Response Headers:', response.headers.get('Content-Type')); // 응답 헤더

    // 5. 응답 본문(body)을 JSON 형태로 파싱
    // -> 응답 본문은 스트림(Stream) 형태이므로, .json() 메서드를 사용해
    //    JavaScript 객체로 변환해야 한다. 이 과정 역시 비동기이다.
    let data = null;
    if (response.ok) {
        try {
            data = await response.json();
        } catch (err) {
            console.error('JSON 파싱 에러', err);
            return;
        }
    }

    // 6. 최종 결과 출력
    console.log('\n--- 최종 결과 ---');
    console.log(data);
})();
```

## 2. GET 파라미터 전송

`GET` 요청 시 URL에 쿼리 파라미터(Query Parameter)를 추가하여 원하는 데이터를 필터링하는 방법을 학습합니다. `URLSearchParams` 객체를 사용하여 안전하고 편리하게 URL을 만드는 방법을 익힙니다.

### 주요 개념
- `URLSearchParams`: URL의 쿼리 문자열을 쉽게 다룰 수 있도록 도와주는 내장 객체입니다. 객체를 `key=value&key=value` 형태의 문자열로 쉽게 변환할 수 있습니다.

### 실습: GET 파라미터 전송하기

**`/05-HttpClient/02-get_with_params.js`**
```javascript
// 1. 비동기 처리를 위한 즉시 실행 함수
(async () => {
    // 2. 데이터를 요청할 기본 URL
    const baseUrl = 'https://jsonplaceholder.typicode.com/comments';

    // 3. Query Parameter로 전송할 데이터 정의
    // -> 특정 게시물(postId=1)에 대한 댓글들만 조회
    const params = { postId: 1 };

    // 4. URLSearchParams 객체를 사용하여 Query String 생성
    // -> params 객체의 key-value가 "key=value&key=value" 형태의 문자열로 변환된다.
    const searchParams = new URLSearchParams(params);
    const url = `${baseUrl}?${searchParams.toString()}`;
    console.log('요청 URL:', url);

    // 5. 데이터 요청
    let response;
    try {
        response = await fetch(url);
    } catch (err) {
        console.error(err);
        return;
    }

    // 6. 응답 결과 처리
    if (response.ok) {
        const data = await response.json();
        console.log('\n--- 응답 결과 ---');
        console.log(data);
    }
})();
```

## 3. POST 데이터 전송

`POST` 요청을 통해 서버에 새로운 데이터를 생성하는 방법을 학습합니다. `fetch` 함수의 두 번째 인자인 `options` 객체에 `method`, `headers`, `body`를 설정하는 방법을 익힙니다.

### 주요 개념
- `method`: HTTP 요청 메서드를 지정합니다. (예: 'POST', 'PUT', 'DELETE')
- `headers`: HTTP 요청 헤더를 설정합니다. `Content-Type` 헤더를 통해 서버에 보내는 데이터의 형식을 알려주는 것이 중요합니다.
- `body`: 요청 본문에 담아 보낼 데이터를 지정합니다. `JSON.stringify()`를 사용하여 JavaScript 객체를 JSON 문자열로 변환해야 합니다.

### 실습: POST 요청으로 데이터 생성하기

**`/05-HttpClient/03-simple_post.js`**
```javascript
// 1. 비동기 처리를 위한 즉시 실행 함수
(async () => {
    // 2. 데이터를 전송할 URL
    const url = 'https://jsonplaceholder.typicode.com/posts';

    // 3. 전송할 데이터 생성
    // -> FormData 객체를 사용하여 데이터를 생성
    const newPost = new FormData();
    newPost.append('title', 'foo');
    newPost.append('body', 'bar');
    newPost.append('userId', 1);

    // 4. fetch() 함수에 대한 옵션 설정
    const options = {
        method: 'POST', // HTTP 요청 메서지 (POST)
        body: newPost   // 요청 본문에 전송할 데이터
    };

    // 5. 데이터 요청
    let response;
    try {
        response = await fetch(url, options);
    } catch (err) {
        console.error(err);
        return;
    }

    // 6. 응답 결과 처리
    // -> POST 요청에 대한 응답으로, 서버가 생성한 데이터의 정보와
    //    id값 등이 포함되어 돌아온다.
    if (response.ok) {
        const data = await response.json();
        console.log('\n--- 응답 결과 ---');
        console.log(data);
    }
})();
```

## 4. 다양한 HTTP 메서드 사용하기

대부분의 RESTful API는 데이터 처리를 위해 **CRUD** 원칙을 따릅니다. CRUD는 `Create(생성)`, `Read(조회)`, `Update(수정)`, `Delete(삭제)`의 약자이며, 각각의 동작은 HTTP 메서드와 다음과 같이 매핑됩니다.

- **C**reate: `POST` (새로운 리소스 생성)
- **R**ead: `GET` (리소스 조회)
- **U**pdate: `PUT` (리소스 전체 수정) 또는 `PATCH` (리소스 일부 수정)
- **D**elete: `DELETE` (리소스 삭제)

`PUT`과 `DELETE` 메서드를 사용하는 방법은 `POST`와 거의 동일합니다. `fetch`의 `options` 객체에서 `method` 값만 변경해주면 됩니다.

- **PUT**: 기존 리소스 전체를 새로운 데이터로 덮어쓰는(수정하는) 역할을 합니다. 수정할 데이터 전체를 `body`에 담아 전송해야 합니다.
- **DELETE**: 지정된 리소스를 삭제합니다. 보통 `body` 없이 요청합니다.

요청 방식이 `POST`와 매우 유사하므로 별도의 실습 파일은 생략하지만, 코드는 다음과 같은 형태가 됩니다.

```javascript
// PUT 요청 예시 (id가 1인 게시물 전체 수정)
(async () => {
    const formData = new FormData();
    formData.append('title', 'Updated Title');
    formData.append('body', 'This content has been updated.');
    formData.append('userId', 1);

    const options = {
        method: 'PUT', // 메서드를 'PUT'으로 변경
        body: formData // 수정할 전체 데이터를 FormData로 전달
    };

    const response = await fetch('https://jsonplaceholder.typicode.com/posts/1', options);
    const data = await response.json();
    console.log(data);
})();

// DELETE 요청 예시 (id가 1인 게시물 삭제)
(async () => {
    const options = {
        method: 'DELETE' // 메서드를 'DELETE'로 변경
    };

    const response = await fetch('https://jsonplaceholder.typicode.com/posts/1', options);
    // DELETE 요청은 보통 빈 객체 {}를 응답으로 받습니다.
    const data = await response.json();
    console.log(data);
    console.log('삭제 완료');
})();
```

## 5. 에러 처리

네트워크 문제나 서버의 HTTP 에러(4xx, 5xx) 등 요청 과정에서 발생할 수 있는 다양한 에러를 처리하는 방법을 학습합니다. `try...catch`와 `response.ok` 속성을 활용한 견고한 에러 처리 방법을 익힙니다.

### 주요 개념
- `try...catch`: `fetch` 실행 중 네트워크 장애(예: DNS 조회 실패, 인터넷 연결 끊김)가 발생하면 `catch` 블록이 실행됩니다.
- `response.ok`: `fetch`는 서버가 404나 500 같은 에러 코드를 반환해도 네트워크 통신 자체는 성공으로 간주합니다. 따라서 `response.ok`가 `false`인 경우를 직접 확인하여 HTTP 에러를 처리해야 합니다.

### 실습: 요청 및 응답 에러 처리

**`/05-HttpClient/04-error_handling.js`**
```javascript
// 1. 비동기 처리를 위한 즉시 실행 함수
(async () => {
    // 2. 존재하지 않는 리소스를 요청하여 404 에러를 유도
    const url = 'https://jsonplaceholder.typicode.com/posts/9999';

    let response;
    try {
        response = await fetch(url);
        console.log('>> 요청 성공');
    } catch (err) {
        // `fetch()` 자체는 네트워크 장애(DNS 조회 실패, 오프라인 등)가 발생한 경우에만
        // Promise가 reject되어 이 블록이 실행된다.
        console.error('>> 네트워크 에러 발생', err);
        return;
    }

    // 3. `fetch()`는 서버가 4xx, 5xx 같은 에러 상태 코드를 반환해도
    //    네트워크 통신 자체는 성공으로 간주하여 Promise를 reject하지 않는다.
    //    따라서 `response.ok` 속성을 확인하여 응답의 성공 여부를 직접 판단해야 한다.
    if (response.ok) {
        console.log('>> 응답 성공');
        const data = await response.json();
        console.log(data);
    } else {
        // 4. 응답이 성공적이지 않은 경우 (HTTP 에러)
        console.error(`>> HTTP 에러: ${response.status} ${response.statusText}`);

        // 에러의 상세 내용을 확인하기 위해 응답 본문을 텍스트로 읽어온다.
        // (에러 응답은 JSON이 아닐 수 있으므로 .text() 사용)
        try {
            const errorBody = await response.text();
            console.error('>> 에러 내용:', errorBody);
        } catch (err) {
            console.error('>> 에러 본문을 읽는 중 추가 에러 발생', err);
        }
    }
})();
```

## 6. FetchHelper 모듈을 활용한 실무 적용

실무에서는 반복적인 `fetch` 코드를 매번 작성하는 대신, 이를 클래스나 모듈로 만들어 재사용합니다. 직접 제작한 `FetchHelper` 모듈을 사용하여 코드의 중복을 줄이고 유지보수성을 높이는 방법을 학습합니다.

### 1) FetchHelper 모듈 코드

먼저, `helpers` 폴더에 위치한 `FetchHelper.js` 모듈의 구조를 살펴봅니다. 이 모듈은 다음과 같은 특징을 가집니다.

- **URL 자동 처리**: `http`로 시작하지 않는 URL의 경우, 현재 페이지의 기본 URL을 자동으로 붙여줍니다. (Node.js 환경에서는 `window` 객체가 없으므로 이 부분은 실행 환경에 맞게 수정이 필요할 수 있습니다.)
- **FormData 자동 변환**: `POST`, `PUT`, `DELETE` 요청 시 일반 JavaScript 객체를 `FormData` 객체로 자동 변환하여 전송합니다.
- **중앙화된 에러 처리**: `__request` 메서드 내에서 네트워크 에러와 HTTP 에러를 모두 감지하고, 일관된 형식의 에러 객체를 `throw`하여 호출한 쪽에서 쉽게 처리할 수 있도록 합니다.
- **상세한 로그**: `console.group`을 사용하여 각 요청의 시작과 끝, 전송 데이터와 응답 결과를 그룹으로 묶어 보여주므로 디버깅에 용이합니다.

**`/helpers/FetchHelper.js`**
```javascript
import logHelper from './LogHelper.js';

const fetchHelper = {
    __setUrl: function (url) {
        if (url.constructor !== URL) {
            return new URL(url);
        }
        return url;
    },
    __request: async function (url, method = "get", params = null, headers = {}) {
        // 요청 URL이 URL객체가 아닌 경우 객체 생성
        url = this.__setUrl(url);

        // post, put, delete 방식에서 파라미터가 FormData 객체가 아닌 경우 객체 변환
        if (method.toLocaleLowerCase() !== "get" && params) {

            if (headers?.["Content-Type"] === "application/json") {
                params = JSON.stringify(params);
            } else {
                if (params.constructor !== FormData) {
                    const tmp = structuredClone(params);
                    params = new FormData();

                    for (const t in tmp) {
                        const value = tmp[t];
                        if (value) {
                            params.set(t, value);
                        }
                    }
                }
            }
        }

        let result = null;      // Ajax 연동 결과가 저장될 객체
        let options = null;     // post, put, delete에서 사용할 옵션 변수

        if (method.toLocaleLowerCase() !== "get") {
            options = {
                method: method,
                cache: "no-cache",
                headers: headers,
                body: params,
            };
        }

        try {
            // 백엔드로부터의 응답 받기
            const response = await fetch(url, options);
            logHelper.info(`→ [${method}] ${url} >>> ${response.status} ${response.statusText}`);

            // 백엔드가 에러를 보내왔다면?
            if (parseInt(response.status / 100) != 2) {
                let message = response.statusText;
                let json = await response.json();

                if (!message) {
                    message = json?.message ?? "서버에서 에러가 발생했습니다.";
                }

                // 에러 객체 생성후 에러 발생 --> catch로 이동함
                const err = new Error(message);
                err.status = response.status;
                throw err;
            }

            // 응답으로부터 JSON 데이터 추출
            result = await response.json();
        } catch (err) {
            logHelper.error("FetchHelper Request Error", err);
            throw err;
        }

        return result;
    },
    get: async function(urlString, params, headers = {}) {
        let url = this.__setUrl(urlString);

        // params를 url에 QueryString형태로 추가해야 함
        if (params) {
            if (params.constructor === FormData) {
                for (const p of params.keys()) {
                    const value = params.get(p);
                    if (value) {
                        url.searchParams.set(p, value);
                    }
                }
            } else {
                for (const p in params) {
                    const value = params[p];
                    if (value) {
                        url.searchParams.set(p, params[p]);
                    }
                }
            }
        }

        return await this.__request(url, "get", null, headers);
    },
    post: async function(urlString, params, headers = {}) {
        // params를 FormData객체 형태로 변환해야 함
        return await this.__request(urlString, "post", params, headers);
    },
    put: async function(urlString, params, headers = {}) {
        // params를 FormData객체 형태로 변환해야 함
        return await this.__request(urlString, "put", params, headers);
    },
    delete: async function(urlString, params, headers = {}) {
        // params를 FormData객체 형태로 변환해야 함
        return await this.__request(urlString, "delete", params, headers);
    }
}

export default fetchHelper;
```

### 2) FetchHelper 모듈 사용하기

이제 `FetchHelper` 모듈을 가져와서 사용하는 예제입니다. 복잡한 로직이 모두 모듈 내부에 캡슐화되어, 사용하는 쪽의 코드가 매우 간결하고 직관적으로 변한 것을 확인할 수 있습니다.

**`/05-HttpClient/05-use_fetch_helper.js`**
```javascript
// 1. FetchHelper 모듈 가져오기
// -> `helpers` 폴더에 위치하므로 경로에 주의
import fetchHelper from '../helpers/FetchHelper.js';

// 2. 비동기 즉시 실행 함수
(async () => {
    try {
        // 1) GET 요청
        console.log('\n--- GET 요청 ---');
        // `get(url, params)`. 파라미터가 없으면 params 생략 가능
        const getResult = await fetchHelper.get('https://jsonplaceholder.typicode.com/posts/1');
        console.log(getResult);

        // 2) POST 요청
        console.log('\n--- POST 요청 ---');
        // `post(url, params)`. 전송할 데이터를 params로 전달
        const postData = { title: 'My New Post', body: 'This is a test.', userId: 100 };
        const postResult = await fetchHelper.post('https://jsonplaceholder.typicode.com/posts', postData);
        console.log(postResult);

    } catch (err) {
        // FetchHelper 내부에서 throw된 에러를 여기서 최종 처리
        // err 객체는 status와 message 프로퍼티를 포함할 수 있다.
        console.error(`--- 최종 에러: ${err.status} ${err.message} ---`);
    }
})();
```

## 7. 실전 예제: 영화진흥위원회 일일 박스오피스 순위 조회

지금까지 학습한 내용을 바탕으로, 영화진흥위원회에서 제공하는 오픈 API를 사용하여 특정 날짜의 박스오피스 순위를 조회하는 실전 예제를 만들어 보겠습니다. 이 예제는 `FetchHelper` 모듈을 활용하여 간결하게 구현합니다.

### 1) API 명세 확인

- **요청 URL**: `http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json`
- **HTTP 메서드**: `GET`
- **요청 파라미터**:
    - `key` (필수): 발급받은 API 키
    - `targetDt` (필수): 조회할 날짜 (yyyymmdd 형식)

### 2) 실습: 일일 박스오피스 순위 조회하기

`FetchHelper`를 사용하여 API를 호출하고, 응답으로 받은 영화 목록을 콘솔에 출력하는 예제입니다.

**`/05-HttpClient/06-movie_rank.js`**
```javascript
// 1. helpers 패키지의 FetchHelper 모듈 가져오기
import fetchHelper from '../helpers/FetchHelper.js';

// 2. 비동기 즉시 실행 함수
(async () => {
    // 3. 조회할 날짜를 변수로 정의
    // yyyymmdd 형식으로 지정
    const targetDt = '20240721';

    // 4. 영화진흥위원회 OpenAPI를 통해 박스오피스 순위 가져오기
    // -> get 파라미터: key, targetDt
    const url = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json";
    const params = {
        key: '6d2cf4aa96725383235c717f2e569f1e',
        targetDt: targetDt
    };

    let result = null;
    try {
        result = await fetchHelper.get(url, params);
    } catch (err) {
        console.error(`에러 발생: ${err.message}`);
        return;
    }

    // 5. 연동 결과 확인
    if (result) {
        // result.boxOfficeResult.dailyBoxOfficeList 배열의 각 원소를 반복적으로 탐색
        // -> v: 배열의 원소, i: 배열의 인덱스
        result.boxOfficeResult.dailyBoxOfficeList.forEach((v, i) => {
            console.log('%d위: %s (관객수: %d, 개봉일: %s)', v.rank, v.movieNm, v.audiCnt, v.openDt);
        });
    }
})();
```

### 3) 실행 결과

위 코드를 실행하면 콘솔에 다음과 같이 지정된 날짜의 영화 순위가 출력됩니다.

```
1위: 인사이드 아웃 2 (관객수: 153684, 개봉일: 2024-06-12)
2위: 파일럿 (관객수: 108231, 개봉일: 2024-07-31)
3위: 데드풀과 울버린 (관객수: 90831, 개봉일: 2024-07-24)
...
```