# Fix: React Native Gradle Plugin Not Found

## Problem

Error: `Could not read script 'C:\Users\suhai\Documents\NightShift\mobile\node_modules\react-native-gradle-plugin\react-native-gradle-plugin.gradle'`

## Cause

The `settings.gradle` file was looking for the plugin in the wrong location:
- ❌ Wrong: `node_modules/react-native-gradle-plugin/`
- ✅ Correct: `node_modules/@react-native/gradle-plugin/`

## Fix Applied

Updated `mobile/android/settings.gradle` to use the correct path:
```gradle
apply from: file("../node_modules/@react-native/gradle-plugin/react-native-gradle-plugin.gradle")
```

## Next Steps

1. **Make sure Java 17 is set:**
   ```powershell
   cd mobile
   .\set-java17.ps1
   ```

2. **Clean and rebuild:**
   ```powershell
   cd android
   .\gradlew.bat clean
   cd ..
   npm run android
   ```

## If Still Fails

Reinstall dependencies:
```powershell
cd mobile
Remove-Item -Path "node_modules" -Recurse -Force
Remove-Item -Path "package-lock.json" -Force
npm install
npm run android
```

