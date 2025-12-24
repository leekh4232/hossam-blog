---
title: Node.js 백엔드에 LLM(OpenAI API) 내장하기
description: "Node.js 환경에서 OpenAI API를 연동하여 LLM(거대 언어 모델)을 백엔드 서비스에 통합하는 두 가지 방법을 학습합니다."
categories: [06.Backend,Node]
date:   2025-09-01 09:00:00 +0900
author: Hossam
image: /images/indexs/node2.png
tags: [Web Development,Backend,Node,AI,LLM,OpenAI]
pin: true
math: true
mermaid: true
---

# Node.js 백엔드에 LLM(OpenAI API) 내장하기

최근 ChatGPT와 같은 거대 언어 모델(LLM)을 애플리케이션에 통합하려는 수요가 폭발적으로 증가하고 있습니다. 예를 들어, 고객 문의에 자동으로 답변하는 챗봇, 사용자의 요청에 따라 콘텐츠를 생성하는 서비스, 코드나 문서를 분석하고 요약하는 도구 등 무궁무진한 활용이 가능합니다.

이번 시간에는 Node.js 백엔드 환경에서 가장 대표적인 LLM인 OpenAI의 API를 연동하는 방법을 학습합니다. 이를 통해 여러분의 백엔드 서비스에 강력한 AI 기능을 내장할 수 있게 될 것입니다.

## OpenAI API는 유료 서비스입니다

본격적인 학습에 앞서, **OpenAI API는 유료 서비스**라는 점을 명확히 인지해야 합니다. 비용은 API 요청 및 응답에 사용된 텍스트의 양, 즉 **토큰(Token)** 수를 기준으로 부과됩니다. 1,000 토큰은 대략 영어 단어 750개에 해당합니다.

비용은 사용하는 모델에 따라 다르며, 이 포스팅에서 사용할 `gpt-3.5-turbo` 모델의 경우 2025년 9월 기준으로 다음과 같습니다.

-   **입력(Input) 토큰**: 100만 토큰당 약 $0.50
-   **출력(Output) 토큰**: 100만 토큰당 약 $1.50

일반적으로 질문(입력)보다 답변(출력)의 텍스트 양이 많으므로 출력 비용이 더 높게 책정되어 있습니다. 다행히 OpenAI는 **신규 가입자에게 일정 기간 사용할 수 있는 무료 크레딧을 제공**하므로, 이를 활용하여 부담 없이 학습과 테스트를 진행할 수 있습니다. 하지만 실제 서비스를 운영할 때에는 예상치 못한 과도한 비용이 발생하지 않도록 사용량을 모니터링하고 제어하는 전략이 반드시 필요합니다.

## 주요 OpenAI API 엔드포인트

OpenAI는 단순히 대화를 나누는 것 외에도 다양한 AI 기능을 API 형태로 제공합니다. 각 기능은 고유한 엔드포인트(Endpoint)를 통해 접근할 수 있습니다. 주요 엔드포인트와 그 용도는 다음과 같습니다.

| 엔드포인트 (Endpoint) | 주요 용도 | HTTP 메서드 |
| --- | --- | --- |
| `v1/chat/completions` | 대화형 AI, 챗봇, 일반적인 텍스트 생성 및 요약 | `POST` |
| `v1/embeddings` | 텍스트를 벡터로 변환하여 의미 기반 검색, 분류, 군집화 | `POST` |
| `v1/images/generations` | 텍스트 설명(프롬프트)을 기반으로 이미지 생성 (DALL·E) | `POST` |
| `v1/audio/transcriptions` | 음성 파일을 텍스트로 변환 (Speech-to-Text, Whisper) | `POST` |
| `v1/audio/speech` | 텍스트를 자연스러운 음성으로 변환 (Text-to-Speech, TTS) | `POST` |
| `v1/fine_tuning/jobs` | 특정 작업에 맞게 기본 모델을 미세 조정(Fine-tuning) | `POST` |
| `v1/files` | Fine-tuning이나 검색 등에 사용할 파일을 업로드 | `POST` |
| `v1/models` | 사용 가능한 모델 목록 조회 및 정보 확인 | `GET` |

이 포스팅에서는 이 중에서 가장 핵심적인 **`v1/chat/completions`** 엔드포인트를 사용하여 LLM을 백엔드에 연동하는 방법을 중점적으로 다룹니다.

