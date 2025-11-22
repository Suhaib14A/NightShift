# SightMate Mobile App

React Native mobile application for SightMate.

## Features

- **Scene Description**: Take photos and get audio descriptions
- **Text Reading**: Extract and read text from documents
- **Voice Commands**: Control the app with voice

## Setup

### Prerequisites

- Node.js 16+
- React Native CLI
- iOS: Xcode and CocoaPods
- Android: Android Studio and Android SDK

### Installation

```bash
npm install
```

### iOS Setup

```bash
cd ios
pod install
cd ..
```

### Running

**iOS:**
```bash
npm run ios
```

**Android:**
```bash
npm run android
```

## Configuration

Update the API endpoint in `src/services/api.js` or `src/config.js` with your deployed API Gateway URL.

## Permissions

The app requires:
- Camera access (for taking photos)
- Microphone access (for voice commands)
- Storage access (for temporary audio files)

These are configured in:
- `android/app/src/main/AndroidManifest.xml` (Android)
- `ios/SightMate/Info.plist` (iOS)

## Project Structure

```
mobile/
├── src/
│   ├── screens/
│   │   └── HomeScreen.js      # Main screen with buttons
│   ├── services/
│   │   └── api.js             # API service layer
│   └── App.js                 # App entry point
├── android/                   # Android native code
├── ios/                       # iOS native code
└── package.json
```

## Dependencies

- `react-native-image-picker`: Camera access
- `@react-native-voice/voice`: Voice recognition
- `react-native-sound`: Audio playback
- `react-native-fs`: File system operations
- `axios`: HTTP requests
- `@react-navigation/native`: Navigation

## Development

### Debugging

- Use React Native Debugger
- Check Metro bundler logs
- Use `console.log` for debugging

### Testing

Test on both iOS and Android devices/emulators to ensure compatibility.

