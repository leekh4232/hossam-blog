---
layout: post
title:  "[Laravel] Hello World"
date:   2024-05-08
banner_image: index-laravel.jpg
tags: [PHP,Laravel]
---

Express와 Next.js의 조합은 국내 웹 호스팅을 주로 사용할 수 밖에 없는 프리렌서형 외주 개발에는 그리 친절한 환경은 아니었다. AWS나 Naver Cloud등을 고려해 볼 수 도 있겠으나 서버 유지를 위해 1년 단위에 5만원 미만의 비용으로 유지할 수 있는 PHP환경에서 고객사들을 움직이게 하기에는 매우 어려운 설득 과정이었다. 결국 PHP를 다시 고려하게 되었으나 이미 구시대 유물로 취급되고 있는 CI3를 다시 사용하고 싶지는 않았다. 결국 Laravel을 공부해 보기로 했다. 이 시리즈는 스스로의 학습 과정 기록이다.

<!--more-->

# #01. 요구사항

## [1] PHP, Apache

2024년 05월 09일 현재 `Laravel 11`까지 발표되었다. 당연히 PHP와 Apache가 필요하며 적절한 데이터베이스도 필요하다. `PHP 8.3.4`와 `Apache/2.4.58 (Unix)`버전을 Mac에 설치했다.

Apache의 경우 Mac sonoma부터 기본으로 탑제되어 있는 버전이 부적절하다는 글을 확인했었기 때문에 Homebrew를 사용해서 직접 새로운 버전을 설치했다.

> 라라벨 프로젝트를 생성하는 과정에서 안 것이지만 라라벨 자체 내장 서버가 있기 때문에 개발 과정에서 Apache가 꼭 필요하지는 않다.

## [2] DATABASE

MySQL과 MariaDB중에서 고민하다가 MariaDB를 사용하기로 결정했다.

설치 과정에서 `mysql.sock` 파일에 대한 경로 문제가 지속적으로 발생하였고 구글링을 통해 해결했다.

MySQL의 잔여물 때문에 설치가 꽤나 힘겨웠다. 혹시라도 Mac을 포멧하게 된다면 MySQL은 이제 설치하지 말도록 하자~!!!

## [3] PHP 확장

스터디를 위해 선택한 책을 살펴보니 아래의 확장들은 필수 항목이라고 되어 있었다. `phpinfo()` 함수를 사용하여 스팩을 확인한 결과 다행스럽게도 이 확장들은 모두 설치되어 있었다.

```plain
BCMath, Ctype, Fileinfo, JSON, Mbstring, OpenSSL, PD0, Tokenizer, XML
```

# #02. 라라벨 인스톨러

## [1] 인스톨러 설치

컴쏘저 설치와 확장 활성화가 완료되었다면 이제 라라벨 인스톨러를 통해 라라벨 프로젝트를 다운받고 실행할 수 있다. 먼저 아래와 같은 명령을 통해 라라벨 인스톨러를 설치해보자.

```shell
$ composer global require laravel/installer
```


## [2] 환경변수 설정

### Mac OS

```
$HOME/.composer/vendor/bin
```

### Windows

```
%USERPROFILE%\AppData\Roaming\Composer\vendor\bin
```

## [3] 설치확인

Global 영역에 laravel installer가 설치되었으므로 어느 디렉토리에서도 `laravel` 명령을 사용할 수 있다.

컴포저를 사용하여 다른 패키지를 다운받을 때도 다음과 같이 다운로드 받을 수 있다.

```shell
$ composer [global] require <package>
```

아래 명령으로 설치 버전을 확인한다.

```shell
$ laravel --version
```

![version](/images/posts/2024/0508/laravel--version.png) 

# #03. 라라벨 프로젝트 시작

## [1] 프로젝트 생성

프로젝트 생성에는 두 가지 방법이 있다.

```shell
$ composer create-project laravel/laravel <프로젝트이름>
```

혹은

```shell
$ laravel new 프로젝트이름
```

두 번째 방법은 라라벨에서 제공하는 개발환경 패키지를 사용하는 방법이다. 이 방법은 부가적인 설정이 있으므로 다음 포스팅에서 다루도록 한다.


## [3] 프로젝트 가동

프로젝트 디렉토리로 이동한 후 아래 명령으로 프로젝트를 가동한다.

