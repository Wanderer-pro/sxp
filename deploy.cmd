@echo off
chcp 65001 >nul
rem 双击本文件即可运行 deploy.ps1（绕过 PowerShell 脚本执行策略限制）
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0deploy.ps1" %*
echo.
pause
