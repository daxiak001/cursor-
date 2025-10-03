@echo off
:: Non-interactive Universal Setup Tools Script
:: No pause commands - runs completely automated

:: Set UTF-8 code page for better character support
chcp 65001 >nul 2>&1
title Universal Setup Tools - Automated Version

echo =====================================================
echo    Universal Setup Tools - Automated Version
echo =====================================================
echo.

:: Use safe English paths only
set "SETUP_DIR=%USERPROFILE%\Desktop\setup_tools"

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
    echo.
    echo To install winget, you can:
    echo 1. Open Microsoft Store and search for "App Installer"
    echo 2. Or visit: https://github.com/microsoft/winget-cli/releases/latest
    echo.
    echo After installing winget, run this script again.
    goto :end_script
)

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
    echo ERROR: Installation failed
    echo Manual installation: https://github.com/PowerShell/PowerShell/releases/latest
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
    for /f "tokens=*" %%i in ('winget --version 2^>nul') do echo Version: %%i
) else (
    echo INFO: winget is not available
)

if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" (
    echo SUCCESS: PowerShell 7 is available
    for /f "tokens=*" %%i in ('"%ProgramFiles%\PowerShell\7\pwsh.exe" -Command "$PSVersionTable.PSVersion.ToString()" 2^>nul') do echo Version: %%i
    echo.
    echo Usage commands:
    echo   winget search ^<package^>     # Search packages
    echo   winget install ^<package^>    # Install packages  
    echo   winget list                  # List installed packages
    echo   pwsh                         # Start PowerShell 7
) else (
    echo INFO: PowerShell 7 is not available
)

:end_script
echo.
echo Setup directory: %SETUP_DIR%
echo Script completed! No user interaction required.
echo.