## OpenAI API 연동 방식 비교

Node.js에서 OpenAI API를 연동하는 방법은 크게 두 가지로 나눌 수 있습니다.

1.  **순수 HTTP 클라이언트 사용 (`node-fetch` 등)**
    -   **장점**:
        -   별도의 API 전용 라이브러리 없이, `fetch`와 같은 기본적인 HTTP 클라이언트만으로 구현할 수 있어 의존성이 적습니다.
        -   API의 모든 요청/응답 구조를 직접 제어하므로, 동작 원리를 깊이 이해하는 데 도움이 됩니다.
    -   **단점**:
        -   API 명세에 맞춰 헤더, 본문 등을 직접 구성해야 하므로 코드가 길고 복잡해질 수 있습니다.
        -   API가 업데이트될 때마다 변경 사항을 직접 코드에 반영해야 합니다.
        -   타입스크립트 사용 시, 응답 데이터에 대한 타입을 직접 정의해야 하는 번거로움이 있습니다.

2.  **공식 SDK 사용 (`openai` 패키지)**
    -   **장점**:
        -   OpenAI가 직접 제공하는 라이브러리로, API 사용법이 매우 간결하고 직관적입니다.
        -   복잡한 인증 절차나 요청 구조가 추상화되어 있어 몇 줄의 코드만으로 API를 호출할 수 있습니다.
        -   타입스크립트를 완벽하게 지원하여 개발 생산성과 안정성이 높습니다.
        -   API 업데이트 시 SDK도 함께 업데이트되므로 유지보수가 용이합니다.
    -   **단점**:
        -   `openai`라는 새로운 의존성이 추가됩니다.
        -   내부 동작이 추상화되어 있어, HTTP 통신의 세부적인 원리를 파악하기는 어렵습니다.

**결론적으로, 특별한 이유가 없다면 공식 SDK(`openai` 패키지)를 사용하는 것이 생산성, 안정성, 유지보수 측면에서 훨씬 유리합니다.** 이번 학습에서는 두 가지 방법을 모두 실습하여 그 차이점을 명확히 이해해 보겠습니다.

## 0. 실습 준비

본격적인 실습에 앞서, 예제 코드를 저장할 폴더를 생성하고 필요한 패키지를 설치합니다.

### 1) OpenAI API Key 발급

