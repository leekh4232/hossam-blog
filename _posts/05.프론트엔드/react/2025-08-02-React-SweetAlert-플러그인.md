---
title:  "[React] SweetAlert2 플러그인 사용법"
description: "아름답고 반응형인 팝업 메시지 박스를 제공하는 SweetAlert2 플러그인으로 사용자 친화적인 알림 구현"
categories: [05.Frontend,React]
tags: [Web Development,Frontend,React,Alert,Modal,Popup,Plugin]
image: /images/indexs/react.png
date: 2025-08-02 14:30:22 +0900
author: Hossam
pin: true
math: true
mermaid: true
---

## #01. 플러그인 설치

https://sweetalert2.github.io/ 에서 자세한 내용을 확인할 수 있다.

### Yarn 사용
```shell
$ yarn add sweetalert2 sweetalert2-react-content
```

### npm 사용
```shell
$ npm install sweetalert2 sweetalert2-react-content
```

> **주의**: React에서 사용하려면 `sweetalert2`와 `sweetalert2-react-content` 두 패키지 모두 설치해야 합니다.

## #02. 초기 구성

### 1. 라이브러리 참조

```jsx
import React, {memo, useCallback} from 'react';
import styled from 'styled-components';

import Swal from "sweetalert2";
import withReactContent from "sweetalert2-react-content";

// 이미지 파일 (선택사항)
import img1 from "../assets/img/img1.png";
```

### 2. React용 SweetAlert2 인스턴스 생성

```jsx
const MySwal = withReactContent(Swal);
```

`withReactContent(Swal)`을 사용하여 React 컴포넌트에서 사용할 수 있는 형태로 변환합니다.

### 3. 스타일 컴포넌트 정의

```jsx
const SweetAlertExContainer = styled.div`
   .btn {
        border: 1px solid #d5d5d5;
        padding: 10px 20px;
        margin: 0 10px;
        font-size: 16px;

        &:first-child {
            margin-left: 0;
        }

        &:hover {
            background-color: #aaa;
        }

        &:active {
            background-color: #ccc;
            transform: scale(0.9, 0.9);
        }
    }
`;
```

## #03. 기본 사용 방법

### 1. 간단한 알림 메시지

```jsx
MySwal.fire('안녕하세요!');
```

### 2. 제목과 내용이 있는 메시지

```jsx
MySwal.fire({
    title: "알림",
    text: "작업이 완료되었습니다.",
    icon: "success"
});
```

### 3. 사용 가능한 아이콘 타입

- `success` - 성공 (체크 아이콘)
- `error` - 오류 (X 아이콘)
- `warning` - 경고 (느낌표 아이콘)
- `info` - 정보 (i 아이콘)
- `question` - 질문 (물음표 아이콘)

## #04. Promise 방식 사용

### 1. .then() 방식

```jsx
const onButton1Click = useCallback(() => {
    MySwal.fire({
        title: "Promise",
        text: "SweetAlert을 활용한 메시지 박스 테스트 입니다.",
        icon: "info",
        footer: '<a href="https://sweetalert2.github.io/">SweetAlert2에 대해 궁금한가요?</a>',
    }).then((result) => {
        console.debug(result);

        if (result.isConfirmed) {
            MySwal.fire("확인 버튼을 눌렀습니다.");
        } else if (result.isDismissed && result.dismiss === 'backdrop') {
            MySwal.fire("화면의 빈 공간을 눌렀습니다.");
        }
    });
}, []);
```

### 2. async/await 방식

```jsx
const onButton2Click = useCallback(async () => {
    const result = await MySwal.fire({
        title: "Async Await",
        text: "SweetAlert을 활용한 메시지 박스 테스트 입니다.",
        icon: "success",
        footer: '<a href="https://sweetalert2.github.io/">SweetAlert2에 대해 궁금한가요?</a>',
    });

    console.debug(result);

    if (result.isConfirmed) {
        MySwal.fire("확인 버튼을 눌렀습니다.");
    } else if (result.isDismissed && result.dismiss === 'backdrop') {
        MySwal.fire("화면의 빈 공간을 눌렀습니다.");
    }
}, []);
```

## #05. 이미지 사용

### 1. 아이콘 대신 이미지 표시

```jsx
const onButton3Click = useCallback(async () => {
    const result = await MySwal.fire({
        imageUrl: img1,
        imageWidth: "95%",
        imageAlt: "Photographic",
        title: "My Photo",
        text: "Hello?",
    });

    console.debug(result);

    if (result.isConfirmed) {
        MySwal.fire("확인 버튼을 눌렀습니다.");
    } else if (result.isDismissed && result.dismiss === 'backdrop') {
        MySwal.fire("화면의 빈 공간을 눌렀습니다.");
    }
}, []);
```

