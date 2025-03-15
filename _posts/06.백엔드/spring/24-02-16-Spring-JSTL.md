---
title:  "Spring - JSTL 요약"
description: "지금은 thymleaf에 밀려서 거의 사용되지 않지만 그래도 오랜 기간동안 MVC 패턴에서 View 한 축을 담당했던 JSTL에 대한 기록이다. 정리해 둔 자료를 보관할 목적으로 포스팅한다."
categories: [06.Backend,Spring]
date:   2024-02-16 11:33:00 +0900
author: Hossam
image: /images/index-java3.webp
tags: [Web,Mac,Backend,Spring,JSTL,View]
pin: true
math: true
mermaid: true
---

## #01. JSTL(Java Standard Tag Library)의 이해

### 1) JSP Standard Tag Library

- JSP 표준 태그 라이브러리
- HTML 태그와 비슷한 문법을 통해 Java 언어의 프로그래밍적 문법과 변수, 객체 등에 접근할 수 있는 기능을 제공한다.
- MVC 패턴의 View에서 사용할 경우 JSP 파일에서는 Java 문법을 완전히 제거할 수 있기 때문에 **프로그래밍 부분과 UI 구현 부분을 독립적으로 분리**할 수 있다.

### 2) JSTL의 중요성

- Spring에서 View에 대한 기본 문법으로 채택하고 있다.

    (만약 진행중이던 포트폴리오의 JSP파일이 Java문법을 사용중이라면 모두 JSTL 문법으로 변경해야 함.)


## #02. 사용 설정하기

### 1) 라이브러리 의존성 설정

pom.xml에 다음의 구문 추가 (Spring 설정 과정에서 이미 적용되어 있음)

```xml
<!-- <https://mvnrepository.com/artifact/javax.servlet.jsp.jstl/jstl-api> -->
<dependency>
    <groupId>javax.servlet.jsp.jstl</groupId>
    <artifactId>jstl-api</artifactId>
    <version>1.2</version>
</dependency>

<!-- <https://mvnrepository.com/artifact/org.apache.taglibs/taglibs-standard-impl> -->
<dependency>
    <groupId>org.apache.taglibs</groupId>
    <artifactId>taglibs-standard-impl</artifactId>
    <version>1.2.5</version>
</dependency>
```

### 2) JSTL 파일 상단에 다음의 구문 추가

<aside>
💡 JSP파일 상단에 커스텀 태그의 사용 정의하기

</aside>

JSTL의 사용을 위해서는 문법 구조를 정의하고 있는 파일의 URL을 명시해야 한다.

```bash
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
```

#### 기본 문법 구성

```java
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
```

#### 확장함수 지원

```java
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
```

#### 포멧터(형식문자) 지원

```java
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
```

## #03. 변수값 활용하기

### 1) 변수값 출력

controller에서 view로 전달할 때 사용한 key값을 사용하여 **`${key}`**형식으로 접근

```html
${변수이름}
```

### 2) 간단한 수식 지원 (간단연산가능)

`**${}**`안에서 하면 됨

```html
${변수이름 + 123}
${변수이름1 - 변수이름2}
```

### 3) Beans객체 사용

#### 멤버변수값 출력하기 (getter호출)

**Controller**에서 객체를 전달했다면 **`${key.필드}`** 형식으로 **getter**를 호출할 수 있다.

멤버변수(필드)에 접근하는 것 같이 표기하지만 실제로는 **getter** 함수가 호출되는 것이므로 이름 규칙에 맞는 **getter**, **setter**가 정의되어 있어야 한다.

```html
${객체이름.멤버변수이름}
```

#### 멤버변수값 변경하기 (setter호출)

setter 메서드가 호출되는 것이므로 이름 규칙에 맞는 setter 메서드가 정의되어 있어야 한다.

```html
<c:set target="${객체이름}" property="멤버변수이름" value="할당할 값" />
```

## #04. 조건문



### 1) IF문

```html
<!-- if (true) { ... } -->
<c:if test="true">
<h1>이 블록은 무조건 출력됩니다.</h1>
</c:if>
```

```html
<!-- if (false) { ... } -->
<c:if test="false">
<h1>이 블록은 출력되지 않습니다.</h1>
</c:if>
```

```html
<!-- if (member.age > 19) { ... } -->
<c:if test="${member.age > 19}">
<h1>${member.name}님은 성인 입니다.</h1>
</c:if>
```

### 2) CASE문 (`if ~ else if ~ else`)

`if ~ else if ~ else`에 해당한다.

