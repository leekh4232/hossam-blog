---
title: Node.js MyBatis 연동
description: "Node.js 환경에서 mybatis-mapper 라이브러리를 사용하여 SQL 쿼리를 코드와 분리하고, DBHelper와 연동하여 MySQL/MariaDB 데이터베이스 작업을 수행하는 방법을 학습합니다."
categories: [06.Backend,Node]
date:   2025-09-03 09:00:00 +0900
author: Hossam
image: /images/indexs/database.jpg
tags: [Web Development,Backend,Node,Database,MySQL,MyBatis]
pin: true
math: true
mermaid: true
---

# Node.js MyBatis 연동

이전 시간에는 `DBHelper`를 통해 JavaScript 코드 내에서 직접 SQL문을 실행하는 방법을 배웠습니다. 이 방식은 간단한 쿼리에는 유용하지만, 애플리케이션 규모가 커지고 SQL이 복잡해지면 코드 가독성이 떨어지고 유지보수가 어려워지는 단점이 있습니다.

이러한 문제를 해결하기 위해 **MyBatis**와 같은 SQL Mapper 프레임워크를 사용할 수 있습니다. MyBatis는 SQL 쿼리를 XML 파일에 작성하여 코드와 분리하고, 동적 쿼리 생성을 용이하게 하여 생산성을 높여줍니다.

이번 시간에는 Node.js에서 `mybatis-mapper` 라이브러리를 사용하여 SQL 쿼리를 관리하고, 이를 기존의 `DBHelper`와 연동하여 `async/await` 기반으로 데이터베이스 CRUD 작업을 수행하는 방법을 학습합니다.

## 1. `mybatis-mapper` 라이브러리 설치

Node.js에서 MyBatis의 Mapper XML 파일을 사용하기 위해서는 `mybatis-mapper` 라이브러리가 필요합니다.

```bash
$ yarn add mybatis-mapper
```

## 2. Mapper 파일과 환경설정

### 1) Mapper XML 파일 생성

먼저 SQL 쿼리를 저장할 XML 파일을 생성해야 합니다. 프로젝트 루트에 `mappers` 폴더를 만들고 그 안에 `DepartmentMapper.xml` 파일을 생성합니다.

