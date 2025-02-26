---
layout: post
title:  "[Ubuntu] Python 버전 변경"
date:   2024-04-20
banner_image: index-ubuntu.png
tags: [Linux, Python]
---

우분투 리눅스에는 기본적으로 파이썬 `3.10`이 설치되어 있습니다. (`22.04.4`기준) 이 버전을 원하는 버전으로 변경하는 과정을 소개합니다.

<!--more-->

# #01. 현재 파이썬 확인

## 1. 파이썬 버전 확인

```shell
$ python3 --version
```

#### 출력결과

```shell
Python 3.10.12
```

## 2. 파이썬 명령어의 위치 확인

`which 명령어`를 사용하면 특정 명령어의 실행 파일 위치를 확인할 수 있습니다.

```shell
$ which python3
```

#### 출력결과

```shell
/usr/bin/python3
```

## 3. 파이썬 명령어가 어떤 파일에 연결되어 있는지 확인

만약 `python3` 명령어가 링크파일 형태라면 이 명령어가 연결되어 있는 본체가 따로 존재합니다. 이를 확인하기 위해 명령어가 위치하고 있는 `/usr/bin` 디렉토리의 목록을 확인합니다.

이 때 `python`이라는 키워드가 포함된 항목만 필터링을 합니다.

```shell
$ ls -al /usr/bin | grep python
```

#### 출력결과

본체가 따로 존재하는 링크 파일이라면 파일 목록에서 `->` 표시를 통해 본체를 함께 표시해 줍니다.

```shell
lrwxrwxrwx  1 root root          24 Nov 20 15:14 pdb3.10 -> ../lib/python3.10/pdb.py
lrwxrwxrwx  1 root root          31 Aug 18  2022 py3versions -> ../share/python3/py3versions.py
-rwxr-xr-x  1 root root         953 May  1  2021 pybabel-python3
lrwxrwxrwx  1 root root          10 Aug 18  2022 python3 -> python3.10
-rwxr-xr-x  1 root root     5904904 Nov 20 15:14 python3.10
```

위 결과를 보면 `python3`라는 명령은 같은 디렉토리에 있는 `python3.10` 파일에 대한 링크 파일 입니다.

# #02. 파이썬 설치를 위한 저장소 구성

## 1. apt 인덱스 업데이트

```shell
$ sudo apt update
```

#### 출력결과

```shell
Get:1 http://security.ubuntu.com/ubuntu jammy-security InRelease [110 kB]
Hit:2 http://kr.archive.ubuntu.com/ubuntu jammy InRelease
Get:3 http://kr.archive.ubuntu.com/ubuntu jammy-updates InRelease [119 kB]
Hit:4 http://kr.archive.ubuntu.com/ubuntu jammy-backports InRelease
Get:5 http://security.ubuntu.com/ubuntu jammy-security/main amd64 Packages [1,381 kB]
Get:6 http://kr.archive.ubuntu.com/ubuntu jammy-updates/main amd64 Packages [1,597 kB]
Get:7 http://kr.archive.ubuntu.com/ubuntu jammy-updates/universe amd64 Packages [1,070 kB]
Get:8 http://security.ubuntu.com/ubuntu jammy-security/main Translation-en [242 kB]
Get:9 http://security.ubuntu.com/ubuntu jammy-security/restricted amd64 Packages [1,744 kB]
Get:10 http://security.ubuntu.com/ubuntu jammy-security/restricted Translation-en [294 kB]
Fetched 6,558 kB in 10s (647 kB/s)
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
20 packages can be upgraded. Run 'apt list --upgradable' to see them.
```

## 2. Python PPA 가져오기

Ubuntu 배포판에는 일반적으로 기본적으로 Python이 포함되어 있지만 새 릴리스로 업데이트할 수 있는 옵션이 부족한 경우가 많습니다. 최신 버전의 Python 3.11을 설치하기 위해 이 가이드에서는 평판이 좋고 널리 알려진 타사 PPA를 사용합니다.

### 1) 최신 안정 릴리스가 포함된 Python 저장소를 가져오기

```shell
$ sudo add-apt-repository ppa:deadsnakes/ppa -y
```

#### 출력결과

