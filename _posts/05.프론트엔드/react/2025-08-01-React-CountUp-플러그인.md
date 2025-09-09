---
title:  "[React] React CountUp 플러그인 사용법"
description: "숫자 카운팅 애니메이션을 제공하는 React CountUp 플러그인으로 스크롤에 반응하는 동적 효과 구현"
categories: [05.Frontend,React]
tags: [Web Development,Frontend,React,Animation,CountUp,Plugin]
image: /images/indexs/react.png
date: 2025-08-01 15:30:22 +0900
author: Hossam
pin: true
math: true
mermaid: true
---

# [React] React CountUp 플러그인 사용법

## #01. 플러그인 설치

https://www.npmjs.com/package/react-countup 에서 자세한 내용을 확인할 수 있다.

### Yarn 사용
```shell
$ yarn add react-countup
```

### npm 사용
```shell
$ npm install react-countup
```

## #02. 초기 구성

### 1. 라이브러리 참조

```jsx
import React, {memo} from 'react';
import styled from 'styled-components';

/** import --> yarn add react-countup 필요함 */
import CountUp from 'react-countup';
```

### 2. 스타일 컴포넌트 정의

숫자를 표시할 카운터 박스의 스타일을 정의합니다:

```jsx
const CountUpExContainer = styled.div`
   .counter-box {
        display: flex;
        padding: 100px 50px;
        justify-content: space-around;

        // 숫자를 카운트할 박스
        .my-counter {
            font-size: 80px;
            font-weight: bold;
            width: 300px;
            height: 250px;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #555;
            color: #fff;
        }
    }
`;
```

## #03. 기본 사용 방법

### 1. 기본 카운트업 구현

```jsx
<CountUp
    start={0}           // 시작값
    end={100}           // 종료값
    duration={2}        // 애니메이션 지속시간 (초)
/>
```

### 2. 주요 속성 설정

```jsx
<CountUp
    start={1}               // 시작값 (기본값: 0)
    end={345}               // 종료값 (필수)
    duration={5}            // 애니메이션 지속시간 (기본값: 2초)
    enableScrollSpy         // 스크롤에 반응하여 시작
    scrollSpyDelay={1000}   // 스크롤 후 딜레이 시간 (밀리초)
    className='my-counter'  // CSS 클래스명
/>
```

### 3. 스크롤 감지 기능

`enableScrollSpy` 속성을 사용하면 요소가 화면에 나타났을 때 카운팅이 시작됩니다:

```jsx
<CountUp
    start={1}
    end={567}
    duration={5}
    enableScrollSpy         // 스크롤에 반응
    scrollSpyDelay={1500}   // 화면 진입 후 1.5초 대기
    className='my-counter'
/>
```

## #04. 고급 기능

### 1. 포매팅 옵션

```jsx
<CountUp
    start={0}
    end={1234567.89}
    duration={3}
    separator=","           // 천 단위 구분자
    decimals={2}            // 소수점 자릿수
    decimal="."             // 소수점 구분자
    prefix="$"              // 접두사
    suffix=" USD"           // 접미사
/>
```

### 2. 커스텀 렌더링

```jsx
<CountUp
    start={0}
    end={100}
    duration={3}
>
    {({ countUpRef, start }) => (
        <div>
            <span ref={countUpRef} />
            <button onClick={start}>시작</button>
        </div>
    )}
</CountUp>
```

### 3. 콜백 함수

```jsx
<CountUp
    start={0}
    end={100}
    duration={3}
    onStart={() => console.log('카운팅 시작!')}
    onEnd={() => console.log('카운팅 완료!')}
    onPauseResume={() => console.log('일시정지/재개')}
    onReset={() => console.log('리셋됨')}
    onUpdate={(value) => console.log('현재 값:', value)}
/>
```

## #05. 완전한 예제 코드

{% raw %}
```jsx
/**
 * React Count-up
 *
 * https://www.npmjs.com/package/react-countup
 *
 * yarn add react-countup
 */
import React, {memo} from 'react';

import styled from 'styled-components';

/** (1) import --> yarn add react-countup 필요함 */
import CountUp from 'react-countup';

const CountUpExContainer = styled.div`
   .counter-box {
        display: flex;
        padding: 100px 50px;
        justify-content: space-around;

        // 숫자를 카운트할 박스
        .my-counter {
            font-size: 80px;
            font-weight: bold;
            width: 300px;
            height: 250px;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #555;
            color: #fff;
        }
    }
