---
layout: post
title:  "[파이썬] API 문서 자동 생성하기"
date:   2024-03-25
banner_image: index-computing.png
tags: [Python]
---

자신만의 모듈을 만들고 나면 함수나 클래스 단위로 주석을 작성합니다. 이 주석을 읽어들여서 레퍼런스 문서를 자동으로 생성해 주는 기능을 소개합니다.

<!--more-->

# #01. 모듈화 기능의 주석문 예시

파이썬에서 함수 단위의 주석은 아래와 같은 형식으로 작성됩니다.

```python
def my_normalize_data(
    mean: float, std: float, size: int = 100, round: int = 2
) -> np.ndarray:
    """정규분포를 따르는 데이터를 생성한다.

    Args:
        mean (float): 평균
        std (float): 표준편차
        size (int, optional): 데이터 크기. Defaults to 1000.

    Returns:
        np.ndarray: 정규분포를 따르는 데이터
    """
    p = 0
    x = []
    while p < 0.05:
        x = np.random.normal(mean, std, size).round(round)
        _, p = normaltest(x)

    return x
```

# #02. 레퍼런스 생성 자동화 하기

## [1] 패키지 설치

pdoc 이라는 패키지를 설치합니다.

```shell
pip install pdoc
```

## [2] 문서 생성

작업 폴더 위치에서 명령 수행

```shell
pdoc --html --output-dir 생성될폴더이름 패키지폴더이름
```

### 사용 예

```shell
pdoc --html --output-dir docs helper
```