```shell
Repository: 'deb https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu/ jammy main'
Description:
This PPA contains more recent Python versions packaged for Ubuntu.

... 생략 ...

Nightly Builds
==============

For nightly builds, see ppa:deadsnakes/nightly https://launchpad.net/~deadsnakes/+archive/ubuntu/nightly
More info: https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa
Adding repository.
Adding deb entry to /etc/apt/sources.list.d/deadsnakes-ubuntu-ppa-jammy.list
Adding disabled deb-src entry to /etc/apt/sources.list.d/deadsnakes-ubuntu-ppa-jammy.list
Adding key to /etc/apt/trusted.gpg.d/deadsnakes-ubuntu-ppa.gpg with fingerprint F23C5A6CF475977595C89F51BA6932366A755776
Hit:1 http://security.ubuntu.com/ubuntu jammy-security InRelease
Hit:2 http://kr.archive.ubuntu.com/ubuntu jammy InRelease
Hit:3 http://kr.archive.ubuntu.com/ubuntu jammy-updates InRelease
Hit:4 http://kr.archive.ubuntu.com/ubuntu jammy-backports InRelease
Get:5 https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu jammy InRelease [18.1 kB]
Get:6 https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu jammy/main amd64 Packages [23.5 kB]
Get:7 https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu jammy/main Translation-en [4,800 B]
Fetched 46.4 kB in 3s (16.0 kB/s)
Reading package lists... Done
```

### 2) apt 업데이트

새로 가져온 PPA가 반영되도록 진행하기 전에 APT 업데이트를 실행하세요.

```shell
$ sudo apt update
```

#### 출력결과

```shell
Hit:1 http://security.ubuntu.com/ubuntu jammy-security InRelease
Hit:2 http://kr.archive.ubuntu.com/ubuntu jammy InRelease
Hit:3 http://kr.archive.ubuntu.com/ubuntu jammy-updates InRelease
Hit:4 https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu jammy InRelease
Hit:5 http://kr.archive.ubuntu.com/ubuntu jammy-backports InRelease
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
20 packages can be upgraded. Run 'apt list --upgradable' to see them.
```

# #03. 원하는 버전의 파이썬 설치

## 1. Python 3.11 설치

Python 3.11 PPA를 성공적으로 가져오면 터미널에서 다음 명령을 실행하여 Python 3.11을 설치합니다.

```shell
$ sudo apt-get install -y python3.11
```

위의 명령은 파이썬의 core만을 설치합니다. 만약 전체 기능을 모두 설치하고자 할 경우 아래 명령을 사용하세요 (추천)

```shell
$ sudo apt-get install -y python3.11-full
```


#### 출력결과

```shell
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:

... 생략 ...

Scanning processes...
Scanning linux images...

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
```

## 2. 설치결과 확인

다음 명령을 사용하여 Python 3.11의 설치 및 빌드 버전을 확인하세요.

```shell
$ python3.11 --version
```

#### 출력결과

```shell
Python 3.11.9
```

## 3. `python3` 명령어 링크

앞의 과정에서 리눅스의 `python3` 명령어가 `python 3.10`에 연결되어 있음을 확인했습니다.

이 연결을 방금 설치한 `3.11`버전으로 변경해야 합니다.

이 과정을 수행하지 않을 경우 `pip`명령으로 설치하는 모든 패키지가 `3.10` 하위로 설치되게 됩니다.

명령어 형식은 다음과 같습니다.

```shell
sudo update-alternatives --install [심볼릭 링크 경로] [이름] [실제 경로] [우선순위]
```

이를 현재 OS에 설치되어 있는 파이썬 버전에 따라 수행해 줍니다.

실제 사용 예시는 아래와 같습니다.

```shell
sudo update-alternatives --install /usr/bin/python3 python /usr/bin/python3.11 1
sudo update-alternatives --install /usr/bin/python3 python /usr/bin/python3.10 2
```

## #04. 파이썬 버전 변경

### 1. 파이썬 버전 확인

아래 명령을 수행하면 `python`이라는 이름으로 등록된 파이썬 버전들이 표시됩니다.

```shell
$ sudo update-alternatives --config python
```

#### 출력결과

```
There are 2 choices for the alternative python (providing /usr/bin/python3).

  Selection    Path                 Priority   Status
------------------------------------------------------------
* 0            /usr/bin/python3.10   2         auto mode
  1            /usr/bin/python3.10   2         manual mode
  2            /usr/bin/python3.11   1         manual mode

Press <enter> to keep the current choice[*], or type selection number:
```

현재는 `Selection` 컬럼을 기준으로 `0`번이 선택되어 있다는 의미로 `0`번 앞에 `*`표가 표시되어 있습니다. 

이 화면에서 사용하고자 하는 `Selection`번호를 입력하고 엔터를 누릅니다. 

`python3.11`을 사용할 것이므로 `2`를 입력하고 엔터를 누릅니다.


### 2. 결과 확인

```shell
$ python3 --version
```

#### 출력결과

```shell
Python 3.11.9
```


# #04. PIP 설치

윈도우와 다르게 pip 명령이 함께 설치되지는 않습니다. 아래 명령으로 pip를 설치합니다.

```shell
$ sudo apt-get install -y python3-pip
```

설치가 완료되면 아래 명령으로 결과를 확인합니다.

```shell
$ pip3 --version
```

#### 출력결과