**실습: `/mappers/DepartmentMapper.xml`**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="DepartmentMapper">

    <!-- 전체 데이터 수 조회 -->
    <select id="selectCountAll" resultType="int">
        SELECT COUNT(*) AS cnt FROM departments
        <where>
            <if test="dname != null and dname != ''">
                dname LIKE CONCAT('%', #{dname}, '%')
            </if>
            <if test="loc != null and loc != ''">
                AND loc LIKE CONCAT('%', #{loc}, '%')
            </if>
        </where>
    </select>

    <!-- 단일 학과 조회 -->
    <select id="selectItem" resultType="map">
        SELECT id, dname, loc, phone, email, established, homepage
        FROM departments
        WHERE id = #{id}
    </select>

    <!-- 전체 학과 목록 조회 -->
    <select id="selectList" resultType="map">
        SELECT id, dname, loc, phone, email, established, homepage
        FROM departments
        <where>
            <if test="dname != null and dname != ''">
                dname LIKE CONCAT('%', #{dname}, '%')
            </if>
            <if test="loc != null and loc != ''">
                AND loc LIKE CONCAT('%', #{loc}, '%')
            </if>
        </where>
        ORDER BY id DESC
        <if test="limit != null and limit > 0">
            LIMIT 0, ${limit}
        </if>
    </select>

    <!-- 학과 정보 추가 -->
    <insert id="insertItem">
        INSERT INTO departments (dname, loc, phone, email, established, homepage)
        VALUES (#{dname}, #{loc}, #{phone}, #{email}, #{established}, #{homepage})
    </insert>

    <!-- 학과 정보 수정 -->
    <update id="updateItem">
        UPDATE departments
        <set>
            <if test="dname != null">dname = #{dname},</if>
            <if test="loc != null">loc = #{loc},</if>
            <if test="phone != null">phone = #{phone},</if>
            <if test="email != null">email = #{email},</if>
            <if test="established != null">established = #{established},</if>
            <if test="homepage != null">homepage = #{homepage},</if>
        </set>
        WHERE id = #{id}
    </update>

    <!-- 학과 정보 삭제 -->
    <delete id="deleteItem">
        DELETE FROM departments WHERE id = #{id}
    </delete>
</mapper>
```

- **`<mapper namespace="...">`**: Mapper의 고유한 이름을 정의합니다. 이 이름을 통해 특정 Mapper를 식별합니다.
- **`<select>`, `<insert>`, `<update>`, `<delete>`**: 각 SQL 작업을 정의하는 태그입니다.
- **`id` 속성**: 각 쿼리를 식별하는 고유한 ID입니다. `namespace`와 `id`를 조합하여 `DepartmentMapper.selectItem`과 같이 사용합니다.
- **`#{...}`**: 파라미터를 받는 변수 플레이스홀더입니다. `mybatis-mapper`가 이 부분을 `?`로 변환하고 값을 바인딩합니다.
- **`${...}`**: 파라미터를 문자열로 직접 삽입합니다. 주로 `LIMIT` 절과 같이 숫자나 식별자에 사용됩니다.
- **`<if test="...">`**: 동적 쿼리를 생성하는 조건문입니다. 파라미터가 존재하고 비어있지 않을 경우에만 해당 SQL 조각을 포함시킵니다.

### 2) MyBatis 초기화 설정

`mybatis-mapper`를 사용하기 전, SQL 쿼리가 정의된 XML 파일의 위치를 알려주어야 합니다. `createMapper` 함수에 배열 형태로 Mapper 파일들의 경로를 전달하면, 라이브러리가 해당 파일들을 읽어 SQL 쿼리를 메모리에 로드합니다.

웹 애플리케이션의 경우, 애플리케이션이 시작되는 시점(보통 `app.js`)에 한 번만 호출하여 전역적으로 설정할 수 있습니다.

하지만 이번 실습의 예제 파일들처럼 독립적으로 실행되는 스크립트의 경우, 각 파일에서 `mybatisMapper`를 사용하기 전에 매번 초기화 코드를 실행해주어야 합니다.

**실습: 예제 파일 상단에 추가**

```javascript
import mybatisMapper from 'mybatis-mapper';

// Mapper XML 파일 로드 --> 프로젝트 root 기준 상대경로 지정
mybatisMapper.createMapper(['mappers/DepartmentMapper.xml']);

// ... 이후 코드 ...
```

이제 이 초기화 코드를 포함하여 전체 CRUD 예제를 살펴보겠습니다.

## 3. MyBatis 연동 CRUD 구현하기

이제 `mybatis-mapper`와 `DBHelper`를 함께 사용하여 `departments` 테이블에 대한 CRUD 작업을 수행하는 예제를 만들어 보겠습니다.

MyBatis를 사용하는 기본 흐름은 다음과 같습니다.

1.  `mybatisMapper.getStatement()`를 호출하여 XML에 정의된 SQL문을 가져옵니다.
2.  이때 파라미터를 함께 전달하여 동적 쿼리를 완성합니다.
3.  가져온 SQL문과 파라미터를 `DBHelper.query()`에 전달하여 실행합니다.

### 1) 데이터 조회 (SELECT)

`DepartmentMapper.xml`에 정의된 `selectList`와 `selectItem`을 사용하여 학과 목록과 특정 학과 정보를 조회합니다.

**실습: `/08-MyBatis/01_select.js`**

```javascript
import dbHelper from '../helpers/DBHelper.js';
import mybatisMapper from 'mybatis-mapper';

// 프로젝트 root 기준 상대경로 지정
mybatisMapper.createMapper(['mappers/DepartmentMapper.xml']);

(async () => {
    try {
        await dbHelper.connect();

        // 1. 전체 데이터 수 조회
        console.log('1. 전체 데이터 수 조회');
        let params = { /* 파라미터 없음 */ };
        let sql = mybatisMapper.getStatement('DepartmentMapper', 'selectCountAll', params);
        let result = await dbHelper.query(sql);
        console.log(`- 전체 데이터 수: ${result[0].cnt}`);

        // 1. 단일행 조회
        console.log('\n5. 101번 학과 정보 조회');
        params = { id: 101 };
        sql = mybatisMapper.getStatement('DepartmentMapper', 'selectItem', params);
        result = await dbHelper.query(sql, Object.values(params));
        console.log('- 101번 학과:', result[0]);

        // 2. 조건에 따른 데이터 수 조회 (동적 SQL)
        console.log('\n2. "공학관" 위치의 데이터 수 조회');
        params = { loc: '공학관' };
        sql = mybatisMapper.getStatement('DepartmentMapper', 'selectCountAll', params);
        result = await dbHelper.query(sql, Object.values(params));
        console.log(`- "공학관" 데이터 수: ${result[0].cnt}`);

        // 3. 전체 목록 조회
        console.log('\n3. 전체 목록 조회');
        params = { /* 파라미터 없음 */ };
        sql = mybatisMapper.getStatement('DepartmentMapper', 'selectList', params);
        result = await dbHelper.query(sql);
        console.log('- 전체 목록:', result);

        // 4. 조건에 따른 목록 조회 (동적 SQL)
        console.log('\n4. "컴퓨터" 키워드를 포함하는 학과 목록 조회');
        params = { dname: '컴퓨터' };
        sql = mybatisMapper.getStatement('DepartmentMapper', 'selectList', params);
        result = await dbHelper.query(sql, Object.values(params));
        console.log('- "컴퓨터" 검색 결과:', result);
    } catch (e) {
        console.error("MyBatis 예제 실행에 실패했습니다.");
        console.error(e);
    } finally {
        await dbHelper.close();
    }
})();
```

### 2) 데이터 추가 (INSERT)

`insertItem` 쿼리를 사용하여 새로운 학과 데이터를 추가합니다.

**실습: `/08-MyBatis/02_insert.js`**

```javascript
import dbHelper from '../helpers/DBHelper.js';
import mybatisMapper from 'mybatis-mapper';

mybatisMapper.createMapper(['mappers/DepartmentMapper.xml']);

(async () => {
    try {
        await dbHelper.connect();

        console.log('학과 정보 추가');

        const params = {
            dname: '블록체인학과',
            loc: '미래관',
            phone: '051-123-7788',
            email: 'blockchain@myschool.ac.kr',
            established: 2025,
            homepage: 'http://blockchain.myschool.ac.kr'
        };

        const sql = mybatisMapper.getStatement('DepartmentMapper', 'insertItem', params);
        const result = await dbHelper.query(sql, Object.values(params));

        console.log('INSERT 결과:', result);
        console.log(`새로 추가된 데이터의 ID: ${result.insertId}`);

    } catch (e) {
        console.error("MyBatis 예제 실행에 실패했습니다.");
        console.error(e);
    } finally {
        await dbHelper.close();
    }
})();
```

### 3) 데이터 수정 (UPDATE)

`updateItem` 쿼리를 사용하여 기존 학과 데이터를 수정합니다. XML에 정의된 동적 SQL `<if>` 태그 덕분에, 파라미터로 전달된 필드만 선택적으로 수정할 수 있습니다.

**실습: `/08-MyBatis/03_update.js`**

```javascript
import dbHelper from '../helpers/DBHelper.js';
import mybatisMapper from 'mybatis-mapper';

mybatisMapper.createMapper(['mappers/DepartmentMapper.xml']);

(async () => {
    try {
        await dbHelper.connect();

        console.log('학과 정보 수정');

        // 수정할 데이터의 Primary Key와 변경할 필드들
        const params = {
            id: 201,
            loc: 'IT융합관',
            phone: '051-555-1234'
        };

        const sql = mybatisMapper.getStatement('DepartmentMapper', 'updateItem', params);
        const result = await dbHelper.query(sql, Object.values(params));

        console.log('UPDATE 결과:', result);
        console.log(`영향받은 행 수: ${result.affectedRows}`);

    } catch (e) {
        console.error("MyBatis 예제 실행에 실패했습니다.");
        console.error(e);
    } finally {
        await dbHelper.close();
    }
})();
```

### 4) 데이터 삭제 (DELETE)

`deleteItem` 쿼리를 사용하여 특정 학과 데이터를 삭제합니다.

**실습: `/08-MyBatis/04_delete.js`**

```javascript
import dbHelper from '../helpers/DBHelper.js';
import mybatisMapper from 'mybatis-mapper';

mybatisMapper.createMapper(['mappers/DepartmentMapper.xml']);

(async () => {
    try {
        await dbHelper.connect();

        console.log('학과 정보 삭제');

        // 삭제할 데이터의 Primary Key
        const params = {
            id: 503 // 체육학과
        };

        const sql = mybatisMapper.getStatement('DepartmentMapper', 'deleteItem', params);
        const result = await dbHelper.query(sql, Object.values(params));

        console.log('DELETE 결과:', result);
        console.log(`삭제된 행 수: ${result.affectedRows}`);

    } catch (e) {
        console.error("MyBatis 예제 실행에 실패했습니다.");
        console.error(e);
    } finally {
        await dbHelper.close();
    }
})();
```
