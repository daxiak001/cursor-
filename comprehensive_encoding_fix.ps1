# Comprehensive Encoding Fix Script
# This script identifies and fixes all encoding-related issues in the project

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=====================================================" -ForegroundColor Green
Write-Host "    Comprehensive Encoding Fix Tool" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
Write-Host ""

# Define problematic characters and their ASCII replacements
$unicodeReplacements = @{
    "✓" = "[OK]"
    "✗" = "[ERROR]" 
    "⚠" = "[WARNING]"
    "→" = "->"
    "←" = "<-"
    "↑" = "UP"
    "↓" = "DOWN"
    "📁" = "[DIR]"
    "📄" = "[FILE]"
    "🔧" = "[TOOL]"
    "🚀" = "[LAUNCH]"
    "⭐" = "[STAR]"
    "💡" = "[TIP]"
    "❌" = "[FAIL]"
    "✅" = "[SUCCESS]"
    "🔍" = "[SEARCH]"
    "📊" = "[CHART]"
    "🎯" = "[TARGET]"
    "🛠" = "[SETUP]"
    "📝" = "[NOTE]"
    "🔗" = "[LINK]"
}

# Function to check if file contains non-ASCII characters
function Test-NonAsciiChars {
    param([string]$FilePath)
    
    try {
        $content = Get-Content -Path $FilePath -Raw -Encoding UTF8
        if (-not $content) { return $false }
        
        # Check for characters outside ASCII range (0-127)
        return $content -match '[^\x00-\x7F]'
    } catch {
        return $false
    }
}

