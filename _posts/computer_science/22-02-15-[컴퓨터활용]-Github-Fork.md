---
layout: post
title:  "[컴퓨터활용] Github에서 Fork 한 저장소 동기화 하기"
date:   2022-02-14
banner_image: index-computing.png
tags: [컴퓨터활용]
---

Github에서 다른 계정의 저장소를 내 계정으로 복사하는 것을 Fork라고 합니다. Fork를 하게 되면 원본 저장소의 변경사항이 자동으로 반영되지 않습니다. 원본 저장소와의 동기화를 위해서는 아래와 같은 과정을 거쳐야 합니다.

<!--more-->

# #01. 원본 저장소에 URL을 추가하기

> 이 단계는 저장소를 clone한 후 최초 1회만 수행
>
> 새로 clone 한다면 다시 수행해야 함

## [1] 현재 저장소에 등록된 URL 확인

내 저장소의 주소가 확인된다.

```shell
$ git remote -v
```

### 출력예시

```shell
$ git remote -v
origin  https://github.com/YOUR_USERNAME/YOUR_FORK.git (fetch)
origin  https://github.com/YOUR_USERNAME/YOUR_FORK.git (push)
```


## [2] 동기화 하고자 하는 원본 저장소의 URL 추가

```shell
$ git remote add upstream 저장소URL
```

공개된 오픈소스인 경우 `https` 주소 사용.

`ssh`는 인증서가 등록된 collaborator가 아닌 이상 적용 안되는 경우가 가끔 있음.

```shell
$ git remote add upstream https://github.com/leekh4232/hossam-data-helper.git
```

## [3] 결과 확인

내 저장소와 원본의 주소가 모두 확인되어야 한다.

```shell
$ git remote -v
```

### 출력예시

```shell
$ git remote -v
origin    https://github.com/YOUR_USERNAME/YOUR_FORK.git (fetch)
origin    https://github.com/YOUR_USERNAME/YOUR_FORK.git (push)
upstream  https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git (fetch)
upstream  https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git (push)
```



# #02. 원본 저장소의 변경사항을 update하기

## [1] 원본 저장소의 변경사항이 있는지 확인

```shell
$ git fetch upstream
```

### 출력예시

```shell
$ git fetch upstream
remote: Counting objects: 75, done.
remote: Compressing objects: 100% (53/53), done.
remote: Total 62 (delta 27), reused 44 (delta 9)
Unpacking objects: 100% (62/62), done.
From https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY
 * [new branch]      main     -> upstream/main
```

## [2] 원본 저장소의 내용을 내 로컬 저장소로 받아온다.

```shell
$ git checkout main
```

### 출력예시

```shell
$ git checkout main
Switched to branch 'main'

$ git merge upstream/main
Updating a422352..5fdff0f
Fast-forward
 README                    |    9 -------
 README.md                 |    7 ++++++
 2 files changed, 7 insertions(+), 9 deletions(-)
 delete mode 100644 README
 create mode 100644 README.md
```

## [3] 병합된 내용을 내 저장소로 push

```shell
$ git push origin main
```