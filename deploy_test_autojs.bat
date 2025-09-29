@echo off
:: Deploy and Test AutoJS Script
chcp 65001 >nul 2>&1
title AutoJS Deploy and Test

echo =====================================================
echo    AutoJS Script Deploy and Test
echo =====================================================
echo.

set ADB_PATH=C:\Users\Administrator\AutoJS_Setup\platform-tools\adb.exe
set SCRIPT_FILE=test_autojs_connection.js
set TARGET_PATH=/sdcard/Scripts/

echo Step 1: Checking ADB connection...
"%ADB_PATH%" devices
if %errorlevel% neq 0 (
    echo ERROR: ADB connection failed
    pause
    exit /b 1
)
echo SUCCESS: ADB connected

echo.
echo Step 2: Creating target directory on device...
"%ADB_PATH%" shell mkdir -p %TARGET_PATH%
echo SUCCESS: Directory created

echo.
echo Step 3: Deploying test script...
if not exist "%SCRIPT_FILE%" (
    echo ERROR: Script file %SCRIPT_FILE% not found
    pause
    exit /b 1
)

"%ADB_PATH%" push "%SCRIPT_FILE%" "%TARGET_PATH%%SCRIPT_FILE%"
if %errorlevel% equ 0 (
    echo SUCCESS: Script deployed to %TARGET_PATH%%SCRIPT_FILE%
) else (
    echo ERROR: Script deployment failed
    pause
    exit /b 1
)

echo.
echo Step 4: Verifying deployment...
"%ADB_PATH%" shell ls -la %TARGET_PATH%
echo.

echo Step 5: AutoJS status check...
echo Checking if AutoJS is running...
"%ADB_PATH%" shell ps | findstr autojs
if %errorlevel% equ 0 (
    echo SUCCESS: AutoJS process found
) else (
    echo INFO: AutoJS may not be running
    echo Please start AutoJS app manually
)

echo.
echo Step 6: Manual test instructions...
echo =====================================================
echo To test the connection:
echo.
echo 1. Open AutoJS app on the emulator
echo 2. Navigate to /sdcard/Scripts/
echo 3. Run test_autojs_connection.js
echo 4. Check console output and floating window
echo.
echo Alternative - Run from ADB:
echo %ADB_PATH% shell am start -n org.autojs.autojs/.ui.main.MainActivity
echo.
echo Script location on device: %TARGET_PATH%%SCRIPT_FILE%
echo =====================================================
echo.

echo AutoJS deployment completed!
pause
