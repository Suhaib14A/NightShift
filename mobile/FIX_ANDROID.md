# Fix Android Setup - Quick Guide

## Current Issues

React Native doctor found:
- ❌ ADB not in PATH
- ❌ Android SDK not configured
- ❌ ANDROID_HOME not set
- ❌ No Android emulator/device

## Quick Fix Options

### Option 1: Set Up Android SDK (If Android Studio is Installed)

If you have Android Studio installed, we just need to configure it:

```powershell
# Find Android SDK location (usually in AppData)
$sdkPath = "$env:LOCALAPPDATA\Android\Sdk"

# Set ANDROID_HOME permanently
[System.Environment]::SetEnvironmentVariable("ANDROID_HOME", $sdkPath, "User")
[System.Environment]::SetEnvironmentVariable("ANDROID_SDK_ROOT", $sdkPath, "User")

# Add to PATH
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
$newPath = "$currentPath;$sdkPath\platform-tools;$sdkPath\tools;$sdkPath\tools\bin"
[System.Environment]::SetEnvironmentVariable("Path", $newPath, "User")

# Refresh current session
$env:ANDROID_HOME = $sdkPath
$env:ANDROID_SDK_ROOT = $sdkPath
$env:Path += ";$sdkPath\platform-tools;$sdkPath\tools"
```

Then close and reopen PowerShell, then verify:
```powershell
adb --version
```

### Option 2: Initialize Complete Android Project

The Android project structure is incomplete. We need to generate it:

```powershell
cd mobile

# Option A: Use React Native CLI to generate Android project
npx react-native init TempProject --skip-install
# Copy android folder from TempProject to mobile
# Then delete TempProject

# Option B: Use Expo (easier, but requires code changes)
npx create-expo-app --template blank
# Then migrate your code
```

### Option 3: Use Expo Go (Easiest for Testing)

Convert to Expo for easier testing without full Android setup:

1. Install Expo CLI:
```powershell
npm install -g expo-cli
```

2. Initialize Expo project:
```powershell
cd mobile
npx create-expo-app@latest . --template blank
```

3. Install Expo Go on your phone from Play Store

4. Run:
```powershell
npx expo start
```

5. Scan QR code with Expo Go app

## Recommended: Complete Android Setup

### Step 1: Install Android Studio (if not installed)

1. Download: https://developer.android.com/studio
2. Install with Android SDK
3. Open Android Studio → SDK Manager
4. Install:
   - Android SDK Platform 33
   - Android SDK Build-Tools
   - Android Emulator

### Step 2: Create AVD (Android Virtual Device)

1. Android Studio → Tools → Device Manager
2. Create Device → Pixel 5
3. Download system image (Android 13)
4. Finish

### Step 3: Set Environment Variables

Run the PowerShell commands from Option 1 above.

### Step 4: Initialize Android Project

Since the Android folder is incomplete, regenerate it:

```powershell
cd mobile

# Backup your src folder
Copy-Item -Path "src" -Destination "src_backup" -Recurse

# Create new React Native project (will generate Android/iOS)
npx react-native init SightMateNew --skip-install

# Copy Android folder
Copy-Item -Path "SightMateNew\android" -Destination "android" -Recurse -Force

# Restore your src folder
Remove-Item -Path "src" -Recurse
Copy-Item -Path "src_backup" -Destination "src" -Recurse

# Clean up
Remove-Item -Path "SightMateNew" -Recurse
Remove-Item -Path "src_backup" -Recurse
```

### Step 5: Test

```powershell
# Start emulator from Android Studio first, then:
npm run android
```

## Quick Test: Use Physical Device

If you have an Android phone:

1. Enable Developer Options:
   - Settings → About Phone → Tap Build Number 7 times
   - Settings → Developer Options → Enable USB Debugging

2. Connect phone via USB

3. Verify:
```powershell
adb devices
```

4. Run app:
```powershell
npm run android
```

## Alternative: Test API Without Mobile App

While setting up Android, you can test the backend API:

```powershell
# Test the deployed API
$testBody = @{
    text = "describe"
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://4pov2vc0o8.execute-api.us-west-2.amazonaws.com/prod/voice-command" -Method Post -Body $testBody -ContentType "application/json"
```

## Next Steps

1. **If Android Studio is installed:** Run the environment variable setup (Option 1)
2. **If not installed:** Install Android Studio first
3. **For quick testing:** Consider Expo Go (Option 3)
4. **For production:** Complete Android setup (Recommended section)

