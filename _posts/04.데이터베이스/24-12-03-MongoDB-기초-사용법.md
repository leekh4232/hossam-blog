---
title:  "MongoDB 기초 사용법"
description: "NoSQL 데이터베이스인 MongoDB의 설치부터 기본 사용법까지 알아봅니다. 관계형 데이터베이스와의 차이점과 MongoDB만의 특징을 소개합니다."
categories: [04.Database,NoSQL]
tags: [Database,MongoDB,NoSQL,문서데이터베이스,기본사용법]
image: /images/indexs/data.png
date: 2024-12-03 10:00:00 +0900
author: Hossam
pin: false
math: true
mermaid: true
---

## #01. MongoDB 소개

### 1. MongoDB란?

**MongoDB**는 문서 지향 NoSQL 데이터베이스로, JSON과 유사한 BSON(Binary JSON) 형태로 데이터를 저장합니다. 스키마가 유연하고 수평적 확장이 용이하여 현대적인 애플리케이션 개발에 널리 사용됩니다.

### 2. MongoDB의 특징

- **문서 지향**: JSON 형태의 문서로 데이터 저장
- **스키마 없음**: 유연한 데이터 구조
- **수평적 확장**: 샤딩을 통한 분산 처리
- **고성능**: 메모리 매핑된 파일을 사용한 빠른 읽기/쓰기
- **풍부한 쿼리**: 복잡한 쿼리와 인덱싱 지원
- **복제**: 자동 장애 조치와 데이터 중복성

### 3. 관계형 DB vs MongoDB

| 구분 | 관계형 DB | MongoDB |
|------|-----------|---------|
| 데이터 모델 | 테이블/행/열 | 컬렉션/문서/필드 |
| 스키마 | 고정 스키마 | 동적 스키마 |
| 확장성 | 수직적 확장 | 수평적 확장 |
| 트랜잭션 | ACID 완전 지원 | 4.0부터 다중 문서 트랜잭션 |
| 조인 | 복잡한 조인 지원 | $lookup을 통한 조인 |
| 쿼리 언어 | SQL | MongoDB Query Language |

## #02. MongoDB 설치

### 1. Windows 설치