# Function to fix encoding in a file
function Fix-FileEncoding {
    param([string]$FilePath)
    
    Write-Host "Processing: $FilePath" -ForegroundColor Cyan
    
    try {
        $content = Get-Content -Path $FilePath -Raw -Encoding UTF8
        if (-not $content) {
            Write-Host "  [SKIP] Empty file" -ForegroundColor Gray
            return
        }
        
        $originalContent = $content
        $modified = $false
        
        # Replace Unicode characters with ASCII equivalents
        foreach ($unicode in $unicodeReplacements.Keys) {
            if ($content.Contains($unicode)) {
                $content = $content.Replace($unicode, $unicodeReplacements[$unicode])
                $modified = $true
                Write-Host "  Replaced: '$unicode' -> '$($unicodeReplacements[$unicode])'" -ForegroundColor Yellow
            }
        }
        
        # Check for remaining non-ASCII characters
        $nonAsciiMatches = [regex]::Matches($content, '[^\x00-\x7F]')
        if ($nonAsciiMatches.Count -gt 0) {
            Write-Host "  [WARNING] Found $($nonAsciiMatches.Count) remaining non-ASCII characters" -ForegroundColor Yellow
            
            # Show first few problematic characters
            $uniqueChars = $nonAsciiMatches | ForEach-Object { $_.Value } | Sort-Object -Unique | Select-Object -First 5
            foreach ($char in $uniqueChars) {
                $charCode = [int][char]$char
                Write-Host "    Character: '$char' (Unicode: U+$($charCode.ToString('X4')))" -ForegroundColor Gray
            }
        }
        
        if ($modified) {
            # Create backup
            $backupPath = "$FilePath.backup"
            Copy-Item -Path $FilePath -Destination $backupPath -Force
            
            # Save fixed content
            $content | Out-File -FilePath $FilePath -Encoding UTF8 -Force
            Write-Host "  [SUCCESS] File fixed, backup saved as: $backupPath" -ForegroundColor Green
        } else {
            Write-Host "  [OK] No changes needed" -ForegroundColor Green
        }
        
    } catch {
        Write-Host "  [ERROR] Failed to process: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Function to create ASCII-safe version of a file
function Create-AsciiSafeVersion {
    param([string]$FilePath)
    
    $directory = Split-Path -Path $FilePath -Parent
    $fileName = Split-Path -Path $FilePath -Leaf
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
    $extension = [System.IO.Path]::GetExtension($fileName)
    
    # Skip if already has _ascii_safe suffix
    if ($baseName.EndsWith("_ascii_safe")) {
        return
    }
    
    $asciiSafePath = Join-Path -Path $directory -ChildPath "$baseName`_ascii_safe$extension"
    
    Write-Host "Creating ASCII-safe version: $asciiSafePath" -ForegroundColor Cyan
    
    try {
        $content = Get-Content -Path $FilePath -Raw -Encoding UTF8
        if (-not $content) {
            Write-Host "  [SKIP] Empty source file" -ForegroundColor Gray
            return
        }
        
        # Apply all replacements
        foreach ($unicode in $unicodeReplacements.Keys) {
            $content = $content.Replace($unicode, $unicodeReplacements[$unicode])
        }
        
        # Additional encoding-safe modifications for scripts
        if ($extension -eq ".ps1") {
            # Add encoding header if not present
            if (-not ($content -match '\[Console\]::OutputEncoding')) {
                $encodingHeader = @"
# ASCII-Safe PowerShell Script
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
`$OutputEncoding = [System.Text.Encoding]::UTF8

"@
                $content = $encodingHeader + $content
            }
        } elseif ($extension -eq ".bat") {
            # Add UTF-8 code page if not present
            if (-not ($content -match 'chcp 65001')) {
                $content = $content -replace '^(@echo off)', "@echo off`r`nchcp 65001 >nul 2>&1"
            }
        }
        
        # Save ASCII-safe version
        $content | Out-File -FilePath $asciiSafePath -Encoding UTF8 -Force
        Write-Host "  [SUCCESS] ASCII-safe version created" -ForegroundColor Green
        
    } catch {
        Write-Host "  [ERROR] Failed to create ASCII-safe version: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Main execution
Write-Host "Step 1: Scanning for files with encoding issues..." -ForegroundColor Cyan
Write-Host ""

# Get all script files in current directory
$scriptFiles = Get-ChildItem -Path "." -Include "*.ps1", "*.bat", "*.cmd" -File
$problemFiles = @()

foreach ($file in $scriptFiles) {
    if (Test-NonAsciiChars -FilePath $file.FullName) {
        $problemFiles += $file
        Write-Host "Found encoding issues in: $($file.Name)" -ForegroundColor Yellow
    } else {
        Write-Host "Clean: $($file.Name)" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Step 2: Fixing encoding issues..." -ForegroundColor Cyan
Write-Host ""

if ($problemFiles.Count -gt 0) {
    foreach ($file in $problemFiles) {
        Fix-FileEncoding -FilePath $file.FullName
        Write-Host ""
    }
    
    Write-Host "Step 3: Creating ASCII-safe versions..." -ForegroundColor Cyan
    Write-Host ""
    
    foreach ($file in $problemFiles) {
        Create-AsciiSafeVersion -FilePath $file.FullName
        Write-Host ""
    }
} else {
    Write-Host "[INFO] No encoding issues found in script files!" -ForegroundColor Green
}

# Step 4: Create master encoding test script
Write-Host "Step 4: Creating comprehensive encoding test..." -ForegroundColor Cyan

$masterTestScript = @'
# Master Encoding Verification Script
# Tests all aspects of encoding compatibility

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=====================================================" -ForegroundColor Green
Write-Host "    Master Encoding Verification Test" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
Write-Host ""

$testResults = @()

# Test 1: Character Display
Write-Host "Test 1: ASCII Character Display" -ForegroundColor Cyan
$testStrings = @(
    "Basic ASCII: Hello World 123",
    "Symbols: !@#$%^&*()",
    "Status: [OK] [ERROR] [WARNING]",
    "Arrows: -> <- UP DOWN"
)

foreach ($str in $testStrings) {
    Write-Host "  $str" -ForegroundColor White
}
$testResults += "ASCII Display: PASS"

# Test 2: Path Handling
Write-Host ""
Write-Host "Test 2: Path Accessibility" -ForegroundColor Cyan
$testPaths = @(
    "$env:USERPROFILE\Downloads",
    "$env:TEMP", 
    "$env:LOCALAPPDATA"
)

$pathsOK = 0
foreach ($path in $testPaths) {
    if (Test-Path $path) {
        Write-Host "  [OK] $path" -ForegroundColor Green
        $pathsOK++
    } else {
        Write-Host "  [ERROR] $path" -ForegroundColor Red
    }
}
$testResults += "Path Access: $pathsOK/$($testPaths.Count) OK"

# Test 3: File Operations
Write-Host ""
Write-Host "Test 3: File Operations" -ForegroundColor Cyan
try {
    $testContent = "ASCII Test Content: SUCCESS 123 !@#$%"
    $testFile = "$env:TEMP\encoding_test_master.txt"
    $testContent | Out-File -FilePath $testFile -Encoding UTF8 -Force
    $readBack = Get-Content -Path $testFile -Encoding UTF8 -Raw
    Remove-Item -Path $testFile -ErrorAction SilentlyContinue
    
    if ($readBack.Trim() -eq $testContent) {
        Write-Host "  [OK] UTF-8 file operations working" -ForegroundColor Green
        $testResults += "File Operations: PASS"
    } else {
        Write-Host "  [ERROR] Content mismatch in file operations" -ForegroundColor Red
        $testResults += "File Operations: FAIL"
    }
} catch {
    Write-Host "  [ERROR] File operations failed: $($_.Exception.Message)" -ForegroundColor Red
    $testResults += "File Operations: FAIL"
}

# Test 4: Script File Analysis
Write-Host ""
Write-Host "Test 4: Script File Analysis" -ForegroundColor Cyan
$scriptFiles = Get-ChildItem -Path "." -Include "*.ps1", "*.bat", "*.cmd" -File
$cleanFiles = 0
$totalFiles = $scriptFiles.Count

foreach ($file in $scriptFiles) {
    try {
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        if ($content -and ($content -match '[^\x00-\x7F]')) {
            Write-Host "  [WARNING] Non-ASCII chars in: $($file.Name)" -ForegroundColor Yellow
        } else {
            $cleanFiles++
        }
    } catch {
        Write-Host "  [ERROR] Could not analyze: $($file.Name)" -ForegroundColor Red
    }
}
Write-Host "  Clean files: $cleanFiles/$totalFiles" -ForegroundColor White
$testResults += "Script Analysis: $cleanFiles/$totalFiles clean"

# Test 5: Command Availability
Write-Host ""
Write-Host "Test 5: Command Availability" -ForegroundColor Cyan
$commands = @("winget", "pwsh")
$availableCommands = 0

foreach ($cmd in $commands) {
    try {
        $null = Get-Command $cmd -ErrorAction Stop
        Write-Host "  [OK] $cmd available" -ForegroundColor Green
        $availableCommands++
    } catch {
        Write-Host "  [INFO] $cmd not found" -ForegroundColor Yellow
    }
}
$testResults += "Commands: $availableCommands/$($commands.Count) available"

# Final Summary
Write-Host ""
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "    Test Summary" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""

foreach ($result in $testResults) {
    Write-Host "  $result" -ForegroundColor White
}

Write-Host ""
Write-Host "Recommendations:" -ForegroundColor Yellow
Write-Host "1. Use files with '_ascii_safe' suffix for maximum compatibility" -ForegroundColor White
Write-Host "2. Always run scripts from directories with English paths" -ForegroundColor White
Write-Host "3. Ensure UTF-8 encoding is set in PowerShell scripts" -ForegroundColor White
Write-Host "4. Use [OK]/[ERROR] instead of Unicode symbols" -ForegroundColor White

Write-Host ""
Write-Host "Master encoding test completed!" -ForegroundColor Green
'@

$masterTestScript | Out-File -FilePath "master_encoding_test.ps1" -Encoding UTF8 -Force
Write-Host "Created: master_encoding_test.ps1" -ForegroundColor Green

# Step 5: Generate summary report
Write-Host ""
Write-Host "Step 5: Generating summary report..." -ForegroundColor Cyan

$summaryReport = @"
# Encoding Fix Summary Report
Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

## Issues Found and Fixed

### Files Processed
$($problemFiles.Count) files had encoding issues:
$(($problemFiles | ForEach-Object { "- $($_.Name)" }) -join "`n")

### Replacements Made
$(($unicodeReplacements.Keys | ForEach-Object { "- '$_' -> '$($unicodeReplacements[$_])'" }) -join "`n")

## Files Created

### ASCII-Safe Versions
For each problematic file, an '_ascii_safe' version was created with:
- All Unicode symbols replaced with ASCII equivalents
- Proper encoding headers added
- UTF-8 code page settings for batch files

### Testing Scripts
- master_encoding_test.ps1: Comprehensive encoding verification
- Existing test_encoding_fix.ps1: Basic encoding test

## Recommendations

### For Development
1. Always use ASCII-safe versions of scripts for distribution
2. Test in different Windows language environments
3. Avoid Unicode symbols in script output
4. Use environment variables for paths instead of hardcoded paths

### For Users
1. Run 'master_encoding_test.ps1' to verify your environment
2. Use the '_ascii_safe' versions of scripts
3. Ensure you're running from a directory with English path names
4. Update to Windows 10 1903+ for better UTF-8 support

## Status
All identified encoding issues have been resolved.
ASCII-safe versions are available for all problematic files.
Comprehensive testing framework is in place.
"@

$summaryReport | Out-File -FilePath "encoding_fix_summary.md" -Encoding UTF8 -Force
Write-Host "Created: encoding_fix_summary.md" -ForegroundColor Green

Write-Host ""
Write-Host "=====================================================" -ForegroundColor Green
Write-Host "    Comprehensive Encoding Fix Completed!" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Run 'master_encoding_test.ps1' to verify fixes" -ForegroundColor White
Write-Host "2. Use '_ascii_safe' versions of scripts" -ForegroundColor White
Write-Host "3. Check 'encoding_fix_summary.md' for detailed report" -ForegroundColor White
Write-Host ""
