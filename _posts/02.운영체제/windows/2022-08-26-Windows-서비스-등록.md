---
title:  "Windows 서비스 등록"
description: 수동으로 설치한 프로그램들이 윈도우 부팅시에 자동으로 구동되도록 명령프롬프트 상에서 윈도우에 서비스를 등록하는 명령어들 정리.
categories: [02.Operating System,Windows]
date:   2022-08-26 18:26:00 +0900
author: Hossam
image: /images/indexs/computing.png
tags: [컴퓨터활용,Operating System,Windows]
pin: true
math: true
mermaid: true
---

## #01. `sc`명령 사용

### 1) 서비스 등록하기

```powershell
sc create 서비스이름 binpath=실행파일경로
```

### 2) 서비스 해제하기

```powershell
sc delete 서비스이름
```

## #02. 자체적인 명령어를 사용하는 경우

### 1) 아파치 웹 서버 서비스 등록하기

아파치 설치 디렉토리 내의 bin 폴더에서 수행

```powershell
httpd.exe -k install
```

### 2) MySQL 서비스 등록하기

MySQL 설치 디렉토리 내의 bin 폴더에서 수행

```powershell
mysqld --install
```

## #03. sc 명령어 고급 사용법

### 1) 서비스 등록 시 상세 옵션 설정

```powershell
# 기본 서비스 등록
sc create MyService binpath="C:\MyApp\myapp.exe"

# 자동 시작 서비스 등록
sc create MyService binpath="C:\MyApp\myapp.exe" start=auto

# 지연 자동 시작 설정
sc create MyService binpath="C:\MyApp\myapp.exe" start=delayed-auto

# 서비스 설명 추가
sc description MyService "My Custom Application Service"

# 실행 계정 설정
sc create MyService binpath="C:\MyApp\myapp.exe" obj=".\MyUser" password="MyPassword"

# 의존성 설정 (다른 서비스가 먼저 시작되어야 함)
sc create MyService binpath="C:\MyApp\myapp.exe" depend="Tcpip/RpcSs"
```

### 2) 서비스 시작 타입 설정

| 시작 타입 | 설명 |
|-----------|------|
| `auto` | 자동 시작 (부팅 시 자동 실행) |
| `delayed-auto` | 지연된 자동 시작 (다른 서비스 시작 후 실행) |
| `demand` | 수동 시작 (필요시에만 실행) |
| `disabled` | 비활성화 (시작 불가) |

```powershell
# 시작 타입 변경
sc config MyService start=auto
sc config MyService start=demand
sc config MyService start=disabled
```

### 3) 서비스 제어 명령어

```powershell
# 서비스 시작
sc start MyService

# 서비스 중지
sc stop MyService

# 서비스 일시정지
sc pause MyService

# 서비스 재개
sc continue MyService

# 서비스 상태 확인
sc query MyService

# 모든 서비스 상태 확인
sc query state=all

# 실행 중인 서비스만 확인
sc query state=running
```

### 4) 서비스 설정 변경

```powershell
# 서비스 설명 변경
sc description MyService "새로운 서비스 설명"

# 실행 파일 경로 변경
sc config MyService binpath="C:\NewPath\myapp.exe"

# 실행 계정 변경
sc config MyService obj=".\NewUser" password="NewPassword"

# 로컬 시스템 계정으로 변경
sc config MyService obj="LocalSystem"

# 네트워크 서비스 계정으로 변경
sc config MyService obj="NT AUTHORITY\NetworkService"
```

## #04. PowerShell을 이용한 서비스 관리

### 1) PowerShell 서비스 명령어

```powershell
# 서비스 목록 확인
Get-Service

# 특정 서비스 확인
Get-Service -Name "MyService"

# 서비스 이름으로 검색
Get-Service -Name "*apache*"

# 서비스 시작
Start-Service -Name "MyService"

# 서비스 중지
Stop-Service -Name "MyService"

# 서비스 재시작
Restart-Service -Name "MyService"

# 서비스 일시정지
Suspend-Service -Name "MyService"

# 서비스 재개
Resume-Service -Name "MyService"
```

### 2) 서비스 속성 확인 및 변경

```powershell
# 서비스 상세 정보 확인
Get-Service -Name "MyService" | Format-List *

# WMI를 이용한 서비스 정보 확인
Get-WmiObject -Class Win32_Service -Filter "Name='MyService'"

# 서비스 시작 모드 변경
Set-Service -Name "MyService" -StartupType Automatic
Set-Service -Name "MyService" -StartupType Manual
Set-Service -Name "MyService" -StartupType Disabled

# 서비스 설명 변경
Set-Service -Name "MyService" -Description "새로운 설명"
```

### 3) 서비스 모니터링 스크립트

```powershell
# 서비스 상태 모니터링 스크립트
$services = @("MyService1", "MyService2", "Apache")

foreach ($service in $services) {
    $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($svc) {
        Write-Host "$service : $($svc.Status)" -ForegroundColor $(
            if ($svc.Status -eq "Running") { "Green" } else { "Red" }
        )

        # 중지된 서비스 자동 시작
        if ($svc.Status -eq "Stopped" -and $svc.StartType -eq "Automatic") {
            Start-Service -Name $service
            Write-Host "  -> $service 서비스를 시작했습니다." -ForegroundColor Yellow
        }
    } else {
        Write-Host "$service : 서비스를 찾을 수 없습니다." -ForegroundColor Red
    }
}
```

