# Helper script to run React Native app with PATH refresh
# This ensures Node.js and npm are available

Write-Host "Refreshing PATH..." -ForegroundColor Yellow
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host "Checking Node.js..." -ForegroundColor Yellow
$nodeVersion = node --version
$npmVersion = npm --version
Write-Host "Node.js: $nodeVersion" -ForegroundColor Green
Write-Host "npm: $npmVersion" -ForegroundColor Green

Write-Host "`nInstalling dependencies (if needed)..." -ForegroundColor Yellow
if (-not (Test-Path "node_modules")) {
    npm install
} else {
    Write-Host "Dependencies already installed" -ForegroundColor Gray
}

Write-Host "`nStarting React Native..." -ForegroundColor Yellow
Write-Host "Choose platform:" -ForegroundColor Cyan
Write-Host "  1. Android" -ForegroundColor White
Write-Host "  2. iOS (macOS only)" -ForegroundColor White
Write-Host "  3. Start Metro bundler only" -ForegroundColor White

$choice = Read-Host "Enter choice (1-3)"

switch ($choice) {
    "1" {
        Write-Host "`nStarting Android app..." -ForegroundColor Green
        npm run android
    }
    "2" {
        Write-Host "`nStarting iOS app..." -ForegroundColor Green
        if (-not (Test-Path "ios/Pods")) {
            Write-Host "Installing CocoaPods..." -ForegroundColor Yellow
            cd ios
            pod install
            cd ..
        }
        npm run ios
    }
    "3" {
        Write-Host "`nStarting Metro bundler..." -ForegroundColor Green
        npm start
    }
    default {
        Write-Host "Invalid choice. Starting Metro bundler..." -ForegroundColor Yellow
        npm start
    }
}

