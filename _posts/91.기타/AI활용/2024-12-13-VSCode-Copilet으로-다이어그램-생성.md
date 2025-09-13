---
title:  "VSCode에서 Copilet으로 다이어그램 생성하기"
description: SpringBoot 프로젝트 수업을 진행하면서 클래스 다이어그램과 시퀀스 다이어그램을 소개하고자 했는데, IntelliJ의 다이어그램 생성기능이 무료 버전에서는 마음에 들지 않아 시도해 본 방법이다. 결과물은 꽤나 마음에 든다.
categories: [91.AI활용]
date:   2024-12-13 23:13:00 +0900
author: Hossam
image: /images/indexs/study-cafe.png
categories: [91.기타,AI활용]
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
{패키지이름}.controllers 패키지에 포함된 모든 클래스별로 클래스 다이어그램을 PlantUML 로 만들어야 합니다.

[요청사항]
1. 컨트롤러 클래스 1개당 하나의 클래스 다이어그램이 생성되어야 함.
2. {패키지이름} 패키지 내의 클래스만 대상으로 할 것
3. 클래스이름,  생성자,  파라미터 타입,  리턴타입을 명시할 것.
4. 이 클래스와 연관된 모든 IsA,  HasA 관계를 포함할 것
5. 클래스 간의 관계선에 IsA, HasA 텍스트가 명시되어야 함
6. 다이어그램에 포함되는 모든 클래스의 생성자,  필드,  메서드를 명시할 것.
7. 인터페이스와 인터페이스를 상속받는 하위 클래스가 존재할 경우 인터페이스까지만 정의할 것
8. dpi를 200으로 설정할 것 --> "skinparam dpi 200" 구문 사용

[금지사항]
1. 어노테이션에 대한 명시는 필요 없음
2. getter, setter, toString 메서드는 제외할 것
3. "또는"과 같은 표현으로 한 번에 두 개 이상의 메서드를 표시해서는 안됨
4. 패키지 구분은 하지 말 것
5. 인터페이스를 상속 받는 하위 클래스는 다이어그램에 포함시키지 말 것

위 내용에 따라 작성된 다이어그램을 프로젝트 내에 "uml" 디렉토리를 만들고, "[클래스다이어그램] 클래스이름.puml" 파일로 저장하세요.
- 디렉토리가 이미 존재한다면 존재하는 디렉토리를 사용하세요.
- 동일한 이름의 파일이 이미 있다면 기존 파일을 덮어 쓰세요.
```

![hello.png](/images/2024/1213/hello.png)

### 2. 시퀀스 다이어그램

```
{패키지이름}.controllers 패키지와 그 하위 패키지에 포함된 모든 클래스가 갖는 모든 메서드의 대한 시퀀스 다이어그램을 PlantUML 로 만들어야 합니다.

[요청사항]
1. 요청한 클래스에 포함되어 있는 메서드 1개당 하나의 시퀀스 다이어그램이 생성되어야 함.
2. {패키지이름} 패키지 내의 클래스만 대상으로 할 것
2. Actor > Controller > Service > Mapper > Helper > Database 순으로 나열할 것.
    - Actor는 사용자를 의미함
    - Controller는 {패키지이름}.controllers 패키지에 존재
    - Service는 {패키지이름}.services 패키지에 존재
    - Helper는 {패키지이름}.helpers 패키지에 존재
4. Database에 호출시에는 사용된 SQL문의 유형을 텍스트로 표시할 것
    - SELECT, INSERT, UPDATE, DELETE 중 하나 (SQL전문이 아닌 하나의 단어로만 표기)
5. 파라미터를 표시할 때는 데이터 타입도 함께 명시할 것
    - 하지만 파라미터가 3개를 초과할 경우에는 파라미터 명시를 생략하고 '...'으로 표기할 것
6. 리턴이 있는 경우 리턴값의 흐름도 표현할 것
7. RegexHelper에 대한 호출은 하나로 묶어서 처리하고 "유효성 검사"라고만 표기할 것
8. MyRestExceptionHandler가 구현되어 있다면,  Controller에서 예외가 발생했을 때 MyRestExceptionHandler가 예외처리를 해 주고 있다는 것을 포함할 것
9. 각 메서드에서 발생할 수 있는 Exception들만 노트로 추가할 것
10. 결과 코드는 PlantUML 형식일 것
11. dpi를 200으로 설정할 것 --> "skinparam dpi 200" 구문 사용

