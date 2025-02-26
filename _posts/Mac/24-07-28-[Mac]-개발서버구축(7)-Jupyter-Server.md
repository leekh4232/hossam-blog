---
layout: post
title:  "[Mac] 개발서버 구축기 (7) - Jupyter Server"
date:   2024-07-28
banner_image: index-mac-studio.jpg
tags: [Mac]
---

Mac Studio를 구입한 가장 큰 이유가 머신러닝 성능때문이다. 머신러닝의 경우 대부분 Jupyter를 통해 작업을 하기 때문에 Jupyter Server를 설치해 두면 언제 어디서나 작업이 가능해 진다.

<!--more-->

# #01. Jupyter 설치

Jupyter를 설치할 때 `pip` 명령어를 사용하면 백그라운드 서비스 등록 및 관리 방법이 다른 서비스들과 달라지기 때문에 관리의 일관성을 위해 Homebrew를 사용해 설치했다.

```shell
$ brew install jupyterlab
```

# #02. Jupyter 서버 설정

## [1] 비밀번호 설정

### (1) 비밀번호 생성

아래 명령으로 비밀번호를 생성한다.

```shell
$ jupyter lab password
```

##### 출력결과

아래와 같이 비밀번호를 두 번 입력받는다. 그 후 비밀번호가 기입된 파일의 경로가 표시된다.

```shell
Enter password: ****
Verify password: ****
[JupyterPasswordApp] Wrote hashed password to /Users/leekh/.jupyter/jupyter_server_config.json
```

### (2) 비밀번호 확인

생성된 파일을 열어 비밀번호를 확인한다. 입력한 값이 암호화 되어 있다.

이 값을 설정파일에 기입해야 한다.

```shell
$ cat ~/.jupyter/jupyter_server_config.json
```

##### 출력결과

`hashed_password`의 값을 따옴표 없이 복사한다.

```shell
{
  "IdentityProvider": {
    "hashed_password": "생성된 비밀번호"
  }
}
```


## [2] Jupyter 설정

### (1) 설정파일 생성

아래 명령으로 설정 파일을 생성한다.

```shell
$ jupyter lab --generate-config
```

##### 출력결과

아래와 같이 생성된 설정파일의 위치가 출력된다.

```shell
Writing default config to: /Users/leekh/.jupyter/jupyter_lab_config.py
```

### (2) 설정파일 수정

vi 에디터로 설정파일을 편집한다.

```shell
$ vi ~/.jupyter/jupyter_lab_config.py
```

혹은 VSCode로 연다



```shell
$ code ~/.jupyter/jupyter_lab_config.py
```

파일을 열면 맨 위에 `c = get_config()`라는 구문이 있다.

이 구문 아래에 다음과 같이 추가한다.

이 파일은 설정을 변경하고자 하는 사항에 대한 예시들만 들어 있기 때문에 모든 내용이 주석처리되어 있다.

상세 옵션을 설정할 경우 주석으로 기입된 내용을 잘 읽어보고 값을 입력하면 된다.

```py
# 외부에서 Jupyter로 접속할 때 사용할 IP주소 지정 (미지정시 Local만 가능함)
c.ServerApp.ip = "*"

# Jupyter 가동시 브라우저가 자동으로 열리지 않도록 설정
c.ServerApp.open_browser = False

# 비밀번호 설정
c.ServerApp.password = "복사한값 적용"

# 포트번호 지정 (기본값=8888)
c.ServerApp.port = 9904

# 기본 디렉토리 지정(사용자의 홈디렉토리 이하 경로. 해당 폴더가 생성되어 있어야 함)
c.ServerApp.root_dir = "/Users/leekh/workspace-jupyter"
```

위 옵션에서 `c.ServerApp.notebook_dir`을 지정하지 않으면 jupyter는 사용자 홈 디렉토리에 접속하게 된다.


## [3] SSL 인증서 경로 설정

HTTPS 접속을 설정할 경우 `~/.jupyter/jupyter_lab_config.py` 파일에 다음과 같이 SSL 인증서 파일의 경로를 지정해 준다.

```py
c.ServerApp.keyfile = "/Users/leekh/.ssl/live/home.hossam.kr/privkey.pem"
c.ServerApp.certfile = "/Users/leekh/.ssl/live/home.hossam.kr/fullchain.pem"
```

# #03. 서비스 가동 및 중지

```shell
# 시작 스크립트
$ brew services start jupyterlab

# 종료 스크립트
$ brew services stop jupyterlab
```
