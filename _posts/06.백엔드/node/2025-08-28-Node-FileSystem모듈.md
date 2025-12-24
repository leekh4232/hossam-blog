---
title: Node.js FileSystem 모듈
description: "Node.js를 시작하는데 필수적으로 알아야 하는 기본 내장모듈중에서 디렉토리와 파일에 관련된 작업을 수행하는 fs모듈에 대해 설명합니다."
categories: [06.Backend,Node]
date:   2025-08-28 09:00:00 +0900
author: Hossam
image: /images/indexs/node2.png
tags: [Web Development,Backend,Node]
pin: true
math: true
mermaid: true
---

# Node.js FileSystem 모듈

Node.js의 `fs` 모듈은 파일 시스템과 상호 작용하는 데 사용되는 모든 메서드를 포함하고 있습니다. 이 모듈을 통해 파일 읽기, 쓰기, 디렉토리 생성, 삭제 등 다양한 파일 관련 작업을 수행할 수 있습니다. `fs` 모듈의 메서드는 동기(synchronous)와 비동기(asynchronous) 버전을 모두 제공합니다.

## 1. 동기식 파일 쓰기

동기식 파일 처리는 작업이 완료될 때까지 코드 실행을 차단합니다. 간단한 스크립트나 애플리케이션 초기화 과정에서는 유용할 수 있지만, 서버와 같이 동시성을 처리해야 하는 환경에서는 성능 저하의 원인이 될 수 있습니다.

### `fs.existsSync()`

파일이나 디렉토리의 존재 여부를 동기적으로 확인합니다. 파일이나 디렉토리의 존재 여부를 확인하는 작업은 파일의 용량과는 상관 없는 작업이기 때문에 비동기로 처리하지 않아도 됩니다.

- `fs.existsSync(path)`
  - `path`: 확인할 파일 또는 디렉토리의 경로
  - 반환값: 존재하면 `true`, 존재하지 않으면 `false`

### `fs.writeFileSync()`

파일에 데이터를 동기적으로 씁니다. 파일이 이미 존재하면 내용을 덮어쓰고, 파일이 없으면 새로 생성합니다.

- `fs.writeFileSync(file, data[, options])`
  - `file`: 파일의 경로
  - `data`: 파일에 쓸 데이터
  - `options`: 인코딩, 모드, 플래그 등을 설정하는 객체 또는 문자열 (기본 인코딩: 'utf8')

### `fs.chmodSync()`

파일의 권한을 동기적으로 변경합니다.

- `fs.chmodSync(path, mode)`
  - `path`: 파일 경로
  - `mode`: 권한을 나타내는 8진수 형태의 문자열 또는 정수 (예: '0766')

### `fs.unlinkSync()`

파일을 동기적으로 삭제합니다.

- `fs.unlinkSync(path)`
  - `path`: 삭제할 파일의 경로

### 실습: 동기식으로 파일 쓰고 삭제하기

**02-fs모듈/01_file_write1.js**

```javascript
/** (1) 모듈참조, 필요한 변수 생성 */
import fs from "fs"; // FileSystem 모듈 참조

const target = "./output_sync.txt"; // 저장할 파일의 경로
const content = "Hello World"; // 저장할 내용
const is_exists = fs.existsSync(target); // 파일의 존재 여부 검사

if (!is_exists) {
    /** (2) 파일이 존재하지 않을 경우 새로 저장 */
    // 상대경로 지정, 동기식 파일 저장.
    // 이 파일을 다 저장하기 전까지는 프로그램이 대기상태임.
    // 그러므로 대용량 처리에는 적합하지 않음.
    fs.writeFileSync(target, content, "utf8");

    // 퍼미션 설정
    fs.chmodSync(target, "0766");

    // 파일 저장이 완료된 후에나 메시지가 표시된다.
    console.log(target + " 파일에 데이터 쓰기 및 퍼미션 설정 완료.");
} else {
    /** (3) 파일이 존재할 경우 파일 삭제 */
    fs.unlinkSync(target);
    console.log(target + " 파일 삭제 완료.");
}
```

---

## 2. 비동기식 파일 쓰기

