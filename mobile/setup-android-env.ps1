# Setup Android Environment Variables
# Run this script to configure Android SDK for React Native

Write-Host "Setting up Android environment..." -ForegroundColor Yellow

$sdkPath = "$env:LOCALAPPDATA\Android\Sdk"

if (-not (Test-Path $sdkPath)) {
    Write-Host "ERROR: Android SDK not found at $sdkPath" -ForegroundColor Red
    Write-Host "Please install Android Studio first: https://developer.android.com/studio" -ForegroundColor Yellow
    exit 1
}

Write-Host "Android SDK found at: $sdkPath" -ForegroundColor Green

# Set environment variables for current session
$env:ANDROID_HOME = $sdkPath
$env:ANDROID_SDK_ROOT = $sdkPath
$env:Path += ";$sdkPath\platform-tools;$sdkPath\tools;$sdkPath\tools\bin"

# Set permanently for user
[System.Environment]::SetEnvironmentVariable("ANDROID_HOME", $sdkPath, "User")
[System.Environment]::SetEnvironmentVariable("ANDROID_SDK_ROOT", $sdkPath, "User")

# Add to PATH permanently
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$sdkPath\platform-tools*") {
    $newPath = "$currentPath;$sdkPath\platform-tools;$sdkPath\tools;$sdkPath\tools\bin"
    [System.Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "Added Android SDK to PATH permanently" -ForegroundColor Green
} else {
    Write-Host "Android SDK already in PATH" -ForegroundColor Gray
}

Write-Host "`nVerifying setup..." -ForegroundColor Yellow

# Check ADB
if (Test-Path "$sdkPath\platform-tools\adb.exe") {
    $adbVersion = & "$sdkPath\platform-tools\adb.exe" version
    Write-Host "✅ ADB found: $($adbVersion[0])" -ForegroundColor Green
} else {
    Write-Host "⚠️  ADB not found. Install Android SDK Platform-Tools in Android Studio" -ForegroundColor Yellow
}

Write-Host "`n✅ Environment variables set!" -ForegroundColor Green
Write-Host "`nIMPORTANT: Close and reopen PowerShell for changes to take effect permanently." -ForegroundColor Yellow
Write-Host "Or continue in this session - variables are set for now." -ForegroundColor Gray

Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "1. Close and reopen PowerShell (or continue in this session)" -ForegroundColor White
Write-Host "2. Verify: adb --version" -ForegroundColor White
Write-Host "3. Start Android emulator OR connect physical device" -ForegroundColor White
Write-Host "4. Run: npm run android" -ForegroundColor White

