@echo off
setlocal
cd /d "%~dp0"
title Gerar Pacote do Cliente - MR Rob Run

echo ======================================================
echo   GERANDO PACOTE DO CLIENTE (MR_RobRun_Client.zip)
echo   Origem: CHEEKOS_CLIENT
echo   Destino: public\MR_RobRun_Client.zip
echo ======================================================
echo.

if not exist "public" mkdir "public"

powershell -NoProfile -ExecutionPolicy Bypass -Command "Write-Host 'Compactando CHEEKOS_CLIENT...'; Compress-Archive -Path '.\CHEEKOS_CLIENT\*' -DestinationPath '.\public\MR_RobRun_Client.zip' -Force; Write-Host 'Concluido!'"

if errorlevel 1 (
    echo [ERRO] Falha ao compactar pacote.
    pause
    exit /b 1
)

echo.
echo ======================================================
echo   Pacote public\MR_RobRun_Client.zip gerado com sucesso!
echo   Pronto para download no site e envio pelo bot.
echo ======================================================
echo.
pause
