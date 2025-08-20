---
title:  "[React] FsLightbox 플러그인 사용법"
description: "어떤 요소를 클릭했을 때 지정된 이미지나 영상 등을 모달창으로 띄울 수 있게 하는 플러그인"
categories: [05.Frontend,React]
tags: [Web Development,Frontend,React,Plugin]
image: /images/indexs/react.png
date: 2025-07-30 10:00:22 +0900
author: Hossam
pin: true
math: true
mermaid: true
---

## #01. 플러그인 설치

https://fslightbox.com/ 에서 자세한 내용을 확인할 수 있다.

### Yarn 사용
```shell
$ yarn add fslightbox-react
```

### npm 사용
```shell
$ npm install fslightbox-react
```

## #02. 사용 방법

### 1. 라이브러리와 샘플 이미지 참조

`useState()`가 필요하다

```javascript
import React, {memo, useState} from 'react';

import FsLightbox from 'fslightbox-react';

import img1 from '../../assets/img/img1.png';
import img2 from '../../assets/img/img2.png';
import img3 from '../../assets/img/img3.png';
import img4 from '../../assets/img/img4.png';
import img5 from '../../assets/img/img5.png';
```

### 2. 단일 이미지에 대한 구현

![이미지](/images/2025/0730/fslightbox-case1.png)

#### 모달창 표시 여부에 대한 상태 변수 생성

```javascript
const [singleToggler, setSingleToggler] = useState(false);
```

#### 클릭시 이미지 모달 창 표시

버튼을 클릭하면 `singleToggler` 상태변수의 값을 `false`에서 `true`로 변경한다.

`<FsLightbox>` 컴포넌트에 `sources` 프로퍼티로 표시하고자 하는 이미지를 지정한다. (배열임에 주의)

`<FsLightbox>` 컴포넌트에 설정된 `toggler` 프로퍼티의 값이 `true`인 경우 모달창이 표시되고 `false`인 경우 모달창이 사라진다. 이 부분을 상태변수로 제어하는 것이다.

```jsx
<button className="btn" onClick={e => { setSingleToggler(!singleToggler) }}>
    <img src={img1} width={150} alt="img1" />
</button>
<FsLightbox sources={[img1]} toggler={singleToggler} />
```

## #03. FsLightbox 주요 속성

### 1. 필수 속성

| 속성 | 타입 | 설명 |
|------|------|------|
| `sources` | Array | 표시할 미디어 소스 배열 (이미지, 동영상 등) |
| `toggler` | Boolean | 라이트박스 표시/숨김 제어 |

### 2. 선택적 속성

| 속성 | 타입 | 기본값 | 설명 |
|------|------|--------|------|
| `slide` | Number | 1 | 시작할 슬라이드 번호 (1부터 시작) |
| `type` | String | 'auto' | 미디어 타입 ('image', 'youtube', 'video' 등) |
| `maxYouTubeVideoDimensions` | Object | `{width: 1920, height: 1080}` | YouTube 동영상 최대 크기 |
| `openOnMount` | Boolean | false | 마운트 시 자동 열기 |
| `slideDistance` | Number | 0.3 | 슬라이드 간 거리 |
| `zoomIncrement` | Number | 0.25 | 줌 증가량 |

### 3. 이벤트 콜백

```jsx
<FsLightbox
    sources={[img1, img2, img3]}
    toggler={toggler}
    onOpen={() => console.log('라이트박스 열림')}
    onClose={() => console.log('라이트박스 닫힘')}
    onSlideChange={(slideIndex) => console.log('슬라이드 변경:', slideIndex)}
/>
```

### 4. 커스터마이징

#### 스타일 커스터마이징
```css
/* 라이트박스 배경색 변경 */
.fslightbox-container {
    background: rgba(0, 0, 0, 0.9) !important;
}

/* 닫기 버튼 스타일 */
.fslightbox-toolbar-button {
    color: #fff !important;
    font-size: 24px !important;
}

/* 네비게이션 화살표 스타일 */
.fslightbox-slide-btn {
    color: #fff !important;
}
```

### 3. 복수 이미지에 대한 구현

