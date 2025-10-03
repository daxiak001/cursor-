@echo off
:: Universal Setup Tools Script
:: Compatible with all Windows systems and encoding environments
:: No Chinese characters - English only for maximum compatibility

:: Set UTF-8 code page for better character support
chcp 65001 >nul 2>&1
title Universal Setup Tools - winget and PowerShell 7

echo =====================================================
echo    Universal Setup Tools - winget and PowerShell 7
echo =====================================================
echo.

:: Use safe English paths only
set "SETUP_DIR=%USERPROFILE%\Desktop\setup_tools"
set "WINGET_URL=https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

:: Create setup directory on Desktop (always accessible)
if not exist "%SETUP_DIR%" (
    mkdir "%SETUP_DIR%"
    echo Created setup directory: %SETUP_DIR%
    echo.
)

:: Change to setup directory to avoid path issues
cd /d "%SETUP_DIR%"
echo Working directory: %CD%
echo.

:: Check winget status
echo [Step 1] Checking winget installation status...
winget --version >nul 2>&1
if %errorlevel% equ 0 (
    echo SUCCESS: winget is already installed!
    for /f "tokens=*" %%i in ('winget --version 2^>nul') do set WINGET_VER=%%i
    echo Version: %WINGET_VER%
    goto :check_powershell7
) else (
    echo INFO: winget not found
)

echo.
echo [Step 1.1] winget Installation Options:
echo.
echo Option A: Microsoft Store (Recommended)
echo   1. Open Microsoft Store
echo   2. Search for "App Installer"  
echo   3. Click Install
echo.
echo Option B: Manual Download
echo   Download: Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
echo   From: https://github.com/microsoft/winget-cli/releases/latest
echo.

:: Open installation pages
echo Opening Microsoft Store and GitHub pages...
start "" "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"
start "" "https://github.com/microsoft/winget-cli/releases/latest"

echo.
echo Please install winget first, then run this script again.
echo.
pause
exit /b 1

:check_powershell7
echo.
echo [Step 2] Checking PowerShell 7 installation status...

:: Check if PowerShell 7 is installed
if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" (
    echo SUCCESS: PowerShell 7 is already installed!
    for /f "tokens=*" %%i in ('"%ProgramFiles%\PowerShell\7\pwsh.exe" -Command "$PSVersionTable.PSVersion.ToString()" 2^>nul') do set PS7_VER=%%i
    echo Version: %PS7_VER%
    goto :all_installed
) else (
    echo INFO: PowerShell 7 not found
)

echo.
echo [Step 2.1] Installing PowerShell 7 using winget...
winget install Microsoft.PowerShell --accept-package-agreements --accept-source-agreements
if %errorlevel% equ 0 (
    echo SUCCESS: PowerShell 7 installed!
) else (
    echo ERROR: Installation failed. Please try manual installation:
    echo   https://github.com/PowerShell/PowerShell/releases/latest
    start "" "https://github.com/PowerShell/PowerShell/releases/latest"
)

:all_installed
echo.
echo =====================================================
echo    Installation Summary
echo =====================================================
echo.

:: Final verification
winget --version >nul 2>&1
if %errorlevel% equ 0 (
    echo SUCCESS: winget is available
) else (
    echo ERROR: winget is not available
)

if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" (
    echo SUCCESS: PowerShell 7 is available
    echo.
    echo Usage commands:
    echo   winget search ^<package^>     # Search packages
    echo   winget install ^<package^>    # Install packages  
    echo   winget list                  # List installed packages
    echo   pwsh                         # Start PowerShell 7
) else (
    echo ERROR: PowerShell 7 is not available
)

echo.
echo Setup directory: %SETUP_DIR%
echo You can delete this directory after installation.
echo.
pause

