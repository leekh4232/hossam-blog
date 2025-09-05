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
# OpenAI API Key
OPENAI_API_KEY="여기에_발급받은_API_키를_붙여넣으세요"
```

## 1. 순수 HTTP 클라이언트로 API 연동하기

먼저 `node-fetch`를 사용하여 OpenAI의 `chat/completions` API를 직접 호출하는 예제입니다. `FetchHelper` 대신 `node-fetch`를 사용한 이유는 `FetchHelper`가 브라우저 환경의 `FormData`를 기준으로 설계되어 있어, JSON 기반의 API 연동에는 `node-fetch`가 더 직관적이기 때문입니다.

### 실습 코드

**`/06-OpenAIClient/01-use_fetch_helper.js`**
```javascript
import logHelper from '../helpers/LogHelper.js';
import fetch from 'node-fetch';
import dotenv from 'dotenv';

dotenv.config({ path: '../.env' });

const API_URL = 'https://api.openai.com/v1/chat/completions';
const API_KEY = process.env.OPENAI_API_KEY;

if (!API_KEY) {
    logHelper.error('OPENAI_API_KEY is not set in .env file');
    process.exit(1);
}

(async () => {
    logHelper.info('--- OpenAI API with node-fetch ---');

    const messages = [
        { role: 'system', content: 'You are a helpful assistant.' },
        { role: 'user', content: 'Node.js에서 파일 시스템을 다루는 방법에 대해 설명해줘.' },
    ];

    try {
        const response = await fetch(API_URL, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${API_KEY}`,
            },
            body: JSON.stringify({
                model: 'gpt-3.5-turbo',
                messages: messages,
                temperature: 0.7,
            }),
        });

        if (!response.ok) {
            const errorBody = await response.json();
            logHelper.error(`HTTP Error: ${response.status} ${response.statusText}`, errorBody);
            return;
        }

        const data = await response.json();

        logHelper.debug('API Response:', data);

        if (data.choices && data.choices.length > 0) {
            const assistantMessage = data.choices[0].message.content;
            logHelper.info('Assistant:', assistantMessage);
        } else {
            logHelper.warn('No choices returned from API.');
        }

    } catch (error) {
        logHelper.error('Error fetching from OpenAI API:', error);
    }
})();
```

### 코드 분석

-   `dotenv.config()`: `.env` 파일에 저장된 `OPENAI_API_KEY`를 `process.env` 객체로 불러옵니다.
-   `fetch(API_URL, options)`: `fetch` 함수를 사용하여 `POST` 요청을 보냅니다.
-   `headers`:
    -   `Content-Type: 'application/json'`: 요청 본문이 JSON 형식임을 명시합니다.
    -   `Authorization: 'Bearer ${API_KEY}'`: API 키를 Bearer 토큰 방식으로 헤더에 포함하여 인증을 수행합니다.
-   `body`:
    -   `JSON.stringify()`: JavaScript 객체를 JSON 문자열로 변환하여 전송합니다.
    -   `model`: 사용할 LLM 모델을 지정합니다. (예: `gpt-3.5-turbo`, `gpt-4`)
    -   `messages`: 대화 내용을 배열 형태로 전달합니다. `role`은 `system`(AI의 역할 정의), `user`(사용자 질문), `assistant`(AI의 이전 답변) 등으로 구성됩니다.
-   `response.ok`: 응답 상태 코드가 2xx가 아닐 경우 에러를 처리합니다.
-   `data.choices[0].message.content`: API 응답에서 실제 AI가 생성한 답변 텍스트가 담겨있는 경로입니다.

## 2. `openai` 공식 SDK로 API 연동하기

이번에는 `openai` 패키지를 사용하여 동일한 기능을 훨씬 간결하게 구현하는 예제입니다.

### 관련 패키지 설치

```bash
$ yarn add openai
```

### 실습 코드

**`/06-OpenAIClient/02-use_openai_package.js`**
```javascript
import logHelper from '../helpers/LogHelper.js';
import OpenAI from 'openai';
import dotenv from 'dotenv';

dotenv.config({ path: '../.env' });

const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
});

(async () => {
    logHelper.info('--- OpenAI API with openai package ---');

    const messages = [
        { role: 'system', content: 'You are a helpful assistant.' },
        { role: 'user', content: 'Node.js에서 HTTP 클라이언트를 만드는 방법에 대해 설명해줘.' },
    ];

    try {
        const chatCompletion = await openai.chat.completions.create({
            model: 'gpt-3.5-turbo',
            messages: messages,
            temperature: 0.7,
        });

        logHelper.debug('API Response:', chatCompletion);

        const assistantMessage = chatCompletion.choices[0].message.content;
        logHelper.info('Assistant:', assistantMessage);

    } catch (error) {
        logHelper.error('Error fetching from OpenAI API:', error);
    }
})();
```

### 코드 분석

-   `new OpenAI({ apiKey: ... })`: API 키를 전달하여 `OpenAI` 클라이언트 객체를 생성합니다.
-   `openai.chat.completions.create({ ... })`: 이 메서드 하나로 채팅 API 호출이 끝납니다.
    -   인자로 전달하는 객체는 `fetch` 방식의 `body`에 있던 내용과 거의 동일합니다.
    -   HTTP 헤더 설정, `JSON.stringify` 등의 번거로운 과정이 모두 추상화되어 있습니다.
-   `chatCompletion.choices[0].message.content`: 응답 객체의 구조는 SDK가 API 응답을 그대로 객체화해주므로, `fetch` 방식과 동일한 경로로 결과에 접근할 수 있습니다.

두 코드를 비교해 보면, `openai` 패키지를 사용했을 때 코드가 훨씬 단순하고 의도가 명확하게 드러나는 것을 확인할 수 있습니다.

이처럼 공식 SDK를 사용하면 비즈니스 로직에 더 집중할 수 있으므로, 특별한 경우가 아니라면 SDK 사용을 적극 권장합니다.
