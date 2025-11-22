# Install and configure Java 17 for React Native

Write-Host "=== Installing Java 17 for React Native ===" -ForegroundColor Cyan
Write-Host ""

# Install Java 17
Write-Host "Installing Java 17..." -ForegroundColor Yellow
winget install Microsoft.OpenJDK.17

Write-Host "`nFinding Java 17 installation..." -ForegroundColor Yellow
$java17Path = Get-ChildItem "C:\Program Files\Microsoft" -Filter "jdk-17*" -Directory -ErrorAction SilentlyContinue | Select-Object -First 1

if ($java17Path) {
    $javaHome = $java17Path.FullName
    Write-Host "✅ Found Java 17 at: $javaHome" -ForegroundColor Green
    
    # Set for current session
    $env:JAVA_HOME = $javaHome
    $env:Path = "$javaHome\bin;$env:Path"
    
    Write-Host "`nVerifying Java version..." -ForegroundColor Yellow
    java -version
    
    Write-Host "`n✅ Java 17 configured!" -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Cyan
    Write-Host "1. Clean build: cd android && .\gradlew.bat clean && cd .." -ForegroundColor White
    Write-Host "2. Run app: npm run android" -ForegroundColor White
} else {
    Write-Host "❌ Java 17 not found. Please install manually:" -ForegroundColor Red
    Write-Host "   winget install Microsoft.OpenJDK.17" -ForegroundColor Yellow
    Write-Host "   Then run this script again." -ForegroundColor Yellow
}
