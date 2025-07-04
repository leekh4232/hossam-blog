---
title:  "VSCode에서 Copilet으로 다이어그램 생성하기"
description: SpringBoot 프로젝트 수업을 진행하면서 클래스 다이어그램과 시퀀스 다이어그램을 소개하고자 했는데, IntelliJ의 다이어그램 생성기능이 무료 버전에서는 마음에 들지 않아 시도해 본 방법이다. 결과물은 꽤나 마음에 든다.
categories: [91.AI활용,Copilet]
date:   2024-12-13 23:13:00 +0900
author: Hossam
image: /images/photo/study-cafe.png
tags: [AI,vscode,copilet]
pin: true
math: true
mermaid: true
---

## 준비작업

VSCode에서 컨트롤러 클래스를 열어 놓은 상태에서 코파일럿을 실행한다.

아예 `src/main` 폴더를 통째로 끌어 넣으면 편하다.

그리고 아래의 질문을 수행한다.

### 1. 클래스 다이어그램

```
다음에 유의해서 `클래스이름` 대한 클래스 다이어그램을 생성해줘.
1. 클래스이름,  생성자,  파라미터 타입,  리턴타입을 명시할 것.
2. 이 클래스와 연관된 모든 IsA,  HasA 관계를 포함할 것
3. 결과 코드는 PlantUML 형식일 것.
4. "또는"과 같은 표현으로 한 번에 두 개 이상의 메서드를 표시해서는 안됨
5. dpi를 200으로 설정할 것
```

![hello.png](/images/2024/1213/hello.png)

### 2. 시퀀스 다이어그램

```
다음에 유의해서 `클래스이름.메서드이름`에 대한 시퀀스다이어그램을 각각 만들어줘
1. Actor > Controller > Service > Mapper > Helper > Database 순으로 나열할 것.
2. 결과 코드는 PlantUML 형식일 것.
3. "또는"과 같은 표현으로 한 번에 두 개 이상의 메서드를 표시해서는 안됨
4. Database에 대한 호출시에는 사용된 SQL문의 유형을 함께 표시할 것
    - SELECT, INSERT, UPDATE, DELETE
5. 파라미터를 표시할 때는 데이터 타입도 함께 명시할 것
6. dpi를 200으로 설정할 것
```

![world.png](/images/2024/1213/world.png)

만약, 파라미터가 너무 많아서 다이어그램이 이상해 보인다면 파라미터에 대한 요구사항을 조절해서 사용해야 한다.