`;

const CountUpEx = memo(() => {
    return (
        <CountUpExContainer>
            <h2>CountUpEx</h2>

            <hr />
            <div style={{
                height: "3000px",
                display: "flex",
                justifyContent: 'center',
                alignItems: 'start',
                fontSize: "32px"
            }}>dummy (아래로 스크롤~~~)</div>
            <hr />

            <div className="counter-box">
                <CountUp
                    start={1}               // 시작값
                    end={345}               // 종료값
                    duration={5}            // 5초동안 애니메이션 가동(기본값=2)
                    enableScrollSpy         // 스크롤에 반응해라~
                    scrollSpyDelay={1000}   // 스크롤에 의해 화면에 표시된 후 딜레이 시간
                    className='my-counter' />

                <CountUp
                    start={1}               // 시작값
                    end={234}               // 종료값
                    duration={5}            // 3초동안 애니메이션 가동(기본값=2)
                    enableScrollSpy         // 스크롤에 반응해라~
                    scrollSpyDelay={500}    // 스크롤에 의해 화면에 표시된 후 딜레이 시간
                    className='my-counter'
                />

                <CountUp
                    start={1}               // 시작값
                    end={567}               // 종료값
                    duration={5}            // 3초동안 애니메이션 가동(기본값=2)
                    enableScrollSpy         // 스크롤에 반응해라~
                    scrollSpyDelay={1500}   // 스크롤에 의해 화면에 표시된 후 딜레이 시간
                    className='my-counter'
                />
            </div>

        </CountUpExContainer>
    );
});

export default CountUpEx;
```
{% endraw %}

## #06. 자주 사용되는 속성 정리

| 속성 | 타입 | 기본값 | 설명 |
|------|------|--------|------|
| `start` | number | 0 | 카운팅 시작 값 |
| `end` | number | 필수 | 카운팅 종료 값 |
| `duration` | number | 2 | 애니메이션 지속시간 (초) |
| `enableScrollSpy` | boolean | false | 스크롤 감지 활성화 |
| `scrollSpyDelay` | number | 0 | 스크롤 후 딜레이 (밀리초) |
| `scrollSpyOnce` | boolean | true | 스크롤 감지 일회성 여부 |
| `separator` | string | - | 천 단위 구분자 |
| `decimals` | number | 0 | 소수점 자릿수 |
| `decimal` | string | "." | 소수점 구분자 |
| `prefix` | string | - | 접두사 |
| `suffix` | string | - | 접미사 |
| `preserveValue` | boolean | false | 값 보존 여부 |
| `redraw` | boolean | false | 강제 재렌더링 |
| `useEasing` | boolean | true | 이징 효과 사용 |
| `easingFn` | function | easeInExpo | 이징 함수 |

## #07. 활용 팁

### 1. 통계 섹션에서 활용

```jsx
<div className="statistics-section">
    <div className="stat-item">
        <CountUp end={1500} duration={3} enableScrollSpy />
        <span>만족한 고객</span>
    </div>
    <div className="stat-item">
        <CountUp end={250} duration={3} enableScrollSpy scrollSpyDelay={500} />
        <span>완료된 프로젝트</span>
    </div>
    <div className="stat-item">
        <CountUp end={99} suffix="%" duration={3} enableScrollSpy scrollSpyDelay={1000} />
        <span>성공률</span>
    </div>
</div>
```

### 2. 대시보드에서 활용

```jsx
<div className="dashboard-metrics">
    <CountUp
        end={revenue}
        prefix="$"
        separator=","
        duration={2}
        preserveValue
    />
    <CountUp
        end={users}
        suffix=" 명"
        separator=","
        duration={2}
        preserveValue
    />
</div>
```

### 3. 성능 최적화

- `preserveValue` 속성을 사용하여 불필요한 재렌더링 방지
- `scrollSpyOnce` 속성으로 한 번만 실행되도록 설정
- `memo`를 사용하여 컴포넌트 최적화

## #08. 주의사항

1. **스크롤 감지**: `enableScrollSpy`를 사용할 때는 요소가 화면에 보이는 시점을 고려해야 합니다.
2. **성능**: 많은 수의 CountUp 컴포넌트를 동시에 사용할 때는 성능에 주의해야 합니다.
3. **접근성**: 시각 장애인을 위해 `aria-label` 등의 접근성 속성을 고려해주세요.
4. **브라우저 호환성**: 최신 브라우저에서만 일부 기능이 지원될 수 있습니다.

React CountUp 플러그인은 웹사이트에 생동감 있는 숫자 애니메이션을 쉽게 추가할 수 있는 훌륭한 도구입니다. 특히 스크롤 감지 기능을 통해 사용자 경험을 크게 향상시킬 수 있습니다.
