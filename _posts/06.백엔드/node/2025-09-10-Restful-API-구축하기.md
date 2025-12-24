---
title: Node.js - RESTful API 구축하기
description: "Express와 MyBatis를 활용하여 departments 테이블에 대한 완전한 CRUD RESTful API를 구축하는 방법을 학습합니다."
categories: [06.Backend,Node]
date:   2025-09-10 09:00:00 +0900
author: Hossam
image: /images/indexs/restapi.png
tags: [Web Development,Backend,Node,Express,REST API,CRUD,MyBatis,Database]
pin: true
math: true
mermaid: true
---

# RESTful API 구축하기

이번 포스팅에서는 앞서 학습한 MyBatis Helper와 Router Helper를 활용하여 departments 테이블에 대한 완전한 CRUD RESTful API를 구축해보겠습니다. 실무에서 사용되는 표준적인 REST API 설계 패턴을 따르며, 일관된 응답 형식과 적절한 HTTP 상태 코드를 사용하는 방법을 학습합니다.

## 1. RESTful API 설계 개요

### 구현할 주요 기능

1. **완전한 CRUD 지원**: Create, Read, Update, Delete 모든 작업 지원
2. **RESTful 설계**: 표준 HTTP 메서드와 적절한 상태 코드 사용
3. **일관된 응답 형식**: 모든 API가 동일한 JSON 구조 사용
4. **강력한 에러 처리**: 다양한 예외 상황에 대한 적절한 처리
5. **상세한 로깅**: 디버깅과 모니터링을 위한 상세 로그
6. **입력값 검증**: 필수값과 데이터 형식 검증

### API 엔드포인트 설계

departments 테이블에 대한 CRUD 작업을 수행하는 RESTful API를 다음과 같이 설계합니다:

| HTTP Method | URL | 설명 | 요청 데이터 | 응답 |
|-------------|-----|------|-------------|------|
| **GET** | `/api/departments` | 전체 학과 목록 조회 | 쿼리 파라미터: `dname`, `loc`, `limit` | 학과 목록 + 페이징 정보 |
| **GET** | `/api/departments/:id` | 특정 학과 조회 | URL 파라미터: `id` | 단일 학과 정보 |
| **POST** | `/api/departments` | 새 학과 추가 | FormData: `dname`, `loc`, `phone`, `email`, `established`, `homepage` | 추가된 학과 정보 |
| **PUT** | `/api/departments/:id` | 기존 학과 수정 | URL 파라미터: `id` + FormData | 수정된 학과 정보 |
| **DELETE** | `/api/departments/:id` | 학과 삭제 | URL 파라미터: `id` | 삭제된 학과 정보 |


### 응답 형식 표준화

모든 API는 다음과 같은 일관된 JSON 응답 형식을 사용합니다:

```json
{
    "status": 200,
    "message": "OK",
    "item": { /* 데이터 */ },
    "pagenation": { // 목록 조회시에만
        "totalCount": 15,
        "listCount": 10
    },
    "timestamp": "2025-09-10T10:30:45.123Z"
}
```

### 사용할 Helper 클래스들

- **MybatisHelper**: 데이터베이스 연동 및 SQL 실행
- **RouteHelper**: 데코레이터 기반 자동 라우팅 등록
- **LogHelper**: 상세한 로깅
- **ExceptionHelper**: 커스텀 예외 처리

## 2. 프로젝트 구조 준비

### API 컨트롤러 폴더 생성

기존의 일반 컨트롤러와 API 컨트롤러를 구분하기 위해 별도 폴더를 생성합니다:

```
controllers/
├── HelloController.js
├── MvcController.js
├── UserController.js
└── api/
    └── DepartmentApiController.js  ← 새로 생성할 파일
```

### 자동 라우팅 설정 확인

`app.js`에서 `fsFileTree` 모듈이 `recursive: true` 옵션으로 설정되어 있어 `controllers/api` 폴더까지 자동으로 스캔됩니다:

```javascript
const files = await fsFileTree('./controllers', { ext: '.js', recursive: true });
```

## 3. DepartmentApiController 뼈대 구성

먼저 전체적인 구조를 파악할 수 있도록 메서드 정의부터 살펴보겠습니다.

### 모듈 import 및 기본 구조

