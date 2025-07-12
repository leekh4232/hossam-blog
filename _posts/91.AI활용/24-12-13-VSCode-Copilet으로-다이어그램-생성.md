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
kr.hossam.myshop.controllers 패키지와 그 하위 패키지에 포함된 모든 클래스에 대한 클래스 다이어그램을 PlantUML 로 만들어야 합니다.

다음에 유의해서 각각의 클래스 다이어그램을 생성해 주세요.

1. kr.hossam.myshop 패키지 내의 클래스만 대상으로 할 것
    - 어노테이션에 대한 명시는 필요 없음
2. 클래스이름,  생성자,  파라미터 타입,  리턴타입을 명시할 것.
3. getter, setter, toString 메서드는 제외해야 함
4. 이 클래스와 연관된 모든 IsA,  HasA 관계를 포함할 것
5. 클래스 간의 관계선에 IsA, HasA 텍스트가 명시되어야 함
6. 다이어그램에 포함되는 모든 클래스의 생성자,  필드,  메서드를 명시할 것.
7. 결과 코드는 PlantUML 형식일 것.
8. "또는"과 같은 표현으로 한 번에 두 개 이상의 메서드를 표시해서는 안됨
9. dpi를 200으로 설정할 것 --> "skinparam dpi 200" 구문 사용

위 내용에 따라 작성된 다이어그램을 프로젝트 내에 "uml" 디렉토리를 만들고, "클래스이름_ClassDiagram.puml" 파일로 저장하세요.
- 디렉토리가 이미 존재한다면 존재하는 디렉토리를 사용하세요.
- 동일한 이름의 파일이 이미 있다면 기존 파일을 덮어 쓰세요.
```

![hello.png](/images/2024/1213/hello.png)

### 2. 시퀀스 다이어그램

```
kr.hossam.myshop.controllers 패키지와 그 하위 패키지에 포함된 모든 클래스가 갖는 모든 메서드의 대한 시퀀스 다이어그램을 PlantUML 로 만들어야 합니다.

다음에 유의해서 각각의 시퀀스 다이어그램을 생성해 주세요.

1. kr.hossam.myshop 패키지 내의 클래스만 대상으로 할 것
    - 어노테이션에 대한 명시는 필요 없음
2. Actor > Controller > Service > Mapper > Helper > Database 순으로 나열할 것.
    - Actor는 사용자를 의미함
    - Controller는 kr.hossam.myshop.controllers 패키지에 존재
    - Service는 kr.hossam.myshop.services 패키지에 존재
    - Helper는 kr.hossam.myshop.helpers 패키지에 존재
    - 테이블 스키마는 /src/sql 디렉토리에 저장되어 있음
3. "또는"과 같은 표현으로 한 번에 두 개 이상의 메서드를 표시해서는 안됨
4. Database에 호출시에는 사용된 SQL문의 유형을 텍스트로 표시할 것
    - SELECT, INSERT, UPDATE, DELETE 중 하나 (SQL전문이 아닌 하나의 단어로만 표기)
5. 파라미터를 표시할 때는 데이터 타입도 함께 명시할 것
    - 하지만 파라미터가 3개를 초과할 경우에는 파라미터 명시를 생략하고 '...'으로 표기할 것
6. 리턴이 있는 경우 리턴값의 흐름도 표현할 것
7. RegexHelper에 대한 호출은 하나로 묶어서 처리하고 "유효성 검사"라고만 표기할 것
8. 컨트롤러의 유형이 @RestController인 경우 MyApiResponseAdvice과 MyRestExceptionHandler의 작용도 표시할 것
9. 결과 코드는 PlantUML 형식일 것
10. dpi를 200으로 설정할 것 --> "skinparam dpi 200" 구문 사용

위 내용에 따라 작성된 다이어그램을 프로젝트 내에 "uml/클래스이름" 디렉토리를 만들고, "메서드이름_Sequence.puml" 파일로 저장하세요.
- 디렉토리가 이미 존재한다면 존재하는 디렉토리를 사용하세요.
- 동일한 이름의 파일이 이미 있다면 기존 파일을 덮어 쓰세요.
```

![world.png](/images/2024/1213/world.png)

만약, 파라미터가 너무 많아서 다이어그램이 이상해 보인다면 파라미터에 대한 요구사항을 조절해서 사용해야 한다.

### 3. Swagger를 위한 어노테이션 자동 생성

```
이 프로젝트는 springboot로 진행중이며 Swagger로 WEB-UI를 만들도록 설정되어 있습니다.

다음에 유의하여 kr.hossam.myshop.controllers.apis 패키지 하위의 모든 클래스에 Swagger에 필요한 @Operation,  @Parameters,  @ApiResponses를 추가해 주세요.

1. 각 메서드의 설명은 메서드에 정의된 javadoc 주석을 참고하세요.
2. StringFormatException은 HTTP 상태코드 400에 해당합니다.
3. 그 밖의 Exception은 HTTP 상태코드 500에 해당합니다.
4. @SessionAttribute가 적용된 파라미터에는 `@Parameter(hidden=true)`를 추가해 주세요.

* 참고사항:
    AccountRestController.idUniqueCheck 메서드에 참고할 수 있는 샘플이 구성되어 있습니다.
    이 내용을 토대로 나머지 내용을 처리해 주세요.
```
