---
title:  "React + Node.js(Express) + MCP 기반 프로젝트 아이디어"
description: 학생들에게 제시할 미니 프로젝트 아이디어
categories: [98.강의리소스]
date:   2025-08-26 11:26:00
author: Hossam
image: /images/indexs/note.jpg
categories: [90.강의리소스,수업연구]
pin: true
math: true
mermaid: true
---

# React + Node.js(Express) + MCP 기반 프로젝트 아이디어

## 프로젝트 아이디어 요약

- React → 인터랙티브 UI
- Express → 데이터 관리 및 API
- MCP → AI 모델 연동 (추천, 요약, 생성 기능 등)

| 시나리오                     | 개요                        | 주요 기능 |
| ------------------------ | ------------------------- | ------------------------------------------------------------------------------------------------- |
| **1. AI 기반 쇼핑몰 고객지원 챗봇** | 쇼핑몰 웹사이트에 AI 상담원 배치       | - React UI로 상품검색/FAQ 채팅 인터페이스<br>- Express API 서버: 주문/배송 DB 연동<br>- MCP로 LLM 연동 → FAQ 답변·상품추천     |
| **2. 개인화 학습 플랫폼**        | 학습자가 질문하면 AI가 답변·문제 생성    | - React UI로 강의 영상/퀴즈 화면 구성<br>- Express 서버: 학습 데이터 저장<br>- MCP로 AI 튜터 연결 (퀴즈·힌트 생성)               |
| **3. 스마트 일정관리 & 추천 시스템** | 일정 등록/조회 + AI 추천          | - React 캘린더 UI<br>- Express API: 일정 CRUD<br>- MCP로 AI 연결 → 일정 요약·추천<br>&nbsp;(예: “내일 회의 전에 읽을 자료”)         |
| **4. 여행 플래너 서비스**        | 사용자가 목적지 입력 → AI가 여행코스 설계 | - React UI로 여행지 지도/일정 표시<br>- Express 서버: DB 저장, 외부 API(날씨/항공) 연동<br>- MCP: AI 여행추천 (코스·예산·날씨 고려) |

## 구현 체크리스트 (공통)

- 프롬프트 규격화: system/role, 입력 스키마, 출력 스키마 고정
- 컨텍스트 관리: DB 조회값 → MCP 프롬프트에 필드 레벨로 삽입
- 관찰가능성: 프롬프트/응답 로깅 + 버전(A/B 프롬프트 테스트)
- 안전장치: PII 마스킹, 레이트리밋, 토큰 사용량 메트릭
- 실패 복구: LLM 실패 시 규칙기반 fallback 경로 마련

## 구현 아이디어 구체화

### 1. AI 기반 쇼핑몰 고객지원 챗봇

- FAQ·주문내역을 컨텍스트 주입해서 LLM 환각 줄이기
- 응답 페이로드에 근거 링크(citations) 포함

```mermaid
sequenceDiagram
    actor U as User
    participant FE as "React App / Next.js"
    participant BE as "Express API"
    participant DB as "Shop DB (orders, products)"
    participant MCP as "MCP Bridge"
    participant LLM as "LLM / Tools"

    U->>FE: 상품/주문 문의 입력
    FE->>BE: POST /chat {query, userId}
    BE->>DB: SELECT user, orders, faq
    DB-->>BE: user profile, order history
    BE->>MCP: compose prompt(context, user/order)
    MCP->>LLM: infer(answer + citations)
    LLM-->>MCP: 답변/추천안(근거 포함)
    MCP-->>BE: response(JSON)
    BE-->>FE: {message, references, actions}
    FE-->>U: 챗 UI 표시(추천상품/FAQ 링크)

    opt 주문 상태 조회
        U->>FE: "주문 #1234 배송상태?"
        FE->>BE: GET /orders/1234
        BE->>DB: SELECT order status
        DB-->>BE: shipped(out-for-delivery)
        BE-->>FE: status payload
        FE-->>U: 배송상태 배지 업데이트
    end
```

### 2. 개인화 학습 플랫폼 (AI 튜터)