```javascript
/**
 * @filename: DepartmentApiController.js
 * @description: 학과 정보에 대한 RESTful API를 제공하는 컨트롤러
 */

/*----------------------------------------------------------
 * 모듈 참조
 *----------------------------------------------------------*/
import mybatis from '../../helpers/MybatisHelper.js';
import logger from '../../helpers/LogHelper.js';
import { GET, POST, PUT, DELETE } from '../../helpers/RouteHelper.js';

/*----------------------------------------------------------
 * API 함수 정의
 *----------------------------------------------------------*/

/**
 * 전체 학과 목록 조회 (GET /api/departments)
 */
export const getDepartments = GET('/api/departments')(async (req, res) => {
    // 구현부는 뒤에서 설명
});

/**
 * 특정 학과 정보 조회 (GET /api/departments/:id)
 */
export const getDepartment = GET('/api/departments/:id')(async (req, res) => {
    // 구현부는 뒤에서 설명
});

/**
 * 새로운 학과 정보 추가 (POST /api/departments)
 */
export const addDepartment = POST('/api/departments')(async (req, res) => {
    // 구현부는 뒤에서 설명
});

/**
 * 기존 학과 정보 수정 (PUT /api/departments/:id)
 */
export const updateDepartment = PUT('/api/departments/:id')(async (req, res) => {
    // 구현부는 뒤에서 설명
});

/**
 * 학과 정보 삭제 (DELETE /api/departments/:id)
 */
export const deleteDepartment = DELETE('/api/departments/:id')(async (req, res) => {
    // 구현부는 뒤에서 설명
});
```

### 주요 특징

1. **RouteHelper 데코레이터**: `@GET`, `@POST`, `@PUT`, `@DELETE` 데코레이터를 사용하여 자동 라우팅
2. **MyBatis 연동**: 미리 구현된 `DepartmentMapper.xml`의 SQL 쿼리 활용
3. **일관된 응답 형식**: 모든 API가 동일한 JSON 구조로 응답
4. **상세한 로깅**: 각 단계별 로그 기록으로 디버깅 용이성 확보

## 4. 단계별 구현

### 4-1. 전체 학과 목록 조회 (GET /api/departments)

목록 조회 API는 검색 조건과 페이징을 지원합니다.

```javascript
export const getDepartments = GET('/api/departments')(async (req, res) => {
    logger.debug('[DepartmentApiController:getDepartments] 학과 목록 조회 요청');

    // 검색 조건 파라미터 처리
    const params = {
        dname: req.query.dname || null,    // 학과명 검색
        loc: req.query.loc || null,        // 위치 검색
        limit: req.query.limit ? parseInt(req.query.limit) : null  // 결과 제한
    };

    let json = null;

    try {
        // 전체 데이터 수 조회 (페이징 정보 제공용)
        const totalCount = await mybatis.execute('DepartmentMapper.selectCountAll', params);

        // 목록 조회
        const list = await mybatis.execute('DepartmentMapper.selectList', params);

        json = {
            status: 200,
            message: 'OK',
            item: list,
            pagenation: {
                totalCount: totalCount,
                listCount: list.length
            },
            timestamp: new Date().toISOString()
        };

        logger.debug(`[DepartmentApiController:getDepartments] 조회 완료 - 총 ${totalCount}건 중 ${list.length}건`);

    } catch (err) {
        logger.error('[DepartmentApiController:getDepartments] 데이터베이스 조회 실패', err);

        json = {
            status: 500,
            message: err.message,
            timestamp: new Date().toISOString()
        };
    }

    res.status(json.status).json(json);
});
```

**주요 포인트:**
- **쿼리 파라미터 처리**: `req.query`를 통해 검색 조건 수집
- **페이징 정보**: 전체 건수와 현재 결과 건수를 함께 제공
- **에러 처리**: try-catch로 데이터베이스 오류 처리
- **로깅**: 요청과 결과를 상세히 기록

### 4-2. 특정 학과 조회 (GET /api/departments/:id)

단일 데이터 조회 API는 URL 파라미터로 전달된 ID를 사용합니다.

```javascript
export const getDepartment = GET('/api/departments/:id')(async (req, res) => {
    const id = parseInt(req.params.id);

    logger.debug(`[DepartmentApiController:getDepartment] 학과 조회 요청 - ID: ${id}`);

    // 파라미터 유효성 검사
    if (!id || isNaN(id)) {
        const json = {
            status: 400,
            message: '올바른 학과 ID를 입력하세요.',
            timestamp: new Date().toISOString()
        };
        return res.status(400).json(json);
    }

    let json = null;

    try {
        const item = await mybatis.execute('DepartmentMapper.selectItem', { id });

        if (!item || item.length === 0) {
            json = {
                status: 404,
                message: '해당 학과를 찾을 수 없습니다.',
                timestamp: new Date().toISOString()
            };
        } else {
            json = {
                status: 200,
                message: 'OK',
                item: item[0],
                timestamp: new Date().toISOString()
            };
            logger.debug(`[DepartmentApiController:getDepartment] 조회 완료 - ${item[0].dname}`);
        }

    } catch (err) {
        logger.error('[DepartmentApiController:getDepartment] 데이터베이스 조회 실패', err);

        json = {
            status: 500,
            message: err.message,
            timestamp: new Date().toISOString()
        };
    }

    res.status(json.status).json(json);
});
```

