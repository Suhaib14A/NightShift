# Android Setup Guide for SightMate

## Current Issue

You're missing:
1. **Android SDK/ADB** - Android Debug Bridge not in PATH
2. **Android Emulator** - No emulator configured
3. **Gradle wrapper** - Android build tools not set up

## Solution Options

### Option 1: Set Up Android Development Environment (Recommended)

#### Step 1: Install Android Studio

1. Download from: https://developer.android.com/studio
2. Install Android Studio
3. During installation, make sure to install:
   - Android SDK
   - Android SDK Platform
   - Android Virtual Device (AVD)

#### Step 2: Set Up Environment Variables

After installing Android Studio, add to your PATH:

```powershell
# Add to System Environment Variables (permanent)
[System.Environment]::SetEnvironmentVariable("ANDROID_HOME", "$env:LOCALAPPDATA\Android\Sdk", "User")
[System.Environment]::SetEnvironmentVariable("Path", "$env:Path;$env:LOCALAPPDATA\Android\Sdk\platform-tools;$env:LOCALAPPDATA\Android\Sdk\tools", "User")
```

Or manually:
1. Open System Properties → Environment Variables
2. Add `ANDROID_HOME` = `C:\Users\YourUsername\AppData\Local\Android\Sdk`
3. Add to PATH:
   - `%ANDROID_HOME%\platform-tools`
   - `%ANDROID_HOME%\tools`
   - `%ANDROID_HOME%\tools\bin`

#### Step 3: Create Android Virtual Device (AVD)

1. Open Android Studio
2. Go to **Tools** → **Device Manager**
3. Click **Create Device**
4. Select a device (e.g., Pixel 5)
5. Download a system image (e.g., Android 13)
6. Finish setup

#### Step 4: Initialize React Native Android Project

The Android project structure needs to be generated. Run:

```powershell
cd mobile
npx react-native init SightMate --template react-native-template-typescript --skip-install
```

**OR** manually create the Android project structure (complex).

### Option 2: Use Physical Android Device (Easier)

#### Step 1: Enable Developer Options

1. On your Android device: **Settings** → **About Phone**
2. Tap **Build Number** 7 times
3. Go back → **Developer Options**
4. Enable **USB Debugging**

#### Step 2: Connect Device

1. Connect phone via USB
2. Allow USB debugging when prompted on phone
3. Verify connection:
   ```powershell
   # After installing Android SDK
   adb devices
   ```

#### Step 3: Run App

```powershell
cd mobile
npm run android
```

### Option 3: Use Expo (Alternative - Easier Setup)

Expo provides a simpler setup without needing Android Studio:

```powershell
cd mobile
npx create-expo-app --template blank-typescript
# Then migrate your code
```

## Quick Fix: Initialize Android Project

If you want to continue with React Native CLI, you need to initialize the Android project:

```powershell
cd mobile

# Option A: Use React Native CLI to add Android
npx @react-native-community/cli init SightMate --skip-install
# Then copy your src files

# Option B: Create minimal Android structure manually (complex)
```

## Recommended: Use Expo Go for Quick Testing

For fastest testing without Android Studio setup:

1. Install Expo Go app on your phone (from Play Store)
2. Convert project to Expo (or create new Expo project)
3. Run: `npx expo start`
4. Scan QR code with Expo Go app

## Check Current Setup

Run React Native doctor to see what's missing:

```powershell
cd mobile
npx react-native doctor
```

This will tell you exactly what needs to be installed.

## Alternative: Test API Without Mobile App

You can test the backend API directly while setting up Android:

```powershell
# Test analyze-image endpoint
$body = @{
    image = "base64_test_image"
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://4pov2vc0o8.execute-api.us-west-2.amazonaws.com/prod/analyze-image" -Method Post -Body $body -ContentType "application/json"
```

## Next Steps

1. **Choose your approach:**
   - Full Android Studio setup (for production)
   - Physical device (faster to start)
   - Expo (easiest for testing)

2. **For now, I recommend:**
   - Install Android Studio
   - Set up one AVD
   - Then run `npm run android`

## Need Help?

- React Native Android Setup: https://reactnative.dev/docs/environment-setup
- Android Studio Guide: https://developer.android.com/studio/intro
- Expo Alternative: https://docs.expo.dev/

