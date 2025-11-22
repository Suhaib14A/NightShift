# Complete fix for Java version and Gradle cache issues

Write-Host "=== Complete Java & Gradle Fix ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check current Java version
Write-Host "1. Checking Java version..." -ForegroundColor Yellow
$javaVersion = java -version 2>&1 | Select-Object -First 1
Write-Host "Current: $javaVersion" -ForegroundColor Gray

if ($javaVersion -match "21\.") {
    Write-Host "⚠️  Java 21 detected - needs Java 17 for React Native 0.72.6" -ForegroundColor Yellow
    Write-Host "`nInstalling Java 17..." -ForegroundColor Cyan
    
    # Install Java 17
    winget install Microsoft.OpenJDK.17 --accept-package-agreements --accept-source-agreements
    
    # Find Java 17
    Start-Sleep -Seconds 3
    $java17Path = Get-ChildItem "C:\Program Files\Microsoft" -Filter "jdk-17*" -Directory -ErrorAction SilentlyContinue | 
                   Sort-Object Name -Descending | Select-Object -First 1
    
    if ($java17Path) {
        $javaHome = $java17Path.FullName
        Write-Host "✅ Found Java 17 at: $javaHome" -ForegroundColor Green
        
        # Set JAVA_HOME
        $env:JAVA_HOME = $javaHome
        $env:Path = "$javaHome\bin;$env:Path"
        
        Write-Host "✅ Java 17 configured for this session" -ForegroundColor Green
        Write-Host "`nVerifying..." -ForegroundColor Yellow
        java -version
    } else {
        Write-Host "❌ Java 17 not found. Please install manually:" -ForegroundColor Red
        Write-Host "   winget install Microsoft.OpenJDK.17" -ForegroundColor Yellow
        exit 1
    }
} elseif ($javaVersion -match "17\.") {
    Write-Host "✅ Java 17 already in use" -ForegroundColor Green
} else {
    Write-Host "⚠️  Unknown Java version. Proceeding anyway..." -ForegroundColor Yellow
}

# Step 2: Clean ALL Gradle caches
Write-Host "`n2. Cleaning Gradle caches..." -ForegroundColor Yellow
$gradleCache = "$env:USERPROFILE\.gradle\caches"
if (Test-Path $gradleCache) {
    # Remove old Gradle version caches
    Get-ChildItem $gradleCache -Directory -Filter "8.*" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "✅ Cleaned old Gradle caches" -ForegroundColor Green
} else {
    Write-Host "No Gradle cache found" -ForegroundColor Gray
}

# Step 3: Verify Gradle wrapper version
Write-Host "`n3. Checking Gradle wrapper..." -ForegroundColor Yellow
$gradleProps = Get-Content "android\gradle\wrapper\gradle-wrapper.properties" -Raw
if ($gradleProps -match "gradle-8\.5") {
    Write-Host "✅ Gradle 8.5 configured" -ForegroundColor Green
} else {
    Write-Host "⚠️  Gradle version may need update" -ForegroundColor Yellow
}

# Step 4: Clean Android build
Write-Host "`n4. Cleaning Android build..." -ForegroundColor Yellow
Set-Location android
.\gradlew.bat clean 2>&1 | Out-Null
Set-Location ..
Write-Host "✅ Build cleaned" -ForegroundColor Green

# Step 5: Set ADB PATH
Write-Host "`n5. Setting ADB PATH..." -ForegroundColor Yellow
$sdkPath = "$env:LOCALAPPDATA\Android\Sdk"
$env:Path += ";$sdkPath\platform-tools"
Write-Host "✅ ADB configured" -ForegroundColor Green

Write-Host "`n=== Ready to Build ===" -ForegroundColor Cyan
Write-Host "`nNext: npm run android" -ForegroundColor Yellow
Write-Host "`nNote: Java 17 is set for THIS SESSION only." -ForegroundColor Gray
Write-Host "To make permanent, set JAVA_HOME in System Environment Variables." -ForegroundColor Gray

