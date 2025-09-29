# Simple Encoding Fix Script - ASCII Only
# This script uses only basic ASCII characters

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=====================================================" -ForegroundColor Green
Write-Host "    Simple Encoding Fix Tool" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
Write-Host ""

Write-Host "Step 1: Checking current files..." -ForegroundColor Cyan
Write-Host ""

# List all script files
$scriptFiles = Get-ChildItem -Path "." -Include "*.ps1", "*.bat", "*.cmd" -File
Write-Host "Found $($scriptFiles.Count) script files:" -ForegroundColor Yellow

foreach ($file in $scriptFiles) {
    Write-Host "  $($file.Name)" -ForegroundColor White
}

Write-Host ""
Write-Host "Step 2: Analyzing encoding issues..." -ForegroundColor Cyan
Write-Host ""

$problemFiles = @()
foreach ($file in $scriptFiles) {
    try {
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        if ($content) {
            # Check for non-ASCII characters (outside 0-127 range)
            $nonAsciiFound = $false
            for ($i = 0; $i -lt $content.Length; $i++) {
                $charCode = [int][char]$content[$i]
                if ($charCode -gt 127) {
                    $nonAsciiFound = $true
                    break
                }
            }
            
            if ($nonAsciiFound) {
                $problemFiles += $file
                Write-Host "  [ISSUE] $($file.Name) - Contains non-ASCII characters" -ForegroundColor Yellow
            } else {
                Write-Host "  [OK] $($file.Name) - Clean ASCII" -ForegroundColor Green
            }
        }
    } catch {
        Write-Host "  [ERROR] Could not read $($file.Name)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Step 3: Creating clean versions..." -ForegroundColor Cyan
Write-Host ""

foreach ($file in $problemFiles) {
    $originalPath = $file.FullName
    $directory = Split-Path -Path $originalPath -Parent
    $fileName = Split-Path -Path $originalPath -Leaf
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
    $extension = [System.IO.Path]::GetExtension($fileName)
    
    # Create clean version filename
    $cleanPath = Join-Path -Path $directory -ChildPath "$baseName`_clean$extension"
    
    Write-Host "Processing: $fileName" -ForegroundColor Cyan
    
    try {
        $content = Get-Content -Path $originalPath -Raw -Encoding UTF8
        $cleanContent = ""
        
        # Process each character and replace problematic ones
        for ($i = 0; $i -lt $content.Length; $i++) {
            $char = $content[$i]
            $charCode = [int][char]$char
            
            if ($charCode -le 127) {
                # ASCII character - keep as is
                $cleanContent += $char
            } else {
                # Non-ASCII character - replace with safe alternative
                switch ($charCode) {
                    8730 { $cleanContent += "[OK]" }      # Check mark
                    10003 { $cleanContent += "[OK]" }     # Heavy check mark
                    10007 { $cleanContent += "[ERROR]" }  # Cross mark
                    8594 { $cleanContent += "->" }        # Right arrow
                    8592 { $cleanContent += "<-" }        # Left arrow
                    8593 { $cleanContent += "UP" }        # Up arrow
                    8595 { $cleanContent += "DOWN" }      # Down arrow
                    default { 
                        # For any other non-ASCII character, replace with [?]
                        $cleanContent += "[?]" 
                    }
                }
            }
        }
        
        # Add encoding headers if needed
        if ($extension -eq ".ps1" -and -not ($cleanContent -match '\[Console\]::OutputEncoding')) {
            $header = "# Clean ASCII PowerShell Script`r`n[Console]::OutputEncoding = [System.Text.Encoding]::UTF8`r`n`$OutputEncoding = [System.Text.Encoding]::UTF8`r`n`r`n"
            $cleanContent = $header + $cleanContent
        } elseif ($extension -eq ".bat" -and -not ($cleanContent -match 'chcp 65001')) {
            $cleanContent = $cleanContent -replace '^(@echo off)', "@echo off`r`nchcp 65001 >nul 2>&1"
        }
        
        # Save clean version
        $cleanContent | Out-File -FilePath $cleanPath -Encoding UTF8 -Force
        Write-Host "  [SUCCESS] Clean version created: $cleanPath" -ForegroundColor Green
        
    } catch {
        Write-Host "  [ERROR] Failed to process: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Step 4: Creating test script..." -ForegroundColor Cyan

# Create a simple test using only ASCII
$testContent = @"
# Simple ASCII Test Script
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
`$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "Simple Encoding Test - ASCII Only" -ForegroundColor Green
Write-Host ""

Write-Host "Testing basic output:" -ForegroundColor Cyan
Write-Host "  Text: Hello World 123" -ForegroundColor White
Write-Host "  Symbols: !@#`$%^&*()" -ForegroundColor White
Write-Host "  Status: [OK] [ERROR] [WARNING]" -ForegroundColor White

Write-Host ""
Write-Host "Testing paths:" -ForegroundColor Cyan
if (Test-Path "`$env:USERPROFILE\Downloads") {
    Write-Host "  [OK] Downloads folder accessible" -ForegroundColor Green
} else {
    Write-Host "  [ERROR] Downloads folder not found" -ForegroundColor Red
}

Write-Host ""
Write-Host "Test completed!" -ForegroundColor Green
"@

$testContent | Out-File -FilePath "simple_test.ps1" -Encoding UTF8 -Force
Write-Host "Created: simple_test.ps1" -ForegroundColor Green

Write-Host ""
Write-Host "=====================================================" -ForegroundColor Green
Write-Host "    Simple Encoding Fix Completed!" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Summary:" -ForegroundColor Yellow
Write-Host "- Found $($problemFiles.Count) files with encoding issues" -ForegroundColor White
Write-Host "- Created clean versions with '_clean' suffix" -ForegroundColor White
Write-Host "- All special characters replaced with ASCII alternatives" -ForegroundColor White
Write-Host "- Created 'simple_test.ps1' for verification" -ForegroundColor White
Write-Host ""
Write-Host "Recommended actions:" -ForegroundColor Yellow
Write-Host "1. Run 'simple_test.ps1' to verify the environment" -ForegroundColor White
Write-Host "2. Use the '_clean' versions of scripts" -ForegroundColor White
Write-Host "3. Always work from English-named directories" -ForegroundColor White
Write-Host ""
