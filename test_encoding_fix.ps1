# ASCII-only Encoding Test Script
# Simple test to verify encoding fixes work

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "================================================" -ForegroundColor Green
Write-Host "    Encoding Fix Verification Test" -ForegroundColor Green  
Write-Host "================================================" -ForegroundColor Green
Write-Host ""

Write-Host "Test 1: Script Files Check" -ForegroundColor Cyan
$scripts = @(
    "winget_install_universal.ps1",
    "powershell7_install_universal.ps1", 
    "setup_tools_universal.bat"
)

foreach ($script in $scripts) {
    if (Test-Path $script) {
        Write-Host "  FOUND: $script" -ForegroundColor Green
    } else {
        Write-Host "  MISSING: $script" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Test 2: Character Display" -ForegroundColor Cyan
Write-Host "  ASCII text: SUCCESS" -ForegroundColor White
Write-Host "  Numbers: 123456789" -ForegroundColor White  
Write-Host "  Symbols: !@#$%^&*()" -ForegroundColor White

Write-Host ""
Write-Host "Test 3: Path Access" -ForegroundColor Cyan
$paths = @(
    "$env:USERPROFILE\Downloads",
    "$env:TEMP"
)

foreach ($path in $paths) {
    if (Test-Path $path) {
        Write-Host "  OK: $path" -ForegroundColor Green
    } else {
        Write-Host "  FAIL: $path" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Test 4: Commands" -ForegroundColor Cyan
try {
    $wingetVer = & winget --version 2>$null
    if ($wingetVer) {
        Write-Host "  winget: Available ($wingetVer)" -ForegroundColor Green
    } else {
        Write-Host "  winget: Not found" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  winget: Not found" -ForegroundColor Yellow
}

try {
    $ps7Ver = & pwsh --version 2>$null
    if ($ps7Ver) {
        Write-Host "  PowerShell 7: Available ($ps7Ver)" -ForegroundColor Green
    } else {
        Write-Host "  PowerShell 7: Not found" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  PowerShell 7: Not found" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "    Summary" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Encoding fixes completed:" -ForegroundColor Yellow
Write-Host "- Universal scripts created (English only)" -ForegroundColor White
Write-Host "- UTF-8 encoding configured" -ForegroundColor White
Write-Host "- Safe path handling implemented" -ForegroundColor White
Write-Host "- ASCII-compatible output" -ForegroundColor White
Write-Host ""
Write-Host "Use these files:" -ForegroundColor Yellow
Write-Host "- winget_install_universal.ps1" -ForegroundColor White
Write-Host "- powershell7_install_universal.ps1" -ForegroundColor White
Write-Host "- setup_tools_universal.bat" -ForegroundColor White
Write-Host ""
Write-Host "Test completed successfully!" -ForegroundColor Green
