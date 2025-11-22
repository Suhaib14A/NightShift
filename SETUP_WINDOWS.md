# Windows Setup Guide for SightMate

This guide will help you install all prerequisites on Windows.

## Step 1: Install Node.js

Node.js includes `npm` (Node Package Manager).

### Option A: Using Chocolatey (Recommended)

If you have Chocolatey installed:
```powershell
choco install nodejs
```

### Option B: Manual Installation

1. Go to https://nodejs.org/
2. Download the LTS (Long Term Support) version for Windows
3. Run the installer (.msi file)
4. Follow the installation wizard
5. **Important**: Check the box to "Add to PATH" during installation

### Option C: Using winget (Windows 10/11)

```powershell
winget install OpenJS.NodeJS.LTS
```

### Verify Installation

After installation, **close and reopen PowerShell**, then run:

```powershell
node --version
npm --version
```

You should see version numbers (e.g., `v18.17.0` and `9.6.7`).

## Step 2: Install AWS CDK

Once Node.js is installed, install AWS CDK globally:

```powershell
npm install -g aws-cdk
```

### Verify CDK Installation

```powershell
cdk --version
```

You should see a version number (e.g., `2.100.0`).

## Step 3: Install AWS CLI (Optional but Recommended)

For deploying to AWS, you'll need AWS credentials configured.

### Option A: Using winget

```powershell
winget install Amazon.AWSCLI
```

### Option B: Using MSI Installer

1. Download from: https://aws.amazon.com/cli/
2. Run the installer
3. Configure with: `aws configure`

## Step 4: Verify Everything is Ready

Run these commands to verify:

```powershell
node --version
npm --version
cdk --version
aws --version  # If you installed AWS CLI
```

## Step 5: Continue with SightMate Setup

Once all tools are installed, you can proceed:

```powershell
# Navigate to backend directory
cd backend

# Install dependencies
npm install

# Bootstrap CDK (first time only)
cdk bootstrap

# Deploy
cdk deploy
```

## Troubleshooting

### "npm is not recognized" after installing Node.js

1. Close and reopen PowerShell/Command Prompt
2. If still not working, add Node.js to PATH manually:
   - Find where Node.js was installed (usually `C:\Program Files\nodejs\`)
   - Add it to System Environment Variables PATH

### "cdk is not recognized" after installing

1. Make sure you installed it globally: `npm install -g aws-cdk`
2. Close and reopen PowerShell
3. Verify with: `cdk --version`

### Permission Errors

If you get permission errors, run PowerShell as Administrator:
1. Right-click PowerShell
2. Select "Run as Administrator"
3. Try the command again

## Next Steps

After installing prerequisites, see `QUICKSTART.md` for the next steps.

