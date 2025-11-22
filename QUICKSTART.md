# SightMate Quick Start Guide

Get SightMate up and running in minutes!

## Quick Overview

SightMate is a React Native app that helps people with low vision understand their surroundings using AWS AI services.

**Architecture:**
- React Native mobile app (iOS & Android)
- AWS serverless backend (Lambda, API Gateway, S3)
- AWS AI services (Rekognition, Textract, Transcribe, Polly)

## 5-Minute Setup

### 1. Backend Setup (2 minutes)

```bash
cd backend
npm install
cdk bootstrap  # First time only
cdk deploy
```

**Copy the API endpoint URL** from the deployment output.

### 2. Mobile App Setup (3 minutes)

```bash
cd mobile
npm install

# For iOS
cd ios && pod install && cd ..

# Update API endpoint in src/services/api.js
# Replace YOUR_API_ID with your actual endpoint
```

### 3. Run the App

```bash
# iOS
npm run ios

# Android
npm run android
```

## What You Get

✅ **Scene Description**: Take a photo → Get audio description  
✅ **Text Reading**: Photo of text → Audio reading  
✅ **Voice Commands**: Speak commands → App responds  

## Testing

1. **Test Scene Description:**
   - Tap "Describe Scene"
   - Take a photo
   - Listen to description

2. **Test Text Reading:**
   - Tap "Read Text"
   - Take photo of text
   - Listen to reading

3. **Test Voice Command:**
   - Tap "Voice Command"
   - Say "describe" or "read"
   - Get response

## Troubleshooting

**Backend won't deploy?**
- Check AWS credentials: `aws configure`
- Verify CDK is installed: `cdk --version`

**Mobile app won't build?**
- iOS: Run `pod install` in `ios/` directory
- Android: Check Android SDK is installed

**API calls failing?**
- Verify API endpoint URL is correct
- Check API Gateway is deployed
- Review CloudWatch logs for errors

## Next Steps

- Customize UI colors and styles
- Add more voice commands
- Enhance error handling
- Add user preferences

## Support

See `DEPLOYMENT.md` for detailed deployment instructions.  
See `README.md` for project overview.

