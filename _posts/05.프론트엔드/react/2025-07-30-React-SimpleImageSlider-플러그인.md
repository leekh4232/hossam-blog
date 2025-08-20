---
title:  "[React] React Simple Image Slider 플러그인 사용법"
description: "간단하고 가벼운 React 이미지 슬라이더 컴포넌트로 자동재생, 네비게이션, 인디케이터 등 다양한 기능 지원"
categories: [05.Frontend,React]
tags: [Web Development,Frontend,React,Slider,Carousel,Plugin]
image: /images/indexs/react.png
date: 2025-07-30 11:00:22 +0900
author: Hossam
pin: true
math: true
mermaid: true
---

## #01. 플러그인 설치

https://github.com/kimcoder/react-simple-image-slider 에서 자세한 내용을 확인할 수 있다.

### Yarn 사용
```shell
$ yarn add react-simple-image-slider
```

### npm 사용
```shell
$ npm install react-simple-image-slider
```

## #02. 초기 구성

### 1. 라이브러리와 샘플 이미지 참조

```jsx
import React, {memo} from 'react';
import styled from 'styled-components';
import ImageSlider from "react-simple-image-slider";

import slide1 from '../../assets/img/slide1.jpg';
import slide2 from '../../assets/img/slide2.jpg';
import slide3 from '../../assets/img/slide3.jpg';
import slide4 from '../../assets/img/slide4.jpg';
```

### 2. 이미지 데이터 구조

React Simple Image Slider는 `url` 속성을 가진 객체 배열을 사용합니다:

```jsx
const images = [
    { url: slide1 },
    { url: slide2 },
    { url: slide3 },
    { url: slide4 }
];
```

![슬라이더 데모](/images/2025/0730/slider-demo.png)

## #03. 기본 사용 방법

### 1. 기본 슬라이더 구현

```jsx
<ImageSlider
    width="100%"
    height={480}
    images={images}
/>
```

### 2. 주요 속성 설정

```jsx
<ImageSlider
    width="100%"              // 슬라이더 너비
    height={480}              // 슬라이더 높이
    images={images}           // 이미지 배열
    showBullets={true}        // 하단 인디케이터 표시
    showNavs={true}           // 좌우 네비게이션 화살표 표시
    autoPlay={true}           // 자동재생 활성화
    autoPlayDelay={2.0}       // 자동재생 지연시간 (초)
    loop={true}               // 무한 루프 설정
/>
```

### 3. 기본 사용 방법이 적용된 간단한 샘플 코드

```jsx
/**
 * React Simple Image Slider
 *
 * https://github.com/kimcoder/react-simple-image-slider#readme
 *
 * yarn add react-simple-image-slider
 */

import React, {memo} from 'react';

import styled from 'styled-components';

import ImageSlider from "react-simple-image-slider";

import slide1 from '../../assets/img/slide1.jpg';
import slide2 from '../../assets/img/slide2.jpg';
import slide3 from '../../assets/img/slide3.jpg';
import slide4 from '../../assets/img/slide4.jpg';

const SliderExContainer = styled.div`

`;

const SliderEx = memo(() => {
    const images = [
        { url: slide1 },
        { url: slide2 },
        { url: slide3 },
        { url: slide4 }
    ];

    return (
        <SliderExContainer>
            <h2>SliderEx</h2>

            <ImageSlider
                width="100%"
                height={480}
                images={images}
                showBullets={true}
                showNavs={true}
                autoPlay={true}
                autoPlayDelay={2.0}
                loop={true} />

        </SliderExContainer>
    );
});

export default SliderEx;
```


## #04. ImageSlider 주요 속성

### 1. 필수 속성

| 속성 | 타입 | 설명 |
|------|------|------|
| `images` | Array | 이미지 객체 배열 `[{url: "path"}]` |
| `width` | String/Number | 슬라이더 너비 |
| `height` | String/Number | 슬라이더 높이 |

### 2. 선택적 속성