비동기식 파일 처리는 작업을 시작한 후 즉시 다음 코드로 실행 흐름을 넘깁니다. 작업이 완료되면 등록된 콜백 함수가 호출됩니다. 이 방식은 I/O 작업이 많은 Node.js 애플리케이션의 성능과 확장성을 높여줍니다.

### `fs.writeFile()`

파일에 데이터를 비동기적으로 씁니다.

- `fs.writeFile(file, data[, options], callback)`
  - `callback`: 작업 완료 후 호출될 함수. 첫 번째 인자로 에러 객체(`err`)를 받습니다.

### `fs.chmod()`

파일의 권한을 비동기적으로 변경합니다.

- `fs.chmod(path, mode, callback)`

### 실습: 비동기식으로 파일 쓰고 삭제하기

**02-fs모듈/02_file_write2.js**

```javascript
/** (1) 모듈참조, 필요한 변수 생성 */
import fs from "fs"; // FileSystem 모듈 참조

const target = "./output.txt"; // 파일경로
const content = "Hello World"; // 저장할 내용
const is_exists = fs.existsSync(target); // 파일의 존재 여부 검사

if (!is_exists) {
    /** (2) 파일이 존재하지 않을 경우 새로 저장 */
    // 절대경로 지정, 비동기식 파일 저장
    fs.writeFile(target, content, "utf8", (err) => {
        if (err) {
            return console.log(err);
        }
        console.log(target + "에 데이터 쓰기 완료.");

        // 퍼미션 설정
        fs.chmod(target, "0766", (err) => {
            if (err) {
                return console.log(err);
            }
            console.log(target + "의 퍼미션 설정 완료");
        });
    });

    console.log(target + "의 파일 저장을 요청했습니다.");
} else {
    /** (3) 파일이 존재할 경우 파일 삭제 */
    fs.unlink(target, (err) => {
        if (err) {
            return console.log(err);
        }
        console.log(target + "의 파일 삭제 완료");
    });

    console.log(target + "의 파일 삭제를 요청했습니다.");
}
```

---

## 3. `async/await`를 이용한 비동기 파일 처리

Node.js `fs` 모듈은 `promises` API를 제공하여, `async/await` 구문을 통해 비동기 코드를 동기식 코드처럼 깔끔하고 직관적으로 작성할 수 있게 해줍니다.

### `fs.promises`

`fs` 모듈의 `promises` 객체는 각 `fs` 메서드에 대해 `Promise`를 반환하는 버전을 제공합니다.

- `await fs.promises.writeFile(file, data[, options])`
- `await fs.promises.chmod(path, mode)`
- `await fs.promises.unlink(path)`

### 실습: `async/await`로 파일 쓰고 권한 설정하기

**02-fs모듈/03_file_write_async.js**

```javascript
/** (1) 모듈참조, 필요한 변수 생성 */
import fs from "fs"; // FileSystem 모듈 참조

const target = "./output.txt"; // 파일경로
const content = "Hello World"; // 저장할 내용
const is_exists = fs.existsSync(target); // 파일의 존재 여부 검사

if (!is_exists) {
    /** (2) 파일이 존재하지 않을 경우 새로 저장 */
    // 절대경로 지정, 비동기식 파일 저장
    (async () => {
        console.log(target + "의 파일 저장을 요청했습니다.");

        // async~await는 비동기식 처리를 동기식으로 작동하도록 제어함
        try {
            await fs.promises.writeFile(target, content, "utf8");
            console.log(target + "에 데이터 쓰기 완료.");

            await fs.promises.chmod(target, "0766");
            console.log(target + "의 퍼미션 설정 완료");
        } catch (err) {
            console.log(err);
            return;
        }
    })();
} else {
    /** (3) 파일이 존재할 경우 파일 삭제 */
    console.log(target + "의 파일 삭제를 요청했습니다.");

    (async () => {
        try {
            await fs.promises.unlink(target);
            console.log(target + "의 파일 삭제 완료");
        } catch (err) {
            console.log(err);
            return;
        }
    })();
}
```

---

## 4. 동기식 파일 읽기

### `fs.readFileSync()`

파일을 동기적으로 읽고 그 내용을 문자열이나 `Buffer` 객체로 반환합니다. 파일을 다 읽을 때까지 프로그램 실행이 중단되므로 대용량 파일 처리에는 적합하지 않습니다.