먼저 [OpenAI Platform](https://platform.openai.com/)에 가입하고, API Key를 발급받아야 합니다.
-   로그인 후 `API Keys` 메뉴로 이동하여 `Create new secret key` 버튼을 클릭해 새로운 키를 생성합니다.
-   **생성된 키는 다시 확인할 수 없으므로 반드시 안전한 곳에 복사해 두어야 합니다.**

### 2) .env 파일 생성

프로젝트 루트에 `.env` 파일을 생성하고, 발급받은 API 키를 다음과 같이 저장합니다. **이 파일은 절대 Git과 같은 버전 관리 시스템에 포함되어서는 안 됩니다.**

**`/.env`**
```
# ... 이전 내용 생략 ...

# OpenAI API Key
OPENAI_API_KEY=sk-proj-... # 발급받은 키로 변경
```

## 1. 순수 HTTP 클라이언트로 API 연동하기

먼저 `node-fetch` 기반으로 직접 구현한 `FetchHelper`를 사용하여 OpenAI의 `chat/completions` API를 직접 호출하는 예제입니다. 이 방법을 통해 API 통신의 기본적인 구조를 이해할 수 있습니다.

### 실습 코드 (**`/06-OpenAIClient/01-use_fetch_helper.js`**)
```javascript
import logHelper from "../helpers/LogHelper.js";
import fetchHelper from "../helpers/FetchHelper.js";
import dotenv from "dotenv";

dotenv.config();

const API_URL = "https://api.openai.com/v1/chat/completions";
const API_KEY = process.env.OPENAI_API_KEY;

if (!API_KEY) {
    logHelper.error("OPENAI_API_KEY is not set in .env file");
    process.exit(1);
}

(async () => {
    const params = {
        model: "gpt-3.5-turbo",
        messages: [
            { role: "system", content: "You are a helpful assistant." },
            { role: "user", content: "Node.js에서 파일 시스템을 다루는 방법에 대해 설명해줘." },
        ],
        max_tokens: 1000,
        temperature: 0.7,
    };

    const headers = {
        "Content-Type": "application/json",
        Authorization: `Bearer ${API_KEY}`,
    };

    let json = null;

    try {
        json = await fetchHelper.post(API_URL, params, headers);
    } catch (err) {
        logHelper.error(`Error during fetch: ${err.message}`);
        return;
    }

    logHelper.debug("응답 데이터: ", json);

    if (json?.choices?.length > 0) {
        const message = json.choices[0].message;
        logHelper.debug(`OpenAI Response: ${message.content}`);
    } else {
        logHelper.warn("응답결과 없음!!!");
    }
})();
```

### 코드 분석

-   **`import`**: `logHelper` (로그 출력), `fetchHelper` (HTTP 통신), `dotenv` (환경변수 관리) 모듈을 가져옵니다.
-   **`dotenv.config()`**: `.env` 파일에 정의된 환경변수(`OPENAI_API_KEY`)를 `process.env` 객체로 로드하여 코드에서 사용할 수 있게 합니다.
-   **`API_URL`**: API 요청을 보낼 목표 주소, 즉 OpenAI의 `chat/completions` 엔드포인트 URL을 상수로 정의합니다.
-   **`API_KEY`**: `process.env`에서 API 키 값을 가져옵니다. 이 키는 API 인증에 사용됩니다.
-   **`if (!API_KEY)`**: API 키가 설정되지 않았을 경우, 에러를 출력하고 프로세스를 즉시 종료합니다. 이는 민감한 키 정보가 누락된 상태에서 코드가 실행되는 것을 방지하는 중요한 방어 로직입니다.
-   **`params` (요청 본문 객체)**: API에 전달할 주요 파라미터를 정의하는 JavaScript 객체입니다.
    -   `model`: 사용할 AI 모델을 지정합니다. `gpt-3.5-turbo`는 비용과 성능의 균형이 좋은 모델입니다.
    -   `messages`: 대화의 흐름을 담는 배열입니다.
        -   `role: "system"`: AI의 역할이나 정체성을 정의합니다. (예: "당신은 친절한 도우미입니다.")
        -   `role: "user"`: 사용자가 AI에게 전달하는 질문이나 명령입니다.
    -   `max_tokens`: AI가 생성할 답변의 최대 길이를 토큰 단위로 제한합니다. 예상치 못한 긴 답변으로 과도한 비용이 발생하는 것을 막아줍니다.
    -   `temperature`: 답변의 창의성 수준을 조절합니다. 0에 가까울수록 결정론적이고 일관된 답변을, 1에 가까울수록 다양하고 창의적인 답변을 생성합니다. (0.7은 약간의 창의성을 부여한 상태)
-   **`headers` (요청 헤더 객체)**: HTTP 요청에 포함될 헤더 정보를 정의합니다.
    -   `"Content-Type": "application/json"`: 요청 본문(`params`)의 데이터 형식이 JSON임을 서버에 알립니다.
    -   `Authorization: `Bearer ${API_KEY}``: API 키를 `Bearer` 토큰 인증 방식에 따라 헤더에 포함시켜 요청의 소유자를 인증합니다.
-   **`try...catch` 블록**: 네트워크 통신과 같이 실패 가능성이 있는 작업을 처리합니다.
    -   `await fetchHelper.post(API_URL, params, headers)`: `fetchHelper`를 사용해 `API_URL`에 `params`와 `headers`를 담아 `POST` 요청을 보냅니다. `fetchHelper` 내부에서는 `params` 객체를 JSON 문자열로 변환(`JSON.stringify`)하여 전송합니다.
    -   `catch (err)`: 요청 실패 시(네트워크 오류, 서버 에러 등), 에러 메시지를 로그로 남기고 함수 실행을 중단합니다.
-   **`if (json?.choices?.length > 0)`**: API 응답이 성공적으로 수신되었는지, 그리고 그 안에 `choices` 배열이 비어있지 않은지 확인합니다. `?.` (Optional Chaining) 연산자는 `json`이나 `json.choices`가 `null` 또는 `undefined`일 경우 에러를 발생시키지 않고 `undefined`를 반환하여 코드를 안정적으로 만듭니다.
-   **`const message = json.choices[0].message`**: `choices` 배열의 첫 번째 요소(`[0]`)에 AI의 답변 정보가 담겨 있습니다. 이 `message` 객체 안에는 `role`과 `content`가 포함됩니다.
-   **`logHelper.debug(`OpenAI Response: ${message.content}`)`**: `message` 객체에서 실제 답변 텍스트인 `content`를 추출하여 로그로 출력합니다.

## 2. `openai` 공식 SDK로 API 연동하기

이번에는 `openai` 패키지를 사용하여 동일한 기능을 훨씬 간결하게 구현하는 예제입니다. SDK를 사용하면 복잡한 HTTP 요청 과정을 추상화하고, 마치 일반적인 함수를 호출하듯 API를 사용할 수 있습니다.

### 관련 패키지 설치

```bash
$ yarn add openai
```

### 실습 코드 (**`/06-OpenAIClient/02-use_openai_package.js`**)

```javascript
import logHelper from "../helpers/LogHelper.js";
import OpenAI from "openai";
import dotenv from "dotenv";

dotenv.config();

const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
});

(async () => {
    let json = null;

    try {
        json = await openai.chat.completions.create({
            model: "gpt-3.5-turbo",
            messages: [
                { role: "system", content: "You are a helpful assistant." },
                { role: "user", content: "Node.js에서 HTTP 클라이언트를 만드는 방법에 대해 설명해줘." },
            ],
            temperature: 0.7,
        });
    } catch (error) {
        logHelper.error("OpenAI API Error:", error);
        return;
    }

    if (json?.choices?.length > 0) {
        const message = json.choices[0].message;
        logHelper.debug(`OpenAI Response: ${message.content}`);
    } else {
        logHelper.warn("응답결과 없음!!!");
    }
})();
```

### 코드 분석

-   **`import OpenAI from "openai"`**: `openai` 패키지에서 `OpenAI` 클래스를 가져옵니다.
-   **`const openai = new OpenAI({ apiKey: ... })`**: 가져온 `OpenAI` 클래스를 인스턴스화하여 클라이언트 객체를 생성합니다. 이때, 생성자의 인자로 API 키를 전달하여 인증 정보를 설정합니다. 이 `openai` 객체가 앞으로 API와 통신하는 역할을 담당합니다.
-   **`try...catch` 블록**:
    -   **`await openai.chat.completions.create({ ... })`**: API를 호출하는 핵심 부분입니다.
        -   `chat.completions.create` 메서드는 `v1/chat/completions` 엔드포인트에 대한 요청을 추상화한 것입니다.
        -   메서드의 인자로 전달하는 객체는 순수 HTTP 방식에서 `params`로 정의했던 내용과 거의 동일합니다. (`model`, `messages` 등)
        -   **SDK의 장점**: `Content-Type`이나 `Authorization` 헤더를 직접 설정하거나, 요청 본문을 `JSON.stringify`로 변환하는 등의 번거로운 작업이 전혀 필요 없습니다. SDK가 이 모든 과정을 내부적으로 처리해줍니다.
    -   `catch (error)`: API 호출 중 발생하는 모든 에러(인증 실패, 잘못된 파라미터, 서버 오류 등)를 잡아 상세한 에러 정보를 로그로 남깁니다. SDK는 에러 발생 시 유용한 정보를 담은 에러 객체를 반환합니다.
-   **결과 처리**:
    -   `if (json?.choices?.length > 0)`: SDK가 반환하는 응답 객체(`json`)의 구조는 순수 HTTP 요청 시와 동일합니다. 따라서 결과를 확인하고 데이터에 접근하는 방식도 완전히 같습니다.
    -   `const message = json.choices[0].message`: `choices` 배열의 첫 번째 요소에서 `message` 객체를 가져옵니다.
    -   `logHelper.debug(`OpenAI Response: ${message.content}`)`: `message` 객체의 `content` 속성에서 최종 답변 텍스트를 추출하여 출력합니다.

두 코드를 비교해 보면, `openai` 패키지를 사용했을 때 코드가 훨씬 단순하고 의도가 명확하게 드러나는 것을 확인할 수 있습니다. 이는 개발자가 비즈니스 로직에 더 집중할 수 있게 해주므로, 특별한 경우가 아니라면 공식 SDK 사용을 적극 권장합니다.