@echo off
setlocal
cd /d "%~dp0"
title MR - Rob Run

if not exist "RRX.exe" (
    echo [ERROR] RRX.exe is missing from this folder.
    pause
    exit /b 1
)

rem Rotacao automatica de logs se passarem de 5MB
for %%F in (*.log) do (
    if %%~zF gtr 5242880 (
        echo [INFO] Limpando log volumoso: %%F
        type nul > "%%F"
    )
)

rem Verificacao e Ativacao da Licenca (Key)
if exist "activate.ps1" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0activate.ps1"
    if errorlevel 1 (
        echo [STOP] Acesso negado. Ativacao necessaria para continuar.
        pause
        exit /b 1
    )
)

rem The driver publishes HKLM\SYSTEM\SmxRing when it is mapped; the overlay
rem reads its session token from that key, so a missing key is a real failure.
reg query "HKLM\SYSTEM\SmxRing" >nul 2>&1
if errorlevel 1 (
    echo [WARN] The driver is not mapped on this PC yet.
    echo        Close this, run MAP-DRIVER.bat as administrator, then start again.
    echo.
)

tasklist /FI "IMAGENAME eq ROB RUN.exe" 2>nul | find /I "ROB RUN.exe" >nul
if errorlevel 1 (
    echo [WARN] ROB RUN.exe is not running - the overlay shows "waiting for game".
    echo.
)

echo Starting MR (administrator prompt follows)...
start "MR" "%~dp0RRX.exe"
ping -n 3 127.0.0.1 >nul
echo.
echo Ctrl+F1 = menu    Ctrl+Insert = overlay on/off    Ctrl+End = quit
echo The overlay closes by itself when the game closes.
exit /b 0
