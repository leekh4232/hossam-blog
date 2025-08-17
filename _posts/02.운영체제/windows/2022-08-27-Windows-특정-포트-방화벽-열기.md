---
title:  "Windows 특정 포트 방화벽 열기"
description: 수동으로 설치한 프로그램들이 윈도우 부팅시에 자동으로 구동되도록 명령프롬프트 상에서 윈도우에 서비스를 등록하는 명령어들 정리.
categories: [02.Operating System,Windows]
date:   2022-08-27 18:26:00 +0900
author: Hossam
image: /images/indexs/computing.png
tags: [컴퓨터활용,Operating System,Windows]
pin: true
math: true
mermaid: true
---

윈도우는 기본적으로 방화벽을 통해 모든 포트번호에 대한 외부 접근을 차단하고 있다. 톰켓이나 MySQL같은 서버 프로그램을 운영하면서 특정 포트번호에 대한 방화벽 접근을 허용하면 다른 PC를 통해 원격 접속을 테스트해 볼 수 있다.



## #01. 방화벽 규칙 생성하기

### 1) 방화벽 설정 열기

`WinKey+R`을 누른후 실행 창에서 **wf.msc**를 입력하고 확인을 누른다.

![방화벽 설정 열기](/images/2022/0827/wf1.png)

### 2) 새 인바운드 규칙 추가

왼쪽 메뉴에서 **인바운드 규칙**을 선택하고 오른쪽 메뉴에서 **새 규칙**을 클릭한다.

![새 인바운드 규칙 추가](/images/2022/0827/wf2.png)

### 3) 포트 설정 추가

포트를 선택하고 다음으로 넘어간다.

![포트 설정 추가](/images/2022/0827/wf3.png)

### 4) 허용할 포트 입력하기

프로토콜 종류를 **TCP**로 선택하고 접근을 허용할 포트를 입력한 후 다음으로 넘어간다.

![허용할 포트 입력하기](/images/2022/0827/wf4.png)

#### 연결 허용 선택

![연결 허용 선택](/images/2022/0827/wf5.png)

#### 연결 위치 지정

모든 위치를 선택하고 다음으로 넘어간다.

![연결 위치 지정](/images/2022/0827/wf6.png)

#### 연결 이름 지정

적절한 값을 입력하고 설정 과정을 마친다.

![연결 이름 지정](/images/2022/0827/wf7.png)

## #02. 테스트하기

공인IP를 사용하지 않는 경우라면 클라이언트 역할을 하는 장비와 서버 역할을 하는 장비가 동일한 공유기(Wifi포함)에 연결되어 있어야 합니다.

### Case1

컴퓨터 A에 톰켓이 설치되어 있고 8080 포트에 대한 방화벽 접근이 허용된 경우 같은 공유기에 연결되어 있는 다른 컴퓨터나 스마트폰, 테블릿PC 등을 통해 A에서 구동중인 톰켓에 접속할 수 있다.

### Case2

컴퓨터 B에 MySQL이 설치되어 있고 3306 포트에 대한 방화벽 접근이 허용된 경우 같은 공유기에 연결된 다른 컴퓨터에서 MySQL Workbench나 명령프롬프트를 통한 mysql 명령으로 B에서 구동중인 MySQL에 접근할 수 있다.

```bash
mysql -u사용자계정 -p -h컴퓨터A의_IP주소
```

> 단, 여기서 사용되는 사용자계정은 컴퓨터B에 대한 정보를 사용해야 한다.

### Case3

컴퓨터 C에 MySQL이 설치되어 있고 3306 포트에 대한 방화벽 접근이 허용된 경우 같은 공유기에 연결된 다른 컴퓨터에서 개발중인 Spring 프로젝트에서 MyBatis의 설정 파일에 C에서 구동중인 MySQL 정보를 입력해서 여러명의 개발자가 하나의 데이터베이스를 공유하는 것이 가능하다.

## #03. 명령줄을 이용한 방화벽 관리

### 1) netsh 명령어 사용