[금지사항]
1. 어노테이션에 대한 명시는 필요 없음
2. getter, setter, toString 메서드는 제외할 것
3. "또는"과 같은 표현으로 한 번에 두 개 이상의 메서드를 표시해서는 안됨
4. 패키지 구분은 하지 말 것
5. 인터페이스를 상속 받는 하위 클래스는 다이어그램에 포함시키지 말 것
6. 실제로 구현되지 않은 클래스에 대한 내용이 포함되어서는 안됩니다.

위 내용에 따라 작성된 다이어그램을 프로젝트 내에 "uml/[시퀀스다이어그램] 클래스이름" 디렉토리를 만들고, "[시퀀스다이어그램] 클래스이름.메서드이름.puml" 파일로 저장하세요.
- 디렉토리가 이미 존재한다면 존재하는 디렉토리를 사용하세요.
- 동일한 이름의 파일이 이미 있다면 기존 파일을 덮어 쓰세요.

[작성예시]
\`\`\`uml
@startuml
skinparam dpi 300

actor Actor as "사용자"
participant AccountRestController
participant MyApiResponseAdvice
participant MyRestExceptionHandler
participant RegexHelper
participant MemberService
participant MemberMapper
participant Database

Actor -> AccountRestController: GET /api/account/email_unique_check?email={email}
activate AccountRestController
' note right: @SessionCheckHelper(enable = false)

AccountRestController -> RegexHelper: 유효성 검사
activate RegexHelper
note right of RegexHelper: 발생 가능한 예외:\n- StringFormatException\n  (이메일 미입력, 잘못된 이메일 형식)
RegexHelper -->> MyRestExceptionHandler: StringFormatException
RegexHelper --> AccountRestController
deactivate RegexHelper

AccountRestController -> MemberService: isUniqueEmail(input: Member)
activate MemberService
MemberService -> MemberMapper: selectCount(input: Member)
activate MemberMapper
MemberMapper -> Database: SELECT
activate Database
note right: 중복 이메일 조회
note right of Database: 발생 가능한 예외:\n- SQLException\n  (데이터베이스 연결 오류)
Database -->> MyRestExceptionHandler: SQLException
Database --> MemberMapper: int
deactivate Database
MemberMapper --> MemberService: int
deactivate MemberMapper
note right of MemberService: 발생 가능한 예외:\n- AlreadyExistsException\n  (이미 존재하는 이메일)
MemberService -->> MyRestExceptionHandler: AlreadyExistsException
MemberService --> AccountRestController
deactivate MemberService

AccountRestController --> MyApiResponseAdvice: null
deactivate AccountRestController
activate MyApiResponseAdvice
MyApiResponseAdvice --> Actor: JSON 응답 (성공)
deactivate MyApiResponseAdvice

note over MyRestExceptionHandler: 모든 예외를 포착하여\nJSON 에러 응답으로 변환
MyRestExceptionHandler --> Actor: JSON 에러 응답

@enduml
\`\`\`
```

![world.png](/images/2024/1213/world.png)

만약, 파라미터가 너무 많아서 다이어그램이 이상해 보인다면 파라미터에 대한 요구사항을 조절해서 사용해야 한다.

### 3. Swagger를 위한 어노테이션 자동 생성

```
이 프로젝트는 SpringBoot로 진행중이며 Swagger로 WEB-UI를 만들도록 설정되어 있습니다.

다음에 유의하여 kr.hossam.myshop.controllers.apis 패키지 하위의 모든 클래스에 Swagger에 필요한 @Operation,  @Parameters,  @ApiResponses를 추가해 주세요.

1. 각 메서드의 설명은 메서드에 정의된 javadoc 주석을 참고하세요.
2. StringFormatException은 HTTP 상태코드 400에 해당합니다.
3. 그 밖의 Exception은 HTTP 상태코드 500에 해당합니다.
4. @SessionAttribute가 적용된 파라미터에는 `@Parameter(hidden=true)`를 추가해 주세요.

* 참고사항:
    AccountRestController.idUniqueCheck 메서드에 참고할 수 있는 샘플이 구성되어 있습니다.
    이 내용을 토대로 나머지 내용을 처리해 주세요.
```
