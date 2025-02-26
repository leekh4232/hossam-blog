---
layout: post
title:  "[Ubuntu] Jupyter Server 설치"
date:   2024-04-21
banner_image: index-ubuntu.png
tags: [Linux, Python]
---

리눅스 기반으로 데이터 분석을 수행한다면 하나의 머신을 여러 명의 분석가가 공유하는 경우가 대부분입니다. 이럴 때 jupyter server를 리눅스에 설치하고 원격 접속이 가능하게 한다면 colab과 같은 환경으로 사용할 수 있습니다.

<!--more-->

이 과정은 Python과 pip가 설치되어 있어야 합니다.

# #01. Jupyter 설치

아래 명령을 사용해 Jupyter를 설치합니다.

```shell
$ sudo pip3 install jupyter
```

정상 설치를 확인하기 위해서 아래 명령으로 jupyter의 버전을 확인해 봅니다.

```shell
$ jupyter --version
```

##### 출력결과

```shell
Selected Jupyter core packages...
IPython          : 8.23.0
ipykernel        : 6.29.4
ipywidgets       : 8.1.2
jupyter_client   : 8.6.1
jupyter_core     : 5.7.2
jupyter_server   : 2.14.0
jupyterlab       : 4.1.6
nbclient         : 0.10.0
nbconvert        : 7.16.3
nbformat         : 5.10.4
notebook         : 7.1.3
qtconsole        : 5.5.1
traitlets        : 5.14.3
```

# #02. Jupyter 서버 설정

## [1] 비밀번호 설정

### (1) 비밀번호 생성

아래 명령으로 비밀번호를 생성합니다.

```shell
$ jupyter lab password
```

##### 출력결과

아래와 같이 비밀번호를 두 번 입력받는다. 그 후 비밀번호가 기입된 파일의 경로가 표시됩니다.

```shell
Enter password: ****
Verify password: ****
[JupyterPasswordApp] Wrote hashed password to /home/leekh/.jupyter/jupyter_server_config.json
```

### (2) 비밀번호 확인

생성된 파일을 열어 비밀번호를 확인한다. 입력한 값이 암호화 되어 있습니다.

이 값을 설정파일에 기입해야 합니다.

```shell
$ cat /home/leekh/.jupyter/jupyter_server_config.json
```

##### 출력결과

`hashed_password`의 값을 따옴표 없이 복사한다.

```shell
{
  "IdentityProvider": {
    "hashed_password": "argon2:$argon2id$v=19$m=10240,t=10,p=8$eosovHV4oK+YoLZYRIFmjA$FKRzhvliPfzNWUVd43ylG8e41itMgVBFiHZey0r0phQ"
  }
}%
```


## [2] Jupyter 설정

### (1) 설정파일 생성

아래 명령으로 설정 파일을 생성합니다.

```shell
$ jupyter lab --generate-config
```

##### 출력결과

아래와 같이 생성된 설정파일의 위치가 출력됩니다.

```shell
Writing default config to: /home/leekh/.jupyter/jupyter_lab_config.py
```

### (2) 설정파일 수정

vi 에디터로 설정파일을 편집합니다.

```shell
$ vi ~/.jupyter/jupyter_lab_config.py
```

파일을 열면 맨 위에 `c = get_config()`라는 구문이 있습니다.

이 구문 아래에 다음과 같이 추가합니다.

이 파일은 설정을 변경하고자 하는 사항에 대한 예시들만 들어 있기 때문에 모든 내용이 주석처리되어 있습니다.

상세 옵션을 설정할 경우 주석으로 기입된 내용을 잘 읽어보고 값을 입력하면 됩니다.

```py
# 외부에서 Jupyter로 접속할 때 사용할 IP주소 지정 (미지정시 Local만 가능함)
c.NotebookApp.ip = '192.168.245.128'

# 포트번호 지정 (기본값=8888)
c.NotebookApp.port = 9905

# 기본 디렉토리 지정(사용자의 홈디렉토리 이하 경로. 해당 폴더가 생성되어 있어야 함)
c.NotebookApp.notebook_dir='notebook'

# 비밀번호(앞서 생성한 값)
c.NotebookApp.password='argon2:$argon2id$v=19$m=10240,t=10,p=8$eosovHV4oK+YoLZYRIFmjA$FKRzhvliPfzNWUVd43ylG8e41itMgVBFiHZey0r0phQ'
```

위 옵션에서 `c.NotebookApp.notebook_dir`을 지정하지 않으면 jupyter는 사용자 홈 디렉토리에 접속하게 됩니다.

값을 `notebook`이라고 기입할 경우 `~/notebook` 디렉토리에서 시작됩니다. 물론 이 폴더는 미리 생성되어 있어야 합니다.


## [3] 방화벽 포트 열기

설정파일에서 포트번호를 `9905`로 지정했으므로 해당 포트를 열어야 합니다.

### (1) 포트 규칙 추가

```shell
$ sudo ufw allow 9905/tcp
```

### (2) 방화벽 리로드

```shell
$ sudo ufw reload
```

### (3) 방화벽 규칙 확인

```shell
$ sudo ufw status
```

###### 출력결과