### 2. 배경 이미지 사용

```jsx
const onButton5Click = useCallback(async () => {
    const result = await MySwal.fire({
        title: '<strong style="color:#fff">HTML <u>example</u></strong>',
        icon: "info",
        html: '<p style="color: #fff">You can use <b>bold text</b>, <a href="//sweetalert2.github.io">links</a> and other HTML tags</p>',
        background: `url(${img1}) no-repeat center center / cover`,
        showCloseButton: true,
        showDenyButton: true,
        focusConfirm: true,
        confirmButtonText: "네",
        denyButtonText: "아니오",
    });

    // 결과 처리...
}, []);
```

## #06. 다양한 버튼 구성

### 1. 확인/거부/취소 버튼

```jsx
const onButton4Click = useCallback(async () => {
    const result = await MySwal.fire({
        title: '확인',
        icon: 'question',
        text: '변경사항을 저장하시겠습니까?',
        showCloseButton: true,      // X 닫기 버튼
        showDenyButton: true,       // 거부 버튼
        showCancelButton: true,     // 취소 버튼
        confirmButtonText: '네',
        denyButtonText: '아니오',
        cancelButtonText: '나중에',
        confirmButtonColor: '#3085d6',
        denyButtonColor: '#d33',
        cancelButtonColor: '#aaa'
    });

    console.debug(result);

    if (result.isConfirmed) {
        MySwal.fire('"네"를 선택하셨습니다.');
    } else if (result.isDenied) {
        MySwal.fire('"아니오"를 선택하셨습니다.');
    } else if (result.isDismissed && result.dismiss === 'cancel') {
        MySwal.fire('"나중에"를 선택하셨습니다.');
    } else if (result.isDismissed && result.dismiss === 'close') {
        MySwal.fire("닫기 버튼을 눌렀습니다.");
    } else if (result.isDismissed && result.dismiss === 'backdrop') {
        MySwal.fire("화면의 빈 공간을 눌렀습니다.");
    }
}, []);
```

### 2. 버튼 결과 처리

| 결과 | 설명 |
|------|------|
| `result.isConfirmed` | 확인 버튼 클릭 |
| `result.isDenied` | 거부 버튼 클릭 |
| `result.isDismissed` | 대화상자가 닫힘 |
| `result.dismiss === 'cancel'` | 취소 버튼 클릭 |
| `result.dismiss === 'close'` | X 버튼 클릭 |
| `result.dismiss === 'backdrop'` | 배경 클릭 |
| `result.dismiss === 'esc'` | ESC 키 누름 |

## #07. 완전한 예제 코드

```jsx
/**
 * SweetAlert2
 *  메시지 팝업창 라이브러리
 *
 * https://sweetalert2.github.io/
 *
 * yarn add sweetalert2 sweetalert2-react-content
 */
import React, {memo, useCallback} from 'react';

import Swal from "sweetalert2";
import withReactContent from "sweetalert2-react-content";

import styled from 'styled-components';

import img1 from "../assets/img/img1.png";

const SweetAlertExContainer = styled.div`
   .btn {
        border: 1px solid #d5d5d5;
        padding: 10px 20px;
        margin: 0 10px;
        font-size: 16px;

        &:first-child {
            margin-left: 0;
        }

        &:hover {
            background-color: #aaa;
        }

        &:active {
            background-color: #ccc;
            transform: scale(0.9, 0.9);
        }
    }