- `fs.readFileSync(path[, options])`

### 실습: 동기식으로 파일 읽기

**02-fs모듈/04_file_read1.js**

```javascript
import fs from "fs"; // FileSystem 모듈 참조

const target = "./output_sync.txt"; // 읽어들일 파일의 경로

if (fs.existsSync(target)) {
    // 파일을 동기식으로 읽어서 그 내용을 리턴한다.
    // 이 파일을 다 읽기 전까지는 프로그램이 대기상태임.
    // 그러므로 대용량 처리에는 적합하지 않음.
    const data = fs.readFileSync("./output_sync.txt", "utf8");

    // 읽어 들인 데이터를 출력.
    console.log(data);
} else {
    console.log(target + "파일이 존재하지 않습니다.");
}
```

---

## 5. 비동기식 파일 읽기

### `fs.readFile()`

파일을 비동기적으로 읽습니다. 파일 읽기가 완료되면 콜백 함수가 호출되며, 파일 내용이 두 번째 파라미터(`data`)로 전달됩니다.

- `fs.readFile(path[, options], callback)`
  - `callback`: `(err, data)`를 인자로 받습니다.

### 실습: 비동기식으로 파일 읽기

**02-fs모듈/05_file_read2.js**

```javascript
import fs from "fs";            // FileSystem 모듈 참조
const target = './output.txt';	// 파일경로

if (fs.existsSync(target)) {
	// 파일을 비동기식으로 파일 읽기
	// 파일을 다 읽을 때까지 대기하지 않고 프로그램은 다음으로 진행.
	// --> 파일 읽기가 종료되면 세 번째 파라미터인 콜백함수가 호출된다.
	fs.readFile(target, 'utf8', (err, data) => {
		if(err) { return console.log(err); }
		console.log(data);	// 읽어 들인 데이터 출력
	});
	console.log(target + ' 파일을 읽도록 요청했습니다.');
} else {
	console.log(target + "파일이 존재하지 않습니다.");
}
```

---

## 6. `async/await`를 이용한 비동기 파일 읽기

### `fs.promises.readFile()`

`Promise`를 반환하는 `readFile` 메서드를 사용하여 `async/await`와 함께 파일을 비동기적으로 읽을 수 있습니다.

- `await fs.promises.readFile(path[, options])`

### 실습: `async/await`로 파일 읽기

**02-fs모듈/06_file_read_async.js**

```javascript
import fs from "fs";            // FileSystem 모듈 참조
const target = "./output.txt";  // 파일경로

if (fs.existsSync(target)) {
    console.log(target + " 파일을 읽도록 요청했습니다.");

    (async () => {
        try {
            const data = await fs.promises.readFile(target, "utf8");
            console.log(data); // 읽어 들인 데이터 출력
        } catch (err) {
            console.log(err);
        }
    })();
} else {
    console.log(target + "파일이 존재하지 않습니다.");
}
```

---

## 7. 동기식 디렉토리 관리

### `fs.mkdirSync()`

디렉토리를 동기적으로 생성합니다.

- `fs.mkdirSync(path[, options])`

### `fs.rmdirSync()`

디렉토리를 동기적으로 삭제합니다. **주의할 점은 디렉토리가 비어 있어야만 삭제가 가능합니다.**

- `fs.rmdirSync(path[, options])`

### 실습: 동기식으로 디렉토리 생성 및 삭제

**02-fs모듈/07_dir1.js**

```javascript
import fs from "fs";            // FileSystem 모듈 참조
const target = "./docs";

if (!fs.existsSync(target)) {
	console.log(target + "경로가 존재하지 않기 때문에 생성합니다.");

    // 폴더 생성하기
    fs.mkdirSync(target);

    // 생성된 폴더에 대한 퍼미션 설정
    fs.chmodSync(target, '0755');

	console.log(target + "(이)가 생성되었습니다.");
} else {
	console.log(target + "경로가 존재하므로 삭제합니다.");

    // 폴더 삭제하기
    fs.rmdirSync(target);

	console.log(target + "(이)가 삭제되었습니다.");
}
```

---

## 8. 비동기식 디렉토리 관리

### `fs.mkdir()`

디렉토리를 비동기적으로 생성합니다.

- `fs.mkdir(path[, options], callback)`

