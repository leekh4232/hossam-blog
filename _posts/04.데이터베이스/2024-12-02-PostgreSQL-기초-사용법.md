---
title:  "PostgreSQL 기초 사용법"
description: "오픈소스 관계형 데이터베이스인 PostgreSQL의 설치부터 기본 사용법까지 알아봅니다. MySQL과의 차이점과 PostgreSQL만의 고급 기능들을 소개합니다."
categories: [04.Database,PostgreSQL]
tags: [Database,PostgreSQL,설치,기본사용법,SQL]
image: /images/indexs/data.png
date: 2024-12-02 10:00:00 +0900
author: Hossam
pin: false
math: true
mermaid: true
---

## #01. PostgreSQL 소개

### 1. PostgreSQL이란?

**PostgreSQL**은 확장 가능성과 SQL 표준 호환성을 강조하는 객체-관계형 데이터베이스 관리 시스템입니다. 30년 이상의 개발 역사를 가진 오픈소스 데이터베이스로, 신뢰성과 강력한 기능으로 유명합니다.

### 2. PostgreSQL의 특징

- **ACID 준수**: 완전한 트랜잭션 지원
- **다양한 데이터 타입**: JSON, Array, UUID 등 지원
- **확장성**: 사용자 정의 함수, 연산자, 데이터 타입 생성 가능
- **동시성**: MVCC(Multi-Version Concurrency Control) 지원
- **표준 준수**: SQL 표준에 가장 가까운 구현
- **크로스 플랫폼**: Windows, Linux, macOS 지원

### 3. MySQL과의 주요 차이점

| 구분 | PostgreSQL | MySQL |
|------|------------|-------|
| 라이선스 | PostgreSQL License (MIT 유사) | GPL/Commercial |
| ACID 준수 | 완전 지원 | 엔진에 따라 다름 |
| 복잡한 쿼리 | 우수 | 제한적 |
| JSON 지원 | 네이티브 지원 | 5.7부터 지원 |
| 전문 검색 | 내장 | 외부 엔진 필요 |
| 윈도우 함수 | 완전 지원 | 8.0부터 지원 |

## #02. PostgreSQL 설치

### 1. Windows 설치

