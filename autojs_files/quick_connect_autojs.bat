@echo off
:: Quick AutoJS Emulator Connection Script
chcp 65001 >nul 2>&1
title AutoJS Quick Connect

echo =====================================================
echo    AutoJS Emulator Quick Connect
echo =====================================================
echo.

:: Common emulator ADB ports
set LDPLAYER_PORT=5555
set NOX_PORT=62001
set BLUESTACKS_PORT=5037

echo Step 1: Checking ADB availability...
adb version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: ADB not found in PATH
    echo Please run setup_autojs_environment.ps1 first
    pause
    exit /b 1
)
echo SUCCESS: ADB is available

echo.
echo Step 2: Current connected devices...
adb devices
echo.

echo Step 3: Attempting to connect to common emulator ports...

echo Trying LDPlayer (127.0.0.1:%LDPLAYER_PORT%)...
adb connect 127.0.0.1:%LDPLAYER_PORT% >nul 2>&1
if %errorlevel% equ 0 (
    echo SUCCESS: Connected to LDPlayer
    goto :connected
)

echo Trying Nox Player (127.0.0.1:%NOX_PORT%)...
adb connect 127.0.0.1:%NOX_PORT% >nul 2>&1
if %errorlevel% equ 0 (
    echo SUCCESS: Connected to Nox Player
    goto :connected
)

echo Trying BlueStacks (127.0.0.1:%BLUESTACKS_PORT%)...
adb connect 127.0.0.1:%BLUESTACKS_PORT% >nul 2>&1
if %errorlevel% equ 0 (
    echo SUCCESS: Connected to BlueStacks
    goto :connected
)

echo INFO: No emulator found on common ports
echo.
echo Manual connection options:
echo   adb connect 127.0.0.1:5555   (LDPlayer)
echo   adb connect 127.0.0.1:62001  (Nox)
echo   adb connect 127.0.0.1:5037   (BlueStacks)
echo.
goto :end

:connected
echo.
echo Step 4: Verifying connection...
adb devices
echo.

echo Step 5: AutoJS readiness check...
echo Checking if AutoJS is installed...
adb shell pm list packages | findstr /i autojs >nul 2>&1
if %errorlevel% equ 0 (
    echo SUCCESS: AutoJS package found
) else (
    echo INFO: AutoJS not found, install with:
    echo   adb install autojs.apk
)

echo.
echo AutoJS connection ready!
echo You can now:
echo 1. Start AutoJS app on emulator
echo 2. Enable accessibility service
echo 3. Connect to desktop IDE or run scripts

:end
echo.
pause
