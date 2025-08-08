@echo off
REM ==========================================
REM Jekyll 환경 구축 스크립트 실행 배치파일
REM ==========================================

REM 현재 스크립트 경로를 기반으로 PowerShell 스크립트 경로 설정
set SCRIPT_DIR=%~dp0
set PS_SCRIPT=%SCRIPT_DIR%win-setup.ps1

REM PowerShell 실행 정책을 임시로 Bypass 하여 실행
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%"

pause
