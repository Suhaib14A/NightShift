# Mobile App Setup - Quick Reference

## PATH Issue Fix

If you get "npm is not recognized", refresh PATH in PowerShell:

```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

Or use the helper script:
```powershell
.\run-app.ps1
```

## Quick Start

### Option 1: Use Helper Script (Easiest)

```powershell
.\run-app.ps1
```

### Option 2: Manual Steps

**1. Refresh PATH (if needed):**
```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

**2. Install dependencies:**
```powershell
npm install
```

**3. Run Android:**
```powershell
npm run android
```

**4. Run iOS (macOS only):**
```powershell
cd ios
pod install
cd ..
npm run ios
```

## Dependencies Installed ✅

Your dependencies are already installed! You can now run the app.

## Next Steps

1. **For Android:**
   - Make sure Android Studio is installed
   - Start an Android emulator OR connect a physical device
   - Run: `npm run android`

2. **For iOS (macOS only):**
   - Make sure Xcode is installed
   - Run: `cd ios && pod install && cd ..`
   - Run: `npm run ios`

## Troubleshooting

**"npm is not recognized":**
- Refresh PATH (see above)
- Close and reopen PowerShell
- Verify Node.js is installed: `node --version`

**"react-native: command not found":**
- Run `npm install` again
- Check you're in the `mobile` directory

**Build errors:**
- For Android: Check Android SDK is installed
- For iOS: Check Xcode and CocoaPods are installed
- Check React Native setup: https://reactnative.dev/docs/environment-setup

## API Endpoint

Your app is configured to use:
```
https://4pov2vc0o8.execute-api.us-west-2.amazonaws.com/prod
```

This is set in `src/services/api.js`

