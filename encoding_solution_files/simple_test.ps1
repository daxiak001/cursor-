# Simple ASCII Test Script
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "Simple Encoding Test - ASCII Only" -ForegroundColor Green
Write-Host ""

Write-Host "Testing basic output:" -ForegroundColor Cyan
Write-Host "  Text: Hello World 123" -ForegroundColor White
Write-Host "  Symbols: !@#$%^&*()" -ForegroundColor White
Write-Host "  Status: [OK] [ERROR] [WARNING]" -ForegroundColor White

Write-Host ""
Write-Host "Testing paths:" -ForegroundColor Cyan
if (Test-Path "$env:USERPROFILE\Downloads") {
    Write-Host "  [OK] Downloads folder accessible" -ForegroundColor Green
} else {
    Write-Host "  [ERROR] Downloads folder not found" -ForegroundColor Red
}

Write-Host ""
Write-Host "Test completed!" -ForegroundColor Green