## #05. 웹 서버 및 데이터베이스 서비스 관리

### 1) Apache HTTP Server

```powershell
# Apache 서비스 설치 (Apache 설치 디렉토리에서)
cd "C:\Apache24\bin"
httpd.exe -k install

# 서비스명 지정하여 설치
httpd.exe -k install -n "Apache2.4"

# 설정 파일 지정하여 설치
httpd.exe -k install -n "Apache2.4" -f "C:\Apache24\conf\httpd.conf"

# Apache 서비스 시작/중지
net start Apache2.4
net stop Apache2.4

# Apache 서비스 제거
httpd.exe -k uninstall
httpd.exe -k uninstall -n "Apache2.4"
```

### 2) Nginx

```powershell
# NSSM을 이용한 Nginx 서비스 등록
# 먼저 NSSM 다운로드: https://nssm.cc/download

# NSSM으로 서비스 등록
nssm install nginx "C:\nginx\nginx.exe"

# 작업 디렉토리 설정
nssm set nginx AppDirectory "C:\nginx"

# 자동 시작 설정
nssm set nginx Start SERVICE_AUTO_START

# 서비스 시작
nssm start nginx

# 서비스 제거
nssm remove nginx confirm
```

### 3) MySQL/MariaDB

```powershell
# MySQL 서비스 설치 (MySQL 설치 디렉토리에서)
cd "C:\MySQL\bin"
mysqld --install

# 서비스명 지정하여 설치
mysqld --install MySQL57

# 설정 파일 지정하여 설치
mysqld --install MySQL57 --defaults-file="C:\MySQL\my.ini"

# MySQL 서비스 시작/중지
net start MySQL57
net stop MySQL57

# MySQL 서비스 제거
mysqld --remove
mysqld --remove MySQL57
```

### 4) PostgreSQL

```powershell
# PostgreSQL 서비스 등록
pg_ctl register -N "PostgreSQL" -D "C:\PostgreSQL\data"

# 서비스 시작/중지
net start PostgreSQL
net stop PostgreSQL

# 서비스 해제
pg_ctl unregister -N "PostgreSQL"
```

## #06. 서비스 문제 해결

### 1) 일반적인 오류 해결

```powershell
# 서비스 오류 로그 확인
Get-EventLog -LogName System -Source "Service Control Manager" -Newest 10

# 특정 서비스 오류 확인
Get-EventLog -LogName System | Where-Object {$_.Source -eq "MyService"}

# 서비스 의존성 확인
sc qc MyService

# 서비스 실행 계정 권한 확인
whoami /priv
```

### 2) 서비스 시작 실패 시 대처법

```powershell
# 1. 실행 파일 경로 확인
sc qc MyService

# 2. 파일 접근 권한 확인
icacls "C:\MyApp\myapp.exe"

# 3. 서비스 로그온 계정 권한 추가
# "서비스로 로그온" 권한 부여: secpol.msc -> 로컬 정책 -> 사용자 권한 할당

# 4. 의존성 서비스 상태 확인
sc enumdepend MyService

# 5. 서비스 복구 옵션 설정
sc failure MyService reset=86400 actions=restart/5000/restart/5000/restart/5000
```

## #07. 서비스 보안 관리

### 1) 서비스 계정 보안

```powershell
# 최소 권한 계정으로 서비스 실행
sc config MyService obj="NT SERVICE\MyService"

# 가상 서비스 계정 사용 (Windows 7/2008 R2 이상)
sc config MyService obj="NT SERVICE\MyServiceName"

# 관리 서비스 계정 사용 (Windows 7/2008 R2 이상)
sc config MyService obj="NT SERVICE\MyService$"
```

### 2) 서비스 접근 제어

```powershell
# 서비스 접근 권한 설정 (SDDL 사용)
sc sdset MyService "D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)"

# 서비스 접근 권한 확인
sc sdshow MyService
```

## #08. 자동화 스크립트

### 1) 서비스 일괄 관리 스크립트

```powershell
# 서비스 일괄 설치 스크립트
$services = @(
    @{Name="MyApp1"; Path="C:\Apps\App1\app1.exe"; Desc="Application 1"},
    @{Name="MyApp2"; Path="C:\Apps\App2\app2.exe"; Desc="Application 2"}
)

foreach ($service in $services) {
    try {
        sc.exe create $service.Name binpath="`"$($service.Path)`"" start=auto
        sc.exe description $service.Name $service.Desc
        Write-Host "서비스 '$($service.Name)' 등록 완료" -ForegroundColor Green
    }
    catch {
        Write-Host "서비스 '$($service.Name)' 등록 실패: $($_.Exception.Message)" -ForegroundColor Red
    }
}
```

### 2) 서비스 상태 체크 및 알림

```powershell
# 서비스 모니터링 및 이메일 알림
$criticalServices = @("Apache2.4", "MySQL57", "MyApp")
$failedServices = @()

foreach ($service in $criticalServices) {
    $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
    if (-not $svc -or $svc.Status -ne "Running") {
        $failedServices += $service
    }
}

if ($failedServices.Count -gt 0) {
    $message = "다음 서비스들이 중지되었습니다: $($failedServices -join ', ')"
    # 이메일 발송 로직 추가
    Write-Warning $message
}
```

이제 Windows 서비스 등록에 대한 포괄적인 가이드가 완성되었습니다. 기본적인 서비스 등록부터 고급 관리, 보안 설정, 문제 해결까지 실무에서 필요한 모든 내용을 포함했습니다.