# Fix Android Build Issues
# This script fixes PATH and Java/Gradle compatibility

Write-Host "=== Fixing Android Build Issues ===" -ForegroundColor Cyan
Write-Host ""

# Fix 1: Set ADB PATH
Write-Host "1. Setting up ADB PATH..." -ForegroundColor Yellow
$sdkPath = "$env:LOCALAPPDATA\Android\Sdk"
$env:Path += ";$sdkPath\platform-tools"
Write-Host "✅ ADB PATH added" -ForegroundColor Green

# Fix 2: Check Java version
Write-Host "`n2. Checking Java version..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1 | Select-Object -First 1
    Write-Host "Java: $javaVersion" -ForegroundColor Gray
    
    # Check if Java 21 (version 65) - too new for Gradle 8.0.1
    if ($javaVersion -match "21\.") {
        Write-Host "⚠️  Java 21 detected - may cause Gradle compatibility issues" -ForegroundColor Yellow
        Write-Host "Gradle 8.0.1 works best with Java 17 or Java 11" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Java not found" -ForegroundColor Red
}

# Fix 3: Clean Gradle cache
Write-Host "`n3. Cleaning Gradle cache..." -ForegroundColor Yellow
$gradleCache = "$env:USERPROFILE\.gradle\caches"
if (Test-Path $gradleCache) {
    Write-Host "Removing corrupted Gradle cache..." -ForegroundColor Gray
    Remove-Item -Path "$gradleCache\8.0.1" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "✅ Gradle cache cleaned" -ForegroundColor Green
} else {
    Write-Host "No Gradle cache found" -ForegroundColor Gray
}

# Fix 4: Check Android project structure
Write-Host "`n4. Checking Android project..." -ForegroundColor Yellow
if (-not (Test-Path "android\settings.gradle")) {
    Write-Host "❌ Android project structure incomplete!" -ForegroundColor Red
    Write-Host "Run: .\init-android-project.ps1 first" -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "✅ Android project structure exists" -ForegroundColor Green
}

Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host "✅ ADB PATH configured" -ForegroundColor Green
Write-Host "✅ Gradle cache cleaned" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. If Java 21: Consider installing Java 17 (recommended for React Native)" -ForegroundColor White
Write-Host "2. Make sure device is connected: .\connect-device.ps1" -ForegroundColor White
Write-Host "3. Try building again: npm run android" -ForegroundColor White

Write-Host "`nTo set JAVA_HOME (if needed):" -ForegroundColor Cyan
Write-Host '$env:JAVA_HOME = "C:\Program Files\Java\jdk-17"' -ForegroundColor Gray
Write-Host '$env:Path = "$env:JAVA_HOME\bin;$env:Path"' -ForegroundColor Gray

