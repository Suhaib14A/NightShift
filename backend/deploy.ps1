# PowerShell script to deploy SightMate with environment variables
# This script sets up the environment and deploys the CDK stack

Write-Host "Setting up AWS credentials from environment variables..." -ForegroundColor Green

# Set region if not already set
if (-not $Env:AWS_DEFAULT_REGION) {
    $Env:AWS_DEFAULT_REGION = "us-west-2"
}

# Verify credentials are set
if (-not $Env:AWS_ACCESS_KEY_ID) {
    Write-Host "ERROR: AWS_ACCESS_KEY_ID not set!" -ForegroundColor Red
    exit 1
}

if (-not $Env:AWS_SECRET_ACCESS_KEY) {
    Write-Host "ERROR: AWS_SECRET_ACCESS_KEY not set!" -ForegroundColor Red
    exit 1
}

# Verify credentials work
Write-Host "Verifying AWS credentials..." -ForegroundColor Yellow
$identity = aws sts get-caller-identity 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to verify AWS credentials!" -ForegroundColor Red
    Write-Host $identity
    exit 1
}

Write-Host "Credentials verified!" -ForegroundColor Green
Write-Host $identity

# Check if session token is set (temporary credentials)
if ($Env:AWS_SESSION_TOKEN) {
    Write-Host "`nWARNING: Using temporary credentials (session token)" -ForegroundColor Yellow
    Write-Host "These credentials will expire. Make sure to refresh them before they expire." -ForegroundColor Yellow
}

Write-Host "`nRegion: $Env:AWS_DEFAULT_REGION" -ForegroundColor Cyan
Write-Host "Account: $(($identity | ConvertFrom-Json).Account)" -ForegroundColor Cyan

# Navigate to backend directory
Set-Location $PSScriptRoot

# Install dependencies if needed
if (-not (Test-Path "node_modules")) {
    Write-Host "`nInstalling dependencies..." -ForegroundColor Yellow
    npm install
}

# Bootstrap CDK (if needed)
Write-Host "`nBootstrapping CDK (if needed)..." -ForegroundColor Yellow
cdk bootstrap

# Deploy
Write-Host "`nDeploying SightMate stack..." -ForegroundColor Yellow
cdk deploy

