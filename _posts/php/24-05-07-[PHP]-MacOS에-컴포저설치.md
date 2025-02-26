---
layout: post
title:  "[PHP] MacOS에 컴포저 설치 (8.3.2)"
date:   2024-05-07
banner_image: index-mac.jpg
tags: [PHP,Mac]
---

Laravel, Codeigniter 등의 PHP프레임워크들이나 PHP 패키지들 의존성을 관리한다던지 PHP클래스파일을 로딩할때 쓰인다. 컴포저는 Packagist라는 PHP 패키지 저장소와 연동되어 있는데, 설치를 원하는 패키지에 대한 composer.json 파일을 작성하고 터미널 창에서 composer.json 파일이 있는 디렉토리로 이동한 후, 알맞은 실행 명령을 입력하면 해당 파일에 기술된 패키지를 자동으로 다운로드받는다. composer.json 파일의 내용과 실행 명령어는 각 벤더 측에서 제공하고 있으니 자세한 것은 그곳을 찾아보면 된다. (출처: 위키백과, https://namu.wiki/w/%EC%BB%B4%ED%8F%AC%EC%A0%80)

<!--more-->

# #01. 컴포저 설치하기

## [1] PHP 설치 확인

우선 MacOS에 PHP가 구성되어 있어야 하며 터미널을 통해 PHP가 실행 가능해야 합니다.

PHP를 설치하는 방법은 이전 포스팅을 참고하세요.

터미널에서 아래의 명령어를 입력했을 때 PHP 버전이 확인된다면 정상적으로 PHP가 구성되어 있는 상태 입니다.

```shell
$ php --version
```

![php](/images/posts/2024/0507/php.png)

## [2] 컴포저 설치하기

컴포저를 설치하는 방법은 공식 사이트에 설명이 되어 있습니다.

> https://getcomposer.org/doc/00-intro.md

터미널을 열고 공식 사이트의 설명에 따라 명령어를 입력하면 됩니다.

### (1) 설치 스크립트 다운로드

```shell
$ php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
```

### (2) 설치 스크립트 실행
```shell
$ php composer-setup.php
```

### (3) 설치 스크립트 삭제

```shell
$ php -r "unlink('composer-setup.php');"
```

위 3단계를 터미널에서 실행하면 아래와 같습니다.

![composer1](/images/posts/2024/0507/composer1.png)

### (4) 설치된 파일 이동

설치가 완료되면 `composer.phar` 파일이 생성됩니다. 이 파일을 `/usr/local/bin/composer` 경로로 이동합니다.

```shell
$ sudo mv composer.phar /usr/local/bin/composer
```

# #02. 설치 결과 확인

설치가 완료되면 아래의 명령어를 통해 컴포저 버전을 확인해 봅시다.

버전이 출력되면 설치가 잘 된겁니다.

```shell
$ composer --version
```

![composer2](/images/posts/2024/0507/composer2.png)