- **개인화 컨텍스트(weak_topics, mastery)**를 MCP로 전달
- 퀴즈/힌트는 버전 관리로 재학습 데이터화 가능

```mermaid
sequenceDiagram
    actor U as Learner
    participant FE as "React App"
    participant BE as "Express API"
    participant DB as "Learning DB"
    participant MCP as "MCP Bridge"
    participant LLM as "LLM + Edu Tools"

    U->>FE: 강의 시청/질문 제출
    FE->>BE: POST /qa {question, courseId, userId}
    BE->>DB: SELECT progress, weak_topics
    DB-->>BE: learner context
    BE->>MCP: prompt(question + learner context)
    MCP->>LLM: generate answer + quizzes
    LLM-->>MCP: {answer, quizzes, hints}
    MCP-->>BE: response
    BE->>DB: INSERT quizzes, interaction log
    BE-->>FE: {answer, quizzes, hints}
    FE-->>U: 답변/퀴즈 UI

    opt 적응형 난이도
        FE->>BE: PATCH /quiz/{id} {result}
        BE->>DB: update mastery level
        BE->>MCP: request next difficulty
        MCP->>LLM: adapt quiz
        LLM-->>MCP: next quiz
        MCP-->>BE: quiz payload
        BE-->>FE: 새로운 퀴즈 렌더
    end
```

### 3. 스마트 일정관리 & 추천 시스템

- 외부 API(날씨/이메일) 신호를 프롬프트에 통합
- 회의 전 리딩 리스트/준비물 자동 생성

```mermaid
sequenceDiagram
    actor U as User
    participant FE as "React Calendar UI"
    participant BE as "Express API"
    participant DB as "Calendar DB"
    participant MCP as "MCP Bridge"
    participant LLM as "LLM + Tools"
    participant EXT as "External APIs (email, weather)"

    U->>FE: 일정 등록/조회/요약 요청
    FE->>BE: GET /events?range=...
    BE->>DB: SELECT events by range
    DB-->>BE: events list
    BE->>MCP: summarize(events, user prefs)
    MCP->>LLM: produce digest + actionables
    LLM-->>MCP: 요약/투두/준비물
    MCP-->>BE: response
    BE-->>FE: digest + 추천

    opt 컨텍스트 추천
        BE->>EXT: weather for time slots
        EXT-->>BE: weather data
        BE->>MCP: enrich(prompt with weather)
        MCP->>LLM: suggest best slots
        LLM-->>MCP: ranked suggestions
        MCP-->>BE: suggestions
        BE-->>FE: 추천 시간/준비물 표시
    end
```

### 4. 여행 플래너 서비스 (추천·예산·날씨)

- 항공/숙박/날씨 제약 조건을 명시적으로 프롬프트화
- 응답을 Day-by-day JSON 스키마로 받아 안정적인 렌더링

```mermaid
sequenceDiagram
    actor U as Traveler
    participant FE as "React App (map, itinerary)"
    participant BE as "Express API"
    participant DB as "Trip DB"
    participant MCP as "MCP Bridge"
    participant LLM as "LLM + Tools"
    participant EXT as "External APIs (항공/숙박/날씨)"

    U->>FE: 목적지/기간/예산 입력
    FE->>BE: POST /plan {dest, dates, budget}
    BE->>EXT: flights/hotels/weather
    EXT-->>BE: options + constraints
    BE->>DB: fetch saved prefs
    DB-->>BE: prefs
    BE->>MCP: prompt(dest, constraints, prefs)
    MCP->>LLM: propose itinerary + budget
    LLM-->>MCP: {day-by-day plan, cost}
    MCP-->>BE: structured plan(JSON)
    BE-->>FE: 일정표 + 지도/예산 뷰

    opt 수정 반복
        U->>FE: "2일차에 미술관 추가"
        FE->>BE: PATCH /plan {...}
        BE->>MCP: refine with constraints
        MCP->>LLM: recompute feasible route
        LLM-->>MCP: updated plan
        MCP-->>BE: plan v2
        BE-->>FE: 변경점 diff와 함께 표시
    end
```
