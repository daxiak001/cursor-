# PowerShell 7 Installation Script (Fixed Version)
# Set UTF-8 encoding for proper display
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=====================================================" -ForegroundColor Green
Write-Host "    PowerShell 7 Installation Script" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
Write-Host ""

# Use English paths to avoid encoding issues
$downloadPath = "$env:USERPROFILE\Downloads\powershell7_install"
$ps7Url = "https://github.com/PowerShell/PowerShell/releases/latest/download/PowerShell-7.4.0-win-x64.msi"
$ps7File = "$downloadPath\powershell7_installer.msi"

# Create download directory if it doesn't exist
if (-not (Test-Path $downloadPath)) {
    New-Item -ItemType Directory -Path $downloadPath -Force | Out-Null
    Write-Host "Created download directory: $downloadPath" -ForegroundColor Yellow
}

Write-Host "Download path: $downloadPath" -ForegroundColor Yellow
Write-Host ""

# Check current PowerShell version
Write-Host "Current PowerShell Information:" -ForegroundColor Cyan
Write-Host "Version: $($PSVersionTable.PSVersion)" -ForegroundColor White
Write-Host "Edition: $($PSVersionTable.PSEdition)" -ForegroundColor White
Write-Host ""

# Check if PowerShell 7 is already installed
$ps7Path = "${env:ProgramFiles}\PowerShell\7\pwsh.exe"
if (Test-Path $ps7Path) {
    try {
        $ps7Version = & $ps7Path -Command '$PSVersionTable.PSVersion.ToString()' 2>$null
        Write-Host "✓ PowerShell 7 is already installed!" -ForegroundColor Green
        Write-Host "Version: $ps7Version" -ForegroundColor Cyan
        Write-Host "Location: $ps7Path" -ForegroundColor Gray
        Write-Host ""
        Write-Host "To use PowerShell 7, run: pwsh" -ForegroundColor Magenta
        return
    } catch {
        Write-Host "PowerShell 7 files found but may be corrupted, reinstalling..." -ForegroundColor Yellow
    }
}

# Check if winget is available
Write-Host "Checking installation methods..." -ForegroundColor Cyan
$useWinget = $false
try {
    $wingetVersion = & winget --version 2>$null
    if ($wingetVersion) {
        Write-Host "✓ winget available, version: $wingetVersion" -ForegroundColor Green
        $useWinget = $true
    }
} catch {
    Write-Host "✗ winget not available" -ForegroundColor Yellow
}

if ($useWinget) {
    # Install using winget
    Write-Host ""
    Write-Host "Installing PowerShell 7 using winget..." -ForegroundColor Cyan
    try {
        & winget install Microsoft.PowerShell --accept-package-agreements --accept-source-agreements
        Write-Host "✓ PowerShell 7 installed successfully via winget!" -ForegroundColor Green
    } catch {
        Write-Host "✗ winget installation failed, trying manual download..." -ForegroundColor Red
        $useWinget = $false
    }
}

if (-not $useWinget) {
    # Manual download and install
    Write-Host ""
    Write-Host "Downloading PowerShell 7 installer..." -ForegroundColor Cyan
    Write-Host "This may take a few minutes..." -ForegroundColor Gray
    
    try {
        # Use TLS 1.2 for better compatibility
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        
        # Get the latest release info
        $latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/PowerShell/PowerShell/releases/latest" -UseBasicParsing
        $asset = $latestRelease.assets | Where-Object { $_.name -like "*win-x64.msi" } | Select-Object -First 1
        
        if ($asset) {
            $ps7Url = $asset.browser_download_url
            $ps7File = "$downloadPath\$($asset.name)"
            Write-Host "Found latest version: $($latestRelease.tag_name)" -ForegroundColor Cyan
        }
        
        $progressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $ps7Url -OutFile $ps7File -UseBasicParsing
        $progressPreference = 'Continue'
        
        Write-Host "✓ Download completed: $ps7File" -ForegroundColor Green
        
        # Install the MSI package
        Write-Host ""
        Write-Host "Installing PowerShell 7..." -ForegroundColor Cyan
        Write-Host "Please wait for the installation to complete..." -ForegroundColor Gray
        
        $installArgs = @(
            "/i"
            "`"$ps7File`""
            "/quiet"
            "/norestart"
            "ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1"
            "ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1"
            "ENABLE_PSREMOTING=1"
            "REGISTER_MANIFEST=1"
        )
        
        Start-Process -FilePath "msiexec.exe" -ArgumentList $installArgs -Wait -NoNewWindow
        Write-Host "✓ PowerShell 7 installation completed!" -ForegroundColor Green
        
    } catch {
        Write-Host "✗ Installation failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
        Write-Host "Manual installation options:" -ForegroundColor Yellow
        Write-Host "1. Visit: https://github.com/PowerShell/PowerShell/releases/latest" -ForegroundColor Cyan
        Write-Host "2. Download: PowerShell-*-win-x64.msi" -ForegroundColor Cyan
        Write-Host "3. Run the installer as Administrator" -ForegroundColor Cyan
        return
    }
}

# Verify installation
Write-Host ""
Write-Host "Verifying PowerShell 7 installation..." -ForegroundColor Cyan
Start-Sleep -Seconds 3

# Refresh environment variables
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")

try {
    if (Test-Path $ps7Path) {
        $ps7Version = & $ps7Path -Command '$PSVersionTable.PSVersion.ToString()' 2>$null
        Write-Host "✓ PowerShell 7 installation verified!" -ForegroundColor Green
        Write-Host "Version: $ps7Version" -ForegroundColor Cyan
        Write-Host "Location: $ps7Path" -ForegroundColor Gray
        Write-Host ""
        Write-Host "How to use PowerShell 7:" -ForegroundColor Magenta
        Write-Host "• Command: pwsh" -ForegroundColor White
        Write-Host "• Start Menu: Search 'PowerShell 7'" -ForegroundColor White
        Write-Host "• Direct path: `"$ps7Path`"" -ForegroundColor White
        Write-Host ""
        Write-Host "PowerShell 7 features:" -ForegroundColor Magenta
        Write-Host "• Cross-platform compatibility" -ForegroundColor White
        Write-Host "• Improved performance" -ForegroundColor White
        Write-Host "• New cmdlets and features" -ForegroundColor White
        Write-Host "• Better JSON and REST API support" -ForegroundColor White
    } else {
        throw "PowerShell 7 executable not found"
    }
} catch {
    Write-Host "✗ PowerShell 7 verification failed" -ForegroundColor Red
    Write-Host "Please restart your computer and try running: pwsh" -ForegroundColor Yellow
}

# Cleanup
Write-Host ""
Write-Host "Cleaning up temporary files..." -ForegroundColor Cyan
try {
    if (Test-Path $ps7File) {
        Remove-Item -Path $ps7File -ErrorAction SilentlyContinue
    }
    Write-Host "✓ Cleanup completed" -ForegroundColor Green
} catch {
    Write-Host "Note: Some temporary files may remain in $downloadPath" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Script execution completed!" -ForegroundColor Green
Write-Host "You can now start using PowerShell 7 by typing: pwsh" -ForegroundColor Magenta
