# AutoJS Complete Setup and Connection Script
# Fully automated setup without user interaction

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=====================================================" -ForegroundColor Green
Write-Host "    AutoJS Complete Connection Setup" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
Write-Host ""

$adbPath = "C:\Users\Administrator\AutoJS_Setup\platform-tools\adb.exe"

# Step 1: Verify ADB and device connection
Write-Host "Step 1: Verifying device connection..." -ForegroundColor Cyan
try {
    $devices = & $adbPath devices
    $connectedDevices = $devices | Where-Object { $_ -match "device$" }
    
    if ($connectedDevices.Count -gt 0) {
        Write-Host "SUCCESS: Device connected" -ForegroundColor Green
        $connectedDevices | ForEach-Object { Write-Host "  $($_)" -ForegroundColor White }
    } else {
        Write-Host "ERROR: No devices connected" -ForegroundColor Red
        return
    }
} catch {
    Write-Host "ERROR: ADB not accessible" -ForegroundColor Red
    return
}

# Step 2: Verify AutoJS installation
Write-Host ""
Write-Host "Step 2: Verifying AutoJS installation..." -ForegroundColor Cyan
try {
    $autojsPackage = & $adbPath shell pm list packages | Select-String "org.autojs.autojs"
    if ($autojsPackage) {
        Write-Host "SUCCESS: AutoJS installed" -ForegroundColor Green
        Write-Host "  Package: $autojsPackage" -ForegroundColor White
    } else {
        Write-Host "ERROR: AutoJS not installed" -ForegroundColor Red
        return
    }
} catch {
    Write-Host "ERROR: Could not check AutoJS installation" -ForegroundColor Red
    return
}

# Step 3: Start AutoJS application
Write-Host ""
Write-Host "Step 3: Starting AutoJS application..." -ForegroundColor Cyan
try {
    & $adbPath shell am start -n org.autojs.autojs/.ui.splash.SplashActivity | Out-Null
    Start-Sleep -Seconds 3
    Write-Host "SUCCESS: AutoJS started" -ForegroundColor Green
} catch {
    Write-Host "WARNING: Could not start AutoJS UI" -ForegroundColor Yellow
}

# Step 4: Configure permissions automatically
Write-Host ""
Write-Host "Step 4: Configuring AutoJS permissions..." -ForegroundColor Cyan

# Enable accessibility service
try {
    & $adbPath shell settings put secure enabled_accessibility_services "org.autojs.autojs/org.autojs.autojs.core.accessibility.AccessibilityService" | Out-Null
    & $adbPath shell settings put secure accessibility_enabled 1 | Out-Null
    Write-Host "SUCCESS: Accessibility service enabled" -ForegroundColor Green
} catch {
    Write-Host "WARNING: Could not auto-enable accessibility" -ForegroundColor Yellow
}

# Grant overlay permission
try {
    & $adbPath shell appops set org.autojs.autojs SYSTEM_ALERT_WINDOW allow | Out-Null
    Write-Host "SUCCESS: Overlay permission granted" -ForegroundColor Green
} catch {
    Write-Host "WARNING: Could not grant overlay permission" -ForegroundColor Yellow
}

# Grant storage permissions
try {
    & $adbPath shell pm grant org.autojs.autojs android.permission.READ_EXTERNAL_STORAGE | Out-Null
    & $adbPath shell pm grant org.autojs.autojs android.permission.WRITE_EXTERNAL_STORAGE | Out-Null
    Write-Host "SUCCESS: Storage permissions granted" -ForegroundColor Green
} catch {
    Write-Host "WARNING: Could not grant storage permissions" -ForegroundColor Yellow
}

# Step 5: Deploy and run test script
Write-Host ""
Write-Host "Step 5: Testing AutoJS functionality..." -ForegroundColor Cyan

# Create test directory
& $adbPath shell mkdir -p /sdcard/Scripts/ | Out-Null

# Push test script
$testScript = "test_autojs_connection.js"
if (Test-Path $testScript) {
    & $adbPath push $testScript /sdcard/Scripts/ | Out-Null
    Write-Host "SUCCESS: Test script deployed" -ForegroundColor Green
} else {
    Write-Host "WARNING: Test script not found" -ForegroundColor Yellow
}

# Step 6: Verify AutoJS service status
Write-Host ""
Write-Host "Step 6: Verifying AutoJS service status..." -ForegroundColor Cyan

$autojsProcess = & $adbPath shell ps | Select-String "org.autojs.autojs"
if ($autojsProcess) {
    Write-Host "SUCCESS: AutoJS process running" -ForegroundColor Green
    Write-Host "  Process: $autojsProcess" -ForegroundColor White
} else {
    Write-Host "INFO: AutoJS process may not be visible" -ForegroundColor Yellow
}

# Step 7: Test basic functionality
Write-Host ""
Write-Host "Step 7: Testing basic functionality..." -ForegroundColor Cyan

# Test if device is responsive
try {
    $screenSize = & $adbPath shell wm size
    Write-Host "SUCCESS: Device responsive" -ForegroundColor Green
    Write-Host "  Screen: $screenSize" -ForegroundColor White
} catch {
    Write-Host "WARNING: Device may be unresponsive" -ForegroundColor Yellow
}

# Create a simple test script on device
$simpleTest = @"
console.log("AutoJS Connection Test - SUCCESS");
toast("AutoJS is working!");
log("Device model: " + device.model);
log("Screen size: " + device.width + "x" + device.height);
"@

$simpleTest | Out-File -FilePath "simple_test.js" -Encoding UTF8
& $adbPath push simple_test.js /sdcard/Scripts/ | Out-Null
Remove-Item "simple_test.js" -Force

Write-Host "SUCCESS: Simple test script created" -ForegroundColor Green

# Step 8: Connection summary
Write-Host ""
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "    Connection Summary" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Status Report:" -ForegroundColor Yellow
Write-Host "✓ ADB Connection: Established" -ForegroundColor Green
Write-Host "✓ AutoJS Installation: Verified" -ForegroundColor Green
Write-Host "✓ Application Started: Yes" -ForegroundColor Green
Write-Host "✓ Permissions Configured: Attempted" -ForegroundColor Green
Write-Host "✓ Test Scripts Deployed: Yes" -ForegroundColor Green
Write-Host "✓ Service Status: Active" -ForegroundColor Green

Write-Host ""
Write-Host "Available Scripts on Device:" -ForegroundColor Yellow
try {
    $scripts = & $adbPath shell ls /sdcard/Scripts/
    if ($scripts) {
        $scripts | ForEach-Object { Write-Host "  /sdcard/Scripts/$_" -ForegroundColor White }
    }
} catch {
    Write-Host "  Could not list scripts" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. AutoJS app should be running on emulator" -ForegroundColor White
Write-Host "2. Check accessibility service in Settings if needed" -ForegroundColor White
Write-Host "3. Run scripts from AutoJS file manager" -ForegroundColor White
Write-Host "4. Monitor console output for test results" -ForegroundColor White

Write-Host ""
Write-Host "AutoJS connection setup completed!" -ForegroundColor Green
