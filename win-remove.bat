@echo off
cls
set SCRIPT_DIR=%~dp0
set PS_SCRIPT=%SCRIPT_DIR%win-remove.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%"
pause
