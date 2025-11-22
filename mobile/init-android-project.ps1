# Initialize Complete Android Project Structure
# This script generates the missing Android project files

Write-Host "Initializing Android project structure..." -ForegroundColor Yellow

$projectRoot = $PSScriptRoot
$tempProject = "$projectRoot\TempRNProject"

# Check if we're in the right directory
if (-not (Test-Path "$projectRoot\package.json")) {
    Write-Host "ERROR: Must run from mobile directory!" -ForegroundColor Red
    exit 1
}

Write-Host "Step 1: Backing up your source code..." -ForegroundColor Cyan
if (Test-Path "$projectRoot\src") {
    Copy-Item -Path "$projectRoot\src" -Destination "$projectRoot\src_backup" -Recurse -Force
    Write-Host "✅ Source code backed up" -ForegroundColor Green
}

Write-Host "`nStep 2: Creating temporary React Native project..." -ForegroundColor Cyan
Write-Host "This will generate the complete Android/iOS structure" -ForegroundColor Gray

# Create new React Native project (this will generate Android folder)
npx react-native init TempRNProject --skip-install --version 0.72.6

if (-not (Test-Path "$tempProject\android")) {
    Write-Host "ERROR: Failed to generate Android project" -ForegroundColor Red
    if (Test-Path "$projectRoot\src_backup") {
        Remove-Item -Path "$projectRoot\src_backup" -Recurse -Force
    }
    exit 1
}

Write-Host "✅ Android project generated" -ForegroundColor Green

Write-Host "`nStep 3: Copying Android project structure..." -ForegroundColor Cyan
# Remove old incomplete android folder
if (Test-Path "$projectRoot\android") {
    Remove-Item -Path "$projectRoot\android" -Recurse -Force
}

# Copy complete Android folder
Copy-Item -Path "$tempProject\android" -Destination "$projectRoot\android" -Recurse -Force
Write-Host "✅ Android folder copied" -ForegroundColor Green

Write-Host "`nStep 4: Restoring your source code..." -ForegroundColor Cyan
if (Test-Path "$projectRoot\src_backup") {
    Remove-Item -Path "$projectRoot\src" -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "$projectRoot\src_backup" -Destination "$projectRoot\src" -Recurse -Force
    Remove-Item -Path "$projectRoot\src_backup" -Recurse -Force
    Write-Host "✅ Source code restored" -ForegroundColor Green
}

Write-Host "`nStep 5: Updating Android package name..." -ForegroundColor Cyan
# Update package name in Android files to match app.json
$appName = (Get-Content "$projectRoot\app.json" | ConvertFrom-Json).name
$packageName = "com.$($appName.ToLower())"

# Update AndroidManifest.xml
$manifestPath = "$projectRoot\android\app\src\main\AndroidManifest.xml"
if (Test-Path $manifestPath) {
    $manifest = Get-Content $manifestPath -Raw
    $manifest = $manifest -replace 'package="[^"]*"', "package=`"$packageName`""
    Set-Content -Path $manifestPath -Value $manifest
    Write-Host "✅ Updated package name to $packageName" -ForegroundColor Green
}

Write-Host "`nStep 6: Cleaning up..." -ForegroundColor Cyan
Remove-Item -Path $tempProject -Recurse -Force
Write-Host "✅ Cleanup complete" -ForegroundColor Green

Write-Host "`n✅ Android project initialized successfully!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "1. Start Android emulator OR connect physical device" -ForegroundColor White
Write-Host "2. Run: npm run android" -ForegroundColor White