```cmd
# 특정 포트 허용 (인바운드)
netsh advfirewall firewall add rule name="Allow Port 8080" dir=in action=allow protocol=TCP localport=8080

# 특정 포트 허용 (아웃바운드)
netsh advfirewall firewall add rule name="Allow Port 8080 Out" dir=out action=allow protocol=TCP localport=8080

# 특정 IP 주소에서의 접근만 허용
netsh advfirewall firewall add rule name="Allow MySQL from 192.168.1.100" dir=in action=allow protocol=TCP localport=3306 remoteip=192.168.1.100

# 포트 범위 허용
netsh advfirewall firewall add rule name="Allow Port Range" dir=in action=allow protocol=TCP localport=8000-8010

# UDP 포트 허용
netsh advfirewall firewall add rule name="Allow DNS" dir=in action=allow protocol=UDP localport=53
```

### 2) 방화벽 규칙 관리

```cmd
# 방화벽 규칙 목록 확인
netsh advfirewall firewall show rule name=all

# 특정 규칙 확인
netsh advfirewall firewall show rule name="Allow Port 8080"

# 규칙 삭제
netsh advfirewall firewall delete rule name="Allow Port 8080"

# 포트별 규칙 삭제
netsh advfirewall firewall delete rule protocol=tcp localport=8080

# 모든 규칙 초기화 (주의!)
netsh advfirewall reset
```

### 3) 방화벽 프로필 관리

```cmd
# 방화벽 상태 확인
netsh advfirewall show allprofiles

# 도메인 프로필 방화벽 끄기
netsh advfirewall set domainprofile state off

# 개인 프로필 방화벽 끄기
netsh advfirewall set privateprofile state off

# 공용 프로필 방화벽 끄기
netsh advfirewall set publicprofile state off

# 모든 프로필 방화벽 켜기
netsh advfirewall set allprofiles state on
```

## #04. PowerShell을 이용한 고급 방화벽 관리

### 1) New-NetFirewallRule 사용

```powershell
# 기본 포트 허용
New-NetFirewallRule -DisplayName "Allow HTTP" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow

# 특정 프로그램 허용
New-NetFirewallRule -DisplayName "Allow MyApp" -Direction Inbound -Program "C:\MyApp\myapp.exe" -Action Allow

# 특정 IP 범위에서만 접근 허용
New-NetFirewallRule -DisplayName "Allow SSH from Local Network" -Direction Inbound -Protocol TCP -LocalPort 22 -RemoteAddress 192.168.1.0/24 -Action Allow

# 특정 서비스 포트 허용
New-NetFirewallRule -DisplayName "Allow HTTPS" -Direction Inbound -Protocol TCP -LocalPort 443 -Action Allow

# 여러 포트 동시 허용
New-NetFirewallRule -DisplayName "Allow Web Ports" -Direction Inbound -Protocol TCP -LocalPort 80,443,8080 -Action Allow
```

### 2) 방화벽 규칙 조회 및 관리

```powershell
# 모든 방화벽 규칙 확인
Get-NetFirewallRule

# 활성화된 규칙만 확인
Get-NetFirewallRule -Enabled True

# 특정 이름의 규칙 확인
Get-NetFirewallRule -DisplayName "*HTTP*"

# 포트 정보와 함께 규칙 확인
Get-NetFirewallRule | Get-NetFirewallPortFilter | Where LocalPort -eq 80

# 규칙 비활성화
Set-NetFirewallRule -DisplayName "Allow HTTP" -Enabled False

# 규칙 삭제
Remove-NetFirewallRule -DisplayName "Allow HTTP"
```

### 3) 고급 필터링 옵션

```powershell
# 특정 인터페이스에만 적용
New-NetFirewallRule -DisplayName "LAN Only" -Direction Inbound -Protocol TCP -LocalPort 3389 -InterfaceType Private

# 특정 시간대에만 허용 (Scheduled Task와 조합)
# 작업 스케줄러에서 시간별로 규칙 활성화/비활성화

# 로깅 설정
Set-NetFirewallProfile -Profile Domain,Public,Private -LogAllowed True -LogBlocked True -LogFileName "%SystemRoot%\System32\LogFiles\Firewall\pfirewall.log"
```