`;

const SweetAlertEx = memo(() => {
    // sweet-alert 클래스를 React에서 호출 할 수 있는 형태로 가공
    const MySwal = withReactContent(Swal);

    // Promise 방식을 사용한 다이얼로그
    const onButton1Click = useCallback(() => {
        MySwal.fire({
            // 불필요한 항목은 삭제 가능함
            title: "Promise",
            text: "SweetAlert을 활용한 메시지 박스 테스트 입니다.",
            // 아이콘은 'success', 'warning', 'info', 'question', 'error' 중에서 선택 가능
            icon: "info",
            footer: '<a href="https://sweetalert2.github.io/">SweetAlert2에 대해 궁금한가요?</a>',
        }).then((result) => {
            console.debug(result);

            // result.isConfirmed: OK버튼을 누른 경우 true
            if (result.isConfirmed) {
                MySwal.fire("확인 버튼을 눌렀습니다.");
            } else if (result.isDismissed && result.dismiss == 'backdrop') {
                MySwal.fire("화면의 빈 공간을 눌렀습니다.");
            }
        });
    }, []);

    // Async~Await 방식을 사용한 다이얼로그
    const onButton2Click = useCallback(async () => {
        const result = await MySwal.fire({
            title: "Async Await",
            text: "SweetAlert을 활용한 메시지 박스 테스트 입니다.",
            icon: "success",
            footer: '<a href="https://sweetalert2.github.io/">SweetAlert2에 대해 궁금한가요?</a>',
        });

        console.debug(result);

        if (result.isConfirmed) {
            MySwal.fire("확인 버튼을 눌렀습니다.");
        } else if (result.isDismissed && result.dismiss == 'backdrop') {
            MySwal.fire("화면의 빈 공간을 눌렀습니다.");
        }
    }, []);

    // 아이콘 대신 이미지를 사용하는 다이얼로그
    const onButton3Click = useCallback(async () => {
        const result = await MySwal.fire({
            imageUrl: img1,
            imageWidth: "95%",
            imageAlt: "Photographic",
            title: "My Photo",
            text: "Hello?",
        });

        console.debug(result);

        if (result.isConfirmed) {
            MySwal.fire("확인 버튼을 눌렀습니다.");
        } else if (result.isDismissed && result.dismiss == 'backdrop') {
            MySwal.fire("화면의 빈 공간을 눌렀습니다.");
        }
    }, []);

    // 다양한 버튼 사용
    const onButton4Click = useCallback(async () => {
        const result = await MySwal.fire({
            title: '확인',
            icon: 'question',
            text: '변경사항을 저장하시겠습니까?',
            showCloseButton: true,
            showDenyButton: true,
            showCancelButton: true,
            confirmButtonText: '네',
            denyButtonText: '아니오',
            cancelButtonText: '나중에',
            confirmButtonColor: '#3085d6',
            denyButtonColor: '#d33',
            cancelButtonColor: '#aaa'
        });

        console.debug(result);

        if (result.isConfirmed) {
            MySwal.fire('"네"를 선택하셨습니다.');
        } else if (result.isDenied) {
            MySwal.fire('"아니오"를 선택하셨습니다.');
        } else if (result.isDismissed && result.dismiss === 'cancel') {
            MySwal.fire('"나중에"를 선택하셨습니다.');
        } else if (result.isDismissed && result.dismiss == 'close') {
            MySwal.fire("닫기 버튼을 눌렀습니다.");
        } else if (result.isDismissed && result.dismiss == 'backdrop') {
            MySwal.fire("화면의 빈 공간을 눌렀습니다.");
        }
    }, []);

    // 이미지 백그라운드
    const onButton5Click = useCallback(async () => {
        const result = await MySwal.fire({
            // 제목에는 HTML태그 사용 가능
            title: '<strong style="color:#fff">HTML <u>example</u></strong>',
            icon: "info",
            html: '<p style="color: #fff">You can use <b>bold text</b>, <a href="//sweetalert2.github.io">links</a> and other HTML tags</p>',
            // CSS의 background 속성을 그대로 적용
            background: `url(${img1}) no-repeat center center / cover`,
            showCloseButton: true,
            showDenyButton: true,
            focusConfirm: true,
            confirmButtonText: "네",
            denyButtonText: "아니오",
        });

        console.debug(result);

        if (result.isConfirmed) {
            MySwal.fire('긍정 버튼을 눌렀습니다.');
        } else if (result.isDenied) {
            MySwal.fire('부정 버튼을 눌렀습니다.');
        } else if (result.isDismissed && result.dismiss == 'close') {
            MySwal.fire("닫기 버튼을 눌렀습니다.");
        } else if (result.isDismissed && result.dismiss == 'backdrop') {
            MySwal.fire("화면의 빈 공간을 눌렀습니다.");
        }
    }, []);

    return (
        <SweetAlertExContainer>
            <h2>SweetAlertEx</h2>

            <button className="btn" onClick={onButton1Click}>Button1</button>
            <button className="btn" onClick={onButton2Click}>Button2</button>
            <button className="btn" onClick={onButton3Click}>Button3</button>
            <button className="btn" onClick={onButton4Click}>Button4</button>
            <button className="btn" onClick={onButton5Click}>Button5</button>
        </SweetAlertExContainer>
    );
});

export default SweetAlertEx;
```

## #08. 주요 속성 정리

### 1. 기본 속성

| 속성 | 타입 | 설명 |
|------|------|------|
| `title` | string | 제목 (HTML 태그 사용 가능) |
| `text` | string | 내용 텍스트 |
| `html` | string | HTML 형식의 내용 |
| `icon` | string | 아이콘 타입 (success, error, warning, info, question) |
| `footer` | string | 하단 영역 HTML |

### 2. 버튼 관련 속성