### `fs.rmdir()`

디렉토리를 비동기적으로 삭제합니다. 디렉토리는 비어 있어야 합니다.

- `fs.rmdir(path[, options], callback)`

### 실습: 비동기식으로 디렉토리 생성 및 삭제

**02-fs모듈/08_dir2.js**

```javascript
import fs from "fs";            // FileSystem 모듈 참조
const target = "./docs";

if (!fs.existsSync(target)) {
	// 파라미터 --> 경로, 퍼미션, 콜백함수
	fs.mkdir(target, (err) => {
		if (err) { return console.log(err); }
		fs.chmodSync(target, '0777');
		console.log('새로운 docs 폴더를 만들었습니다.');
	});
} else {
	// 파일 삭제 --> 비어있지 않은 폴더는 삭제 못함.
	fs.rmdir(target, (err) => {
		if (err) { return console.log(err); }
		console.log('docs 폴더를 삭제했습니다.');
	});
};
```

---

## 9. `async/await`를 이용한 비동기 디렉토리 관리

### `fs.promises.mkdir()` and `fs.promises.rmdir()`

`Promise` 기반의 `mkdir`와 `rmdir` 메서드를 사용하여 `async/await` 구문으로 디렉토리를 관리할 수 있습니다.

- `await fs.promises.mkdir(path[, options])`
- `await fs.promises.rmdir(path[, options])`

### 실습: `async/await`로 디렉토리 생성 및 삭제

**02-fs모듈/09_dir_async.js**

```javascript
import fs from "fs";            // FileSystem 모듈 참조
const target = "./docs";

if (!fs.existsSync(target)) {
    (async () => {
        try {
            await fs.promises.mkdir(target);
            await fs.promises.chmod(target, '0777');
            console.log('새로운 docs 폴더를 만들었습니다.');
        } catch (err) {
            console.log(err);
        }
    })();
} else {
	// 파일 삭제 --> 비어있지 않은 폴더는 삭제 못함.
	(async () => {
		try {
			await fs.promises.rmdir(target);
			console.log('docs 폴더를 삭제했습니다.');
		} catch (err) {
			console.log(err);
		}
	})();
};
```

---

## 10. 중첩된 디렉토리 관리 (외부 라이브러리)

기본 `fs` 모듈의 `mkdir`와 `rmdir`은 한계가 있습니다. `mkdir`는 한 번에 하나의 디렉토리만 만들 수 있고, `rmdir`은 비어있는 디렉토리만 삭제할 수 있습니다. 이러한 한계를 극복하기 위해 외부 라이브러리를 사용할 수 있습니다.

### `mkdirs` 라이브러리

`mkdirs`는 지정된 경로에 필요한 모든 상위 디렉토리를 재귀적으로 생성해주는 라이브러리입니다.

- **설치**: `yarn add mkdirs`

### `rmdir` 라이브러리

`rmdir`은 내용의 유무와 상관없이 지정된 디렉토리와 그 하위 항목을 모두 재귀적으로 삭제합니다. 내부적으로 `rm -rf` 명령을 수행하는 것과 유사합니다.

- **설치**: `yarn add rmdir`

### 실습: `mkdirs`와 `rmdir`로 중첩 디렉토리 관리하기

**02-fs모듈/10_mkdirs.js**

```javascript
import fs from "fs";            // FileSystem 모듈 참조

// 지정된 경로를 따라 폴더를 생성하는 라이브러리
// $ yarn add mkdirs
import { mkdirs } from 'mkdirs';

// 지정된 경로를 따라 폴더와 그 하위 항목을 모두 삭제하는 라이브러리
// 내부적으로 "rm -rf" 명령을 수행함.
// $yarn add rmdir
import rmdir from 'rmdir';

if (!fs.existsSync('./this')) {
    // 현재폴더(./)는 VSCode에서 열려있는 Workspace 폴더 기준
    // 이 라이브러리는 동기식 처리로 되어 있다.
    mkdirs('./this/that/and/the/other');
} else {
    // 이 라이브러리는 비동기식 처리로 되어 있다.
    (async () => {
        try {
            await rmdir('./this');
            console.log('this 폴더를 삭제했습니다.');
        } catch (err) {
            console.log(err);
        }
    })();
}
```