![이미지](/images/2025/0730/fslightbox-case2.png)

#### 모달창 표시 여부에 대한 상태 변수 생성

복수 이미지를 사용할 경우 모달창 표시 여부와 몇 번째 이미지를 표시할지에 대한 상태값을 생성한다.

```javascript
const [multiToggler, setMultiToggler] = useState({
    open: false,
    index: 1
});
```

#### 복수 이미지에 대한 모달 창 구현

마지막 라인의 `<FsLightbox>` 컴포넌트를 보면 `sources` 프로퍼티에 표시할 이미지가 여러 개 배열로 지정되어 있다. 이 때 `toggler`는 모달창의 표시 여부, `slides`는 `sources`에 지정된 이미지 중에서 몇 번째 이미지를 표시할지에 대한 숫자 값이다.

그러므로 버튼 클릭 이벤트에서는 이 두 개의 값을 하나로 묶은 상태변수를 관리하면 된다.

주의할 점은 `slides`가 $1$ 부터 시작된다는 점이다.

```jsx
<button className="btn" onClick={e => { setMultiToggler({open: !multiToggler.open, index: 1}) }}>
    <img src={img1} width={150} alt="img1" />
</button>
<button className="btn" onClick={e => { setMultiToggler({open: !multiToggler.open, index: 2}) }}>
    <img src={img2} width={150} alt="img2" />
</button>
<button className="btn" onClick={e => { setMultiToggler({open: !multiToggler.open, index: 3}) }}>
    <img src={img3} width={150} alt="img3" />
</button>
<button className="btn" onClick={e => { setMultiToggler({open: !multiToggler.open, index: 4}) }}>
    <img src={img4} width={150} alt="img4" />
</button>
<button className="btn" onClick={e => { setMultiToggler({open: !multiToggler.open, index: 5}) }}>
    <img src={img5} width={150} alt="img5" />
</button>

<FsLightbox sources={[img1, img2, img3, img4, img5]} toggler={multiToggler.open} slide={multiToggler.index}/>
```

## #04. Youtube 영상에 대한 처리

### 1. Youtube 영상 썸네일 가져오기

Youtube 공식 레퍼런스에서 영상 썸네일의 URL 규칙을 확인할 수 있다.

| 크기 | URL |
| --- | --- |
| 동영상 배경 썸네일`(480x360)` |  https://img.youtube.com/vi/영상코드/0.jpg |
| 동영상 시작지점 썸네일`(120x90)` |  https://img.youtube.com/vi/영상코드/1.jpg |
| 동영상 중간지점 썸네일`(120x90)` |  https://img.youtube.com/vi/영상코드/2.jpg |
| 동영상 끝지점 썸네일`(120x90)` |  https://img.youtube.com/vi/영상코드/3.jpg |
| 고해상도 썸네일`(1280x720)` |  https://img.youtube.com/vi/영상코드/maxresdefault.jpg |
| 중간해상도 썸네일`(640x480)` |  https://img.youtube.com/vi/영상코드/sddefault.jpg |
| 고품질 썸네일`(480x360)` |  https://img.youtube.com/vi/영상코드/hqdefault.jpg |
| 중간품질 썸네일`(320x180)` |  https://img.youtube.com/vi/영상코드/mqdefault.jpg |
| 보통품질 썸네일`(120x90)` | https://img.youtube.com/vi/영상코드/default.jpg |

### 2. Youtube 영상을 모달로 표시하기

![이미지](/images/2025/0730/fslightbox-case3.png)

#### 상태변수 정의

```javascript
const [youtubeToggler, setYoutubeToggler] = useState(false);
```

#### 모달창 구현

`<FsLightbox>` 컴포넌트의 `sources` 프로퍼티에 Youtube 영상 주소를 지정하면 된다.

```jsx
<button className="btn" onClick={e => setYoutubeToggler(!youtubeToggler)}>
    <img src='https://img.youtube.com/vi/pssTvN-X4VY/hqdefault.jpg' width="150" alt="img1" />
</button>
<FsLightbox toggler={youtubeToggler} sources={["https://www.youtube.com/watch?v=pssTvN-X4VY"]}/>
```