```html
<c:choose>
    <c:when test="${point > 90 && point <= 100}">
        <h1>A학점 입니다.</h1>
    </c:when>

    <c:when test="${point > 80 && point <= 90}">
        <h1>B학점 입니다.</h1>
    </c:when>

    <c:when test="${point > 70 && point <= 80}">
        <h1>C학점 입니다.</h1>
    </c:when>

    <c:otherwise>
        <h1>F학점 입니다.</h1>
    </c:otherwise>
</c:choose>
```

## #05. 반복문



### 1) 기본 반복 (`forEach`)

for 반복문에 대응되는 **forEach**

```html
<!-- for (int i=1; i<=10; i+=2) -->
<c:forEach var="i" begin="1" end="10" step="2">
    <h1>${i}</h1>
</c:forEach>
```

- **var** = 변수 선언
- **begin** = 초기식
- **end** = 조건식
- **step** = 증감식

### 2) 변수값에 의한 반복 범위 설정

#### Controller

필드 기본값을 설정한다. (멤버변수 선언과 초기화)

```java
model.addAttribute("level", 3);
model.addAttribute("first", 1);
model.addAttribute("last", 9);
```

#### View

- `status.count`는 반복 횟수를 의미한다.

```html
<!-- for (int i=first; i<=last; i++) -->
<c:forEach var="i" begin="${first}" end="${last}" varStatus="status">
    <p>[${status.count}/${last}] ${level} x ${i} = ${level * i}</p>
</c:forEach>
```

- **`var` →** 변수 선언
- **`begin` →** 초기식
- **`end` →** 조건식
- **`step` →** 초기식에서 설정한 변수에 대한 변화량. 기본값은 `+1`
- **`varStatus` →** 반복문의 상태를 확인할 수 있는 객체
    - `varStatus="이름임의지정"`
    - **`${varStatus객체명.count}`** → 반복 횟수

### 3) 배열에 의한 반복 (배열탐색)

#### Controller

아래와 같이 View에 전달할 배열 데이터 설정

```java
String[] language = {"C,C++", "JAVA", "PHP", "JSP", "Swift"};
model.addAttribute("langauge", language);
```

#### View

```html
<!-- 배열을 스캔하여 각 아이템을 k에 저장한다 -->
<!-- status.index는 현재 배열 항목에 대한 인덱스 값 -->
<c:forEach var="k" items="${langauge}" varStatus="status">
    language[${status.index}] = ${k}<br/>
</c:forEach>
```

- **`var` →** 배열탐색을 위한 자바문법중 "for(String k: language) {...}" 에서 변수선언 k에 대응
- **`items` →** 배열탐색을 위한 자바문법중 "for(String k: language) {...}" 에서 배열명 language에 대응
- **`varStatus` →** 반복문의 상태를 확인할 수 있는 객체
    - **`${varStatus객체명.index}`** → 현재 원소의 배열 인덱스

### 3) Map 객체에 의한 반복 (맵 탐색)

#### Controller

```java
// Collection Map 객체 생성
Map<String, Member> member = new HashMap<String, Member>();

// Map 객체에 JavaBeans의 객체를 이름표를 적용하여 추가한다.
member.put("PM", new Member("강사", 20));
member.put("backend", new Member("토마토", 19));
member.put("database", new Member("토토리", 18));
member.put("frontend", new Member("야옹이", 17));

// Map객체를 model객체에 등록한다.
model.addAttribute("member", member);
```

#### View

```html
<!-- member객체를 스캔하면서 각 항목을 k에 저장한다 -->
<c:forEach var="k" items="${member}" varStatus="status">
    <!--
        status.index는 현재 반복되고 있는 인덱스 번호
        반복처리때 마다 k.key와 k.value에 라벨과 객체가 저장된다.
    -->
    member[${status.index}] ${k.key} = ${k.value.name}/${k.value.age}<br/>
</c:forEach>
```

- **`var` →** 배열탐색을 위한 자바문법중 "for(Member k: memberMap) {...}" 에서 변수선언 k에 대응
         **→** 여기서 k는 HashMap에 포함된 빈즈객체로, member_map에 포함되어있는 원소 하나이다.
    - **`var명.key`** → 현재원소에 대한 Map키 (여기서 k.key는 String)
    - **`var명.value`** → 현재 원소에 대한 Map Value (여기서는 Member 객체)
- **`items` →** 배열탐색을 위한 자바문법중 "for(Member k: memberMap) {...}" 에서 객체명 memberMap에 대응
- **`varStatus` →** 반복문의 상태를 확인할 수 있는 객체
    - **`${varStatus객체명.index}` →** 현재 원소의 배열 인덱스

