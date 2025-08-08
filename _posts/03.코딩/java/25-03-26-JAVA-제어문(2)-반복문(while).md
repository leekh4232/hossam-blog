---
title:  "JAVA 제어문(2) - 반복문(while)"
description: "while문은 주어진 조건이 참을 충족하는 동안 반복 수행하는 구문입니다."
categories: [03.Coding,Java]
image: /images/indexs/coding2.webp
tags: [Programming,Java,Coding]
date: 2025-03-26 12:08:14 +0900
author: Hossam
pin: true
math: true
mermaid: true
---

## 01. while문

### 1) 기본 구문 형식

주어진 조건식이 참인 동안 블록 안을 반복적으로 수행한다.

```java
while (조건) {
    ... 반복적으로 수행할 구문 ...
}
```

### 2) while문의 조건이 성립하기 위한 구성

- 조건을 판별하기 위해서는 기준이 되는 변수값이 필요하다. —> **초기식**
- 반복 조건이 참인 동안 while문의 블록이 반복적으로 수행되는데, 블록 안에서 조건을 판단하기 위한 변수에 변화가 생기지 않는다면 반복은 영원히 지속된다.
- 블록안에서 반복조건에 변화를 주어 언젠가는 반복이 종료되도록 구성해야 한다. —> **증감식**

```java
초기식;            // (1) 조건식을 판별하기 위한 기준값을 생성한다.

while (조건식) {   // (2)(5) 조건을 판별한다.

    ... 반복적으로 동작할 구문 ... // (3) 명령을 수행한다.

    증감식;        // (4) 기준값에 변화를 주고 다시 조건식으로 이동한다.
}
```

##### 📗 Ex01_While문.java

```java
/**
 * 0부터 10보다 작은 동안 1씩 증가하는 변수값의 변화과정 확인
 */
public class Ex01_While문 {
    public static void main(String[] args) {
        // 초기식
        int x = 0;

        // 조건식 -> x가 10보다 작은 동안 반복수행
        while (x < 10) {
            // 반복이 진행되는 동안 수행할 명령
            // --> 여기서는 x의 변화 과정을 출력한다.
            System.out.printf("x=%d\n", x);

            // 증감식 -> 조건에 사용되는 값을 변경
            x++;
        }

        System.out.println("-------------");
        System.out.printf("x의 최종값: %d\n", x);
    }
}
```

##### 📗 Ex02_While문_구구단.java

```java
/**
 * 숫자값을 입력받아 그 값에 1부터 9까지 곱해가는 구구단을
 * 수식으로 출력하는 프로그램
 */
import java.util.Scanner;

public class Ex02_While문_구구단 {
    public static void main(String[] args) {
        Scanner reader = new Scanner(System.in);

        System.out.print("숫자를 입력하세요(2~9): ");
        int x = reader.nextInt();
        reader.close();

        int y = 1;

        while (y < 10) {
            System.out.printf("%d x %d = %d\n", x, y, x * y);
            y++;
        }
    }
}
```

##### 📗 Ex03_While문_합계.java

```java
public class Ex03_While문_합계 {
    public static void main(String[] args) {
        // 총합을 구하기 위해서는
        // 값을 누적 합산할 변수를 0으로 초기화 하고 시작해야 한다.
        // --> 초기화 : 선언된 변수에 최초로 값을 할당하는 행위
        int sum = 0;

        // 초기식
        int i = 1;

        while (i < 11) {
            // sum에 i의 값이 1부터 10까지 변하는 동안 누적합산 한다.
            sum += i;

            // 중간과정 출력
            System.out.printf("i=%d, sum=%d\n", i, sum);

            // i값을 1씩 증가한다.
            i++;
        }
    }
}
```

##### 📗 Ex04_While문_반복범위.java

