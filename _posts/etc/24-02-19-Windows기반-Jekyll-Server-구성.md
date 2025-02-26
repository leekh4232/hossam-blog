---
layout: post
title:  "Windows기반 Jekyll Server 구성"
date:   2024-02-19
banner_image: photo/study-cafe.png
tags: [Tip&Tech, Windows]
---

Github Page에 블로그 포스팅을 push하고 결과를 확인하는 과정을 반복하면 github에서 변환되는 시간이 매우 길게 느껴져서 불편합니다. 그래서 자신의 컴퓨터에서 Jekyll이 직접적으로 작동할 수 있도록 로컬 환경을 구성하고 글을 작성하는 동안은 내 컴퓨터에서 바로 확인한 후 최종적으로 완료되었을 경우에만 github에 push하는 것이 여러모로 편리합니다.

<!--more-->

# #01. Ruby 설치

Jekyll은 Ruby라는 환경 위에서 동작하므로 먼저 Ruby를 설치해야 합니다. (Ruby는 Python과 비슷한 인터프리터 프로그래밍 언어의 한 종류 입니다.)

## [1] RubyInstaller 다운로드

https://rubyinstaller.org/ 사이트에서 Ruby를 다운로드 합니다.

예전에는 버전을 탔던것 같은데 여기서는 현재 기준 가장 최신 버전인 `3.2.3-1`을 설치하도록 하겠습니다.

![img](/images/posts/2024/0219/ruby01.png)

링크를 타고 들어가면 다운로드 받을 항목을 선택할 수 있습니다.

개발환경이 포함된 "WITH DEVKIT"항목 중에서 가장 최신 버전을 선택했습니다.

![img](/images/posts/2024/0219/ruby02.png)


## [2] RubyInstaller 설치하기

내려받은 설치 프로그램을 실행하여 설치를 진행합니다.

윈도우 환경에서의 설치는 특별한 설정 과정 없이 진행하면 됩니다.

![img](/images/posts/2024/0219/ruby03.png)

설치가 완료되면 아래와 같이 `MSYS2`라는 것을 설치할지 붇는 터미널이 실행됩ㄴ디ㅏ. `1`을 입력하고 엔터를 눌러 설치하면 됩니다.

![img](/images/posts/2024/0219/ruby04.png)


> 저는 설치과정에서 입력을 잘못해서 이 화면을 강제종료 시켰는데 이후 과정에서 `MSYS2`가 없으면 설치하고 넘어가더군요.


# #02. Jekyll Server

## [1] Jekyll Server 설치

명령프롬프트를 열고 아래의 명령을 수행합니다. 

이 명령은 컴퓨터에 Jekyll을 설치하는 것이므로 명령프롬트트가 어느 경로에 있건 실행에 상관이 없습니다.

```shell
$ gem install jekyll bundler
```

명령어가 입력되면 수 초동안 설치과정이 출력됩니다. (다소 시간이 걸립니다.)

설치가 완료되면 아래 명령으로 설치된 버전을 확인해 볼 수 있습니다.

```shell
$ jekyll -v
```

## [2] Github Pages 블로그를 내 컴퓨터에 설치

컴퓨터에 클론 받아 놓은 Github Page 저장소 폴더 위치에서 명령프롬프트를 실행합니다.

아래의 명령을 수행하면 해당 Jekyll 블로그가 사용중인 플러그인들이 다운로드 됩니다.

이 명령은 저장소에서 새로 클론을 받은 후 최초 1회에만 수행하면 됩니다.

```shell
$ bundle install
```

## [2] Github Pages 블로그를 로컬 가동

아래 명령을 수행하면 로컬 웹서버가 작동합니다.

```shell
$ bundle exec jekyll serve
```

웹 서버가 가동되고 나면 명령프롬프트 상에 접속할 수 있는 URL이 표시됩니다.

이제 이 명령프롬프트를 종료하지 않는 한 포스팅을 작성하고 내 컴퓨터에서 즉시 확인이 가능합니다. 글 작성이 모두 완료되면 Git에 push하여 발행하는 개념으로 사용할 수 있습니다.

![img](/images/posts/2024/0219/jekyll.png)