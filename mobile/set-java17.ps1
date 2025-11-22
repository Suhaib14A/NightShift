# Quick script to set Java 17 for React Native builds
# Run this BEFORE npm run android

Write-Host "Setting Java 17 for React Native..." -ForegroundColor Yellow

$java17Path = "C:\Program Files\Microsoft\jdk-17.0.17.10-hotspot"

if (Test-Path $java17Path) {
    $env:JAVA_HOME = $java17Path
    $env:Path = "$java17Path\bin;$env:Path"
    
    Write-Host "✅ Java 17 configured" -ForegroundColor Green
    Write-Host "`nVerifying..." -ForegroundColor Gray
    java -version
    
    Write-Host "`n✅ Ready! Now run: npm run android" -ForegroundColor Cyan
} else {
    Write-Host "❌ Java 17 not found at: $java17Path" -ForegroundColor Red
    Write-Host "`nInstalling Java 17..." -ForegroundColor Yellow
    winget install Microsoft.OpenJDK.17
    Write-Host "`nAfter installation, run this script again." -ForegroundColor Yellow
}