## #05. 일반적인 서비스 포트 설정

### 1) 웹 서버 포트

```powershell
# HTTP (포트 80)
New-NetFirewallRule -DisplayName "Allow HTTP" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow

# HTTPS (포트 443)
New-NetFirewallRule -DisplayName "Allow HTTPS" -Direction Inbound -Protocol TCP -LocalPort 443 -Action Allow

# Apache Tomcat (포트 8080)
New-NetFirewallRule -DisplayName "Allow Tomcat" -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Allow

# Node.js 개발 서버 (포트 3000)
New-NetFirewallRule -DisplayName "Allow Node.js" -Direction Inbound -Protocol TCP -LocalPort 3000 -Action Allow
```

### 2) 데이터베이스 포트

```powershell
# MySQL (포트 3306)
New-NetFirewallRule -DisplayName "Allow MySQL" -Direction Inbound -Protocol TCP -LocalPort 3306 -Action Allow

# PostgreSQL (포트 5432)
New-NetFirewallRule -DisplayName "Allow PostgreSQL" -Direction Inbound -Protocol TCP -LocalPort 5432 -Action Allow

# MongoDB (포트 27017)
New-NetFirewallRule -DisplayName "Allow MongoDB" -Direction Inbound -Protocol TCP -LocalPort 27017 -Action Allow

# Redis (포트 6379)
New-NetFirewallRule -DisplayName "Allow Redis" -Direction Inbound -Protocol TCP -LocalPort 6379 -Action Allow

# SQL Server (포트 1433)
New-NetFirewallRule -DisplayName "Allow SQL Server" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow
```

### 3) 원격 관리 포트

```powershell
# RDP (포트 3389)
New-NetFirewallRule -DisplayName "Allow RDP" -Direction Inbound -Protocol TCP -LocalPort 3389 -Action Allow

# SSH (포트 22)
New-NetFirewallRule -DisplayName "Allow SSH" -Direction Inbound -Protocol TCP -LocalPort 22 -Action Allow

# VNC (포트 5900)
New-NetFirewallRule -DisplayName "Allow VNC" -Direction Inbound -Protocol TCP -LocalPort 5900 -Action Allow

# WinRM (포트 5985, 5986)
New-NetFirewallRule -DisplayName "Allow WinRM HTTP" -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow
New-NetFirewallRule -DisplayName "Allow WinRM HTTPS" -Direction Inbound -Protocol TCP -LocalPort 5986 -Action Allow
```

## #06. 보안 강화 설정

### 1) IP 주소 기반 접근 제어

```powershell
# 특정 IP에서만 접근 허용
New-NetFirewallRule -DisplayName "MySQL Local Access Only" -Direction Inbound -Protocol TCP -LocalPort 3306 -RemoteAddress 192.168.1.0/24 -Action Allow

# 특정 IP 차단
New-NetFirewallRule -DisplayName "Block Suspicious IP" -Direction Inbound -RemoteAddress 203.0.113.0/24 -Action Block

# 루프백만 허용 (로컬 접속만)
New-NetFirewallRule -DisplayName "Redis Local Only" -Direction Inbound -Protocol TCP -LocalPort 6379 -RemoteAddress 127.0.0.1 -Action Allow
```

### 2) 애플리케이션 기반 필터링

```powershell
# 특정 프로그램만 허용
New-NetFirewallRule -DisplayName "Allow Chrome" -Direction Outbound -Program "C:\Program Files\Google\Chrome\Application\chrome.exe" -Action Allow

# 디지털 서명 확인
New-NetFirewallRule -DisplayName "Signed Apps Only" -Direction Inbound -Program "C:\MyApp\myapp.exe" -Authentication Required -Action Allow
```

### 3) 로깅 및 모니터링

