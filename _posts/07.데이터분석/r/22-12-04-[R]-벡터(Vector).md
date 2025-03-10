---
layout: post
title:  "[R] 벡터(Vector)"
date:   2022-12-04
banner_image: index-r.png
tags: [R]
---

여러 개의 스칼라 값들을 연속적으로 저장하는 데이터 형식으로 **연속성 자료형**이라고도 부릅니다. R에서의 연속성 자료형에는 벡터, 요인, 리스트 등이 있습니다.



# #01. 벡터의 이해

## 1) 기본적인 벡터 생성

- 벡터는 한 줄로 구성된 사물함 같은 형태로 스칼라 값의 모음.
- `c()` 함수를 사용하여 포함하고자 하는 같은 종류의 스칼라 값들을 콤마로 구분한다.
- *~~일반 프로그래밍 언어에서 이야기하는 1차 배열의 개념.~~*

### 벡터 생성하기

```r
# 다른 종류의 값들을 c() 함수에 콤마로 구분하여 배치
# --> 가장 포괄적인 스칼라 타입으로 모두 통일된다.
foo <- c("hello", "world", 1L, 3.14, TRUE, NA, NULL, Inf)
foo

# 같은 종류의 값들로만 구성한 경우
bar <- c(1, 2, 3, 4, 5)
bar
```

#### 💻 출력결과

> 💡 여러 종류의 값들이 혼합된 경우 가장 포괄적인 타입은 문자열이기 때문에 모든 값에 문자열을 의미하는 따옴표가 적용되어 출력된다. (단, NA는 예외 / NULL은 실존하지 않고 개념적으로만 존재하는 값이므로 출력 안됨)

```r
'hello''world''1''3.14''TRUE'NA'Inf'
12345
```

## 2) 벡터 인덱스

벡터에 포함되는 각 원소는 1부터 시작되는 일련번호를 부여받는다 --> `인덱스`

### 인덱스 번호를 사용하여 개별적인 원소 값을 출력하기

대괄호를 사용하여 인덱스 번호를 명시한다.

```r
foo <- c(100, 200, 300, 400, 500)
foo[1]
foo[3]
foo[5]
```

#### 💻 출력결과

```r
100
300
500
```

### 음수값 형태의 인덱스를 활용하여 인덱스가 2인 원소를 제외하고 모두 출력

```r
foo <- c(100, 200, 300, 400, 500)
foo[-2]
```

#### 💻 출력결과

```r
100 300 400 500
```

## 3) 벡터의 타입

벡터는 모든 원소값을 가장 표현 범위가 큰 자료형으로 통일하여 변환한다.

### 문자열을 제외한 데이터끼리의 형식 변환

정수, 실수, 논리값의 경우 실수가 가장 표현범위가 넓다.

> 💡 논리값 < 정수 < 실수 < 문자열

- 정수를 논리값으로 형변환 하는 경우 → 0은 `FALSE`, 0이 아닌 모든 수는 `TRUE`
- 논리값을 정수로 형변환 하는 경우 → `FALSE`는 0, `TRUE`는 1

### 문자열이 포함된 벡터의 타입 확인

- 문자열보다 표현 범위가 더 큰 자료형은 없으므로 모든 데이터의 형식이 문자열로 변환된다.
- `typeof()` 는 전달된 매개변수의 종류를 반환하는 기능

```r
foo <- c("hello", "world", 1L, 3.14, TRUE, NA, NULL, Inf)
typeof(foo)
typeof(foo[1])
typeof(foo[3])
typeof(foo[5])
```

#### 💻 출력결과

```r
'character'
'character'
'character'
'character'
```

### 문자열이 포함되지 않은 벡터의 타입 확인

```r
bar = c(1L, 2.3, TRUE)# 정수와 실수가 섞여 있는 벡터 생성
bar   # 생성결과 확인
```

#### 💻 출력결과

```r
1  2.3  1
```

### 정수와 실수로 구성된 벡터의 타입 확인

```r
typeof(bar)   # 대표타입 확인
typeof(bar[1])# 각 원소의 타입 확인
typeof(bar[2])# 각 원소의 타입 확인
```

#### 💻 출력결과

```r
'double'
'double'
'double'
```

## 4) 벡터의 중첩

벡터 안에 다른 벡터가 포함될 경우 단일 차원으로 변환된다.

```r
foo <- c(1, 2, 3)
bar <- c(10, 20, foo)
bar
```

#### 💻 출력결과

```r
10  20  1  2  3
```

# #02. 벡터의 활용

