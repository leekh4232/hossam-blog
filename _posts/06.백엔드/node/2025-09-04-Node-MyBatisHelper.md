---
title: MyBatis 헬퍼 클래스 활용
description: "MyBatis와 DBHelper를 통합 관리하는 헬퍼 클래스를 만들어 데이터베이스 연동 로직을 캡슐화하고, 코드의 재사용성과 가독성을 높이는 방법을 학습합니다."
categories: [06.Backend,Node]
date:   2025-09-04 09:00:00 +0900
author: Hossam
image: /images/indexs/database.jpg
tags: [Web Development,Backend,Node,Database,MySQL,MyBatis,Helper,Refactoring]
pin: true
math: true
mermaid: true
---

# MyBatis 헬퍼 클래스 활용하기

이전 시간에는 `mybatis-mapper`를 사용하여 SQL 쿼리를 XML 파일로 분리하고, `DBHelper`를 통해 데이터베이스와 연동하는 방법을 배웠습니다. 하지만 각 스크립트 파일마다 `mybatisMapper.createMapper()`를 호출하여 초기화하고, `getStatement()`로 SQL문을 생성한 뒤 `dbHelper.query()`로 실행하는 과정이 반복되어 코드가 길고 번거로운 단점이 있었습니다.

이번 시간에는 이러한 반복적인 작업을 캡슐화하고 데이터베이스 연동 로직을 중앙에서 관리하는 `MyBatisHelper` 클래스를 만들어 보겠습니다. 이 헬퍼 클래스를 통해 우리는 더욱 간결하고 유지보수하기 쉬운 코드를 작성할 수 있게 됩니다.

## 1. `MyBatisHelper` 클래스 설계 및 구현

`MyBatisHelper`의 핵심 목표는 다음과 같습니다.

-   **싱글톤 패턴**: 애플리케이션 전체에서 단 하나의 인스턴스만 생성하여 데이터베이스 연결과 매퍼 설정을 공유합니다.
-   **자동 매퍼 로딩**: 지정된 폴더의 모든 Mapper XML 파일을 자동으로 로드하여 초기화합니다.
-   **통합 실행 메서드**: `execute()` 메서드 하나로 모든 종류의 SQL(SELECT, INSERT, UPDATE, DELETE)을 실행하고, 결과도 일관된 형식으로 반환합니다.
-   **트랜잭션 지원**: 복잡한 트랜잭션 처리를 간편하게 수행할 수 있는 `transaction()` 메서드를 제공합니다.

우선 환경설정 파일에 mapper 파일이 위치하는 경로를 지정해 줍니다.

**실습: `/.env`**

```env
# MyBatis Mapper 경로
MAPPER_PATH=./mappers
```

이러한 목표를 바탕으로 작성된 `MyBatisHelper`의 전체 코드는 다음과 같습니다.

**실습: `/helpers/MyBatisHelper.js`**

