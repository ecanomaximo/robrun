@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"
title CHEEKOS - map the driver

set "BADHASH=EC3A09682C300747DC3029C4BACA5728B01403B20E2193A802BF80DBB14166AA"

echo.
echo ============================================================
echo   CHEEKOS - map the kernel driver
echo ============================================================
echo.

if not exist "kd2.exe" (
    echo [ERROR] kd2.exe is missing from this folder.
    pause
    exit /b 1
)
if not exist "kernel-mode.sys" (
    echo [ERROR] kernel-mode.sys is missing from this folder.
    pause
    exit /b 1
)

for /f %%H in ('powershell -NoProfile -Command "(Get-FileHash -Algorithm SHA256 -LiteralPath 'kernel-mode.sys').Hash"') do set "HASH=%%H"
if not defined HASH (
    echo [STOP] Could not hash kernel-mode.sys.
    pause
    exit /b 1
)
if /I "!HASH!"=="%BADHASH%" (
    echo [STOP] This is the driver image tied to a known crash. Get a good copy.
    pause
    exit /b 1
)

for %%A in (kernel-mode.sys) do (
    echo image : kernel-mode.sys
    echo size  : %%~zA bytes
)
echo SHA256: !HASH!
echo.
echo Mapping now - accept the administrator prompt.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "try { $p = Start-Process -FilePath '.\kd2.exe' -ArgumentList '.\kernel-mode.sys' -WorkingDirectory (Get-Location) -Verb RunAs -PassThru -Wait; exit $p.ExitCode } catch { exit 9 }"
set "RC=%ERRORLEVEL%"
echo.
echo kd2.exe exit code: %RC%   (0 = mapped)
echo.
echo If it did not map: reboot, turn Memory Integrity / Core Isolation OFF,
echo then run this script once. A second run in the same session usually fails
echo because the image is already resident - that is not an error.
echo.
echo Next: start the game, then run START.bat.
pause
endlocal