| 속성 | 타입 | 기본값 | 설명 |
|------|------|--------|------|
| `showBullets` | Boolean | false | 하단 인디케이터 점 표시 |
| `showNavs` | Boolean | false | 좌우 네비게이션 화살표 표시 |
| `autoPlay` | Boolean | false | 자동재생 활성화 |
| `autoPlayDelay` | Number | 2.0 | 자동재생 지연시간 (초) |
| `loop` | Boolean | false | 무한 루프 설정 |
| `navStyle` | Number | 1 | 네비게이션 스타일 (1~2) |
| `navSize` | Number | 50 | 네비게이션 크기 (px) |
| `navMargin` | Number | 30 | 네비게이션 여백 (px) |
| `bulletStyle` | Number | 1 | 인디케이터 스타일 (1~2) |
| `bulletSize` | Number | 30 | 인디케이터 크기 (px) |
| `bulletMargin` | Number | 5 | 인디케이터 간격 (px) |
| `slideDuration` | Number | 0.5 | 슬라이드 전환 시간 (초) |
| `bgColor` | String | '#000000' | 배경색 |
| `useGPURender` | Boolean | true | GPU 렌더링 사용 |

### 3. 스타일 커스터마이징

#### 네비게이션 스타일
```jsx
<ImageSlider
    images={images}
    width="100%"
    height={480}
    navStyle={2}              // 네비게이션 스타일 (1 또는 2)
    navSize={60}              // 네비게이션 크기
    navMargin={40}            // 네비게이션 여백
/>
```

#### 인디케이터 스타일
```jsx
<ImageSlider
    images={images}
    width="100%"
    height={480}
    showBullets={true}
    bulletStyle={2}           // 인디케이터 스타일 (1 또는 2)
    bulletSize={25}           // 인디케이터 크기
    bulletMargin={8}          // 인디케이터 간격
/>
```

#### 애니메이션 설정
```jsx
<ImageSlider
    images={images}
    width="100%"
    height={480}
    slideDuration={0.8}       // 전환 시간 (느린 전환)
    autoPlayDelay={3.0}       // 3초마다 자동 전환
/>
```

## #05. 다양한 사용 사례

### 1. 반응형 슬라이더

```jsx
const ResponsiveSlider = () => {
    const [sliderSize, setSliderSize] = useState({
        width: '100%',
        height: 480
    });

    useEffect(() => {
        const handleResize = () => {
            const isMobile = window.innerWidth <= 768;
            setSliderSize({
                width: '100%',
                height: isMobile ? 250 : 480
            });
        };

        window.addEventListener('resize', handleResize);
        handleResize(); // 초기 설정

        return () => window.removeEventListener('resize', handleResize);
    }, []);

    return (
        <ImageSlider
            images={images}
            width={sliderSize.width}
            height={sliderSize.height}
            showBullets={true}
            showNavs={true}
            autoPlay={true}
        />
    );
};
```

### 2. 동적 이미지 로딩

```jsx
const DynamicSlider = () => {
    const [images, setImages] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        // API에서 이미지 목록 가져오기
        fetch('/api/gallery')
            .then(res => res.json())
            .then(data => {
                const formattedImages = data.map(item => ({
                    url: item.imageUrl
                }));
                setImages(formattedImages);
                setLoading(false);
            });
    }, []);

    if (loading) return <div>이미지 로딩중...</div>;

    return (
        <ImageSlider
            images={images}
            width="100%"
            height={400}
            showBullets={true}
            autoPlay={true}
            loop={true}
        />
    );
};
```

### 3. 커스텀 스타일 적용

```jsx
const CustomStyledSlider = styled.div`
    .react-simple-image-slider__bullets {
        bottom: 20px !important;
    }

    .react-simple-image-slider__bullet {
        background-color: rgba(255, 255, 255, 0.5) !important;

        &.active {
            background-color: #fff !important;
        }
    }

    .react-simple-image-slider__nav {
        background-color: rgba(0, 0, 0, 0.3) !important;

        &:hover {
            background-color: rgba(0, 0, 0, 0.6) !important;
        }
    }
`;

const StyledSliderComponent = () => (
    <CustomStyledSlider>
        <ImageSlider
            images={images}
            width="100%"
            height={480}
            showBullets={true}
            showNavs={true}
            autoPlay={true}
        />
    </CustomStyledSlider>
);
```

## #07. 전체 소스코드

