# AutoJS Environment Setup Script
# Automated setup for AutoJS with Android emulator

# Set UTF-8 encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=====================================================" -ForegroundColor Green
Write-Host "    AutoJS Environment Setup Script" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
Write-Host ""

# Configuration
$setupDir = "$env:USERPROFILE\AutoJS_Setup"
$adbDownloadUrl = "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
$adbZipFile = "$setupDir\platform-tools.zip"
$adbDir = "$setupDir\platform-tools"

# Create setup directory
if (-not (Test-Path $setupDir)) {
    New-Item -ItemType Directory -Path $setupDir -Force | Out-Null
    Write-Host "Created setup directory: $setupDir" -ForegroundColor Yellow
}

Write-Host "Setup directory: $setupDir" -ForegroundColor Yellow
Write-Host ""

# Step 1: Check if ADB is already installed
Write-Host "Step 1: Checking ADB installation..." -ForegroundColor Cyan
try {
    $adbVersion = & adb version 2>$null
    if ($adbVersion) {
        Write-Host "SUCCESS: ADB is already installed" -ForegroundColor Green
        Write-Host "Version: $($adbVersion[0])" -ForegroundColor White
        $adbInstalled = $true
    }
} catch {
    Write-Host "INFO: ADB not found, will download..." -ForegroundColor Yellow
    $adbInstalled = $false
}

# Step 2: Download and install ADB if needed
if (-not $adbInstalled) {
    Write-Host ""
    Write-Host "Step 2: Downloading ADB Platform Tools..." -ForegroundColor Cyan
    Write-Host "This may take a few minutes..." -ForegroundColor Gray
    
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $progressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $adbDownloadUrl -OutFile $adbZipFile -UseBasicParsing
        $progressPreference = 'Continue'
        
        Write-Host "SUCCESS: ADB downloaded" -ForegroundColor Green
        
        # Extract ADB
        if (Test-Path $adbDir) {
            Remove-Item -Path $adbDir -Recurse -Force
        }
        Expand-Archive -Path $adbZipFile -DestinationPath $setupDir -Force
        
        Write-Host "SUCCESS: ADB extracted to $adbDir" -ForegroundColor Green
        
        # Add to PATH temporarily
        $env:PATH += ";$adbDir"
        
        # Test ADB
        $adbVersion = & "$adbDir\adb.exe" version 2>$null
        if ($adbVersion) {
            Write-Host "SUCCESS: ADB installation verified" -ForegroundColor Green
            Write-Host "Version: $($adbVersion[0])" -ForegroundColor White
        }
        
    } catch {
        Write-Host "ERROR: ADB download failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Please manually download from: $adbDownloadUrl" -ForegroundColor Yellow
        return
    }
}

# Step 3: Check for emulators
Write-Host ""
Write-Host "Step 3: Checking for Android emulators..." -ForegroundColor Cyan

$emulators = @()
$commonEmulatorPaths = @(
    "${env:ProgramFiles}\LDPlayer\LDPlayer4.0\ldconsole.exe",
    "${env:ProgramFiles(x86)}\LDPlayer\LDPlayer4.0\ldconsole.exe",
    "${env:ProgramFiles}\Nox\bin\nox_adb.exe",
    "${env:ProgramFiles(x86)}\Nox\bin\nox_adb.exe",
    "${env:ProgramFiles}\BlueStacks\HD-Adb.exe",
    "${env:ProgramFiles(x86)}\BlueStacks\HD-Adb.exe"
)

foreach ($path in $commonEmulatorPaths) {
    if (Test-Path $path) {
        $emulatorName = Split-Path (Split-Path $path) -Leaf
        $emulators += @{Name = $emulatorName; Path = $path}
        Write-Host "FOUND: $emulatorName at $path" -ForegroundColor Green
    }
}

if ($emulators.Count -eq 0) {
    Write-Host "INFO: No common emulators found" -ForegroundColor Yellow
    Write-Host "Please install one of the following:" -ForegroundColor White
    Write-Host "- LDPlayer (recommended): https://www.ldplayer.net/" -ForegroundColor Cyan
    Write-Host "- Nox Player: https://www.bignox.com/" -ForegroundColor Cyan
    Write-Host "- BlueStacks: https://www.bluestacks.com/" -ForegroundColor Cyan
} else {
    Write-Host "Found $($emulators.Count) emulator(s)" -ForegroundColor Green
}

# Step 4: Check ADB connection
Write-Host ""
Write-Host "Step 4: Checking ADB connection..." -ForegroundColor Cyan