1. [MongoDB 공식 웹사이트](https://www.mongodb.com/try/download/community)에서 Community Edition 다운로드
2. MSI 설치 파일 실행
3. 설치 옵션 선택:
   - Complete 설치 선택
   - MongoDB Compass 포함 여부 선택
   - Service 설치 여부 선택

### 2. Ubuntu 설치

```bash
# GPG 키 가져오기
wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | sudo apt-key add -

# MongoDB 저장소 추가
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# 패키지 목록 업데이트
sudo apt-get update

# MongoDB 설치
sudo apt-get install -y mongodb-org

# MongoDB 서비스 시작
sudo systemctl start mongod
sudo systemctl enable mongod
```

### 3. macOS 설치

```bash
# Homebrew 사용
brew tap mongodb/brew
brew install mongodb-community

# 서비스 시작
brew services start mongodb/brew/mongodb-community
```

### 4. Docker로 설치

```bash
# MongoDB 컨테이너 실행
docker run --name mongodb -d -p 27017:27017 mongo:latest

# 환경변수와 함께 실행
docker run --name mongodb -d -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=password \
  mongo:latest
```

## #03. MongoDB Shell 기본 사용법

### 1. MongoDB Shell 접속

```bash
# 로컬 접속
mongosh

# 특정 데이터베이스로 접속
mongosh "mongodb://localhost:27017/mydb"

# 인증이 필요한 경우
mongosh "mongodb://username:password@localhost:27017/mydb"
```

### 2. 기본 명령어

```javascript
// 현재 데이터베이스 확인
db

// 데이터베이스 목록 조회
show dbs

// 데이터베이스 전환
use mydb

// 컬렉션 목록 조회
show collections

// 도움말
help

// 종료
exit
```

## #04. 데이터베이스와 컬렉션 관리

### 1. 데이터베이스 생성 및 삭제

```javascript
// 데이터베이스 생성 (사용하면 자동 생성)
use company

// 데이터베이스 삭제
db.dropDatabase()

// 현재 데이터베이스 상태 확인
db.stats()
```

### 2. 컬렉션 생성 및 삭제

```javascript
// 컬렉션 생성 (명시적)
db.createCollection("employees")

// 옵션과 함께 컬렉션 생성
db.createCollection("logs", {
  capped: true,        // 고정 크기 컬렉션
  size: 100000,        // 최대 크기 (바이트)
  max: 1000           // 최대 문서 수
})

// 컬렉션 삭제
db.employees.drop()

// 컬렉션 이름 변경
db.employees.renameCollection("staff")
```

## #05. 문서 삽입 (Create)

### 1. 단일 문서 삽입

```javascript
// insertOne() 사용
db.employees.insertOne({
  name: "김철수",
  age: 30,
  department: "개발팀",
  salary: 5000000,
  skills: ["JavaScript", "Python", "MongoDB"],
  address: {
    city: "서울",
    district: "강남구"
  },
  joinDate: new Date()
})
```

### 2. 여러 문서 삽입

```javascript
// insertMany() 사용
db.employees.insertMany([
  {
    name: "이영희",
    age: 28,
    department: "디자인팀",
    salary: 4500000,
    skills: ["Photoshop", "Illustrator"],
    address: {
      city: "서울",
      district: "마포구"
    }
  },
  {
    name: "박민수",
    age: 35,
    department: "개발팀",
    salary: 6000000,
    skills: ["Java", "Spring", "React"],
    address: {
      city: "부산",
      district: "해운대구"
    }
  }
])
```

## #06. 문서 조회 (Read)

### 1. 기본 조회

```javascript
// 모든 문서 조회
db.employees.find()

// 특정 조건으로 조회
db.employees.find({ department: "개발팀" })

// 하나의 문서만 조회
db.employees.findOne({ name: "김철수" })

// 보기 좋게 출력
db.employees.find().pretty()
```

### 2. 프로젝션 (특정 필드만 조회)

```javascript
// 이름과 부서만 조회
db.employees.find({}, { name: 1, department: 1 })

// _id 제외하고 조회
db.employees.find({}, { name: 1, department: 1, _id: 0 })

// 특정 필드 제외
db.employees.find({}, { address: 0, skills: 0 })
```

### 3. 쿼리 연산자

```javascript
// 비교 연산자
db.employees.find({ age: { $gt: 30 } })        // 나이 > 30
db.employees.find({ age: { $gte: 30 } })       // 나이 >= 30
db.employees.find({ age: { $lt: 30 } })        // 나이 < 30
db.employees.find({ age: { $lte: 30 } })       // 나이 <= 30
db.employees.find({ age: { $ne: 30 } })        // 나이 != 30
db.employees.find({ age: { $in: [25, 30, 35] } }) // 나이가 25, 30, 35 중 하나

// 논리 연산자
db.employees.find({
  $and: [
    { age: { $gt: 25 } },
    { department: "개발팀" }
  ]
})

db.employees.find({
  $or: [
    { department: "개발팀" },
    { department: "디자인팀" }
  ]
})

// 문자열 패턴 매칭
db.employees.find({ name: /김/ })              // 이름에 '김'이 포함
db.employees.find({ name: /^김/ })             // 이름이 '김'으로 시작
db.employees.find({ name: /수$/ })             // 이름이 '수'로 끝남

// 배열 쿼리
db.employees.find({ skills: "JavaScript" })   // skills 배열에 JavaScript 포함
db.employees.find({ skills: { $all: ["JavaScript", "Python"] } }) // 두 스킬 모두 포함
db.employees.find({ skills: { $size: 3 } })   // skills 배열 크기가 3

// 중첩 문서 쿼리
db.employees.find({ "address.city": "서울" })
```

### 4. 정렬과 제한

```javascript
// 정렬 (1: 오름차순, -1: 내림차순)
db.employees.find().sort({ age: 1 })           // 나이 오름차순
db.employees.find().sort({ salary: -1 })       // 급여 내림차순

// 개수 제한
db.employees.find().limit(5)                   // 상위 5개만

// 건너뛰기
db.employees.find().skip(10).limit(5)          // 10개 건너뛰고 5개

// 개수 세기
db.employees.find({ department: "개발팀" }).count()
```

## #07. 문서 수정 (Update)

### 1. 단일 문서 수정

```javascript
// updateOne() 사용
db.employees.updateOne(
  { name: "김철수" },                    // 조건
  {
    $set: {
      salary: 5500000,
      department: "시니어 개발팀"
    }
  }
)

// 증가/감소
db.employees.updateOne(
  { name: "김철수" },
  { $inc: { age: 1 } }                   // 나이 1 증가
)

// 배열에 요소 추가
db.employees.updateOne(
  { name: "김철수" },
  { $push: { skills: "Docker" } }
)

// 배열에서 요소 제거
db.employees.updateOne(
  { name: "김철수" },
  { $pull: { skills: "Python" } }
)
```

### 2. 여러 문서 수정

```javascript
// updateMany() 사용
db.employees.updateMany(
  { department: "개발팀" },
  { $inc: { salary: 500000 } }           // 개발팀 전체 급여 50만원 인상
)
```

### 3. 문서 교체

```javascript
// replaceOne() 사용 (전체 문서 교체)
db.employees.replaceOne(
  { name: "김철수" },
  {
    name: "김철수",
    age: 31,
    department: "팀장",
    salary: 7000000,
    skills: ["JavaScript", "Python", "MongoDB", "Leadership"]
  }
)
```

## #08. 문서 삭제 (Delete)

### 1. 단일 문서 삭제

```javascript
// deleteOne() 사용
db.employees.deleteOne({ name: "김철수" })
```

### 2. 여러 문서 삭제

```javascript
// deleteMany() 사용
db.employees.deleteMany({ department: "마케팅팀" })

// 모든 문서 삭제
db.employees.deleteMany({})
```

## #09. 인덱스

### 1. 인덱스 생성

```javascript
// 단일 필드 인덱스
db.employees.createIndex({ name: 1 })          // 오름차순
db.employees.createIndex({ age: -1 })          // 내림차순

// 복합 인덱스
db.employees.createIndex({ department: 1, salary: -1 })

// 텍스트 인덱스 (전문 검색)
db.employees.createIndex({ name: "text", department: "text" })

// 유니크 인덱스
db.employees.createIndex({ email: 1 }, { unique: true })

// 부분 인덱스
db.employees.createIndex(
  { salary: 1 },
  { partialFilterExpression: { salary: { $gt: 5000000 } } }
)
```

### 2. 인덱스 관리

```javascript
// 인덱스 조회
db.employees.getIndexes()

// 인덱스 삭제
db.employees.dropIndex({ name: 1 })

// 모든 인덱스 삭제 (_id 인덱스 제외)
db.employees.dropIndexes()
```

## #10. 집계 (Aggregation)

### 1. 집계 파이프라인

```javascript
// $match: 필터링
// $group: 그룹화
// $sort: 정렬
// $project: 프로젝션

db.employees.aggregate([
  // 개발팀만 필터링
  { $match: { department: "개발팀" } },

  // 부서별 그룹화 및 통계
  {
    $group: {
      _id: "$department",
      avgSalary: { $avg: "$salary" },
      count: { $sum: 1 },
      maxSalary: { $max: "$salary" },
      minSalary: { $min: "$salary" }
    }
  },

  // 평균 급여로 정렬
  { $sort: { avgSalary: -1 } }
])
```

### 2. 복잡한 집계 예시

```javascript
// 나이대별 급여 통계
db.employees.aggregate([
  {
    $addFields: {
      ageGroup: {
        $switch: {
          branches: [
            { case: { $lt: ["$age", 30] }, then: "20대" },
            { case: { $lt: ["$age", 40] }, then: "30대" },
            { case: { $gte: ["$age", 40] }, then: "40대 이상" }
          ]
        }
      }
    }
  },
  {
    $group: {
      _id: "$ageGroup",
      avgSalary: { $avg: "$salary" },
      count: { $sum: 1 }
    }
  },
  {
    $sort: { avgSalary: -1 }
  }
])
```

## #11. 트랜잭션

### 1. 단일 문서 트랜잭션 (자동)

```javascript
// MongoDB는 단일 문서 작업에 대해 자동으로 원자성 보장
db.employees.updateOne(
  { name: "김철수" },
  {
    $inc: { salary: 1000000 },
    $push: { skills: "Management" }
  }
)
```

### 2. 다중 문서 트랜잭션

```javascript
// 세션 시작
const session = db.getMongo().startSession()

try {
  // 트랜잭션 시작
  session.startTransaction()

  // 트랜잭션 내 작업
  db.employees.updateOne(
    { name: "김철수" },
    { $inc: { salary: -1000000 } },
    { session: session }
  )

  db.employees.updateOne(
    { name: "이영희" },
    { $inc: { salary: 1000000 } },
    { session: session }
  )

  // 트랜잭션 커밋
  session.commitTransaction()
} catch (error) {
  // 트랜잭션 롤백
  session.abortTransaction()
  throw error
} finally {
  // 세션 종료
  session.endSession()
}
```

## #12. 백업과 복원

### 1. mongodump를 이용한 백업

```bash
# 전체 데이터베이스 백업
mongodump --db company --out /backup

# 특정 컬렉션 백업
mongodump --db company --collection employees --out /backup

# 원격 데이터베이스 백업
mongodump --host mongodb.example.com --port 27017 --db company --out /backup
```

### 2. mongorestore를 이용한 복원

```bash
# 데이터베이스 복원
mongorestore --db company /backup/company

# 특정 컬렉션 복원
mongorestore --db company --collection employees /backup/company/employees.bson
```

## #13. 성능 최적화

### 1. 쿼리 성능 분석

```javascript
// 실행 계획 확인
db.employees.find({ department: "개발팀" }).explain("executionStats")

// 인덱스 힌트 사용
db.employees.find({ department: "개발팀" }).hint({ department: 1 })
```

### 2. 프로파일링

```javascript
// 프로파일링 활성화 (느린 쿼리만)
db.setProfilingLevel(1, { slowms: 100 })

// 프로파일링 결과 조회
db.system.profile.find().sort({ ts: -1 }).limit(5)
```

## #14. 마무리

MongoDB는 유연한 스키마와 강력한 쿼리 기능을 제공하는 NoSQL 데이터베이스입니다. 특히 JSON 형태의 문서 저장과 수평적 확장성이 뛰어나 현대적인 웹 애플리케이션 개발에 적합합니다.

관계형 데이터베이스와는 다른 접근 방식이 필요하지만, 적절히 활용하면 개발 생산성과 성능 면에서 큰 이점을 얻을 수 있습니다.
