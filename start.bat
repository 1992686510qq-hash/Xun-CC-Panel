@echo off
title Xun-CC-Panel
cd /d "C:\Users\Administrator\Claude-Code\cc-tools\Xun-CC-Panel"
echo ============================================
echo       Xun-CC-Panel Launcher
echo ============================================
echo.

:: Check if port 5022 is already in use
netstat -ano | findstr :5022 | findstr LISTENING >nul 2>&1
if %errorlevel%==0 (
    echo [OK] Panel is already running!
    echo [OK] Opening browser...
    start http://localhost:5022
    echo.
    echo Press any key to close this window...
    pause >nul
    exit
)

:: Start server
echo [1/3] Starting server...
start "Xun-CC-Panel-Server" /min node server.js

:: Wait for server ready
echo [2/3] Waiting for server...
:WAIT_LOOP
timeout /t 1 /nobreak >nul
curl -s -o nul -w "%%{http_code}" http://localhost:5022 2>nul | findstr "200" >nul
if %errorlevel% neq 0 goto WAIT_LOOP
echo [OK] Server is ready!

:: Start watchdog
echo [3/3] Starting watchdog...
start "Xun-CC-Watchdog" /min node watchdog.js

:: Open browser
echo.
echo ============================================
echo   Panel started! Opening browser...
echo   URL: http://localhost:5022
echo ============================================
start http://localhost:5022
echo.
echo Press any key to close this window...
pause >nul
