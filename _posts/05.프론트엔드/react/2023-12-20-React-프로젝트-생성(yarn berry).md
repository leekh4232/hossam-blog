---
title:  "[React] Yarn Berry 버전으로 React 프로젝트 생성하기"
description: "실제로 React 프로젝트를 진행했을 때 node_modules 폴더의 용량 때문에 호스팅 비용이 생각보다 더 많이 나갔던 경험이 있다. 그 후부터는 프로젝트를 생성할 때 마다 yarn berry 버전으로 생성하고 있다."
categories: [05.Frontend,React]
tags: [Web Development,Frontend,React,Windows,Batch]
image: /images/indexs/toyproject.jpg
date: 2023-12-21 13:01:28 +0900
author: Hossam
pin: true
math: true
mermaid: true
---

## #01. Yarn Berry란?

Yarn Berry(Yarn 2+)는 기존 Yarn 1.x의 한계를 극복하기 위해 개발된 새로운 패키지 매니저입니다.

### 주요 장점

- **Zero-Install**: `.yarn/cache` 폴더를 통해 의존성을 압축 저장하여 `node_modules` 없이도 프로젝트 실행 가능
- **빠른 설치 속도**: PnP(Plug'n'Play) 방식으로 패키지 해석 속도 향상
- **디스크 공간 절약**: 중복 의존성 제거로 프로젝트 크기 대폭 감소
- **향상된 보안**: 의존성 해석 과정에서 보안 취약점 감소

## #02. 리액트 프로젝트 생성하기

일반적인 React 프로젝트를 yarn 명령어로 생성합니다.

```shell
$ yarn create react-app 프로젝트이름
$ cd 프로젝트이름
```

> **참고**: 프로젝트 이름에는 대문자나 특수문자를 사용하지 않는 것을 권장합니다.

## #03. Yarn Berry 설정하기

### 1. Yarn 버전 변경

프로젝트 폴더 안에서 아래의 명령어를 순차적으로 실행합니다.

```shell
$ yarn set version berry
$ yarn install
```

실행 후 다음과 같은 변화가 발생합니다:
- `.yarn/releases/` 폴더가 생성되며 Yarn Berry 실행 파일이 저장됩니다
- `.yarnrc.yml` 파일이 생성됩니다
- `yarn.lock` 파일이 업데이트됩니다

### 2. 설정파일 수정하기

#### `.yarnrc.yml`

생성된 파일에서 `nodeLinker` 값을 `pnp`로 설정합니다. (기본값이 `node-modules`인 경우 변경)

```yaml
nodeLinker: pnp

yarnPath: .yarn/releases/yarn-4.9.2.cjs
```

> **PnP vs node-modules**
> - `pnp`: Plug'n'Play 방식, `node_modules` 폴더 없이 동작 (권장)
> - `node-modules`: 기존 방식과 동일하게 `node_modules` 폴더 사용

#### `package.json`

React 프로젝트에서 기본으로 포함된 `eslintConfig` 설정이 Yarn Berry와 충돌할 수 있으므로 제거하거나 키 이름을 변경합니다.

```json
{
  // 이 부분을 삭제하거나 키 이름 변경
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  }
}
```

### 3. 변경사항 반영하기

프로젝트 폴더 안에서 다음 명령을 다시 실행합니다.

```shell
$ yarn install
```

명령어를 수행하면 다음과 같은 변화가 일어납니다:
- `node_modules` 폴더가 제거됩니다
- `.yarn/cache` 폴더에 압축된 의존성 파일들이 저장됩니다
- `.pnp.cjs` 파일이 생성됩니다 (PnP 모드에서)

> **용량 비교 예시**
> - 기존 `node_modules`: 약 200-300MB
> - Yarn Berry `.yarn/cache`: 약 20-50MB (압축률에 따라 차이)

## #04. VS Code 설정하기

Yarn Berry의 PnP 모드에서 VS Code가 모듈을 올바르게 인식하도록 설정합니다.

### 1. TypeScript SDK 설정

```shell
$ yarn dlx @yarnpkg/sdks vscode
```

### 2. VS Code에서 TypeScript 버전 선택

1. VS Code에서 TypeScript 파일 열기
2. `Ctrl + Shift + P` (또는 `Cmd + Shift + P`)
3. "TypeScript: Select TypeScript Version" 검색
4. "Use Workspace Version" 선택

## #05. 프로젝트 실행하기

설정이 완료되면 일반적인 방법으로 프로젝트를 실행할 수 있습니다.

```shell
# 개발 서버 실행
$ yarn start

# 프로덕션 빌드
$ yarn build

# 테스트 실행
$ yarn test
```

## #06. Git 관련 설정

### Git을 사용하지 않는 경우 관련 파일/폴더 삭제하기 (선택사항)

#### windows

```shell
$ rmdir /q /s .git
$ del .gitignore
```

#### mac

```shell
$ rm -rf .git
$ rm .gitignore
```

### 만약 Git을 사용하는 경우 `.gitignore`에 아래 내용 추가

Yarn Berry 프로젝트에서는 다음 설정을 `.gitignore`에 추가해야 합니다:

```gitignore
# Yarn Berry
.yarn/*
!.yarn/cache
!.yarn/patches
!.yarn/plugins
!.yarn/releases
!.yarn/sdks
!.yarn/versions

# PnP files
.pnp.*
```

> **주의사항**
> - `.yarn/cache` 폴더는 Git에 포함해야 Zero-Install의 장점을 활용할 수 있습니다
> - `.pnp.cjs` 파일도 Git에 포함되어야 합니다

## #07. 트러블슈팅

### 자주 발생하는 문제들

#### 1. 모듈을 찾을 수 없다는 오류

```
Error: Cannot find module 'react'
```

**해결방법:**
```shell
$ yarn install
$ yarn dlx @yarnpkg/sdks vscode  # VS Code 사용 시
```

#### 2. ESLint 오류

```
ESLint couldn't determine the plugin uniquely
```

**해결방법:**
`package.json`에서 `eslintConfig` 제거 또는 별도 `.eslintrc.js` 파일 생성

#### 3. VS Code에서 모듈 인식 불가

**해결방법:**
1. TypeScript SDK 재설정: `yarn dlx @yarnpkg/sdks vscode`
2. VS Code 재시작
3. TypeScript 버전을 "Use Workspace Version"으로 선택

### 기존 프로젝트를 Yarn Berry로 마이그레이션

기존 `npm` 또는 `yarn v1` 프로젝트를 변환하는 경우:

```shell
# 기존 node_modules와 lock 파일 제거
$ rm -rf node_modules package-lock.json yarn.lock  # macOS/Linux
$ rmdir /s node_modules & del package-lock.json yarn.lock  # Windows

# Yarn Berry로 변환
$ yarn set version berry
$ yarn install
```

## #08. 마무리

Yarn Berry를 사용하면 다음과 같은 이점을 얻을 수 있습니다:

- **개발 환경 통일**: Zero-Install로 팀원 간 환경 차이 최소화
- **CI/CD 최적화**: 의존성 설치 시간 단축
- **저장 공간 절약**: 프로젝트 크기 대폭 감소
- **성능 향상**: 빠른 의존성 해석 속도

처음에는 기존 방식과 다르게 느껴질 수 있지만, 프로젝트 규모가 커질수록 Yarn Berry의 장점을 더욱 체감할 수 있습니다.