### 3. 여러 개의 영상 처리하기

![이미지](/images/2025/0730/fslightbox-case4.png)

`<FsLightbox>` 컴포넌트의 `sources` 프로퍼티에 Youtube 영상 주소를 배열로 지정한다.

#### 상태변수 정의

```javascript
const [youtubeMultiToggler, setYoutubeMultiToggler] = useState({
    open: false,
    index: 1
});
```

#### 모달창 구현

```jsx
<button className="btn" onClick={e => setYoutubeMultiToggler({open: !youtubeMultiToggler.open, index: 1})}>
    <img src='https://img.youtube.com/vi/RtPwBk0pqKE/hqdefault.jpg' width="150" alt="img1" />
</button>
<button className="btn" onClick={e => setYoutubeMultiToggler({open: !youtubeMultiToggler.open, index: 2})}>
    <img src='https://img.youtube.com/vi/Aawei6-InKQ/hqdefault.jpg' width="150" alt="img1" />
</button>
<button className="btn" onClick={e => setYoutubeMultiToggler({open: !youtubeMultiToggler.open, index: 3})}>
    <img src='https://img.youtube.com/vi/k7LhdJPUTQ0/hqdefault.jpg' width="150" alt="img1" />
</button>
<FsLightbox toggler={youtubeMultiToggler.open} sources={[
    'https://www.youtube.com/watch?v=RtPwBk0pqKE',
    'https://www.youtube.com/watch?v=Aawei6-InKQ',
    'https://www.youtube.com/watch?v=k7LhdJPUTQ0'
]} slide={youtubeMultiToggler.index}/>
```

## #05. 다양한 미디어 타입 지원

### 1. 지원되는 미디어 타입

FsLightbox는 다양한 미디어 형식을 지원한다:

#### 이미지 형식
- **JPG/JPEG**: `image.jpg`, `image.jpeg`
- **PNG**: `image.png`
- **GIF**: `animated.gif`
- **WebP**: `image.webp`
- **SVG**: `vector.svg`

#### 동영상 형식
- **MP4**: `video.mp4`
- **WebM**: `video.webm`
- **OGV**: `video.ogv`

#### 스트리밍 플랫폼
- **YouTube**: `https://www.youtube.com/watch?v=VIDEO_ID`
- **Vimeo**: `https://vimeo.com/VIDEO_ID`

### 2. 혼합 미디어 갤러리

```jsx
const [mixedToggler, setMixedToggler] = useState({
    open: false,
    index: 1
});

const mixedSources = [
    // 이미지
    '/images/photo1.jpg',
    '/images/photo2.png',

    // 동영상 파일
    '/videos/sample.mp4',

    // YouTube 동영상
    'https://www.youtube.com/watch?v=dQw4w9WgXcQ',

    // Vimeo 동영상
    'https://vimeo.com/1234567'
];

return (
    <div>
        {mixedSources.map((source, index) => (
            <button
                key={index}
                onClick={() => setMixedToggler({open: true, index: index + 1})}
            >
                미디어 {index + 1}
            </button>
        ))}

        <FsLightbox
            sources={mixedSources}
            toggler={mixedToggler.open}
            slide={mixedToggler.index}
        />
    </div>
);
```

### 3. 동영상 자동재생 설정

```jsx
// YouTube 동영상 자동재생
const youtubeAutoplay = 'https://www.youtube.com/watch?v=VIDEO_ID&autoplay=1';

// HTML5 동영상 자동재생
const videoWithControls = (
    <video controls autoPlay>
        <source src="/videos/sample.mp4" type="video/mp4" />
    </video>
);
```

## #06. 고급 사용법과 팁

### 1. 동적 소스 로딩

```jsx
const [sources, setSources] = useState([]);
const [toggler, setToggler] = useState(false);

// API에서 이미지 목록 가져오기
useEffect(() => {
    fetch('/api/gallery')
        .then(res => res.json())
        .then(data => setSources(data.images));
}, []);

// 이미지 미리로딩
const preloadImages = (imageUrls) => {
    imageUrls.forEach(url => {
        const img = new Image();
        img.src = url;
    });
};

useEffect(() => {
    if (sources.length > 0) {
        preloadImages(sources);
    }
}, [sources]);
```

