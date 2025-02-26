---
layout: post
title:  "[React] 프로젝트 생성 windows 배치 파일"
date:   2023-12-21
banner_image: index-toyproject.jpg
tags: [React]
---

React 강의를 진행하면서 단원별로 React Project를 생성하고 yarn berry로 패키지 관리자의 버전을 변경하고, 그 밖에 여러가지 기본 패키지들을 설치하는 반복작업은 무척 시간 낭비가 심하다.

<!--more-->

그래서 수업시에 사용하고자 프로젝트 초기화 batch 파일을 작성했다.

# Batch 파일이 수행하는 작업

수행하는 작업은 다음과 같다.

1. 프로젝트 생성
2. 패키지 관리자를 yarn berry로 변경
3. yarn berry 모드를 pnp로 변경
4. 수업용 필수 패키지 설치
5. `.git` 폴더와 `.gitignore` 파일 삭제
6. 프로젝트 가동

# 사용 방법

```batch
react-app 프로젝트이름
```

# batch 파일 소스코드

```shell
@echo off
chcp 65001
cls

if "%1" == "" goto ERR

echo ----------------------------------
echo 1. 프로젝트를 생성합니다.
echo ----------------------------------
echo $ yarn create react-app "%1"
call yarn create react-app "%1"
echo.

echo ----------------------------------
echo 2. 프로젝트를 yarn berry로 변경합니다.
echo ----------------------------------
echo $ cd "%1"
cd "%1"
echo.
echo $ yarn set version berry
call yarn set version berry
echo.
echo $ yarn install
call yarn install
echo.

echo ----------------------------------
echo 3. berry의 모드를 pnp로 변경합니다.
echo ----------------------------------
echo .yarnrc.yml과 package.json 파일을 수정합니다.
powershell -Command "(gc .yarnrc.yml) -replace 'node-modules', 'pnp' | Out-File -encoding utf8 .yarnrc.yml"

powershell -Command "(gc package.json) -replace 'eslintConfig', 'x-eslintConfig' | Out-File -encoding utf8 package.json"


echo ok.
echo.

echo $ yarn install
call yarn install
echo.

echo ----------------------------------
echo 4. 필수 패키지를 설치합니다.
echo ----------------------------------
call yarn add react-router-dom prop-types react-helmet-async sass styled-reset styled-components styled-components-breakpoints dayjs classnames lodash axios react-loader-spinner axios-hooks react-redux @reduxjs/toolkit redux-devtools-extension chart.js react-chartjs-2 react-intersection-observer
echo.

echo $ yarn add eslint-config-react-app -D
call yarn add eslint-config-react-app -D
echo.

echo ----------------------------------
echo 5. git 관련 파일들을 정리합니다.
echo ----------------------------------
echo $ rmdir /q /s .git
rmdir /q /s .git

echo $ del .gitignore
del .gitignore

echo ok.
echo.

echo ----------------------------------
echo 6. 프로젝트를 시작합니다.
echo ----------------------------------
echo $ yarn start
call yarn start
echo.

echo fin~!! :)
pause
goto :eof

:ERR
echo 프로젝트 이름을 지정하세요.
echo ex) react-app myproject
```