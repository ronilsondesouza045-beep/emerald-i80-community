@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Emerald i80 - Servidor online pelo Tailscale
cd /d "%~dp0"

if not exist "%CD%\configuracao-servidor.cmd" (
  echo ERRO: configuracao-servidor.cmd nao encontrado.
  echo Copie configuracao-servidor.exemplo.cmd para configuracao-servidor.cmd,
  echo edite a senha local do MySQL e execute novamente.
  pause
  exit /b 2
)
call "%CD%\configuracao-servidor.cmd"

set "MYSQL_EXE=%CD%\_Server\mysql\bin\mysql.exe"
set "MYSQLD_EXE=%CD%\_Server\mysql\bin\mysqld.exe"
set "MYSQL_CNF=%CD%\_Server\mysql\bin\my.cnf"
set "MYSQLDUMP_EXE=%CD%\_Server\mysql\bin\mysqldump.exe"
set "TAILSCALE_EXE=C:\Program Files\Tailscale\tailscale.exe"

for %%F in ("%MYSQL_EXE%" "%MYSQLD_EXE%" "%MYSQLDUMP_EXE%" "%CD%\authserver.exe" "%CD%\worldserver.exe") do if not exist "%%~F" (
  echo ERRO: %%~F nao encontrado. Coloque o kit na raiz do repack.
  pause
  exit /b 3
)
if not exist "%TAILSCALE_EXE%" (
  start "" "https://tailscale.com/download/windows"
  echo Instale e conecte o Tailscale antes de continuar.
  pause
  exit /b 4
)

for /f "usebackq delims=" %%I in (`"%TAILSCALE_EXE%" ip -4 2^>nul`) do if not defined TS_IP set "TS_IP=%%I"
if not defined TS_IP (
  echo ERRO: o Tailscale nao esta conectado.
  pause
  exit /b 5
)

echo Tailscale conectado em !TS_IP!.
start "Emerald MySQL" /min "%MYSQLD_EXE%" --defaults-file="%MYSQL_CNF%" --standalone --console
set /a WAITED=0
:wait_mysql
"%MYSQL_EXE%" --host="%DB_HOST%" --port="%DB_PORT%" --user="%DB_USER%" --password="%DB_PASSWORD%" --execute="SELECT 1" >nul 2>&1
if not errorlevel 1 goto mysql_ready
set /a WAITED+=1
if !WAITED! GEQ 30 (
  echo ERRO: MySQL nao respondeu em 30 segundos.
  pause
  exit /b 6
)
timeout /t 1 /nobreak >nul
goto wait_mysql

:mysql_ready
if not exist "%CD%\BACKUPS_AUTOMATICOS" mkdir "%CD%\BACKUPS_AUTOMATICOS"
for /f "tokens=1-6 delims=/:. " %%a in ("%date% %time%") do set "STAMP=%%c%%b%%a_%%d%%e%%f"
"%MYSQLDUMP_EXE%" --host="%DB_HOST%" --port="%DB_PORT%" --user="%DB_USER%" --password="%DB_PASSWORD%" --databases "%DB_AUTH%" --result-file="%CD%\BACKUPS_AUTOMATICOS\auth_!STAMP!.sql"
if errorlevel 1 (
  echo ERRO: o backup falhou; nenhuma configuracao foi alterada.
  pause
  exit /b 7
)

"%MYSQL_EXE%" --host="%DB_HOST%" --port="%DB_PORT%" --user="%DB_USER%" --password="%DB_PASSWORD%" --database="%DB_AUTH%" --execute="UPDATE realmlist SET address='!TS_IP!', localAddress='127.0.0.1', localSubnetMask='255.255.255.0', port=%WORLD_PORT% WHERE id=%REALM_ID%;"
if errorlevel 1 (
  echo ERRO: nao foi possivel atualizar auth.realmlist.
  pause
  exit /b 8
)

>"%CD%\REALMLIST_PARA_JOGADORES.txt" echo set realmlist !TS_IP!
start "Emerald AuthServer" /min "%CD%\authserver.exe"
timeout /t 4 /nobreak >nul
start "Emerald WorldServer" "%CD%\worldserver.exe"
echo.
echo SERVIDOR INICIADO - set realmlist !TS_IP!
echo O MySQL nunca foi exposto; o jogador acessa somente pela rede Tailscale.
start "" "https://login.tailscale.com/admin/machines"
pause