### 2. 터치/스와이프 제스처

```jsx
// 모바일에서 스와이프 제스처는 기본적으로 지원됨
// 추가 설정 없이 좌우 스와이프로 슬라이드 변경 가능

<FsLightbox
    sources={sources}
    toggler={toggler}
    // 모바일 최적화를 위한 설정
    slideDistance={0.1}  // 스와이프 민감도
/>
```

### 3. 키보드 네비게이션

FsLightbox는 기본적으로 키보드 네비게이션을 지원합니다:

- **ESC**: 라이트박스 닫기
- **←/→**: 이전/다음 슬라이드
- **Space**: 슬라이드쇼 일시정지/재생
- **F**: 전체화면 모드 (동영상)

### 4. 접근성 (Accessibility) 개선

```jsx
<button
    className="btn"
    onClick={() => setToggler(true)}
    aria-label="이미지 갤러리 열기"
    role="button"
>
    <img
        src={thumbnail}
        alt="갤러리 썸네일 - 클릭하여 확대보기"
        width={150}
    />
</button>

<FsLightbox
    sources={sources}
    toggler={toggler}
    // 스크린 리더를 위한 설정
    onOpen={() => {
        // 포커스 트랩 설정
        document.body.style.overflow = 'hidden';
    }}
    onClose={() => {
        document.body.style.overflow = 'auto';
    }}
/>
```

## #06. 전체 소스코드

```jsx
/**
 * FsLightBoxEx
 * 어떤 요소(img, button, a 등)를 클릭했을 때
 * 지정된 이미지, 영상 등을 모달 팝업으로 표시하는 기능
 *
 * 공식 사이트: https://fslightbox.com/
 * 설치: yarn add fslightbox-react
 */

import React, {memo, useState} from 'react';
import styled from 'styled-components';
import FsLightbox from 'fslightbox-react';

// 샘플 이미지 import
import img1 from '../../assets/img/img1.png';
import img2 from '../../assets/img/img2.png';
import img3 from '../../assets/img/img3.png';
import img4 from '../../assets/img/img4.png';
import img5 from '../../assets/img/img5.png';

// 스타일 컴포넌트 정의
const FsLightboxExContainer = styled.div`
   .btn {
        border: 0;
        outline: none;
        cursor: pointer;
        padding: 0;
        margin: 0 5px;
        transition: transform 0.2s ease;

        &:hover {
            transform: scale(1.05);
        }

        &:focus {
            outline: 2px solid #007bff;
            outline-offset: 2px;
        }
    }

    .gallery-section {
        margin: 2rem 0;
        padding: 1rem;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
    }

    .gallery-title {
        color: #333;
        margin-bottom: 1rem;
    }