### 4) List에 의한 반복 (리스트 탐색)

#### Controller

```java
// List객체(ArrayList가암묵적형변환됨)에 빈즈객체를 add한다.
List<Member> list = new ArrayList<Member>();
list.add(new Member("토토리", 19));
list.add(new Member("토마토", 18));
list.add(new Member("야옹이", 17));

model.addAttribute("list", list);
```

#### View

```html
<!--
    list라는 이름으로 추가된 ArrayList를 스캔하는 반복처리
    각 반복시기마다 List에 추가된 객체는 "k"에 저장된다.
    status.index = 현재 반복중인 위치의 인덱스
-->
<c:forEach var="k" items="${list}" varStatus="status">
    <!-- 그냥 k를 호출할 경우 toString()가 호출된다. -->
    list[${status.index}] = ${k}<br/>
</c:forEach>
```

- **`var` →** 배열탐색을 위한 자바문법중 "for(Member k: list) {...}" 에서 변수선언 k(빈즈객체)에 대응
          **→** 여기서 k는 ArrayList에 포함된 빈즈객체로, list에 포함되어있는 원소 하나이다.
    - **`var명` →** 현재 원소에 저장된 자료값 (여기서는 현재 원소의 Member 객체)
- **`items` →** 배열탐색을 위한 자바문법중 "for(Member k: list) {...}" 에서 객체명 list에 대응
- **`varStatus` →** 반복문의 상태를 확인할 수 있는 객체
    - **`${varStatus객체명.index}`** **→** 현재 원소에 대한 인덱스 (여기선 List의 인덱스이기도함)

### 5) 문자열을 구분자로 나누어 출력 (Split+배열탐색)

문자열에 대한 Split처리에 따른 반복문

**`forTokens`는 자바의 `split처리+배열 반복문 돌리기`에 동시에 대응한다.**

#### Controller

```java
// 콤마(,)로 구분된 문자열 생성
String list = "토토리,토마토,야옹이";
model.addAttribute("list", list);
```

#### View

```html
<!-- String[] token = list.split(",") 처리 후 token의 항목 수 만큼 반복 -->
<c:forTokens var="token" items="${list}" delims=",">
    ${token}<br/>
</c:forTokens>
```

- **`var`** → 각 원소 저장할 변수 선언 (배열[i]같은거)
- **`items`** → split처리해서 반복문 돌릴 문자열이 저장된 변수
- **`delims`** → split할 때의 기준이 될 글자지정(자바에선 split메서드 파라미터값)

## #05. URL 처리

`/프로젝트이름/study/list.do?keyword=JSP공부&page=1`의 형식으로 URL을 생성한 뒤, next_url이라는 변수에 저장한다. 프로젝트이름(ContextPath)은 자동으로 추가된다.

```html
<c:url value="/study/list.do" var="next_url">
    <c:param name="keyword" value="JSP공부"></c:param>
    <c:param name="page" value="1"></c:param>
</c:url>

<a href="${next_url}">다음으로 이동하기</a>
```

- **c:url 태그**
    - **`value`  →** url 생성. `${contextPath}`는 현재 프로젝트 경로(현재로썬 "/Model2")임.
    - **`var` →** value에서 생성한 url을 저장 (`c:param`이 있다면 value값에 그것도 반영해서 저장)
- **c:url 태그에 속한 c:param 태그**
    - **`name` →** url의 ?뒤(파라미터)에 들어갈 변수명 설정
    - **`value` →** url의 ?뒤(파라미터)에 들어갈 변수값 설정
    - c:param이 여러개일 경우, 각 변수값은 &로 연결되고 자동으로 URL인코딩이 적용된다.

## #06. 간단한 문자열 함수 지원

자바의 (message 문자열에 대한) String클래스 기능에 대응

```java
${fn:toUpperCase(url)}
${fn:toLowerCase(url)}
${fn:substring(url, 7, 21)}
${fn:substringBefore(url, "://")}
${fn:substringAfter(url, "://")}
${fn:replace(url, "LOCALHOST:8080", host)}
${fn:trim(url)}
```

## #07. 형식문자

### **숫자 세자리마다 콤마 추가하기**

- value로 지정한 mynumber정수값에 대해 3자리마다 콤마가 적용된다.

```html
<fmt:formatNumber value="${변수명}" pattern="#,###" />
<fmt:formatNumber value="${객체명.멤버변수명}" pattern="#,###" />
```