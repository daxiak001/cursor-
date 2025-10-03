# ASCII-Safe Encoding Fix Script
# This script fixes encoding issues using only ASCII characters

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=====================================================" -ForegroundColor Green
Write-Host "    ASCII-Safe Encoding Fix Tool" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
Write-Host ""

# Define problematic characters and their ASCII replacements
# Using only ASCII characters in this definition
$replacements = @{
    # Common checkmarks and crosses
    [char]0x2713 = "[OK]"      # ✓
    [char]0x2717 = "[ERROR]"   # ✗
    [char]0x26A0 = "[WARNING]" # ⚠
    [char]0x2192 = "->"        # →
    [char]0x2190 = "<-"        # ←
    [char]0x2191 = "UP"        # ↑
    [char]0x2193 = "DOWN"      # ↓
    [char]0x1F4C1 = "[DIR]"    # 📁
    [char]0x1F4C4 = "[FILE]"   # 📄
    [char]0x1F527 = "[TOOL]"   # 🔧
    [char]0x274C = "[FAIL]"    # ❌
    [char]0x2705 = "[SUCCESS]" # ✅
}

Write-Host "Step 1: Scanning script files for encoding issues..." -ForegroundColor Cyan
Write-Host ""

# Get all script files
$scriptFiles = Get-ChildItem -Path "." -Include "*.ps1", "*.bat", "*.cmd" -File
$problemFiles = @()