```shell
Status: active

To                         Action      From
--                         ------      ----
22                         ALLOW       Anywhere
9902/tcp                   ALLOW       Anywhere
10100:10200/tcp            ALLOW       Anywhere
21/tcp                     ALLOW       Anywhere
9905/tcp                   ALLOW       Anywhere
22 (v6)                    ALLOW       Anywhere (v6)
9902/tcp (v6)              ALLOW       Anywhere (v6)
10100:10200/tcp (v6)       ALLOW       Anywhere (v6)
21/tcp (v6)                ALLOW       Anywhere (v6)
9905/tcp (v6)              ALLOW       Anywhere (v6)
```

# #03. Jupyter 가동하기

```shell
$ jupyter lab
```

서버를 가동하면 아래와 같이 접속 가능한 URL이 출력됩니다.

```shell
 To access the server, open this file in a browser:
    file:///home/leekh/.local/share/jupyter/runtime/jpserver-2308-open.html
 Or copy and paste one of these URLs:
    http://192.168.245.128:9905/lab?token=e72f18eec167704ef0d5186a69277998937438dcffa38e8d
    http://127.0.0.1:9905/lab?token=e72f18eec167704ef0d5186a69277998937438dcffa38e8d
```

이 중에서 IP주소가 지정된 URL을 확인하고 브라우저로 접속을 확인해 봅니다.

![jupyter](/images/posts/2024/0421/jupyter.png)


# #04. Jupyter 서비스 등록

매번 리눅스를 부팅하고 `jupyter lab` 명령어를 수행해서 jupyter를 가동하려면 꽤나 귀찮습니다. 그래서 서비스 가동 스크립트를 생성하고 `systemctl`로 등록해 줍니다.

> 리눅스에서 jupyter가 가동중이라면 `Ctrl+C`를 눌러서 가동을 중단합니다.

## [1] jupyter 실행 파일 위치 찾기

```shell
$ which jupyter
```

##### 출력결과

```shell
/usr/local/bin/jupyter
```

## [2] 서비스 파일 생성

```shell
$ sudo vi /usr/lib/systemd/system/jupyter.service
```

파일이 생성되면 아래의 내용을 작성하고 저장합니다.

> 

```
[Unit]
Description=Jupyter Server

[Service]
Type=test
PIDFile=/run/jupyter.pid
User=계정명                             <---- 자신의 계정명
ExecStart=/usr/local/bin/jupyter lab --config /home/.jupyter/jupyter_lab_config.py
WorkingDirectory=/home/계정명/notebook  <---- 자신의 작업 경로 (c.NotebookApp.notebook_dir값)

[Install]
WantedBy=multi-user.target
```

만약 이 파일을 수정한다면 아래 명령으로 다시 로드해 준수 서비스를 중지/시작해야 합니다.

```shell
$ sudo systemctl daemon-reload 
```

## [3] 서비스 가동

### (1) 부팅시 자동 실행 등록

```shell
$ sudo systemctl enable jupyter.service
```

### (2) 서비스 가동

```shell
$ sudo systemctl start jupyter
```

### (3) 브라우저 접속 확인

웹 브라우저로 다시 jupyter 주소를 입력하고 접속 결과를 확인합니다.

# #05. VSCode에 Jupyter Server 연결

## [1] Remote SSH 익스텐션 설치

`Remote SSH` 익스텐션을 검색하여 설치합니다.

![rssh](/images/posts/2024/0421/rssh.png)

## [2] VSCode SSH 설정

### (1) 설정파일 열기

좌측 탐색기 영역에서 `SSH`화면으로 이동 후 `설정`아이콘을 누릅니다.

![vsconfig1](/images/posts/2024/0421/vsconfig1.png)

설정파일 선택 화면이 나타나면 사용자 홈 디렉토리 하위의 파일을 선택합니다.

![vsconfig2](/images/posts/2024/0421/vsconfig2.png)

### (2) 설정 내용 작성

```
Host [계정명]@[IP 주소]:[SSH포트번호]
    HostName [IP 주소]
    User [계정명]
    Port [SSH포트번호]
    IdentityFile [SSH 인증서 file 경로]
```

실제 작성 예시는 아래와 같습니다.

주의할 것은 jupyter의 포트번호가 아닌 SSH 포트번호 입니다.

```
Host leekh@192.168.245.128:9902
    HostName 192.168.245.128
    User leekh
    Port 9902
    IdentityFile ~/.ssh/myserver
```

> 여기서는 인증서 파일의 이름이 `myserver`라고 가정되어 있습니다. 대부분의 경우 `id_rsa`입니다.

파일을 작성한 후 VSCode에서 설정 새로고침 버튼을 눌러 설정파일을 다시 로드 합니다.

![vsconfig3](/images/posts/2024/0421/vsconfig3.png)


## [3] 원격 접속하기

등록된 SSH 항목을 통해 접속합니다.

![vsconfig4](/images/posts/2024/0421/vsconfig4.png)

## [4] 익스텐션 설치

원격 접속이 된 VSCode는 더 이상 내 컴퓨터에서 실행되는 상태가 아닙니다.

그렇기 때문에 VSCode의 익스텐션도 원격 컴퓨터에 다시 설치해야 합니다.

익스텐션 창을 보면 현재 내 로컬 컴퓨터에 설치된 익스텐션 중에서 원격 컴퓨터에 설치 가능한 항목들에 버튼이 표시됩니다.

이 버튼을 눌러 익스텐션을 설치합니다.

이 과정에서 파이썬 관련 익스텐션들도 다시 설치됩니다.

![vsconfig5](/images/posts/2024/0421/vsconfig5.png)


> 이제 적절한 작업 폴더를 workspace로 지정하고 사용하면 됩니다. Enjoy~!!