| 속성 | 타입 | 기본값 | 설명 |
|------|------|--------|------|
| `showConfirmButton` | boolean | true | 확인 버튼 표시 여부 |
| `showDenyButton` | boolean | false | 거부 버튼 표시 여부 |
| `showCancelButton` | boolean | false | 취소 버튼 표시 여부 |
| `showCloseButton` | boolean | false | X 닫기 버튼 표시 여부 |
| `confirmButtonText` | string | "확인" | 확인 버튼 텍스트 |
| `denyButtonText` | string | "아니오" | 거부 버튼 텍스트 |
| `cancelButtonText` | string | "취소" | 취소 버튼 텍스트 |
| `confirmButtonColor` | string | "#3085d6" | 확인 버튼 색상 |
| `denyButtonColor` | string | "#d33" | 거부 버튼 색상 |
| `cancelButtonColor` | string | "#aaa" | 취소 버튼 색상 |

### 3. 이미지 관련 속성

| 속성 | 타입 | 설명 |
|------|------|------|
| `imageUrl` | string | 이미지 URL |
| `imageWidth` | string/number | 이미지 너비 |
| `imageHeight` | string/number | 이미지 높이 |
| `imageAlt` | string | 이미지 alt 텍스트 |

### 4. 레이아웃 관련 속성

| 속성 | 타입 | 설명 |
|------|------|------|
| `width` | string/number | 대화상자 너비 |
| `padding` | string/number | 내부 여백 |
| `background` | string | 배경 CSS |
| `backdrop` | boolean/string | 배경 오버레이 설정 |
| `position` | string | 위치 설정 (top, center, bottom) |

## #09. 고급 기능

### 1. 입력 필드가 있는 대화상자

```jsx
const { value: email } = await MySwal.fire({
    title: '이메일 입력',
    input: 'email',
    inputLabel: '이메일 주소를 입력하세요',
    inputPlaceholder: 'example@domain.com',
    inputValidator: (value) => {
        if (!value) {
            return '이메일을 입력해주세요!'
        }
    }
});

if (email) {
    MySwal.fire(`입력된 이메일: ${email}`);
}
```

### 2. 로딩 스피너

```jsx
MySwal.fire({
    title: '처리 중...',
    html: '잠시만 기다려주세요.',
    allowEscapeKey: false,
    allowOutsideClick: false,
    didOpen: () => {
        MySwal.showLoading();
    }
});

// 작업 완료 후
setTimeout(() => {
    MySwal.fire({
        icon: 'success',
        title: '완료!',
        text: '작업이 성공적으로 완료되었습니다.'
    });
}, 3000);
```

### 3. 타이머가 있는 자동 닫기

```jsx
MySwal.fire({
    title: '자동 종료',
    text: '5초 후 자동으로 닫힙니다.',
    icon: 'info',
    timer: 5000,
    timerProgressBar: true,
    showConfirmButton: false
});
```

## #10. 실제 활용 예제

### 1. 삭제 확인 대화상자

```jsx
const handleDelete = async (id) => {
    const result = await MySwal.fire({
        title: '정말 삭제하시겠습니까?',
        text: "삭제된 데이터는 복구할 수 없습니다!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: '삭제',
        cancelButtonText: '취소'
    });

    if (result.isConfirmed) {
        try {
            await deleteItem(id);
            MySwal.fire('삭제 완료!', '데이터가 성공적으로 삭제되었습니다.', 'success');
        } catch (error) {
            MySwal.fire('오류!', '삭제 중 오류가 발생했습니다.', 'error');
        }
    }
};
```

### 2. 폼 제출 결과 처리

```jsx
const handleSubmit = async (formData) => {
    MySwal.fire({
        title: '저장 중...',
        allowEscapeKey: false,
        allowOutsideClick: false,
        didOpen: () => MySwal.showLoading()
    });

    try {
        await saveData(formData);
        MySwal.fire({
            icon: 'success',
            title: '저장 완료!',
            text: '데이터가 성공적으로 저장되었습니다.',
            timer: 2000,
            showConfirmButton: false
        });
    } catch (error) {
        MySwal.fire({
            icon: 'error',
            title: '저장 실패',
            text: error.message || '저장 중 오류가 발생했습니다.'
        });
    }
};
```

## #11. 주의사항

1. **패키지 설치**: React에서 사용하려면 반드시 `sweetalert2-react-content`도 함께 설치해야 합니다.
2. **인스턴스 생성**: `withReactContent(Swal)`로 React용 인스턴스를 생성해야 합니다.
3. **메모리 관리**: 컴포넌트 언마운트 시 열려있는 대화상자는 자동으로 닫힙니다.
4. **접근성**: 스크린 리더 사용자를 위해 적절한 `title`과 `text`를 제공해주세요.
5. **모바일 최적화**: 모바일 환경에서도 잘 작동하도록 설계되었습니다.

SweetAlert2는 기본 `alert()`, `confirm()`, `prompt()`를 대체하는 현대적이고 아름다운 대화상자 라이브러리입니다. 다양한 커스터마이징 옵션과 반응형 디자인으로 사용자 경험을 크게 향상시킬 수 있습니다.
