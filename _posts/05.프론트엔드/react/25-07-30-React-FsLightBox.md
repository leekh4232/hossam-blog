---
title:  "[React] FsLightbox 플러그인 사용"
description: "어떤 요소를 클릭했을 때 지정된 이미지나 영상 등을 모달창으로 띄울 수 있게 하는 플러그인"
categories: [05.Frontend,React]
tags: [Web Development,Frontend,React,Windows,Batch]
image: /images/index-react.png
date:2025-07-30 10:00:22
author: Hossam
pin: true
math: true
mermaid: true
---

## #01. 플러그인 설치

https://fslightbox.com/ 에서 자세한 내용을 확인할 수 있다.

```shell
$ yarn add fslightbox-react
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

```javascript
<button className="btn" onClick={e => { setSingleToggler(!singleToggler) }}>
    <img src={img1} width={150} alt="img1" />
</button>
<FsLightbox sources={[img1]} toggler={singleToggler} />
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

```javascript
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

## #03. Youtube 영상에 대한 처리

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

```javascript
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

```javascript
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

----

## 전체 소스코드

```javascript
/**
 * FsLightBoxEx
 *  어떤 요소(img, button, a 등)를 클릭했을 때
 *  지정된 이미지, 영상 등을 모달 팝업으로 표시하는 기능
 *
 * https://fslightbox.com/
 *
 * yarn add fslightbox-react
 *
 * [Youtube 썸네일]
 * - 동영상 배경 썸네일(480x360): https://img.youtube.com/vi/영상코드/0.jpg
 * - 동영상 시작지점 썸네일(120x90): https://img.youtube.com/vi/영상코드/1.jpg
 * - 동영상 중간지점 썸네일(120x90): https://img.youtube.com/vi/영상코드/2.jpg
 * - 동영상 끝지점 썸네일(120x90): https://img.youtube.com/vi/영상코드/3.jpg
 * - 고해상도 썸네일(1280x720): https://img.youtube.com/vi/영상코드/maxresdefault.jpg
 * - 중간해상도 썸네일(640x480): https://img.youtube.com/vi/영상코드/sddefault.jpg
 * - 고품질 썸네일(480x360): https://img.youtube.com/vi/영상코드/hqdefault.jpg
 * - 중간품질 썸네일(320x180): https://img.youtube.com/vi/영상코드/mqdefault.jpg
 * - 보통품질 썸네일(120x90):  https://img.youtube.com/vi/영상코드/default.jpg
 */

import React, {memo, useState} from 'react';

import styled from 'styled-components';

import FsLightbox from 'fslightbox-react';

import img1 from '../../assets/img/img1.png';
import img2 from '../../assets/img/img2.png';
import img3 from '../../assets/img/img3.png';
import img4 from '../../assets/img/img4.png';
import img5 from '../../assets/img/img5.png';

const FsLightboxExContainer = styled.div`
   .btn {
        border: 0;
        outline: none;
        cursor: pointer;
        padding: 0;
        margin: 0 5px;
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
            <h2>FsLightboxEx</h2>

            <h3>Single Gallery</h3>
            <div>
                <button className="btn" onClick={e => { setSingleToggler(!singleToggler) }}>
                    <img src={img1} width={150} alt="img1" />
                </button>
                <FsLightbox sources={[img1]} toggler={singleToggler} />
            </div>

            <h3>Multi Gallery</h3>
            <div>
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
                <FsLightbox toggler={multiToggler.open} sources={[img1, img2, img3, img4, img5]} slide={multiToggler.index}/>
            </div>

            <h3>Youtube Single link</h3>
            <div>
                <button className="btn" onClick={e => setYoutubeToggler(!youtubeToggler)}>
                    <img src='https://img.youtube.com/vi/pssTvN-X4VY/hqdefault.jpg' width="150" alt="img1" />
                </button>
                <FsLightbox toggler={youtubeToggler} sources={["https://www.youtube.com/watch?v=pssTvN-X4VY"]}/>
            </div>

            <h3>Youtube Multi link</h3>
            <div>
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
            </div>


        </FsLightboxExContainer>
    );
});

export default FsLightboxEx;
````