```javascript
import dotenv from 'dotenv';
import path from 'path';
import fs from 'fs';
import mybatisMapper from 'mybatis-mapper';
import dbHelper from './DBHelper.js';
import logger from './LogHelper.js';

// .env 파일 로드
dotenv.config();

/**
 * MyBatis-Mapper를 활용한 데이터베이스 헬퍼 클래스
 */
class MybatisHelper {
    // 싱글톤 객체
    static #current = null;

    // DBHelper 인스턴스
    #dbHelper = null;

    /**
     * 싱글톤 객체를 생성하여 리턴한다.
     * @returns {MybatisHelper}
     */
    static getInstance() {
        if (MybatisHelper.#current === null) {
            MybatisHelper.#current = new MybatisHelper();
        }
        return MybatisHelper.#current;
    }

    /**
     * 생성자
     * @private
     */
    constructor() {
        // DBHelper 인스턴스 참조 (DBHelper는 이미 싱글톤으로 export됨)
        this.#dbHelper = dbHelper;

        // MyBatis-Mapper를 초기화
        this.#initializeMappers();
    }

    /**
     * MyBatis 매퍼 파일들을 초기화
     * @private
     */
    #initializeMappers() {
        try {
            // .env 파일에 정의된 MAPPER_PATH 값을 사용, 없으면 'mappers' 폴더를 기본값으로 사용
            const mapperPath = path.join(process.cwd(), process.env.MAPPER_PATH || 'mappers');
            logger.debug(`[MybatisHelper] Mapper Path: ${mapperPath}`);

            if (!fs.existsSync(mapperPath)) {
                throw new Error(`Mapper directory not found: ${mapperPath}`);
            }

            const files = fs.readdirSync(mapperPath);

            const mapperFiles = files
                .filter(file => path.extname(file).toLowerCase() === '.xml')
                .map(file => path.join(mapperPath, file));

            if (mapperFiles.length === 0) {
                logger.warn('[MybatisHelper] No XML mapper files found');
                return;
            }

            mybatisMapper.createMapper(mapperFiles);
            logger.info(`[MybatisHelper] Loaded ${mapperFiles.length} mapper files successfully`);

        } catch (error) {
            logger.error('[MybatisHelper] Failed to initialize mappers:', error);
            throw error;
        }
    }

    /**
     * SQL문을 실행한다.
     * @param {string} id - mapper의 namespace와 그 하위 id를 점(.)으로 연결한 문자열
     * @param {object} params - SQL문에 전달할 파라미터 객체
     * @returns {Promise<any>} SELECT: 배열, INSERT: insertId, UPDATE/DELETE: affectedRows
     */
    async execute(id, params = {}) {
        // 입력값 검증
        if (!id || typeof id !== 'string') {
            throw new Error('Mapper ID is required and must be a string');
        }

        const [namespace, sqlId] = id.split('.');
        if (!namespace || !sqlId) {
            throw new Error('Mapper ID must be in format "namespace.sqlId"');
        }

        let sql = null;

        try {
            // mybatis-mapper를 통해 SQL문 생성
            sql = mybatisMapper.getStatement(namespace, sqlId, params);
            logger.debug(`[MybatisHelper] Generated SQL for ${id}:`, sql);
            logger.debug(`[MybatisHelper] Parameters:`, params);
        } catch (error) {
            const errorMsg = `Failed to get SQL statement for ${id}: ${error.message}`;
            logger.error(`[MybatisHelper] ${errorMsg}`);
            throw new Error(errorMsg);
        }

        let result = null;

        try {
            // DB에 접속 (이미 연결되어 있으면 재사용)
            await this.#dbHelper.connect();

            // SQL문 실행
            const queryResult = await this.#dbHelper.query(sql);

            // 실행 결과를 종류별로 가공
            if (Array.isArray(queryResult)) {
                // SELECT 결과 - 배열 형태
                result = queryResult;
                logger.debug(`[MybatisHelper] SELECT result: ${queryResult.length} rows`);
            } else if (queryResult.affectedRows !== undefined) {
                // INSERT, UPDATE, DELETE 결과 - OkPacket 객체
                if (queryResult.insertId && queryResult.insertId > 0) {
                    // INSERT - 새로 생성된 ID 반환
                    result = queryResult.insertId;
                    logger.debug(`[MybatisHelper] INSERT result: insertId = ${result}`);
                } else if (queryResult.affectedRows > 0) {
                    // UPDATE, DELETE - 영향받은 행 수 반환
                    result = queryResult.affectedRows;
                    logger.debug(`[MybatisHelper] UPDATE/DELETE result: affectedRows = ${result}`);
                } else {
                    // 영향받은 행이 없는 경우
                    result = 0;
                    logger.debug('[MybatisHelper] No rows affected');
                }
            } else {
                // 예상하지 못한 결과 형태
                result = queryResult;
                logger.warn('[MybatisHelper] Unexpected query result format:', queryResult);
            }

        } catch (error) {
            logger.error(`[MybatisHelper] SQL execution failed for ${id}:`, {
                sql: sql,
                params: params,
                error: error.message
            });
            throw error;
        }

        return result;
    }

    /**
     * 트랜잭션 내에서 여러 SQL을 실행
     * @param {Function} callback - 트랜잭션 내에서 실행할 함수
     * @returns {Promise<any>} 콜백 함수의 반환값
     */
    async transaction(callback) {
        try {
            await this.#dbHelper.connect();
            return await this.#dbHelper.transaction(async (connection) => {
                // 트랜잭션 전용 invoke 메서드를 콜백에 전달
                const transactionInvoke = async (id, params = {}) => {
                    const [namespace, sqlId] = id.split('.');
                    const sql = mybatisMapper.getStatement(namespace, sqlId, params);
                    const [result] = await connection.query(sql, Object.values(params));

                    if (Array.isArray(result)) {
                        return result;
                    } else if (result.insertId && result.insertId > 0) {
                        return result.insertId;
                    } else if (result.affectedRows > 0) {
                        return result.affectedRows;
                    } else {
                        return 0;
                    }
                };

                return await callback(transactionInvoke);
            });
        } catch (error) {
            logger.error('[MybatisHelper] Transaction failed:', error);
            throw error;
        }
    }

    /**
     * 명시적 연결 종료
     */
    async close() {
        await this.#dbHelper.close();
    }
}

// 싱글톤 인스턴스를 export
export default MybatisHelper.getInstance();
```