```shell
pip 22.0.2 from /usr/lib/python3/dist-packages/pip (python 3.11)
```

# #05. 원하는 패키지 설치하기

일부 라이브러리는 설치시 에러가 나기 때문에 아래 명령을 먼저 수행해야 합니다.

```shell
$ pip3 install --upgrade pip setuptools wheel
```

호쌤이 진행하는 데이터 분석 수업에서 사용되는 패키지는 아래의 표와 같습니다.

이를 설치하기 위해 아래 명령을 사용합니다.

```shell
$ pip3 install --upgrade pycallgraphix sqlalchemy requests tqdm ipywidgets tabulate beautifulsoup4 markdownify selenium chromedriver_autoinstaller yfinance pytrends lxml numpy pandas openpyxl xlrd scikit-learn imblearn matplotlib seaborn folium jenkspy scipy wordcloud konlpy statsmodels statannotations pingouin contractions pmdarima prophet  graphviz dtreeviz pca xgboost lightgbm tensorflow keras-tuner
```

| 패키지 이름 | 설명 |
|---|---|
| pycallgraphix | 함수의 실행 과정을 추적함 |
| sqlalchemy | Python을 통한 데이터베이스 연동 기능 제공(범용) |
| requests | HTTP 요청을 처리하는 패키지 (API연동) |
| tqdm | Progressbar 구현 패키지 |
| ipywidgets | tqdm을 jupyter 상에서 동작시키는 패키지 |
| tabulate | 데이터프레임을 표 형태의 문자열로 출력 |
| beautifulsoup4 | HTML 소스코드로부터 컨텐츠 추출 기능 제공 |
| markdownify | HTML태그를 markdown으로 변환해 주는 패키지 |
| selenium | 크롬 브라우저를 제어하는 패키지 |
| chromedriver_autoinstaller | selenium과 크롬 브라우저를 연결해 주는 chromedirver를 자동으로 설치해 주는 패키지 |
| yfinance | 야후 파이낸스 OpenAPI를 내부적으로 연동하여 주가 데이터를 수집하는 패키지 |
| pytrends | 구글 트렌드 데이터를 수집하는 패키지 (`requests`, `lxml`, `pandas` 패키지에 의존한다.) |
| numpy | 데이터 분석의 근간이 되는 수학, 과학 연산 패키지 |
| pandas | 분석용 데이터 구조 및 탐색적 데이터 분석 기능을 제공하는 패키지 |
| openpyxl | 엑셀 파일 처리 패키지 (pandas가 의존함) |
| xlrd | 엑셀 파일 처리 패키지 (pandas가 의존함) |
| scikit-learn | 파이썬의 가장 대표적인 머신러닝 패키지<br/>`threadpoolctl, `scipy`, `joblib` 패키지에 의존한다. |
| imblearn | 데이터 불균형 해소를 위한 기능 제공 |
| matplotlib | 파이썬의 기본 시각화 패키지 |
| seaborn | 파이썬의 가장 대중적인 시각화 패키지 |
| folium | jupyter에 내장 가능한 웹 지도 패키지 |
| jenkspy | jenks natural breaks 패키지 |
| scipy | 과학기술 계산을 위한 파이썬 라이브러리. numpy의 상위 라이브러리 |
| wordcloud | 워드클라우드 시각화 패키지 |
| konlpy | Twitter 한글 형태소 분석기 (JDK설치 및 설정 필요) |
| statsmodels | 통계 분석 관련 기능 제공 패키지 |
| statannotations | seaborn으로 그린 박스플롯에 통계분석에 대한 주석을 추가할 수 있다 |
| pingouin | Games-Howell 검정 기능을 제공한다. |
| contractions | 영어 축약형 표현을 비 축약형으로 변환하는 모듈 |
| pmdarima | auto ARIMA 모형 |
| prophet | Meta(Facebook) 시계열 라이브러리 |
| scikit-learn-intelex | sklearn Intel CPU 하드웨어 가속기 |
| graphviz | 의사결정 트리 시각화 패키지(1) |
| dtreeviz | 의사결정 트리 시각화 패키지(2) |
| pca | 차원축소 패키지 |
| xgboost | XGBoost 알고리즘 |
| lightgbm | LightGBM 알고리즘 |
| tensorflow | 텐서플로우(딥러닝) |
| keras-tuner | 케라스 하이퍼 파라미터 튜닝 |


#### 설치 실패 패키지

아래 패키지들은 설치에 실패했습니다.

이를 해결하기 위한 방법을 별도로 찾아봐야 하지만 이 포스팅에서 중요한 부분은 아니므로 특별히 알아보지는 않았습니다.

| 패키지 이름 | 설명 |
|---|---|
| cx_oracle | 오라클 연동 라이브러리 |
| scikit-surprise | 협업필터링 알고리즘 |