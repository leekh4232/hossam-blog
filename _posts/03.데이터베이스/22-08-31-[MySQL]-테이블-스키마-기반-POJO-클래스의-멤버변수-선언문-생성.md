---
layout: post
title:  "[MySQL] 테이블 스키마 기반 POJO 클래스의 멤버변수 선언문 생성"
date:   2022-10-27
banner_image: 2022/1028/index.jpg
tags: [Database]
---

MySQL의 information_schema 데이터베이스에 저장되어 있는 테이블 정보들을 통해 Java에서 사용할 Pojo 클래스의 멤버변수 이름을 자동으로 생성하는 쿼리 입니다.

<!--more-->

# 구문형식

```sql
SELECT CONCAT('private ', if(DATA_TYPE = 'int', 'int ', 'String '), LOWER(COLUMN_NAME), ';', if(COLUMN_COMMENT='', '', concat(' \t // ', COLUMN_COMMENT))) AS `value`
FROM information_schema.columns
WHERE table_schema = 'DB이름' AND table_name = '테이블이름';
```

# 사용예시

```sql
SELECT CONCAT('private ', if(DATA_TYPE = 'int', 'int ', 'String '), LOWER(COLUMN_NAME), ';', if(COLUMN_COMMENT='', '', concat(' \t // ', COLUMN_COMMENT))) AS `value`
FROM information_schema.columns
WHERE table_schema = 'myschool' AND table_name = 'student';
```

# 결과

```
+--------------------------------------------------+
| value                                            |
+--------------------------------------------------+
| private int studno;       // 학생번호            |
| private String name;      // 이름                |
| private String userid;    // 아이디              |
| private int grade;        // 학년                |
| private String idnum;     // 주민번호            |
| private String birthdate; // 생년월일            |
| private String tel;       // 전화번호            |
| private int height;       // 키                  |
| private int weight;       // 몸무게              |
| private int deptno;       // 학과번호            |
| private int profno;       // 담당교수의 일련번호 |
+--------------------------------------------------+
```