### 1) 주요 구현 내용

-   **`constructor()`**: 생성자에서는 `DBHelper`의 싱글톤 인스턴스를 가져오고, `#initializeMappers()`를 호출하여 매퍼 파일들을 로드합니다. 이 작업은 `MybatisHelper`가 처음 생성될 때 단 한 번만 수행됩니다.

-   **`#initializeMappers()`**: 이 비공개 메서드는 `.env` 파일에 정의된 `MAPPER_PATH` 환경변수를 읽어 매퍼 XML 파일이 위치한 디렉토리 경로를 얻습니다. 해당 디렉토리의 모든 `.xml` 파일을 찾아 `mybatis-mapper`에 등록합니다. 이제 새로운 Mapper 파일이 추가되어도 코드를 수정할 필요 없이 자동으로 로드됩니다.

-   **`execute(id, params)`**: 이 메서드가 `MyBatisHelper`의 핵심입니다.
    1.  `id` 값 (예: `DepartmentMapper.selectList`)과 파라미터 `params`를 받습니다.
    2.  `mybatisMapper.getStatement()`를 호출하여 완전한 SQL문을 생성합니다.
    3.  내부적으로 `dbHelper.query()`를 실행하여 데이터베이스에 쿼리를 전송합니다.
    4.  쿼리 결과를 분석하여 `SELECT`문은 조회된 데이터 배열을, `INSERT`문은 새로 생성된 `insertId`를, `UPDATE`/`DELETE`문은 영향을 받은 행의 수(`affectedRows`)를 반환하도록 가공합니다.

-   **`transaction(callback)`**: `DBHelper`의 트랜잭션 기능을 한 번 더 감싸서, 사용자가 트랜잭션 로직에만 집중할 수 있도록 돕습니다. 콜백 함수 내에서 `execute`와 유사한 전용 실행 함수를 받아 여러 SQL 작업을 원자적으로 처리할 수 있습니다.

## 2. `MyBatisHelper`를 사용한 CRUD 실습

이제 `MyBatisHelper`를 사용하여 기존의 MyBatis 예제를 얼마나 간단하게 만들 수 있는지 확인해 보겠습니다.

**실습: `/08-MyBatis/05_mybatis_helper.js`**