**주요 포인트:**
- **URL 파라미터 처리**: `req.params.id`로 ID 추출
- **입력값 검증**: ID가 숫자인지 확인
- **404 처리**: 해당 데이터가 없을 경우 적절한 상태 코드 반환
- **단일 객체 반환**: 배열의 첫 번째 요소만 반환

### 4-3. 새 학과 추가 (POST /api/departments)

데이터 생성 API는 FormData로 전송된 정보를 처리합니다.

```javascript
export const addDepartment = POST('/api/departments')(async (req, res) => {
    logger.debug('[DepartmentApiController:addDepartment] 학과 추가 요청');
    logger.debug('Request body:', req.body);

    // 필수 파라미터 검증
    const { dname, loc } = req.body;

    if (!dname || !dname.trim()) {
        const json = {
            status: 400,
            message: '학과명은 필수 입력 항목입니다.',
            timestamp: new Date().toISOString()
        };
        return res.status(400).json(json);
    }

    if (!loc || !loc.trim()) {
        const json = {
            status: 400,
            message: '위치는 필수 입력 항목입니다.',
            timestamp: new Date().toISOString()
        };
        return res.status(400).json(json);
    }

    // 파라미터 정리 (trim 처리 및 null 변환)
    const params = {
        dname: dname.trim(),
        loc: loc.trim(),
        phone: req.body.phone ? req.body.phone.trim() : null,
        email: req.body.email ? req.body.email.trim() : null,
        established: req.body.established ? req.body.established.trim() : null,
        homepage: req.body.homepage ? req.body.homepage.trim() : null
    };

    let json = null;

    try {
        const insertId = await mybatis.execute('DepartmentMapper.insertItem', params);

        // 추가된 데이터 조회 (클라이언트에게 완성된 데이터 반환)
        const item = await mybatis.execute('DepartmentMapper.selectItem', { id: insertId });

        json = {
            status: 201,
            message: '학과 정보가 성공적으로 추가되었습니다.',
            item: item[0],
            timestamp: new Date().toISOString()
        };

        logger.debug(`[DepartmentApiController:addDepartment] 추가 완료 - ID: ${insertId}, 학과명: ${params.dname}`);

    } catch (err) {
        logger.error('[DepartmentApiController:addDepartment] 데이터베이스 추가 실패', err);

        json = {
            status: 500,
            message: err.message,
            timestamp: new Date().toISOString()
        };
    }

    res.status(json.status).json(json);
});
```

**주요 포인트:**
- **FormData 처리**: `req.body`를 통해 폼 데이터 수집
- **필수값 검증**: 학과명과 위치는 반드시 입력되어야 함
- **데이터 정제**: `trim()` 함수로 공백 제거, 빈 문자열은 null로 변환
- **201 상태 코드**: 생성 성공 시 적절한 HTTP 상태 코드 사용
- **생성된 데이터 반환**: INSERT 후 실제 저장된 데이터를 다시 조회하여 반환

### 4-4. 기존 학과 수정 (PUT /api/departments/:id)

데이터 수정 API는 부분 업데이트를 지원합니다.

```javascript
export const updateDepartment = PUT('/api/departments/:id')(async (req, res) => {
    const id = parseInt(req.params.id);

    logger.debug(`[DepartmentApiController:updateDepartment] 학과 수정 요청 - ID: ${id}`);
    logger.debug('Request body:', req.body);

    // 파라미터 유효성 검사
    if (!id || isNaN(id)) {
        const json = {
            status: 400,
            message: '올바른 학과 ID를 입력하세요.',
            timestamp: new Date().toISOString()
        };
        return res.status(400).json(json);
    }

    let json = null;

    try {
        // 기존 데이터 존재 여부 확인
        const existingItem = await mybatis.execute('DepartmentMapper.selectItem', { id });

        if (!existingItem || existingItem.length === 0) {
            json = {
                status: 404,
                message: '수정할 학과를 찾을 수 없습니다.',
                timestamp: new Date().toISOString()
            };
            return res.status(404).json(json);
        }

        // 수정할 파라미터 정리 (전송된 필드만 업데이트)
        const params = { id };

        if (req.body.dname && req.body.dname.trim()) {
            params.dname = req.body.dname.trim();
        }
        if (req.body.loc && req.body.loc.trim()) {
            params.loc = req.body.loc.trim();
        }
        if (req.body.phone !== undefined) {
            params.phone = req.body.phone ? req.body.phone.trim() : null;
        }
        if (req.body.email !== undefined) {
            params.email = req.body.email ? req.body.email.trim() : null;
        }
        if (req.body.established !== undefined) {
            params.established = req.body.established ? req.body.established.trim() : null;
        }
        if (req.body.homepage !== undefined) {
            params.homepage = req.body.homepage ? req.body.homepage.trim() : null;
        }

        const affectedRows = await mybatis.execute('DepartmentMapper.updateItem', params);

        if (affectedRows > 0) {
            // 수정된 데이터 조회
            const updatedItem = await mybatis.execute('DepartmentMapper.selectItem', { id });

            json = {
                status: 200,
                message: '학과 정보가 성공적으로 수정되었습니다.',
                item: updatedItem[0],
                timestamp: new Date().toISOString()
            };

            logger.debug(`[DepartmentApiController:updateDepartment] 수정 완료 - ID: ${id}`);
        } else {
            json = {
                status: 500,
                message: '학과 정보 수정에 실패했습니다.',
                timestamp: new Date().toISOString()
            };
        }

    } catch (err) {
        logger.error('[DepartmentApiController:updateDepartment] 데이터베이스 수정 실패', err);

        json = {
            status: 500,
            message: err.message,
            timestamp: new Date().toISOString()
        };
    }

    res.status(json.status).json(json);
});
```

