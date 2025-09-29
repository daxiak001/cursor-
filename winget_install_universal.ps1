# Universal winget Installation Script
# Compatible with all Windows systems and encoding environments
# No Chinese characters - English only for maximum compatibility

# Force UTF-8 encoding
try {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.Encoding]::UTF8
} catch {
    # Silently continue if encoding setup fails
}

Write-Host "=====================================================" -ForegroundColor Green
Write-Host "    Universal winget Installation Script" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
Write-Host ""

# Use safe English paths only
$downloadPath = "$env:USERPROFILE\Downloads\winget_install"
$wingetUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
$dependenciesUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/DesktopAppInstaller_Dependencies.zip"
$wingetFile = "$downloadPath\winget_installer.msixbundle"
$dependenciesFile = "$downloadPath\dependencies.zip"

# Create download directory
if (-not (Test-Path $downloadPath)) {
    New-Item -ItemType Directory -Path $downloadPath -Force | Out-Null
    Write-Host "Created download directory: $downloadPath" -ForegroundColor Yellow
}

Write-Host "Download path: $downloadPath" -ForegroundColor Yellow
Write-Host ""

# Check if winget is already installed
Write-Host "Checking winget installation status..." -ForegroundColor Cyan
try {
    $version = & winget --version 2>$null
    if ($version) {
        Write-Host "SUCCESS: winget is already installed, version: $version" -ForegroundColor Green
        Write-Host "No need to reinstall!" -ForegroundColor Green
        return
    }
} catch {
    Write-Host "INFO: winget not found, starting download..." -ForegroundColor Yellow
}

# Download main installer
Write-Host "Downloading winget main installer..." -ForegroundColor Cyan
Write-Host "File: Microsoft.DesktopAppInstaller (approx 201MB)" -ForegroundColor White
Write-Host "This may take a few minutes..." -ForegroundColor Gray

try {
    # Use TLS 1.2 for better compatibility
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    $progressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $wingetUrl -OutFile $wingetFile -UseBasicParsing
    $progressPreference = 'Continue'
    
    Write-Host "SUCCESS: Main installer downloaded" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Download failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Please manually download from: $wingetUrl" -ForegroundColor Yellow
    return
}

# Try to install main package
Write-Host ""
Write-Host "Installing winget..." -ForegroundColor Cyan
try {
    Add-AppxPackage -Path $wingetFile -ErrorAction Stop
    Write-Host "SUCCESS: winget installed!" -ForegroundColor Green
} catch {
    Write-Host "INFO: Main installer failed, downloading dependencies..." -ForegroundColor Red
    
    # Download dependencies
    try {
        $progressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $dependenciesUrl -OutFile $dependenciesFile -UseBasicParsing
        $progressPreference = 'Continue'
        
        Write-Host "SUCCESS: Dependencies downloaded" -ForegroundColor Green
        
        # Extract dependencies
        $dependenciesDir = "$downloadPath\dependencies"
        if (Test-Path $dependenciesDir) {
            Remove-Item -Path $dependenciesDir -Recurse -Force
        }
        Expand-Archive -Path $dependenciesFile -DestinationPath $dependenciesDir -Force
        
        # Install dependencies
        Write-Host "Installing dependency packages..." -ForegroundColor Cyan
        $depFiles = Get-ChildItem -Path $dependenciesDir -Filter "*.appx" -Recurse
        foreach ($depFile in $depFiles) {
            try {
                Add-AppxPackage -Path $depFile.FullName -ErrorAction SilentlyContinue
                Write-Host "  Installed: $($depFile.Name)" -ForegroundColor Gray
            } catch {
                Write-Host "  Skipped: $($depFile.Name)" -ForegroundColor Gray
            }
        }
        
        # Retry main installer
        Write-Host "Retrying winget installation..." -ForegroundColor Cyan
        Add-AppxPackage -Path $wingetFile -ErrorAction Stop
        Write-Host "SUCCESS: winget installed!" -ForegroundColor Green
        
    } catch {
        Write-Host "ERROR: Installation failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Alternative: Install 'App Installer' from Microsoft Store" -ForegroundColor Yellow
        Write-Host "Store link: ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1" -ForegroundColor Cyan
        return
    }
}

# Verify installation
Write-Host ""
Write-Host "Verifying installation..." -ForegroundColor Cyan
Start-Sleep -Seconds 5

# Refresh environment variables
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")

try {
    $version = & winget --version 2>$null
    if ($version) {
        Write-Host "SUCCESS: winget installation verified!" -ForegroundColor Green
        Write-Host "Version: $version" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "You can now install PowerShell 7 with:" -ForegroundColor Magenta
        Write-Host "winget install Microsoft.PowerShell" -ForegroundColor White
        Write-Host ""
        Write-Host "Other useful commands:" -ForegroundColor Magenta
        Write-Host "winget search <package>    # Search for packages" -ForegroundColor White
        Write-Host "winget list               # List installed packages" -ForegroundColor White
        Write-Host "winget upgrade            # Check for updates" -ForegroundColor White
    } else {
        throw "winget command not found"
    }
} catch {
    Write-Host "ERROR: winget command still not available" -ForegroundColor Red
    Write-Host "Please restart your computer and try again" -ForegroundColor Yellow
    Write-Host "Or manually add to PATH: %LOCALAPPDATA%\\Microsoft\\WindowsApps" -ForegroundColor Cyan
}

# Cleanup temporary files
Write-Host ""
Write-Host "Cleaning up temporary files..." -ForegroundColor Cyan
try {
    Remove-Item -Path $wingetFile -ErrorAction SilentlyContinue
    Remove-Item -Path $dependenciesFile -ErrorAction SilentlyContinue
    Remove-Item -Path "$downloadPath\dependencies" -Recurse -ErrorAction SilentlyContinue
    Write-Host "SUCCESS: Cleanup completed" -ForegroundColor Green
} catch {
    Write-Host "Note: Some temporary files may remain in $downloadPath" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Script execution completed!" -ForegroundColor Green

