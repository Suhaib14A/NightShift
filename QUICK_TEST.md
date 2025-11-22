# Quick Testing Steps for SightMate

Follow these steps in order to test your application.

## Step 1: Deploy Backend (5 minutes)

```powershell
# Make sure you're in the project root
cd backend

# Bootstrap CDK (first time only)
cdk bootstrap

# Deploy
cdk deploy
```

**After deployment, you'll see:**
```
SightMateStack.ApiEndpoint = https://abc123xyz.execute-api.us-west-2.amazonaws.com/prod
```

**Copy this URL!** You'll need it in the next step.

## Step 2: Update Mobile App with API Endpoint

1. Open `mobile/src/services/api.js`
2. Replace the API_BASE_URL with your actual endpoint:

```javascript
const API_BASE_URL = 'https://YOUR_ACTUAL_ENDPOINT.execute-api.us-west-2.amazonaws.com/prod';
```

Replace `YOUR_ACTUAL_ENDPOINT` with the endpoint from Step 1.

## Step 3: Test Backend API (Optional - Quick Verification)

Test that your API works before testing the mobile app:

```powershell
# Test that the API is accessible
aws apigateway get-rest-apis --region us-west-2
```

Or test with a simple curl/Postman request to verify the endpoint is live.

## Step 4: Set Up Mobile App

### For Android:

```powershell
cd mobile
npm install
npm run android
```

### For iOS (macOS only):

```powershell
cd mobile
npm install
cd ios
pod install
cd ..
npm run ios
```

## Step 5: Test Each Feature

### ✅ Test Scene Description
1. Tap "Describe Scene"
2. Take a photo
3. Wait for audio response

### ✅ Test Text Reading  
1. Tap "Read Text"
2. Take photo of text
3. Wait for audio response

### ✅ Test Voice Command
1. Tap "Voice Command"
2. Say "describe" or "read"
3. Wait for response

## Troubleshooting

**If API calls fail:**
- Check API endpoint URL is correct
- Verify backend is deployed: `cd backend && cdk list`
- Check CloudWatch logs for errors

**If mobile app won't build:**
- Run `npm install` in mobile directory
- For iOS: Run `pod install` in ios directory
- Check React Native is properly set up

**If camera/microphone don't work:**
- Grant permissions in device settings
- Check AndroidManifest.xml (Android) or Info.plist (iOS)