```jsx
import React, {memo, useState, useEffect} from 'react';
import styled from 'styled-components';
import ImageSlider from "react-simple-image-slider";

// 샘플 이미지 import
import slide1 from '../../assets/img/slide1.jpg';
import slide2 from '../../assets/img/slide2.jpg';
import slide3 from '../../assets/img/slide3.jpg';
import slide4 from '../../assets/img/slide4.jpg';

// 스타일 컴포넌트 정의
const SliderExContainer = styled.div`
    .slider-section {
        margin: 2rem 0;
        padding: 1rem;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
    }

    .slider-title {
        color: #333;
        margin-bottom: 1rem;
        font-size: 1.2rem;
    }

    .slider-description {
        color: #666;
        margin-bottom: 1rem;
        font-size: 0.9rem;
    }

    .full-width-slider {
        /* body태그에 부여되어 있는 padding만큼 안쪽 여백을 제거하기 위한 코드 */
        margin-left: -50px;
        margin-right: -50px;

        @media (max-width: 768px) {
            margin-left: -20px;
            margin-right: -20px;
        }
    }
`;

const SliderEx = memo(() => {
    // 이미지 데이터 배열
    const images = [
        { url: slide1 },
        { url: slide2 },
        { url: slide3 },
        { url: slide4 }
    ];

    // 반응형 높이 설정
    const [sliderHeight, setSliderHeight] = useState(480);

    useEffect(() => {
        const handleResize = () => {
            const isMobile = window.innerWidth <= 768;
            setSliderHeight(isMobile ? 250 : 480);
        };

        window.addEventListener('resize', handleResize);
        handleResize(); // 초기 설정

        return () => window.removeEventListener('resize', handleResize);
    }, []);

    return (
        <SliderExContainer>
            <h2>React Simple Image Slider 사용 예시</h2>

            {/* 기본 슬라이더 */}
            <div className="slider-section">
                <h3 className="slider-title">기본 슬라이더</h3>
                <p className="slider-description">기본적인 이미지 슬라이더입니다.</p>
                <ImageSlider
                    width="100%"
                    height={300}
                    images={images}
                />
            </div>

            {/* 네비게이션과 인디케이터가 있는 슬라이더 */}
            <div className="slider-section">
                <h3 className="slider-title">네비게이션 + 인디케이터</h3>
                <p className="slider-description">좌우 화살표와 하단 점 인디케이터가 있는 슬라이더입니다.</p>
                <ImageSlider
                    width="100%"
                    height={350}
                    images={images}
                    showBullets={true}
                    showNavs={true}
                />
            </div>

            {/* 자동재생 슬라이더 */}
            <div className="slider-section">
                <h3 className="slider-title">자동재생 슬라이더</h3>
                <p className="slider-description">2초마다 자동으로 슬라이드가 변경됩니다.</p>
                <ImageSlider
                    width="100%"
                    height={350}
                    images={images}
                    showBullets={true}
                    showNavs={true}
                    autoPlay={true}
                    autoPlayDelay={2.0}
                    loop={true}
                />
            </div>

            {/* 커스텀 스타일 슬라이더 */}
            <div className="slider-section">
                <h3 className="slider-title">커스텀 스타일</h3>
                <p className="slider-description">큰 네비게이션과 인디케이터, 느린 전환 효과가 적용된 슬라이더입니다.</p>
                <ImageSlider
                    width="100%"
                    height={350}
                    images={images}
                    showBullets={true}
                    showNavs={true}
                    navStyle={2}
                    navSize={60}
                    bulletStyle={2}
                    bulletSize={20}
                    slideDuration={0.8}
                    autoPlay={true}
                    autoPlayDelay={3.0}
                    loop={true}
                />
            </div>

            {/* 전체 폭 슬라이더 */}
            <div className="slider-section">
                <h3 className="slider-title">전체 폭 슬라이더</h3>
                <p className="slider-description">컨테이너를 벗어나 전체 폭으로 표시되는 슬라이더입니다.</p>
                <div className="full-width-slider">
                    <ImageSlider
                        width="100%"
                        height={sliderHeight}
                        images={images}
                        showBullets={true}
                        showNavs={true}
                        autoPlay={true}
                        autoPlayDelay={2.0}
                        loop={true}
                    />
                </div>
            </div>
        </SliderExContainer>
    );
});

export default SliderEx;
```