`;

const FsLightboxEx = memo(() => {
    // 단일 이미지를 사용할 경우 모달창 표시 여부에 대한 상태값
    const [singleToggler, setSingleToggler] = useState(false);

    // 복수 이미지를 사용할 경우 모달창 표시 여부와 몇 번째 이미지를 표시할지에 대한 상태값
    const [multiToggler, setMultiToggler] = useState({
        open: false,
        index: 1
    });

    // 단일 Youtube 영상을 사용할 경우 모달창 표시 여부에 대한 상태값
    const [youtubeToggler, setYoutubeToggler] = useState(false);

    // 복수 Youtube 영상을 사용할 경우 모달창 표시 여부와 몇 번째 영상을 표시할지에 대한 상태값
    const [youtubeMultiToggler, setYoutubeMultiToggler] = useState({
        open: false,
        index: 1
    });

    return (
        <FsLightboxExContainer>
            <h2>FsLightbox 사용 예시</h2>

            {/* 단일 이미지 갤러리 */}
            <div className="gallery-section">
                <h3 className="gallery-title">단일 이미지 갤러리</h3>
                <button
                    className="btn"
                    onClick={() => setSingleToggler(!singleToggler)}
                    aria-label="단일 이미지 보기"
                >
                    <img src={img1} width={150} alt="샘플 이미지 1" />
                </button>
                <FsLightbox
                    sources={[img1]}
                    toggler={singleToggler}
                    onClose={() => setSingleToggler(false)}
                />
            </div>

            {/* 복수 이미지 갤러리 */}
            <div className="gallery-section">
                <h3 className="gallery-title">복수 이미지 갤러리</h3>
                <div>
                    {[img1, img2, img3, img4, img5].map((img, index) => (
                        <button
                            key={index}
                            className="btn"
                            onClick={() => setMultiToggler({open: !multiToggler.open, index: index + 1})}
                            aria-label={`이미지 ${index + 1} 보기`}
                        >
                            <img src={img} width={150} alt={`샘플 이미지 ${index + 1}`} />
                        </button>
                    ))}
                </div>
                <FsLightbox
                    sources={[img1, img2, img3, img4, img5]}
                    toggler={multiToggler.open}
                    slide={multiToggler.index}
                    onClose={() => setMultiToggler({...multiToggler, open: false})}
                />
            </div>

            {/* 단일 YouTube 영상 */}
            <div className="gallery-section">
                <h3 className="gallery-title">YouTube 단일 영상</h3>
                <button
                    className="btn"
                    onClick={() => setYoutubeToggler(!youtubeToggler)}
                    aria-label="YouTube 영상 재생"
                >
                    <img
                        src='https://img.youtube.com/vi/pssTvN-X4VY/hqdefault.jpg'
                        width="150"
                        alt="YouTube 영상 썸네일"
                    />
                </button>
                <FsLightbox
                    toggler={youtubeToggler}
                    sources={["https://www.youtube.com/watch?v=pssTvN-X4VY"]}
                    onClose={() => setYoutubeToggler(false)}
                />
            </div>

            {/* 복수 YouTube 영상 */}
            <div className="gallery-section">
                <h3 className="gallery-title">YouTube 복수 영상</h3>
                <div>
                    {[
                        {id: 'RtPwBk0pqKE', title: 'YouTube 영상 1'},
                        {id: 'Aawei6-InKQ', title: 'YouTube 영상 2'},
                        {id: 'k7LhdJPUTQ0', title: 'YouTube 영상 3'}
                    ].map((video, index) => (
                        <button
                            key={video.id}
                            className="btn"
                            onClick={() => setYoutubeMultiToggler({open: !youtubeMultiToggler.open, index: index + 1})}
                            aria-label={`${video.title} 재생`}
                        >
                            <img
                                src={`https://img.youtube.com/vi/${video.id}/hqdefault.jpg`}
                                width="150"
                                alt={`${video.title} 썸네일`}
                            />
                        </button>
                    ))}
                </div>
                <FsLightbox
                    toggler={youtubeMultiToggler.open}
                    sources={[
                        'https://www.youtube.com/watch?v=RtPwBk0pqKE',
                        'https://www.youtube.com/watch?v=Aawei6-InKQ',
                        'https://www.youtube.com/watch?v=k7LhdJPUTQ0'
                    ]}
                    slide={youtubeMultiToggler.index}
                    onClose={() => setYoutubeMultiToggler({...youtubeMultiToggler, open: false})}
                />
            </div>
        </FsLightboxExContainer>
    );
});

export default FsLightboxEx;
```

### 7. 성능 최적화

```jsx
// React.memo로 불필요한 리렌더링 방지
const OptimizedGallery = memo(({ images }) => {
    const [toggler, setToggler] = useState(false);

    // 이미지 lazy loading
    const [loadedImages, setLoadedImages] = useState(new Set());

    const handleImageLoad = (index) => {
        setLoadedImages(prev => new Set([...prev, index]));
    };

    return (
        <div>
            {images.map((img, index) => (
                <img
                    key={index}
                    src={loadedImages.has(index) ? img : placeholder}
                    loading="lazy"
                    onLoad={() => handleImageLoad(index)}
                    onClick={() => setToggler(true)}
                />
            ))}
        </div>
    );
});
```

----