# Quick script to check and connect Android device

Write-Host "=== Android Device Connection Helper ===" -ForegroundColor Cyan
Write-Host ""

# Refresh PATH
$sdkPath = "$env:LOCALAPPDATA\Android\Sdk"
$env:Path += ";$sdkPath\platform-tools"

Write-Host "Checking ADB..." -ForegroundColor Yellow
try {
    $adbVersion = adb --version 2>&1 | Select-Object -First 1
    Write-Host "✅ ADB found: $adbVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ ADB not found. Make sure Android SDK is installed." -ForegroundColor Red
    exit 1
}

Write-Host "`nChecking for connected devices..." -ForegroundColor Yellow
Write-Host ""

# Kill and restart ADB server to refresh
adb kill-server 2>&1 | Out-Null
Start-Sleep -Seconds 1
adb start-server 2>&1 | Out-Null

$devices = adb devices
Write-Host $devices

Write-Host ""

if ($devices -match "device\s*$") {
    Write-Host "✅ Device connected and authorized!" -ForegroundColor Green
    Write-Host "`nYou can now run: npm run android" -ForegroundColor Cyan
} elseif ($devices -match "unauthorized") {
    Write-Host "⚠️  Device found but unauthorized" -ForegroundColor Yellow
    Write-Host "`nOn your phone:" -ForegroundColor Cyan
    Write-Host "1. Look for 'Allow USB debugging?' popup" -ForegroundColor White
    Write-Host "2. Check 'Always allow from this computer'" -ForegroundColor White
    Write-Host "3. Tap 'Allow'" -ForegroundColor White
    Write-Host "`nThen run this script again." -ForegroundColor Gray
} else {
    Write-Host "❌ No device found" -ForegroundColor Red
    Write-Host "`nTroubleshooting steps:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. Enable Developer Options:" -ForegroundColor Cyan
    Write-Host "   Settings → About Phone → Tap Build Number 7 times" -ForegroundColor White
    Write-Host ""
    Write-Host "2. Enable USB Debugging:" -ForegroundColor Cyan
    Write-Host "   Settings → Developer Options → Enable USB Debugging" -ForegroundColor White
    Write-Host ""
    Write-Host "3. Connect phone via USB" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "4. On phone, tap 'Allow' when USB debugging popup appears" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "5. Try different USB cable or port" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Run this script again after connecting." -ForegroundColor Gray
}

Write-Host "`nTo check again, run: .\connect-device.ps1" -ForegroundColor Gray