try {
    if ($adbInstalled) {
        $devices = & adb devices 2>$null
    } else {
        $devices = & "$adbDir\adb.exe" devices 2>$null
    }
    
    if ($devices -and $devices.Count -gt 1) {
        Write-Host "ADB devices list:" -ForegroundColor White
        foreach ($line in $devices) {
            if ($line -and $line.Trim() -ne "List of devices attached") {
                Write-Host "  $line" -ForegroundColor Gray
            }
        }
    } else {
        Write-Host "INFO: No devices currently connected" -ForegroundColor Yellow
        Write-Host "Make sure your emulator is running and USB debugging is enabled" -ForegroundColor White
    }
} catch {
    Write-Host "WARNING: Could not check ADB devices" -ForegroundColor Yellow
}

# Step 5: AutoJS setup instructions
Write-Host ""
Write-Host "Step 5: AutoJS Setup Instructions" -ForegroundColor Cyan
Write-Host "After starting your emulator:" -ForegroundColor White
Write-Host "1. Download AutoJS APK from official source" -ForegroundColor White
Write-Host "2. Install in emulator: adb install autojs.apk" -ForegroundColor Gray
Write-Host "3. Grant necessary permissions:" -ForegroundColor White
Write-Host "   - Accessibility Service" -ForegroundColor Gray
Write-Host "   - Overlay permission (floating window)" -ForegroundColor Gray
Write-Host "   - Storage permission" -ForegroundColor Gray
Write-Host "4. Enable developer options in emulator" -ForegroundColor White
Write-Host "5. Turn on USB debugging" -ForegroundColor White

# Step 6: Create helper scripts
Write-Host ""
Write-Host "Step 6: Creating helper scripts..." -ForegroundColor Cyan

# ADB connection script
$adbConnectScript = @"
@echo off
title ADB Connection Helper
echo Checking ADB connection...
"$adbDir\adb.exe" devices
echo.
echo To connect to a specific emulator:
echo adb connect 127.0.0.1:5555  (LDPlayer default)
echo adb connect 127.0.0.1:62001 (Nox default)
echo adb connect 127.0.0.1:5037  (BlueStacks default)
echo.
pause
"@

$adbConnectScript | Out-File -FilePath "$setupDir\connect_adb.bat" -Encoding ASCII

# AutoJS install script
$autojsInstallScript = @"
@echo off
title AutoJS Install Helper
echo Make sure your emulator is running and connected...
echo.
"$adbDir\adb.exe" devices
echo.
echo To install AutoJS APK:
echo 1. Download AutoJS APK file
echo 2. Run: adb install path\to\autojs.apk
echo.
echo Example:
echo adb install autojs-4.1.1.apk
echo.
pause
"@

$autojsInstallScript | Out-File -FilePath "$setupDir\install_autojs.bat" -Encoding ASCII

Write-Host "SUCCESS: Helper scripts created:" -ForegroundColor Green
Write-Host "  - $setupDir\connect_adb.bat" -ForegroundColor Gray
Write-Host "  - $setupDir\install_autojs.bat" -ForegroundColor Gray

# Step 7: Environment variable setup
Write-Host ""
Write-Host "Step 7: Environment setup..." -ForegroundColor Cyan

if (-not $adbInstalled) {
    Write-Host "To permanently add ADB to PATH:" -ForegroundColor Yellow
    Write-Host "1. Open System Properties" -ForegroundColor White
    Write-Host "2. Environment Variables" -ForegroundColor White
    Write-Host "3. Add to PATH: $adbDir" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Or run this command as Administrator:" -ForegroundColor Yellow
    Write-Host "[Environment]::SetEnvironmentVariable('PATH', `$env:PATH + ';$adbDir', 'Machine')" -ForegroundColor Gray
}

# Summary
Write-Host ""
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "    Setup Summary" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Setup directory: $setupDir" -ForegroundColor Yellow
Write-Host "ADB location: $adbDir" -ForegroundColor Yellow
Write-Host ""

Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Start your Android emulator" -ForegroundColor White
Write-Host "2. Run connect_adb.bat to verify connection" -ForegroundColor White
Write-Host "3. Download and install AutoJS APK" -ForegroundColor White
Write-Host "4. Configure AutoJS permissions" -ForegroundColor White
Write-Host "5. Start developing your automation scripts!" -ForegroundColor White

Write-Host ""
Write-Host "Setup completed!" -ForegroundColor Green
