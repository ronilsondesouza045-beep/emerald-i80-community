@echo off
setlocal EnableExtensions
title Emerald i80 - Jogar

set "REALM_HOST=127.0.0.1"
set "WOW_DIR="

echo ========================================
echo          EMERALD I80 - JOGAR
echo ========================================

echo.
echo Endereco atual: %REALM_HOST%
echo.
set /p "NOVO_HOST=Digite o IP ou dominio do servidor (ENTER para manter): "

if defined NOVO_HOST set "REALM_HOST=%NOVO_HOST%"

echo(%REALM_HOST%|findstr /R "^[a-zA-Z0-9][a-zA-Z0-9.-]*$" >nul
if errorlevel 1 (
    echo ERRO: endereco invalido.
    pause
    exit /b 1
)

if exist "D:\WOW335_MOBILE_READY\WOW335\Wow.exe" (
    set "WOW_DIR=D:\WOW335_MOBILE_READY\WOW335"
)

if not defined WOW_DIR if exist "%~dp0Wow.exe" (
    set "WOW_DIR=%~dp0"
)

if not defined WOW_DIR (
    echo Informe a pasta do WoW:
    set /p "WOW_DIR=Pasta: "
)

if not exist "%WOW_DIR%\Wow.exe" (
    echo ERRO: Wow.exe nao encontrado.
    pause
    exit /b 2
)

set "REALMLIST=%WOW_DIR%\Data\enUS\realmlist.wtf"

if exist "%WOW_DIR%\Data\ptBR\realmlist.wtf" (
    set "REALMLIST=%WOW_DIR%\Data\ptBR\realmlist.wtf"
)

if not exist "%REALMLIST%" (
    set "REALMLIST=%WOW_DIR%\realmlist.wtf"
)

if exist "%REALMLIST%" (
    set "BACKUP=%REALMLIST%.backup_%RANDOM%_%RANDOM%"
    copy "%REALMLIST%" "%BACKUP%" >nul
    if errorlevel 1 (
        echo ERRO: nao foi possivel criar o backup.
        pause
        exit /b 3
    )
)

> "%REALMLIST%" echo set realmlist %REALM_HOST%
if errorlevel 1 (
    echo ERRO: nao foi possivel atualizar o realmlist.
    pause
    exit /b 4
)

echo.
echo Realmlist configurado para %REALM_HOST%
echo Abrindo World of Warcraft...

start "" /D "%WOW_DIR%" "%WOW_DIR%\Wow.exe"

endlocal