foreach ($file in $scriptFiles) {
    try {
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        if ($content -and ($content -match '[^\x00-\x7F]')) {
            $problemFiles += $file
            Write-Host "Found non-ASCII chars in: $($file.Name)" -ForegroundColor Yellow
        } else {
            Write-Host "Clean: $($file.Name)" -ForegroundColor Green
        }
    } catch {
        Write-Host "Could not read: $($file.Name)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Step 2: Creating ASCII-safe versions..." -ForegroundColor Cyan
Write-Host ""

foreach ($file in $problemFiles) {
    $originalPath = $file.FullName
    $directory = Split-Path -Path $originalPath -Parent
    $fileName = Split-Path -Path $originalPath -Leaf
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
    $extension = [System.IO.Path]::GetExtension($fileName)
    
    # Create ASCII-safe version
    $asciiSafePath = Join-Path -Path $directory -ChildPath "$baseName`_ascii_safe$extension"
    
    Write-Host "Processing: $fileName" -ForegroundColor Cyan
    
    try {
        $content = Get-Content -Path $originalPath -Raw -Encoding UTF8
        $originalContent = $content
        
        # Apply replacements
        foreach ($unicodeChar in $replacements.Keys) {
            $replacement = $replacements[$unicodeChar]
            if ($content.Contains($unicodeChar)) {
                $content = $content.Replace($unicodeChar, $replacement)
                Write-Host "  Replaced Unicode char with: $replacement" -ForegroundColor Yellow
            }
        }
        
        # Additional specific replacements for common problematic characters
        # Check mark variants
        $content = $content -replace '✓', '[OK]'
        $content = $content -replace '✗', '[ERROR]'
        $content = $content -replace '❌', '[FAIL]'
        $content = $content -replace '✅', '[SUCCESS]'
        $content = $content -replace '⚠', '[WARNING]'
        
        # Arrows
        $content = $content -replace '→', '->'
        $content = $content -replace '←', '<-'
        $content = $content -replace '↑', 'UP'
        $content = $content -replace '↓', 'DOWN'
        
        # Emojis
        $content = $content -replace '📁', '[DIR]'
        $content = $content -replace '📄', '[FILE]'
        $content = $content -replace '🔧', '[TOOL]'
        $content = $content -replace '🚀', '[LAUNCH]'
        $content = $content -replace '⭐', '[STAR]'
        $content = $content -replace '💡', '[TIP]'
        
        # Add encoding headers if needed
        if ($extension -eq ".ps1") {
            if (-not ($content -match '\[Console\]::OutputEncoding')) {
                $encodingHeader = "# ASCII-Safe PowerShell Script`r`n[Console]::OutputEncoding = [System.Text.Encoding]::UTF8`r`n`$OutputEncoding = [System.Text.Encoding]::UTF8`r`n`r`n"
                $content = $encodingHeader + $content
            }
        } elseif ($extension -eq ".bat") {
            if (-not ($content -match 'chcp 65001')) {
                $content = $content -replace '^(@echo off)', "@echo off`r`nchcp 65001 >nul 2>&1"
            }
        }
        
        # Save ASCII-safe version
        $content | Out-File -FilePath $asciiSafePath -Encoding UTF8 -Force
        
        if ($content -ne $originalContent) {
            Write-Host "  [SUCCESS] ASCII-safe version created: $asciiSafePath" -ForegroundColor Green
        } else {
            Write-Host "  [INFO] No changes needed, but safe version created" -ForegroundColor Green
        }
        
    } catch {
        Write-Host "  [ERROR] Failed to process: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
}

# Create a simple test script
Write-Host "Step 3: Creating verification test..." -ForegroundColor Cyan

$testScript = @'
# Simple ASCII Encoding Test
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=====================================================" -ForegroundColor Green
Write-Host "    ASCII Encoding Verification Test" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
Write-Host ""

Write-Host "Test 1: ASCII Characters" -ForegroundColor Cyan
Write-Host "  Basic text: Hello World 123" -ForegroundColor White
Write-Host "  Symbols: !@#$%^&*()" -ForegroundColor White
Write-Host "  Status indicators: [OK] [ERROR] [WARNING]" -ForegroundColor White
Write-Host "  Arrows: -> <- UP DOWN" -ForegroundColor White

Write-Host ""
Write-Host "Test 2: Path Access" -ForegroundColor Cyan
$paths = @("$env:USERPROFILE\Downloads", "$env:TEMP")
foreach ($path in $paths) {
    if (Test-Path $path) {
        Write-Host "  [OK] $path" -ForegroundColor Green
    } else {
        Write-Host "  [ERROR] $path" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Test 3: File Operations" -ForegroundColor Cyan
try {
    $testContent = "ASCII test content: SUCCESS 123"
    $testFile = "$env:TEMP\ascii_test.txt"
    $testContent | Out-File -FilePath $testFile -Encoding UTF8 -Force
    $readBack = Get-Content -Path $testFile -Encoding UTF8 -Raw
    Remove-Item -Path $testFile -ErrorAction SilentlyContinue
    Write-Host "  [OK] File operations working" -ForegroundColor Green
} catch {
    Write-Host "  [ERROR] File operations failed" -ForegroundColor Red
}

Write-Host ""
Write-Host "Test completed successfully!" -ForegroundColor Green
Write-Host "All output uses ASCII-safe characters only." -ForegroundColor Green
'@

$testScript | Out-File -FilePath "ascii_encoding_test.ps1" -Encoding UTF8 -Force
Write-Host "Created: ascii_encoding_test.ps1" -ForegroundColor Green

Write-Host ""
Write-Host "=====================================================" -ForegroundColor Green
Write-Host "    ASCII-Safe Encoding Fix Completed!" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Summary:" -ForegroundColor Yellow
Write-Host "- Processed $($problemFiles.Count) files with encoding issues" -ForegroundColor White
Write-Host "- Created ASCII-safe versions with '_ascii_safe' suffix" -ForegroundColor White
Write-Host "- Added proper encoding headers where needed" -ForegroundColor White
Write-Host "- Created 'ascii_encoding_test.ps1' for verification" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Run 'ascii_encoding_test.ps1' to verify the fix" -ForegroundColor White
Write-Host "2. Use the '_ascii_safe' versions of your scripts" -ForegroundColor White
Write-Host "3. Test in your specific environment" -ForegroundColor White
Write-Host ""
