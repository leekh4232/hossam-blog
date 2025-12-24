---
title:  "ChatGPT DBML Prompt"
description: SpringBoot 프로젝트 수업을 진행하면서 데이터베이스 ERD를 DBML로 생성하기 위한 프롬프트를 작성하여 학생들에게 배포했다. 결과물은 꽤 마움에 든다.
categories: [91.AI활용]
date:   2025-06-17 17:09:00 +0900
author: Hossam
image: /images/indexs/study-cafe.png
categories: [91.기타,AI활용]
pin: true
math: true
mermaid: true
---

## 프롬프트 전문

```
아래의 데이터베이스 스키마를 DBML로 변환하려고 해.

다음에 유의해서 작성해줘.

생성된 결과물은 내가 다운로드 받을 수 있는 파일로 만들어줘. 확장자는 *.dbml이야

1. enum 타입은 별도의 타입을 정의한 후에 테이블 명세에 추가할 것.
    -예시
        Enum admin_gender_type {
            "남"
            "여"
        }

        Table admins {
            admin_gender admin_gender_type [not null, note: "관리자 성별"]
        }

2. 테이블과 컬럼의 comment 속성을 빠짐없이 포함할 것
3. 각 스키마의 구조를 먼저 작성한 후에 참조 관계는 나중에 추가할 것.
    -예시
        Table hello {
            id int [pk, increment, note: "고유 ID"]
            name varchar(255) [not null, note: "이름"]
            created_at datetime [not null, note: "생성 일시"]
        }

        Table world {
            id int [pk, increment, note: "고유 ID"]
            hello_id int [not null, note: "Hello 테이블의 ID"]
            description text [note: "설명"]
            created_at datetime [not null, note: "생성 일시"]
        }

        ref: hello.id < world.hello_id
4. 내가 업로드하는 SQL문에서 생성하는 테이블과 컬럼만 표시하고 그 외에 임의로 내용을 추가하지 않을 것.
5. 모호한 부분은 질문을 통해 명확히 할 것.
6. 테이블간의 참조 관계도 명확히 포함할 것
7. `*.dbml` 파일로 결과물을 생성하여 내가 다운로드 받을 수 있도록 할 것.

---------------

#### SQL CREATE 문 작성 ###

```