---
layout: post
title:  "[Laravel] 프로젝트 생성"
date:   2024-05-09
banner_image: index-laravel.jpg
tags: [PHP,Laravel]
---

나는 Docker등의 가상환경보다는 로컬 환경에서 직접 개발하는 것을 선호한다. 그러다 보니 Laravel도 Docker환경보다는 로컬에 직접 프로젝트를 생성하고 DBMS도 로컬에서 직접 구동시키는 과정을 시도해 보았다.

<!--more-->

# #01. 프로젝트 생성

## [1] 프로젝트 생성 명령어 실행

터미널에서 다음의 명령으로 프로젝트를 생성한다.

```shell
$ laravel new 프로젝트이름
```


## [2] 기본 옵션 선택

### (1) 스타터킷

프로젝트 생성 명령을 실행하면 기본 스타터킷을 사용할지 물어본다. 

스타터킷은 기본적으로 필요한 기능들에 대한 최소한의 완성코드가 포함되는 형태이다.

스타터킷에 대한 자세한 설명은 아래 URL을 통해 확인한다.

> https://laravel.com/docs/11.x/starter-kits

여기서는 스타터킷을 선택하지 않았다.

![laravel](/images/posts/2024/0509/laravel01.png)

### (2) 테스팅 프레임워크

Pest와 PHPUnit중에서 선택할 수 있다.

단위 테스트의 근본은 PHPUnit이지만 Pest는 PHPUnit을 좀 더 편하게 사용할 수 있는 환경을 제공한다.

![laravel](/images/posts/2024/0509/laravel02.png)

### (3) Git 저장소 설정

로컬 Git 저장소를 생성할지 여부이다.

필요에 따라 선택한다.

추후 `git remote add origin 저장소URL` 명령으로 특정 저장소에 연결할 수 있다.

![laravel](/images/posts/2024/0509/laravel03.png)

여기까지 설정하면 기본 파일들이 생성된다.

### (4) 데이터베이스 설정

사용할 DBMS 종류를 선택한다.

![laravel](/images/posts/2024/0509/laravel04.png)

### (5) 데이터베이스 마이그레이션 선택

여기서는 `No`를 선택한다. 어차피 데이터베이스 계정 정보가 없기 때문에 `Yes`를 선택하더라도 에러난다.

![laravel](/images/posts/2024/0509/laravel05.png)


## [3] 데이터베이스 설정

### (1) 데이터베이스 생성

생성한 프로젝트와 연동될 데이터베이스를 생성한다.

```sql
$ create database helloworld default charset utf8;
```

### (2) 데이터베이스 연동 정보 설정

프로젝트의 `.env` 파일을 편집기로 열고 아래 부분을 수정한다.

주의할 점은 비밀번호를 쌍따옴표로 감싸야 한다는 점이다.


```env
DB_CONNECTION=mariadb
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=helloworld
DB_USERNAME=계정명
DB_PASSWORD="비밀번호"
```

### (3) 데이터베이스 마이그레이션

프로젝트 디렉터리 위치에서 터미널을 열고 아래 명령을 실행하면 필요한 기본 테이블이 생성된다.

```shell
$ php artisan migrate
```

![laravel](/images/posts/2024/0509/laravel06.png)

데이터베이스에 접속하여 확인해 보면 상당히 많은 테이블들이 생성되어 있음을 알 수 있다.

![laravel](/images/posts/2024/0509/laravel07.png)

# #02. 결과 확인

아래 명령으로 생성된 프로젝트를 가동한다.

```shell
$ php artisan serve
```

웹 브라우저를 열고 `http://localhost:8000` URL로 접속해 결과를 확인한다.

![laravel](/images/posts/2024/0509/laravel08.png)