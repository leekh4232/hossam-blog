@echo off
REM ==========================================
REM Jekyll ȯ�� ���� ��ũ��Ʈ ���� ��ġ����
REM ==========================================

REM ���� ��ũ��Ʈ ��θ� ������� PowerShell ��ũ��Ʈ ��� ����
set SCRIPT_DIR=%~dp0
set PS_SCRIPT=%SCRIPT_DIR%win-setup.ps1

REM PowerShell ���� ��å�� �ӽ÷� Bypass �Ͽ� ����
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%"

pause