```shell
$ php artisan serve
```

프로젝트가 가동되면 `http://localhost:8000` 으로 접속해 결과를 확인한다.

![img](/images/posts/2024/0508/helloworld.png)

# #04. 일러두기

## [1] 아티즌

아티즌(Artisan)은 라라벨 프레임워크를 사용할 때 개발자에게 각종 도움을 주기 위한 명령어 집합이다.

- 컨트롤러, 모델 생성
- 데이터베이스 마이그레이션 등

`php artisan serve`처럼 사용한 것이 아티즌으로 명령을 수행한 것이며 라라벨을 사용할수록 자연스럽게 자주 쓰게 된다.

어떤 아티즌 명령어가 있는지는 `php artisan list` 명령어를 사용하면 살펴볼 수 있다.

만약 대략적인 명령어를 알고는 있지만 사용법이나 어떤 옵션이 있는지 까먹었을 수도 있다. 그럴 때는 `php artisan help <명령어>` 사용해보자.

![img](/images/posts/2024/0508/help.png)

## [2] 환경설정

### (1) `.env`파일

라라벨의 환경변수는 `.env` 파일에서 관리된다. 

이 파일에는 데이터베이스 설정이나 캐시 및 세션 드라이버 설정 등 어플리케이션이 구동되는 환경에 대한 설정이 담겨있다. 

`APP_KEY`, `데이터베이스 비밀번호`등 외부에 노출되면 위험한 정보가 담겨있기 때문에 일반적으로 git에 푸시하지 않는다. 

일정 부분 공유가 필요하다면 키는 놔두되 값은 비우고, `env.example`등으로 이름을 바꿔서 푸시하면 된다.

환경설정은 `이름=값` 형태로 구성되며 전역변수인 `$_ENV` 변수에 할당된다 . `APP_KEY` 같은 경우 `php artisan key:generate`로 설정된 값이며 `APP_DEBUG`의 경우 `true` 로 놓을 경우 어플 리케이션의 정보가 노출되기 때문에 프로덕트 환경에서는 활성화해서는 안된다.

```env
APP_ENV=local APP_KEY=base64:9mmLYDPH/geWy3zi53TtPBpgwkO/ZoaTrJFgkjvhQ8Y=
APP_DEBUG=true
```

### (2) 환경 설정값에 접근

어플리케이션 내부에서는 `env()`함수로 설정값에 접근할 수 있는데, `config` 디렉터리 아래에 있는 설정 파일을 제외한 컨트롤러 둥 나머지 부분에서 `env()`함수로 직접 환경설정에 접근하는 것은 권장되지 않는다.

`config/app.php`파일은 어플리케이션의 일반적인 설정값을 가지고 있으며 `env()`를 통해 환경변수 값에 접근하는 모습을 볼 수 있다. 

`env()` 함수의 두 번째 파라미터는 환경변수가 설정되지 않았을 경우의 기본값을 지정한다.

```php
'env' => env('APP_ENV', 'production')
```

## [3] 설정

라라벨은 config 디렉터리에 있는 설정 파일에 정의된 값에 따라 어플리케이션에서 사용하는 기능의 설정이 정의된다. 

캐시와 데이터베이스에 해당하는 `cache.php`, `database.php`등 여러 설정 파일들이 있는 것을 볼 수 있다.

> 이 파일들은 라라벨의 내부 기능들을 살펴볼 때 자주 보게 될 예정이므로 지금 당장 살펴보는 것은 낭비다.

`config()` 함수를 사용하면 `env()` 함수로 직접 환경설정에 접근하는 대신 설정 파일에서 값을 읽을 수 있다.

이 함수는 설정값에 접근할 때 사용하며 이때 점(`.`) 표기법을 사용하여 접근한다. 

설정값을 읽어올 때는 `env()` 함수가 아닌 `config()` 함수를 통해 얻어 오는 것이 바람직한 방법이다.

아래의 표현은 `config/app.php`에서 `env`로 설정된 값을 가져오는 코드다.

```php
$ config(’app.env’); // local
```

## [4] 라라벨 기본 구조 (MVC)

> 뭐 흔한 내용이지만 그림이 이뻐서...

![mvc](/images/posts/2024/0508/mvc.png)

## [5] 라라벨 컨트롤러 응답 구조

![mvc](/images/posts/2024/0508/res.png)