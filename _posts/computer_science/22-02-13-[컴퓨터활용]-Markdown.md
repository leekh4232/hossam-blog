---
layout: post
title:  "[컴퓨터활용] Markdown"
date:   2022-02-13
banner_image: index-computing.png
tags: [컴퓨터활용]
---

[**Markdown**](http://whatismarkdown.com/)은 텍스트 기반의 마크업언어로 문서를 쉽고 빠르게 작성할 수 있게 합니다. 마크다운은 별도의 도구없이 간결하게 작성할 수 있고 웹 페이지, pdf등의 다양한 형태로 변환이 가능하며 텍스트(Text)로 저장되기 때문에 용량이 적어 보관이 용이합니다. 또한 지원하는 프로그램과 플랫폼이 다양하기 때문에 활용도가 매우 높습니다.

<!--more-->

# #01. 마크다운 지원 VScode 익스텐션

| 익스텐션 | 개발자 | 설명 |
|---|---|---|
| Markdown All in One | Yu Zhang | 문법강조, 미리보기 기능 지원 |
| Markdown PDF | yzane | PDF 파일 변환 |
| Markdown Preview Github Styling | Matt Bierner(mattbierner.com) | Github 스타일의 미리보기 지원 |
| vscode-pdf | tomoki1207.dev | PDF 뷰어 |

# #02. 새 Markdown 파일 생성

Visual Studio Code에서 `파일 --> 새 텍스트 파일`을 선택한다. 단축키 `Ctrl + N`을 눌러도 좋다.

생성된 파일을 저장하면서 확장자를 `*.md`로 지정하면 Markdown 파일이 생성된다.

# #03. 주요 Markdown 표기법

## 1. 제목 지정하기

`#` 기호 뒤에 한 칸 띄우고 제목을 입력한다.

5수준까지 지원된다.

```markdown
# Heading 1

## Heading 2

### Heading 3

#### Heading 4

##### Heading 5
```

> 미리보기 생략

## 2. 텍스트 입력하기

```markdown
일반 텍스트는 편하게 입력하면 된다.

한줄 바꾸기는 적용되지 않으며
두 줄 바꾸기는 새로운 문단을 생성한다.
```

##### 미리보기

일반 텍스트는 편하게 입력하면 된다.

한줄 바꾸기는 적용되지 않으며
두 줄 바꾸기는 새로운 문단을 생성한다.

### 3. 목록 구성하기

#### 순서 있는 목록

모든 항목을 `1`로 지정하면 된다. `1, 2, 3, 4`와 같이 연속 적인 번호를 기입해도 된다.

**`1.` 뒤에 공백이 필요하다.**

```markdown
1. item1
1. item2
1. item3
1. item4
```

##### 미리보기

1. item1
1. item2
1. item3
1. item4

#### 목록의 계층화

하위 목록은 탭키로 밀어 넣어서 지정한다.

```markdown
1. item1
    1. sub1
    1. sub2
1. item2
    1. sub1
    1. sub2
1. item3
    1. sub1
    1. sub2
```

##### 미리보기

1. item1
    1. sub1
    1. sub2
1. item2
    1. sub1
    1. sub2
1. item3
    1. sub1
    1. sub2


#### 순서 없는 목록

`*` 혹은 `-`를 구분 없이 사용하여 목록을 구성한다. 하위 목록 구성도 가능하다.

**`*` 혹은 `-` 뒤에 공백이 필요하다.**

```markdown
* item1
    - sub1
    - sub2
* item2
    * sub1
    * sub2
- item3
    - sub2
    - sub2
- item4
    * sub1
    - sub2
```


##### 미리보기

* item1
    - sub1
    - sub2
* item2
    * sub1
    * sub2
- item3
    - sub2
    - sub2
- item4
    * sub1
    - sub2

#### 순서 있는 목록과 순서 없는 목록 함께 사용하기

```markdown
1. main1
    * sub1
    * sub2
1. main2
    1. sub-number1
    1. sub-number2
1. main3
    * sub3
    * sub4
```

##### 미리보기

1. main1
    * sub1
    * sub2
1. main2
    1. sub-number1
    1. sub-number2
1. main3
    * sub3
    * sub4

### #03. 소스코드 정리하기

역따옴표 세개(\`\`\`)를 연달아 표시하고  그 뒤에 사용하고자 하는 프로그래밍 언어를 명시한 후 다시 역따옴표 세개로 블록을 만들면 그 안에서 프로그래밍 언어에 대한 설명을 작성할 수 있다.

<pre>```python
for i in range(5):
    print("Hello World")
```</pre>

##### 미리보기

```python
for i in range(5):
    print("Hello World")
```

## #04. Markdown PDF 변환하기

Visual Studio Code Extension에서 `Markdown PDF`를 설치가 되어 있어야 한다.

![md01](/images/posts/2022/0213/md01.png)

작성중인 Markdown 파일에서 `Ctrl + Shift + P`를 눌러서 명령창을 열고 **`Markdown pdf`**로 검색한 후 **`Markdown PDF: Export (pdf)`** 항목을 선택한다.

![md02](/images/posts/2022/0213/md02.png)

이 때 명령창 맨 앞에 `>`가 반드시 포함되어야 한다. 실수로 `>`를 삭제한 경우 다시 입력해야 한다.