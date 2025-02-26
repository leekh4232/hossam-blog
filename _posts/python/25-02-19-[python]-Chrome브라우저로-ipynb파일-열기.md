---
layout: post
title:  "[파이썬] Chrome 브라우저로 ipynb 파일 열기"
date:   2025-02-19
banner_image: index-computing.png
tags: [Python]
---

Jupyter나 VSCode로 작성한 ipynb 파일을 간단히 열람하고자 할 때 사용할 적절한 뷰어를 찾다가 Chrome Extension을 발견했다. 파일의 내용을 확인하는 용도로 사용하기 좋고, 적당한 인쇄 방법을 고민한다면 이 방법으로 파일을 열고 Chrome을 통해 인쇄하거나 pdf로 저장할 수 있다.

<!--more-->

# #01. Chrome Extension 설치

## 1. 크롬 웹 스토어 방문

구글에서 **크롬 웹 스토어**로 검색하고 사이트에 방문한다.

![img](/images/posts/2025/0219/ipynb_viewer_01.png)

## 2. Extension 검색

**Jupyter Notebook Viewer**로 검색하고 검색 결과 페이지로 이동한다.

![img](/images/posts/2025/0219/ipynb_viewer_02.png)

## 3. Extension 설치하고

상세 페이지의 우측 상단에 표시되는 **Chrome에 추가** 버튼을 누르면 설치가 진행된다.

![img](/images/posts/2025/0219/ipynb_viewer_03.png)

# #02. Extension 설정

## 1. 설정화면 열기

크롬 브라우저의 우측 상단에 있는 퍼즐 모양의 아이콘을 클릭하면 설치되어 있는 확장 프로그램 목록이 표시된다. 이 중에서 **Jupyter Notebook Viewer**를 찾아서 클릭한다.

![img](/images/posts/2025/0219/ipynb_viewer_04.png)

## 2. 기본 설정

### 테마

여러 가지 테마를 적용해 보고 마음에 드는 것을 사용하는 것이 가장 좋겠지만 개인적으로 Github 테마가 가장 깔끔해 보였다.

**wide**를 활성화 하면 브라우저 가로에 가득 차게 표시된다. 활성화 하지 않을 경우 항상 고정된 넓이로 표시된다.

![img](/images/posts/2025/0219/ipynb_viewer_05.png)

### 컴파일러

Jupyter를 해석하는 엔진을 고른다. 잘 모르겠으면 모두 다 활성화 하자.

![img](/images/posts/2025/0219/ipynb_viewer_06.png)

### 컨텐트

화면에 표시할 컨텐츠 종류를 활성화 한다. 첫 번째 항목인 `autoreload`는 파일이 수정되면 자동으로 새로고침 되는 기능이다. 그 밖에 이모지(`emoji`), LaTex 수학식(`mathjax`), 프로그램에서 사용되는 UML 다이어그램 (`mermaid`), 가로 스크롤바(`scroll`) 등의 기능이 있다.

`toc` 항목을 활성화 할 경우 ipynb 파일의 markdown 블록에 명시한 제목을 기반으로 문서의 개요를 생성해서 좌측에 표시해 준다. 단, 인쇄를 목적으로 하는 경우 이 옵션은 활성화 하지 말자.

![img](/images/posts/2025/0219/ipynb_viewer_07.png)

## 3. 파일 엑세스 설정

웹 브라우저는 항상 온라인에 연결되어 있는 프로그램이기 때문에 기본적으로 내 컴퓨터 내의 파일에 대한 접근이 제한적이다.

여기서는 내 컴퓨터의 파일을 열람하는 것이 목적이므로 설정을 통해 지금 설정중인 익스텐션이 내 컴퓨터 파일에 접근할 수 있도록 해야 한다.

### 1. 상세 설정 창 열기

**Advanced Options** 버튼을 클릭한다.

![img](/images/posts/2025/0219/ipynb_viewer_08.png)

상세 설정 화면이 표시되면 **ALLOW ACCESS TO FILE:// URLS** 버튼을 클릭한다.

![img](/images/posts/2025/0219/ipynb_viewer_09.png)

### 2. 파일 URL에 대한 엑세스 허용

크롬 설정 화면이 나타나면 스크롤 중간쯤에 있는 **파일 URL에 대한 엑세스 허용**을 활성화 한다.

![img](/images/posts/2025/0219/ipynb_viewer_10.png)

# #03. 연결 프로그램 설정

ipynb 파일을 더블클릭 했을 때 Chrome이 열리도록 기본 연결 프로그램을 수정해야 한다.

## 1. Windows의 경우

ipynb 파일을 마우스 우클릭하고 **연결 프로그램** 항목을 선택한다.

![img](/images/posts/2025/0219/ipynb_viewer_11.png)

Chrome이 나타나지 않는다면 **PC에서 앱 선택** 버튼을 누른다.

![img](/images/posts/2025/0219/ipynb_viewer_12.png)

크롬 브라우저의 실행 파일을 지정한다. 윈도우 기준으로 크롬 브라우저의 실행파일은 `C:\Program Files\Google\Chrome\Application` 위치에 존재한다.

![img](/images/posts/2025/0219/ipynb_viewer_13.png)

다시 원래의 창으로 돌아오면 Chrome 브라우저가 선택된 상태에서 **항상** 버튼을 클릭한다.

![img](/images/posts/2025/0219/ipynb_viewer_14.png)

이제 ipynb 파일을 더블클릭하면 크롬 브라우저를 통해 열람 가능하다. 아래 화면에서 왼쪽의 문서 개요는 `toc` 옵션을 활성화 한 경우에만 표시된다.

![img](/images/posts/2025/0219/ipynb_viewer_15.png)

## 2. Mac의 경우

ipynb 파일을 마우스 우클릭 한 후 **정보 가져오기** 항목을 선택한다.

![img](/images/posts/2025/0219/ipynb_viewer_17.png)

정보 화면에서 **다음으로 열기** 항목에서 Chrome 브라우저를 지정하고 그 하단의 **모두 변경** 버튼을 클릭하면 Mac에서도 ipynb 파일을 더블클릭 했을 때 Chrome 브라우저로 열리게 된다.

![img](/images/posts/2025/0219/ipynb_viewer_18.png)

# #04. ipynb를 PDF로 변환하기

Chrome으로 ipynb를 연 상태에서 `Ctrl + P`를 눌러 인쇄 대화 상자를 연다. (Mac의 경우 `Cmd + P`)

아래 화면과 같이 설정하면 ipynb를 pdf로 변환할 수 있다.

![img](/images/posts/2025/0219/ipynb_viewer_16.png)