1. [PostgreSQL 공식 웹사이트](https://www.postgresql.org/download/windows/)에서 설치 파일 다운로드
2. 설치 마법사를 따라 설치 진행
3. 설치 중 설정할 항목:
   - 설치 경로
   - 데이터 디렉토리
   - 포트 번호 (기본값: 5432)
   - superuser 비밀번호

### 2. Ubuntu 설치

```bash
# 패키지 목록 업데이트
sudo apt update

# PostgreSQL 설치
sudo apt install postgresql postgresql-contrib

# PostgreSQL 서비스 시작
sudo systemctl start postgresql
sudo systemctl enable postgresql

# postgres 사용자로 전환
sudo -i -u postgres

# psql 접속
psql
```

### 3. macOS 설치

```bash
# Homebrew 사용
brew install postgresql

# 서비스 시작
brew services start postgresql

# 데이터베이스 초기화 (필요한 경우)
initdb /usr/local/var/postgres
```

## #03. 기본 명령어

### 1. psql 접속

```bash
# 로컬 접속
psql -U username -d database_name

# 원격 접속
psql -h hostname -p port -U username -d database_name

# 예시
psql -U postgres -d postgres
```

### 2. psql 내부 명령어

```sql
-- 데이터베이스 목록 조회
\l

-- 테이블 목록 조회
\dt

-- 테이블 구조 확인
\d table_name

-- 사용자 목록 조회
\du

-- 현재 연결 정보 확인
\conninfo

-- 도움말
\h

-- psql 종료
\q
```

## #04. 데이터베이스 및 사용자 관리

### 1. 데이터베이스 생성

```sql
-- 기본 데이터베이스 생성
CREATE DATABASE mydb;

-- 옵션을 포함한 데이터베이스 생성
CREATE DATABASE mydb
    WITH OWNER = myuser
    ENCODING = 'UTF8'
    LC_COLLATE = 'ko_KR.UTF-8'
    LC_CTYPE = 'ko_KR.UTF-8'
    TEMPLATE = template0;
```

### 2. 사용자 생성 및 권한 관리

```sql
-- 사용자 생성
CREATE USER myuser WITH PASSWORD 'mypassword';

-- 로그인 권한 부여
ALTER USER myuser LOGIN;

-- 데이터베이스 생성 권한 부여
ALTER USER myuser CREATEDB;

-- 데이터베이스 소유권 변경
ALTER DATABASE mydb OWNER TO myuser;

-- 특정 데이터베이스에 대한 권한 부여
GRANT ALL PRIVILEGES ON DATABASE mydb TO myuser;

-- 테이블에 대한 권한 부여
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO myuser;
```

### 3. 데이터베이스 삭제

```sql
-- 데이터베이스 삭제
DROP DATABASE mydb;

-- 사용자 삭제
DROP USER myuser;
```

## #05. 테이블 생성 및 관리

### 1. 기본 테이블 생성

```sql
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    salary NUMERIC(10,2),
    hire_date DATE DEFAULT CURRENT_DATE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2. PostgreSQL 고유 데이터 타입

```sql
CREATE TABLE example_types (
    id SERIAL PRIMARY KEY,
    -- JSON 타입
    data JSON,
    metadata JSONB,

    -- 배열 타입
    tags TEXT[],
    scores INTEGER[],

    -- UUID 타입
    uuid_field UUID DEFAULT gen_random_uuid(),

    -- 네트워크 타입
    ip_address INET,
    mac_address MACADDR,

    -- 범위 타입
    price_range NUMRANGE,
    date_range DATERANGE,

    -- 기하학적 타입
    location POINT,
    area POLYGON
);
```

### 3. 테이블 수정

```sql
-- 컬럼 추가
ALTER TABLE employees ADD COLUMN department_id INTEGER;

-- 컬럼 수정
ALTER TABLE employees ALTER COLUMN salary TYPE NUMERIC(12,2);

-- 컬럼 삭제
ALTER TABLE employees DROP COLUMN is_active;

-- 제약조건 추가
ALTER TABLE employees ADD CONSTRAINT fk_department
    FOREIGN KEY (department_id) REFERENCES departments(id);

-- 인덱스 생성
CREATE INDEX idx_employees_email ON employees(email);
CREATE INDEX idx_employees_name ON employees(first_name, last_name);
```

## #06. 고급 기능

### 1. JSON/JSONB 다루기

```sql
-- JSON 데이터 삽입
INSERT INTO example_types (data, metadata) VALUES (
    '{"name": "John", "age": 30}',
    '{"skills": ["PostgreSQL", "Python"], "level": "advanced"}'
);

-- JSON 데이터 조회
SELECT
    data->>'name' AS name,
    data->>'age' AS age,
    metadata->'skills' AS skills,
    metadata->>'level' AS level
FROM example_types;

-- JSONB 인덱스 생성
CREATE INDEX idx_metadata_gin ON example_types USING GIN (metadata);

-- JSON 경로로 검색
SELECT * FROM example_types
WHERE metadata @> '{"level": "advanced"}';
```

### 2. 배열 다루기

```sql
-- 배열 데이터 삽입
INSERT INTO example_types (tags, scores) VALUES (
    ARRAY['postgresql', 'database', 'sql'],
    ARRAY[95, 87, 92]
);

-- 배열 조회
SELECT
    tags[1] AS first_tag,
    array_length(tags, 1) AS tag_count,
    scores[1:2] AS first_two_scores
FROM example_types;

-- 배열 요소 검색
SELECT * FROM example_types
WHERE 'postgresql' = ANY(tags);

-- 배열 함수 사용
SELECT
    unnest(tags) AS tag,
    unnest(scores) AS score
FROM example_types;
```

### 3. 윈도우 함수

```sql
-- 순위 함수
SELECT
    first_name,
    last_name,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num,
    RANK() OVER (ORDER BY salary DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank
FROM employees;

-- 집계 윈도우 함수
SELECT
    first_name,
    salary,
    SUM(salary) OVER (ORDER BY hire_date) AS running_total,
    AVG(salary) OVER (PARTITION BY department_id) AS dept_avg_salary
FROM employees;
```

### 4. CTE(Common Table Expression)

```sql
-- 재귀 CTE로 조직도 표현
WITH RECURSIVE org_chart AS (
    -- 기준 쿼리 (최상위 관리자)
    SELECT id, first_name, last_name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- 재귀 쿼리
    SELECT e.id, e.first_name, e.last_name, e.manager_id, oc.level + 1
    FROM employees e
    INNER JOIN org_chart oc ON e.manager_id = oc.id
)
SELECT * FROM org_chart ORDER BY level, first_name;
```

## #07. 성능 최적화

### 1. EXPLAIN을 이용한 쿼리 분석

```sql
-- 실행 계획 확인
EXPLAIN SELECT * FROM employees WHERE salary > 50000;

-- 실제 실행 통계 포함
EXPLAIN ANALYZE SELECT * FROM employees WHERE salary > 50000;

-- 상세 정보 포함
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT * FROM employees WHERE salary > 50000;
```

### 2. 인덱스 최적화

```sql
-- 부분 인덱스
CREATE INDEX idx_high_salary ON employees(salary)
WHERE salary > 100000;

-- 표현식 인덱스
CREATE INDEX idx_lower_email ON employees(LOWER(email));

-- 복합 인덱스
CREATE INDEX idx_name_salary ON employees(last_name, first_name, salary);

-- GIN 인덱스 (전문 검색)
CREATE INDEX idx_fulltext ON employees
USING GIN(to_tsvector('english', first_name || ' ' || last_name));
```

### 3. 테이블 파티셔닝

```sql
-- 범위 파티셔닝
CREATE TABLE sales (
    id SERIAL,
    sale_date DATE NOT NULL,
    amount NUMERIC(10,2)
) PARTITION BY RANGE (sale_date);

-- 파티션 생성
CREATE TABLE sales_2023 PARTITION OF sales
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE sales_2024 PARTITION OF sales
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');
```

## #08. 백업과 복원

### 1. pg_dump를 이용한 백업

```bash
# 전체 데이터베이스 백업
pg_dump -U username -h hostname database_name > backup.sql

# 압축 백업
pg_dump -U username -h hostname -Fc database_name > backup.dump

# 스키마만 백업
pg_dump -U username -h hostname --schema-only database_name > schema.sql

# 데이터만 백업
pg_dump -U username -h hostname --data-only database_name > data.sql
```

### 2. 복원

```bash
# SQL 파일 복원
psql -U username -h hostname database_name < backup.sql

# 압축 파일 복원
pg_restore -U username -h hostname -d database_name backup.dump

# 특정 테이블만 복원
pg_restore -U username -h hostname -d database_name -t table_name backup.dump
```

## #09. 보안 설정

### 1. pg_hba.conf 설정

```conf
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# 로컬 연결
local   all             postgres                                peer
local   all             all                                     md5

# IPv4 로컬 연결
host    all             all             127.0.0.1/32            md5

# IPv6 로컬 연결
host    all             all             ::1/128                 md5

# 원격 연결 (특정 IP만 허용)
host    all             all             192.168.1.0/24          md5
```

### 2. SSL 설정

```sql
-- SSL 강제 설정
ALTER SYSTEM SET ssl = on;
ALTER SYSTEM SET ssl_cert_file = 'server.crt';
ALTER SYSTEM SET ssl_key_file = 'server.key';

-- 설정 리로드
SELECT pg_reload_conf();
```

## #10. 모니터링

### 1. 활성 연결 확인

```sql
-- 현재 활성 연결 조회
SELECT
    pid,
    usename,
    application_name,
    client_addr,
    state,
    query_start,
    query
FROM pg_stat_activity
WHERE state = 'active';
```

### 2. 테이블 통계 정보

```sql
-- 테이블별 통계
SELECT
    schemaname,
    tablename,
    n_tup_ins AS inserts,
    n_tup_upd AS updates,
    n_tup_del AS deletes,
    n_live_tup AS live_tuples,
    n_dead_tup AS dead_tuples
FROM pg_stat_user_tables;
```

## #11. 마무리

PostgreSQL은 강력한 기능과 확장성을 제공하는 엔터프라이즈급 데이터베이스입니다. JSON 지원, 배열 타입, 윈도우 함수 등의 고급 기능을 활용하면 복잡한 데이터 처리도 효율적으로 수행할 수 있습니다.

특히 데이터 무결성과 동시성이 중요한 애플리케이션에서는 PostgreSQL의 MVCC와 ACID 준수 특성이 큰 장점이 됩니다.
