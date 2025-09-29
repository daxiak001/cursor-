# winget Download and Installation Script (Fixed Version)
# Set UTF-8 encoding for proper display
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=====================================================" -ForegroundColor Green
Write-Host "    winget Download and Installation Script" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
Write-Host ""

# Use English paths to avoid encoding issues
$downloadPath = "$env:USERPROFILE\Downloads\winget_install"
$wingetUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
$dependenciesUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/DesktopAppInstaller_Dependencies.zip"
$wingetFile = "$downloadPath\winget_installer.msixbundle"
$dependenciesFile = "$downloadPath\dependencies.zip"

# Create download directory if it doesn't exist
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
        Write-Host "✓ winget is already installed, version: $version" -ForegroundColor Green
        Write-Host "No need to reinstall!" -ForegroundColor Green
        return
    }
} catch {
    Write-Host "✗ winget not found, starting download..." -ForegroundColor Yellow
}

# Download main installer
Write-Host "Downloading winget main installer..." -ForegroundColor Cyan
Write-Host "File: Microsoft.DesktopAppInstaller (approx 201MB)" -ForegroundColor White
Write-Host "This may take a few minutes..." -ForegroundColor Gray

try {
    # Use TLS 1.2 for better compatibility
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    $progressPreference = 'SilentlyContinue'  # Hide progress bar for cleaner output
    Invoke-WebRequest -Uri $wingetUrl -OutFile $wingetFile -UseBasicParsing
    $progressPreference = 'Continue'
    
    Write-Host "✓ Main installer downloaded successfully" -ForegroundColor Green
} catch {
    Write-Host "✗ Download failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Please manually download from: $wingetUrl" -ForegroundColor Yellow
    return
}

# Try to install main package
Write-Host ""
Write-Host "Installing winget..." -ForegroundColor Cyan
try {
    Add-AppxPackage -Path $wingetFile -ErrorAction Stop
    Write-Host "✓ winget installed successfully!" -ForegroundColor Green
} catch {
    Write-Host "✗ Main installer failed, missing dependencies detected" -ForegroundColor Red
    Write-Host "Downloading dependency files..." -ForegroundColor Yellow
    
    # Download dependencies
    try {
        $progressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $dependenciesUrl -OutFile $dependenciesFile -UseBasicParsing
        $progressPreference = 'Continue'
        
        Write-Host "✓ Dependencies downloaded" -ForegroundColor Green
        
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
                # Continue even if some dependencies fail
                Write-Host "  Skipped: $($depFile.Name)" -ForegroundColor Gray
            }
        }
        
        # Retry main installer
        Write-Host "Retrying winget installation..." -ForegroundColor Cyan
        Add-AppxPackage -Path $wingetFile -ErrorAction Stop
        Write-Host "✓ winget installed successfully!" -ForegroundColor Green
        
    } catch {
        Write-Host "✗ Installation failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Alternative: Install 'App Installer' from Microsoft Store" -ForegroundColor Yellow
        Write-Host "Store link: ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1" -ForegroundColor Cyan
        return
    }
}

# Verify installation
Write-Host ""
Write-Host "Verifying installation..." -ForegroundColor Cyan
Start-Sleep -Seconds 5  # Wait for system to register the app

# Refresh environment variables
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")

try {
    $version = & winget --version 2>$null
    if ($version) {
        Write-Host "✓ winget installation verified successfully!" -ForegroundColor Green
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
    Write-Host "✗ winget command still not available" -ForegroundColor Red
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
    Write-Host "✓ Cleanup completed" -ForegroundColor Green
} catch {
    Write-Host "Note: Some temporary files may remain in $downloadPath" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Script execution completed!" -ForegroundColor Green
