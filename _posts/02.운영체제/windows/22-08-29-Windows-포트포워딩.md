---
title:  "Windows 포트포워딩"
description: "특정 포트로 들어오는 요청을 내부의 다른 포트로 포워딩하는 방법"
categories: [02.Operating System,Windows]
tags: [컴퓨터활용,Operating System,Windows,포트포워딩]
image: /images/indexs/windows.webp
date: 2022-08-29 23:34:09 +0900
author: Hossam
pin: true
math: true
mermaid: true
---

## 포트 포워딩(Port Forwarding)이란?

포트 포워딩은 전달받은 패킷에 IP:Port의 정보를 자신의 포트 포워딩 설정 정보를 참고하여 특정 IP:Port로 변환시켜주는 기능입니다. 주로 같은 네트워크 대역(LAN)이나 VM에서 Host OS가 Guest OS에게 특정 Port로 전달되는 패킷을 넘겨주기 위해 사용됩니다.

### 동작 원리

예를 들어, `10.10.10.100` 서버에 포트 포워딩 설정이 되어 있고, 목적지 IP가 `10.10.10.100`, 목적지 포트가 `800`인 패킷을 받을 경우, 이를 목적지 IP `192.168.100.31`, 목적지 포트 `8080`으로 변환시켜 전달하게 됩니다.

```mermaid
graph LR
    A[클라이언트] -->|요청: 10.10.10.100:800| B[포트 포워딩 서버]
    B -->|변환 후 전달: 192.168.100.31:8080| C[대상 서버]
    C -->|응답| B
    B -->|응답 전달| A
```

## Windows에서 포트 포워딩 설정하기

Windows에서는 `netsh` 명령어를 사용하여 포트 포워딩을 설정할 수 있습니다.

> **주의사항**: 모든 명령어는 관리자 권한으로 실행된 CMD에서 실행해야 합니다.
{: .prompt-warning }

### 1. 포트 포워딩 설정

특정 IP:Port로 들어오는 패킷을 다른 IP:Port로 포워딩합니다.

```shell
$ netsh interface portproxy add v4tov4 listenport=[전달받을 포트] listenaddress=[전달받을 IP] connectport=[변환할 포트] connectaddress=[변환할 IP]
```

**예시**: `10.10.10.100:800`으로 전달받은 패킷을 `192.168.100.31:8080`으로 포워딩
```shell
$ netsh interface portproxy add v4tov4 listenport=800 listenaddress=10.10.10.100 connectport=8080 connectaddress=192.168.100.31
```

**모든 IP에서 접근 허용**: 모든 IP 주소에서 `800` 포트로 들어오는 패킷을 `192.168.100.31:8080`으로 포워딩
```shell
$ netsh interface portproxy add v4tov4 listenport=800 listenaddress=0.0.0.0 connectport=8080 connectaddress=192.168.100.31
```

> **참고**: `listenaddress=0.0.0.0`을 사용하면 모든 IP 주소에서의 접근을 허용합니다.
{: .prompt-info }

### 2. 포트 포워딩 해제

설정된 포트 포워딩을 제거합니다.

```shell
$ netsh interface portproxy delete v4tov4 listenport=[전달받을 포트] listenaddress=[전달받을 IP]
```

**예시**: `10.10.10.100:800`에 대한 설정을 해제
```shell
$ netsh interface portproxy delete v4tov4 listenport=800 listenaddress=10.10.10.100
```

### 3. 포트 포워딩 설정 확인

현재 설정된 모든 포트 포워딩 규칙을 조회합니다.

```shell
$ netsh interface portproxy show v4tov4
```

### 4. 모든 포트 포워딩 설정 삭제

모든 포트 포워딩 규칙을 한번에 삭제하려면:

```shell
$ netsh interface portproxy reset
```

## 주요 매개변수 설명

| 매개변수 | 설명 |
|----------|------|
| `listenport` | 들어오는 패킷을 받을 포트 번호 |
| `listenaddress` | 들어오는 패킷을 받을 IP 주소 |
| `connectport` | 포워딩할 대상 포트 번호 |
| `connectaddress` | 포워딩할 대상 IP 주소 |

## 활용 예시

### 1. 로컬 웹 서버 포워딩

로컬에서 실행 중인 웹 서버(localhost:3000)를 외부에서 접근 가능하도록 포워딩:

```shell
$ netsh interface portproxy add v4tov4 listenport=80 listenaddress=0.0.0.0 connectport=3000 connectaddress=127.0.0.1
```

### 2. VM 서버 포워딩

가상머신의 웹 서버를 호스트 머신을 통해 접근할 수 있도록 포워딩:

```shell
$ netsh interface portproxy add v4tov4 listenport=8080 listenaddress=192.168.1.100 connectport=80 connectaddress=192.168.1.200
```

## 문제 해결

### 포트 포워딩이 작동하지 않는 경우

1. **방화벽 확인**: Windows 방화벽에서 해당 포트가 허용되어 있는지 확인
2. **권한 확인**: 관리자 권한으로 명령어를 실행했는지 확인
3. **포트 사용 여부**: 설정하려는 포트가 다른 프로그램에서 사용 중인지 확인

```shell
$ netstat -an | findstr :포트번호
```

> **팁**: 포트 포워딩 설정 후 시스템을 재부팅해도 설정이 유지됩니다.
{: .prompt-tip }
