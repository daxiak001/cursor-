@echo off
chcp 65001 >nul 2>&1
title winget Installation Helper

echo =====================================================
echo    winget Installation Helper
echo =====================================================
echo.

:: Use English paths to avoid encoding issues
set "DOWNLOAD_DIR=%USERPROFILE%\Downloads\winget_setup"
set "WINGET_URL=https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
set "WINGET_FILE=%DOWNLOAD_DIR%\winget_installer.msixbundle"

:: Create download directory
if not exist "%DOWNLOAD_DIR%" (
    mkdir "%DOWNLOAD_DIR%"
    echo Created directory: %DOWNLOAD_DIR%
    echo.
)

:: Check if winget is already installed
echo Checking winget installation...
winget --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ winget is already installed!
    winget --version
    echo.
    echo You can now install PowerShell 7 with:
    echo winget install Microsoft.PowerShell
    pause
    exit /b 0
)

echo ✗ winget not found, need to install
echo.

echo =====================================================
echo Installation Options
echo =====================================================
echo.
echo Option 1: Microsoft Store (Recommended)
echo 1. Open Microsoft Store
echo 2. Search for "App Installer"
echo 3. Click Install
echo.
echo Option 2: Manual Download
echo Download: Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
echo From: https://github.com/microsoft/winget-cli/releases/latest
echo.
echo Opening relevant pages...

:: Open Microsoft Store
start ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1

:: Open GitHub releases
start https://github.com/microsoft/winget-cli/releases/latest

echo.
echo =====================================================
echo After Installation
echo =====================================================
echo.
echo 1. Restart this script to verify winget installation
echo 2. Install PowerShell 7 with: winget install Microsoft.PowerShell
echo 3. Verify PowerShell 7 with: pwsh --version
echo.
echo Note: If winget command is not recognized after installation,
echo please restart your computer.
echo.
pause