**주요 포인트:**
- **존재 여부 확인**: 수정 전 해당 데이터가 존재하는지 검증
- **부분 업데이트**: 전송된 필드만 업데이트 (전체 교체가 아님)
- **undefined 체크**: `req.body.field !== undefined`로 실제 전송된 필드 구분
- **수정 결과 확인**: `affectedRows`로 실제 수정 여부 확인

### 4-5. 학과 삭제 (DELETE /api/departments/:id)

데이터 삭제 API는 안전한 삭제를 위해 사전 검증을 수행합니다.

```javascript
export const deleteDepartment = DELETE('/api/departments/:id')(async (req, res) => {
    const id = parseInt(req.params.id);

    logger.debug(`[DepartmentApiController:deleteDepartment] 학과 삭제 요청 - ID: ${id}`);

    // 파라미터 유효성 검사
    if (!id || isNaN(id)) {
        const json = {
            status: 400,
            message: '올바른 학과 ID를 입력하세요.',
            timestamp: new Date().toISOString()
        };
        return res.status(400).json(json);
    }

    let json = null;

    try {
        // 기존 데이터 존재 여부 확인 (삭제 전 정보 보존용)
        const existingItem = await mybatis.execute('DepartmentMapper.selectItem', { id });

        if (!existingItem || existingItem.length === 0) {
            json = {
                status: 404,
                message: '삭제할 학과를 찾을 수 없습니다.',
                timestamp: new Date().toISOString()
            };
            return res.status(404).json(json);
        }

        const affectedRows = await mybatis.execute('DepartmentMapper.deleteItem', { id });

        if (affectedRows > 0) {
            json = {
                status: 200,
                message: '학과 정보가 성공적으로 삭제되었습니다.',
                item: {
                    deletedId: id,
                    deletedName: existingItem[0].dname
                },
                timestamp: new Date().toISOString()
            };

            logger.debug(`[DepartmentApiController:deleteDepartment] 삭제 완료 - ID: ${id}, 학과명: ${existingItem[0].dname}`);
        } else {
            json = {
                status: 500,
                message: '학과 정보 삭제에 실패했습니다.',
                timestamp: new Date().toISOString()
            };
        }

    } catch (err) {
        logger.error('[DepartmentApiController:deleteDepartment] 데이터베이스 삭제 실패', err);

        json = {
            status: 500,
            message: err.message,
            timestamp: new Date().toISOString()
        };
    }

    res.status(json.status).json(json);
});
```

**주요 포인트:**
- **삭제 전 검증**: 삭제할 데이터가 실제로 존재하는지 확인
- **삭제 정보 반환**: 삭제된 데이터의 ID와 이름을 응답에 포함
- **트랜잭션 고려**: 실제 프로덕션에서는 관련 데이터 정리도 고려해야 함

## 5. API 테스트 방법

### Postman을 이용한 테스트

각 API 엔드포인트를 Postman이나 ThunderClient로 테스트할 수 있습니다:

**1) 목록 조회**
```
GET http://localhost:8080/api/departments
GET http://localhost:8080/api/departments?dname=컴퓨터
GET http://localhost:8080/api/departments?limit=5
```

**2) 단일 조회**
```
GET http://localhost:8080/api/departments/1
```

**3) 데이터 추가**
```
POST http://localhost:8080/api/departments
Content-Type: application/x-www-form-urlencoded

dname=컴퓨터공학과&loc=공학관&phone=02-1234-5678&email=cs@university.ac.kr
```

**4) 데이터 수정**
```
PUT http://localhost:8080/api/departments/1
Content-Type: application/x-www-form-urlencoded

dname=소프트웨어학과&phone=02-9876-5432
```

**5) 데이터 삭제**
```
DELETE http://localhost:8080/api/departments/1
```