```powershell
# 방화벽 로그 활성화
Set-NetFirewallProfile -All -LogAllowed True -LogBlocked True -LogIgnored True

# 로그 파일 경로 설정
Set-NetFirewallProfile -All -LogFileName "C:\Windows\System32\LogFiles\Firewall\pfirewall.log"

# 로그 크기 제한 설정
Set-NetFirewallProfile -All -LogMaxSizeKilobytes 10240
```

## #07. 문제 해결 및 진단

### 1) 연결 테스트

```cmd
# 포트 연결 테스트
telnet localhost 8080
telnet 192.168.1.100 3306

# PowerShell을 이용한 포트 테스트
Test-NetConnection -ComputerName localhost -Port 8080
Test-NetConnection -ComputerName 192.168.1.100 -Port 3306 -InformationLevel Detailed

# 네트워크 연결 상태 확인
netstat -an | findstr :8080
netstat -an | findstr :3306
```

### 2) 방화벽 로그 분석

```powershell
# 방화벽 로그 실시간 모니터링
Get-Content "C:\Windows\System32\LogFiles\Firewall\pfirewall.log" -Wait -Tail 10

# 차단된 연결 확인
Get-Content "C:\Windows\System32\LogFiles\Firewall\pfirewall.log" | Where-Object {$_ -match "DROP"}

# 특정 포트 관련 로그 확인
Get-Content "C:\Windows\System32\LogFiles\Firewall\pfirewall.log" | Where-Object {$_ -match "8080"}
```

### 3) 일반적인 문제 해결

```powershell
# 1. 방화벽 상태 확인
Get-NetFirewallProfile

# 2. 기본 방화벽 정책 확인
Get-NetFirewallProfile | Select Name, DefaultInboundAction, DefaultOutboundAction

# 3. 충돌하는 규칙 확인
Get-NetFirewallRule | Where-Object {$_.LocalPort -eq 8080}

# 4. Windows Defender 방화벽 서비스 상태 확인
Get-Service -Name mpssvc

# 5. 방화벽 서비스 재시작
Restart-Service -Name mpssvc
```

## #08. 자동화 스크립트

### 1) 개발 환경 방화벽 설정 스크립트

```powershell
# 개발 서버용 포트 일괄 허용 스크립트
$DevelopmentPorts = @(
    @{Name="HTTP"; Port=80; Protocol="TCP"},
    @{Name="HTTPS"; Port=443; Protocol="TCP"},
    @{Name="Tomcat"; Port=8080; Protocol="TCP"},
    @{Name="Node.js"; Port=3000; Protocol="TCP"},
    @{Name="React Dev"; Port=3000; Protocol="TCP"},
    @{Name="Vue Dev"; Port=8080; Protocol="TCP"},
    @{Name="MySQL"; Port=3306; Protocol="TCP"},
    @{Name="PostgreSQL"; Port=5432; Protocol="TCP"},
    @{Name="MongoDB"; Port=27017; Protocol="TCP"}
)

foreach ($port in $DevelopmentPorts) {
    $ruleName = "Allow $($port.Name)"

    # 기존 규칙 삭제
    Remove-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue

    # 새 규칙 생성
    New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Protocol $port.Protocol -LocalPort $port.Port -Action Allow

    Write-Host "포트 $($port.Port) ($($port.Name)) 허용 완료" -ForegroundColor Green
}
```

### 2) 방화벽 백업 및 복원 스크립트

```powershell
# 방화벽 규칙 백업
$BackupPath = "C:\Backup\Firewall_$(Get-Date -Format 'yyyyMMdd_HHmmss').wfw"
netsh advfirewall export $BackupPath
Write-Host "방화벽 규칙이 $BackupPath 에 백업되었습니다."

# 방화벽 규칙 복원
# netsh advfirewall import "C:\Backup\Firewall_20241201_143022.wfw"
```

이제 Windows 방화벽 설정에 대한 포괄적인 가이드가 완성되었습니다. 기본적인 GUI 설정부터 고급 명령줄 관리, PowerShell 활용, 보안 강화, 문제 해결까지 실무에서 필요한 모든 내용을 포함했습니다.