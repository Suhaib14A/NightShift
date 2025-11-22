# SightMate Testing Script
# This script helps you test your application step by step

Write-Host "=== SightMate Testing Guide ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check if backend is deployed
Write-Host "Step 1: Checking backend deployment..." -ForegroundColor Yellow
if (Test-Path "backend") {
    Set-Location backend
    Write-Host "Checking CDK stack..." -ForegroundColor Gray
    $stackExists = cdk list 2>&1 | Select-String "SightMateStack"
    if ($stackExists) {
        Write-Host "✅ CDK stack found" -ForegroundColor Green
        Write-Host ""
        Write-Host "To deploy backend, run:" -ForegroundColor Cyan
        Write-Host "  cd backend" -ForegroundColor White
        Write-Host "  cdk bootstrap  # First time only" -ForegroundColor White
        Write-Host "  cdk deploy" -ForegroundColor White
        Write-Host ""
        Write-Host "After deployment, copy the API endpoint URL!" -ForegroundColor Yellow
    } else {
        Write-Host "⚠️  Stack not found. Deploy first." -ForegroundColor Yellow
    }
    Set-Location ..
} else {
    Write-Host "❌ Backend directory not found" -ForegroundColor Red
}

Write-Host ""
Write-Host "Step 2: Update Mobile App Configuration" -ForegroundColor Yellow
Write-Host "After deploying backend:" -ForegroundColor Gray
Write-Host "  1. Open mobile/src/services/api.js" -ForegroundColor White
Write-Host "  2. Replace API_BASE_URL with your endpoint" -ForegroundColor White
Write-Host "  3. Example: https://abc123.execute-api.us-west-2.amazonaws.com/prod" -ForegroundColor Gray
Write-Host ""

Write-Host "Step 3: Test Mobile App" -ForegroundColor Yellow
if (Test-Path "mobile") {
    Write-Host "To test mobile app:" -ForegroundColor Gray
    Write-Host "  cd mobile" -ForegroundColor White
    Write-Host "  npm install" -ForegroundColor White
    Write-Host "  npm run android  # or npm run ios" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "❌ Mobile directory not found" -ForegroundColor Red
}

Write-Host ""
Write-Host "Step 4: Test Features" -ForegroundColor Yellow
Write-Host "In the mobile app, test:" -ForegroundColor Gray
Write-Host "  ✅ Describe Scene - Take photo, get audio description" -ForegroundColor White
Write-Host "  ✅ Read Text - Take photo of text, get audio reading" -ForegroundColor White
Write-Host "  ✅ Voice Command - Speak command, get response" -ForegroundColor White
Write-Host ""

Write-Host "=== Quick Commands ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Deploy backend:" -ForegroundColor Yellow
Write-Host "  cd backend && cdk deploy" -ForegroundColor White
Write-Host ""
Write-Host "Run mobile app:" -ForegroundColor Yellow
Write-Host "  cd mobile && npm run android" -ForegroundColor White
Write-Host ""
Write-Host "Check AWS resources:" -ForegroundColor Yellow
Write-Host "  aws apigateway get-rest-apis --region us-west-2" -ForegroundColor White
Write-Host "  aws lambda list-functions --region us-west-2" -ForegroundColor White
Write-Host ""

Write-Host "For detailed testing guide, see TESTING_GUIDE.md" -ForegroundColor Cyan

