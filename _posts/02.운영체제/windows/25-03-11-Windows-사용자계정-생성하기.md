---
title:  "Windows 사용자 계정 생성하기"
description: "윈도우에 사용자 계정을 생성하면 여러명이 컴퓨터를 함께 사용하더라도 서로 사용 환경이 중복되지 않는다는 이점이 있습니다. 특히 공용 PC인 경우 사용자 계정을 만들어 두면 다른 사람과 다른 환경을 사용할 수 있기 때문에 매우 편합니다."
categories: [02.Operating System,Windows]
tags: [컴퓨터활용,Operating System,Windows,사용자계정]
image: /images/index-windows.webp
date: 2025-03-11 23:34:09 +0900
author: Hossam
pin: true
math: true
mermaid: true
---

## #01. 관리도구 열기

윈도우 폴더 창에서 **내 PC**를 마우스로 우클릭합니다.

윈도우10의 경우 바로 **관리** 메뉴가 보이지만, 윈도우11은 **추가 옵션 표시**를 클릭한 후에 **관리** 메뉴를 선택할 수 있습니다.

![](/images/2025/0311/01.png)

## #02. 사용자 계정 설정

### 1. 계정 생성하기

관리도구의 왼쪽 트리에서 **로컬 사용자 및 그룹** 하위의 **사용자** 항목을 클릭합니다.

관리도구의 오른쪽 화면이 변경되면 빈 공간에서 마우스 우클릭 후 **새 사용자**항목을 선택합니다.

![](/images/2025/0311/02.png)

### 2. 새 사용자 정보 입력

사용자 이름, 전체 이름, 암호 등을 입력하고 로그인 시 암호를 변경하지 않음의 선택을 해제, 암호 사용 기간 제한 없음 선택 등을 설정한 후 **만들기** 버튼을 클릭합니다.

계정이 생성되면 다시 모든 입력 항목이 비워집니다. **닫기**를 눌러 창을 닫습니다.

![](/images/2025/0311/03.png)

### 3. 권한 설정하기

윈도우를 처음 설치할 때 생성되는 사용자는 관리자 권한을 갖고 있지만 새로 생성되는 사용자는 일반 사용자 권한을 갖고 있습니다. 이 권한은 프로그램 설치가 불가능하며 그 밖에 컴퓨터의 설정을 수정할 수도 없어서 사용하기에 불편한 점이 많습니다.

사용자 권한을 변경하기 위해서 소속 그룹을 `Users`에서 `Administrators`로 변경해야 합니다. `Administrators`는 윈도우의 관리자 권한을 갖는 사용자들의 그룹입니다.

새로 추가된 사용자를 마우스로 우클릭 하여 **속성**을 선택합니다.

![](/images/2025/0311/04.png)

**속성**창이 열리면 **소속 그룹**탭으로 이동 후에 **추가**버튼을 누릅니다.

![](/images/2025/0311/05.png)

추가할 그룹 이름 `Administrators`를 입력한 후에 **이름 확인** 버튼을 누르면 오른쪽과 같이 그룹의 전체 이름이 셋팅됩니다. 만약 오타가 있다면 전체 이름이 생성되지 않습니다.

전체 이름을 확인했다면 **확인** 버튼을 누릅니다.

![](/images/2025/0311/06.png)

원래의 화면으로 돌아오면 기본적으로 부여 되어 있던 `Users` 그룹을 제거하고 **확인**을 눌러 창읃 닫습니다.

![](/images/2025/0311/08.png)

## #03. 새로운 사용자로 로그인하기

윈도우의 시작 버튼을 마우스로 우클릭하여 로그아웃 합니다.

![](/images/2025/0311/09.png)

로그인 화면의 좌측 하단에서 새로 생성된 사용자를 선택하면 로그인이 가능합니다.

![](/images/2025/0311/10.png)