## 1) 벡터의 연산

길이가 동일한 벡터끼리 사칙, 비교, 논리 연산을 수행 할 수 있으며
이 때, 위치가 동일한 원소들끼리 연산이 수행된다.

만약 두 벡터간의 원소수가 다르다면 경고메시지가 출력된다.

### 길이(원소의 수)가 같은 벡터끼리의 연산

```r
v1 <- c(1, 2, 3)
v2 <- c(10, 20, 30)
v1 + v2
```

#### 💻 출력결과

```r
11  22  33
```

## 2) 벡터와 스칼라 값에 대한 연산

벡터의 모든 원소에게 스칼라 값에 대한 연산이 적용된다.

사칙,논리,비교 연산 모두 가능

### 벡터와 스칼라 값 연산

```r
v3 <- c(11, 22, 33)
v3 + 10
```

#### 💻 출력결과

```r
21  32  43
```

## 3) 벡터의 슬라이싱

구간을 지정하여 값을 추출하는 형식으로 지정된 끝 위치까지 추출한다.

> 💡 벡터이름[시작위치:끝위치]

### 벡터의 슬라이싱(범위지정)

```r
foo <- c( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 )
a <- foo[5:8]
a
```

#### 💻 출력결과

```r
5  6  7  8
```


## 4) 벡터와 관련된 함수

### 벡터의 길이(=원소의 수) 확인

```r
test <- c( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 )
x <- length(test)
x
```

#### 💻 출력결과

```
10
```

### 벡터의 길이를 확인하는 두 번째 방법

```r
test <- c( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 )
y <- NROW(test)
y
```

#### 💻 출력결과

```r
10
```

### 기술통계 관련 기본 함수들

*여기서 출력되는 값들의 의미는 EDA 관련 단원에서 상세히 소개합니다.*

```r
# 데이터 준비하기
sample <- c(1,2,3,4,5)

print( sum(sample) )# 합계 구하기
print( max(sample) )# 최대값 구하기
print( min(sample) )# 최소값 구하기
print( mean(sample) )   # 평균값 구하기
print( median(sample) ) # 중앙값
print( var(sample) )# 분산
print( sd(sample) ) # 표준편차
```

#### 💻 출력결과

```r
15
5
1
3
3
2.5
1.58113883008419
```


## 5) 정형화 된 벡터를 생성하는 방법들

### `seq(a, b, c)` 함수

- a부터 b까지 원소가 c씩 증가하는 벡터.
- c가 생략될 경우 1씩 증가한다.

### 1부터 5까지 1씩 증가하는 값을 원소로 갖는 벡터 생성

```r
c <- seq(1, 5)
c
```

#### 💻 출력결과

```
1  2  3  4  5
```

### seq() 함수의 축약표현

```r
d <- 1:5
d
```

#### 💻 출력결과

```r
1  2  3  4  5
```

### 0부터 9까지 3씩 증가하는 값을 원소로 갖는 벡터 만들기

```r
e <- seq(0, 9, 3)
e
```

#### 💻 출력결과

```r
0  3  6  9
```

### `seq_len(n)` 함수

1부터 1씩 증가하는 값 n개를 원소로 갖는 벡터

```r
f <- seq_len(5)
f
```

#### 💻 출력결과

```r
1  2  3  4  5
```

### `seq_along(vector)`

1부터 주어진 vector의 길이까지 순차적으로 증가하는 값을 갖는 벡터

```r
# 주어진 데이터가 c('hello','bigdata','world') 이므로 길이는 3
tmp <- c('hello','bigdata','world')
g <- seq_along(tmp)
g
```

#### 💻 출력결과

```r
1  2  3
```

### `rep(start:end, count)`

start부터 end까지의 범위를 count 회 반복하여 원소들을 생성

```r
h <- rep(1:3, 3)
h
```

#### 💻 출력결과

```r
1  2  3  1  2  3  1  2  3
```

### `names(vector) <- c(...)`

vector의 각 원소에 대해 대입된 벡터의 원소로 이름표를 지정한다.

```r
# 테스트를 위한 벡터 지정
점수 <- c(72, 86, 82)

# `점수`벡터의 각 원소에 이름을 지정
names(점수) <- c('철수', '형석', '미영')

# 이름표가 적용된 결과 확인
점수
```

#### 💻 출력결과

```r
철수 : 72  형석 : 86  미영 : 82
```

### names(vector) 함수의 결과에 대한 이름표를 활용하여 특정 원소에 접근

```r
점수['형석']
```

#### 💻 출력결과

```r
형석: 86
```