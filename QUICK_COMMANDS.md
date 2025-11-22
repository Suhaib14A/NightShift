# Quick Commands Reference

## Important: Always Run from Correct Directory!

### Mobile App Commands
**Must be in `mobile` directory:**
```powershell
cd mobile
npm run android
```

### Backend Commands
**Must be in `backend` directory:**
```powershell
cd backend
cdk deploy
```

## Common Mistake

❌ **Wrong:**
```powershell
# In root directory (NightShift)
npm run android  # ERROR: No package.json here!
```

✅ **Correct:**
```powershell
# Navigate to mobile first
cd mobile
npm run android
```

## Quick Navigation

```powershell
# From root to mobile
cd mobile

# From root to backend  
cd backend

# Back to root
cd ..
```

## All Commands by Directory

### Root Directory (`NightShift/`)
- No npm commands here!
- Just navigation

### Mobile Directory (`mobile/`)
```powershell
cd mobile
npm install          # Install dependencies
npm run android      # Run Android app
npm run ios          # Run iOS app (macOS only)
npm start            # Start Metro bundler
.\connect-device.ps1 # Check device connection
.\run-android-fixed.ps1 # Run with fixes
```

### Backend Directory (`backend/`)
```powershell
cd backend
npm install          # Install dependencies
cdk bootstrap        # Bootstrap CDK (first time)
cdk deploy           # Deploy to AWS
cdk destroy          # Remove all resources
```

## Quick Fix Script

If you're not sure where you are:

```powershell
# Check current directory
pwd

# Navigate to mobile
cd C:\Users\suhai\Documents\NightShift\mobile

# Then run commands
npm run android
```