```javascript
import mybatisHelper from '../helpers/MybatisHelper.js';

(async () => {
    try {
        console.log('=== MyBatis Helper 종합 예제 ===');

        // 1. 전체 데이터 수 조회
        console.log('1. 전체 데이터 수 조회');
        let result = await mybatisHelper.execute('DepartmentMapper.selectCountAll');
        console.log(`- 전체 데이터 수: ${result[0].cnt}`);

        // 2. 조건에 따른 데이터 수 조회 (동적 SQL)
        console.log('2. "공학관" 위치의 데이터 수 조회');
        result = await mybatisHelper.execute('DepartmentMapper.selectCountAll', { loc: '공학관' });
        console.log(`- "공학관" 데이터 수: ${result[0].cnt}`);

        // 3. 전체 목록 조회
        console.log('3. 전체 목록 조회 (상위 5개)');
        result = await mybatisHelper.execute('DepartmentMapper.selectList', { limit: 5 });
        console.log('- 상위 5개 목록:', result);

        // 4. 조건에 따른 목록 조회 (동적 SQL)
        console.log('4. "컴퓨터" 키워드를 포함하는 학과 목록 조회');
        result = await mybatisHelper.execute('DepartmentMapper.selectList', { dname: '컴퓨터' });
        console.log('- "컴퓨터" 검색 결과:', result);

        // 5. 단일행 조회
        console.log('5. 101번 학과 정보 조회');
        result = await mybatisHelper.execute('DepartmentMapper.selectItem', { id: 101 });
        console.log('- 101번 학과:', result[0]);

        // 6. INSERT 예제
        console.log('6. 새 학과 정보 추가');
        const insertId = await mybatisHelper.execute('DepartmentMapper.insertItem', {
            dname: 'MyBatis테스트학과',
            loc: 'IT관'
        });
        console.log(`- 새 학과 추가 완료. ID: ${insertId}`);

        // 7. UPDATE 예제
        console.log('8. 학과 정보 수정');
        const updatedRows = await mybatisHelper.execute('DepartmentMapper.updateItem', {
            id: insertId,
            dname: 'MyBatis업데이트학과',
            loc: '신IT관'
        });
        console.log(`- 수정된 행 수: ${updatedRows}`);

        // 8. DELETE 예제
        console.log('10. 학과 정보 삭제');
        const deletedRows = await mybatisHelper.execute('DepartmentMapper.deleteItem', { id: insertId });
        console.log(`- 삭제된 행 수: ${deletedRows}`);

        // 9. 트랜잭션 예제
        console.log('12. 트랜잭션 예제 (배치 작업)');
        const transactionResult = await mybatisHelper.transaction(async (execute) => {
            const insert1 = await execute('DepartmentMapper.insertItem', { dname: '트랜잭션1', loc: 'TX관' });
            const insert2 = await execute('DepartmentMapper.insertItem', { dname: '트랜잭션2', loc: 'TX관' });
            // 테스트 데이터 정리
            await execute('DepartmentMapper.deleteItem', { id: insert1 });
            await execute('DepartmentMapper.deleteItem', { id: insert2 });
            return { insert1, insert2 };
        });
        console.log('- 트랜잭션 결과:', transactionResult);

    } catch (e) {
        console.error("MyBatis 예제 실행에 실패했습니다.");
        console.error(e);
    } finally {
        mybatisHelper.close();
        console.log('=== MyBatis Helper 예제 완료 ===');
    }
})();
```

### 1) 코드 비교 및 분석

이전 예제와 비교했을 때, 코드가 얼마나 달라졌는지 확인해 보세요.

-   `mybatisMapper.createMapper()` 초기화 코드가 사라졌습니다. `MyBatisHelper`를 `import`하는 것만으로 모든 준비가 끝납니다.
-   `mybatisMapper.getStatement()`와 `dbHelper.query()`를 호출하던 복잡한 과정이 `mybatisHelper.execute()` 단 한 줄로 대체되었습니다.
-   `INSERT`, `UPDATE`, `DELETE` 후 결과 객체(`result`)를 직접 파싱할 필요 없이, `execute` 메서드가 `insertId`나 `affectedRows`를 직관적으로 반환해 줍니다.
-   `dbHelper.connect()`와 `dbHelper.close()`를 직접 호출할 필요가 없습니다. `execute` 메서드가 내부적으로 연결을 관리하며, 예제 마지막에 `mybatisHelper.close()`를 호출하여 연결을 종료합니다. (웹 애플리케이션 환경에서는 보통 서버 종료 시점에 한 번만 호출합니다.)

## 3. 결론

`MyBatisHelper` 클래스를 만들어 데이터베이스 관련 로직을 중앙에서 관리하도록 리팩토링했습니다. 이로써 우리는 다음과 같은 이점을 얻었습니다.

-   **코드 간소화**: 각 파일의 코드가 훨씬 짧고 명확해졌습니다.
-   **유지보수 용이성**: 데이터베이스 연결 방식이나 쿼리 실행 로직이 변경되어도 `MyBatisHelper` 클래스만 수정하면 되므로 유지보수가 매우 용이합니다.
-   **재사용성 향상**: 어떤 파일에서든 `MyBatisHelper`를 가져와 동일한 방식으로 데이터베이스 작업을 수행할 수 있습니다.

이처럼 적절한 헬퍼 클래스를 설계하고 활용하는 것은 깨끗하고 효율적인 코드를 작성하는 데 매우 중요한 역할을 합니다. 앞으로 진행될 Express 웹 서버 구축 과정에서도 이 `MyBatisHelper`를 적극적으로 활용할 것입니다.