```java
/**
 * 두 개의 정수 x, y를 입력 받아 x부터 y까지의 총 합
 */
import java.util.Scanner;

public class Ex04_While문_반복범위 {
    public static void main(String[] args) {
        Scanner reader = new Scanner(System.in);

        System.out.print("x를 입력하세요: ");
        int x = reader.nextInt();

        System.out.print("y를 입력하세요: ");
        int y = reader.nextInt();

        reader.close();

        // 초기식
        int i = x;

        // 합계를 저장할 값. --> 총 합을 구하기 위해서는 항상 0으로 초기화 된 변수가 필요하다.
        int sum = 0;

        // 조건식 --> y를 포함해야 하므로 "y보다 1큰값보다 작다"로 설정
        // 혹은 "y보다 작거나 같다"로 설정해도 동일함
        while (i < y+1) {

            System.out.printf("%d + %d\n", sum, i);

            // 합계 계산
            sum += i;

            // 증감식
            i++;
        }

        System.out.printf("%d부터 %d까지의 총 합은 %d 입니다.", x, y, sum);
    }
}
```

##### 📗 Ex05_While문_증감식설정.java

```java
/**
 * 0부터 100 미만까지의 수 중에서 10의 배수만 합산
 */
public class Ex05_While문_증감식설정 {
    public static void main(String[] args) {
        int sum = 0; // 총 합을 저장할 변수
        int i = 0; // 초기식

        while (i < 100) { // 조건식

            sum += i;
            System.out.printf("i=%d, sum=%d\n", i, sum);

            i += 10; // 증감식 (10씩 증가)
        }
    }
}
```


## #02. do-while문 (안중요)

### 1) 기본 구문 형식

do-while문은 선실행, 후판별 형태로 구성된다.

일단 `{}`안의 구문을 1회 실행하고 나서 조건을 판별하여 계속 수행할지 여부를 판단한다.

```java
int i = 0;          // 초기식

do {
    /* ... 반복 실행될 구문 ... */
    i++;            // 증감식
} while (i < 10);   // 조건식

```

### 2) while문과의 비교

#### while문

while문은 조건의 성립 여부에 반복 수행을 결정하므로 만약 조건이 처음부터 거짓이라면 한 번도 수행하지 않는다.

```java
int a = 10;

while (a < 10) {
    // 이 블록은 한번도 실행되지 않는다.
}
```

#### do-while문

만약 아래와 같이 조건이 거짓이더라도 우선 한번은 실행한 후 조건을 판별하기 때문에 do-while문은 최소 한 번은 실행한다.

```java
int a = 10;

do {
    // 이 블록은 한 번만 실행된다.
} while (a < 10);
```

##### 📗 Ex06_doWhile문.java

```java
public class Ex06_doWhile문 {
    public static void main(String[] args) {
        int y = 0;          // 초기식

        do {
            System.out.printf("y=%d\n", y);
            y++;            // 증감식
        } while (y < 10);   // 조건식

        System.out.println("-------------");
        System.out.printf("y의 최종값: %d\n", y);
    }
}
```

##### 📗 Ex07_doWhile차이점.java

```java
public class Ex07_doWhile차이점 {
    public static void main(String[] args) {
        int a = 10;

        /** 1) 조건이 맞지 않는 while문 */
        // while문은 조건의 성립 여부에 반복 수행을 결정하므로
        // 만약 조건이 처음부터 거짓이라면 한 번도 수행하지 않는다.
        while (a < 10) {
            System.out.printf("[while문] a=%d\n", a);
        }

        /** 2) 조건이 맞지 않는 do~while문 */
        // 조건이 거짓이더라도 우선 한번은 실행한 후
        // 조건을 판별하기 때문에 do-while문은 최소 한 번은 실행한다.
        do {
            System.out.printf("[do~while문] a=%d\n", a);
        } while (a < 10);
    }
}
```

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>
<script type="text/x-mathjax-config"> MathJax.Hub.Config({ tex2jax: {inlineMath: [['$', '$']]}, messageStyle: "none" });</script>