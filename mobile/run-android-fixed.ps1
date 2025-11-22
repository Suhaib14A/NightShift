# Run Android with all fixes applied

Write-Host "=== Running Android App (Fixed) ===" -ForegroundColor Cyan
Write-Host ""

# Fix 1: Set ADB PATH
$sdkPath = "$env:LOCALAPPDATA\Android\Sdk"
$env:Path += ";$sdkPath\platform-tools"

# Fix 2: Clean Gradle cache (remove corrupted cache)
Write-Host "Cleaning Gradle cache..." -ForegroundColor Yellow
$gradleCache = "$env:USERPROFILE\.gradle\caches\8.0.1"
if (Test-Path $gradleCache) {
    Remove-Item -Path $gradleCache -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "✅ Cleaned old Gradle cache" -ForegroundColor Green
}

# Fix 3: Check device
Write-Host "`nChecking for connected device..." -ForegroundColor Yellow
$devices = adb devices 2>&1
if ($devices -match "device\s*$") {
    Write-Host "✅ Device connected" -ForegroundColor Green
} else {
    Write-Host "⚠️  No device found. Make sure device is connected and authorized." -ForegroundColor Yellow
    Write-Host "Run: .\connect-device.ps1" -ForegroundColor Gray
}

Write-Host "`nStarting React Native..." -ForegroundColor Yellow
Write-Host ""

# Run the app
npm run android

