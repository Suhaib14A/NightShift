# SightMate Testing Guide

This guide will help you test your SightMate application end-to-end.

## Prerequisites Checklist

Before testing, make sure you have:

- [x] AWS credentials configured
- [ ] Backend deployed to AWS
- [ ] API endpoint URL copied
- [ ] Mobile app configured with API endpoint
- [ ] React Native development environment set up

## Step 1: Deploy the Backend

First, deploy your AWS infrastructure:

```powershell
cd backend
cdk bootstrap  # First time only
cdk deploy
```

**What to look for:**
- CDK will create all AWS resources
- At the end, you'll see output like:
  ```
  SightMateStack.ApiEndpoint = https://abc123xyz.execute-api.us-west-2.amazonaws.com/prod
  ```
- **Copy this URL** - you'll need it for the mobile app!

## Step 2: Update Mobile App Configuration

Update the mobile app with your API endpoint:

1. Open `mobile/src/services/api.js`
2. Find this line:
   ```javascript
   const API_BASE_URL = __DEV__
     ? 'http://localhost:3000'
     : 'https://YOUR_API_ID.execute-api.us-east-1.amazonaws.com/prod';
   ```
3. Replace with your actual endpoint:
   ```javascript
   const API_BASE_URL = 'https://abc123xyz.execute-api.us-west-2.amazonaws.com/prod';
   ```

## Step 3: Set Up Mobile App

### For Android Testing

```powershell
cd mobile
npm install
npm run android
```

**Requirements:**
- Android Studio installed
- Android emulator running OR physical device connected
- USB debugging enabled (for physical device)

### For iOS Testing

```powershell
cd mobile
npm install
cd ios
pod install
cd ..
npm run ios
```

**Requirements:**
- macOS with Xcode installed
- iOS Simulator OR physical iOS device
- CocoaPods installed

## Step 4: Test Each Feature

### Test 1: Scene Description

**Steps:**
1. Open the app
2. Tap **"Describe Scene"** button
3. Take a photo of something (e.g., a desk, room, outdoor scene)
4. Wait for processing (you'll see a loading indicator)
5. Listen to the audio description
6. Check the text response on screen

**Expected Result:**
- App takes photo
- Shows "Processing..." message
- Plays audio describing what's in the scene (e.g., "I can see Person, Furniture, and more.")
- Displays text on screen

**Troubleshooting:**
- If camera doesn't open: Check app permissions
- If no response: Check API endpoint is correct
- If error: Check CloudWatch logs in AWS Console

### Test 2: Text Reading

**Steps:**
1. Open the app
2. Tap **"Read Text"** button
3. Take a photo of text (document, label, sign, etc.)
4. Wait for processing
5. Listen to the text being read aloud
6. Check the extracted text on screen

**Expected Result:**
- App takes photo
- Shows "Processing..." message
- Extracts text from image
- Plays audio reading the text
- Displays extracted text on screen

**Troubleshooting:**
- If no text found: Try clearer image with better lighting
- If text is garbled: Textract may have trouble with handwriting or poor quality

### Test 3: Voice Command

**Steps:**
1. Open the app
2. Tap **"Voice Command"** button
3. Speak a command like:
   - "describe"
   - "read text"
   - "what can you see"
4. Wait for response
5. Listen to the response

**Expected Result:**
- App starts listening
- Transcribes your speech
- Detects intent (describe/read)
- Responds with audio
- Shows response text

**Troubleshooting:**
- If microphone doesn't work: Check app permissions
- If command not recognized: Speak clearly and use keywords like "describe" or "read"

## Step 5: Verify Backend is Working

### Check API Gateway

1. Go to [AWS Console](https://console.aws.amazon.com/)
2. Navigate to **API Gateway**
3. Find your `SightMateApi`
4. Check that all 3 endpoints exist:
   - `/analyze-image` (POST)
   - `/read-text` (POST)
   - `/voice-command` (POST)

### Check Lambda Functions

1. Go to **Lambda** in AWS Console
2. You should see 3 functions:
   - `SightMateStack-AnalyzeImageFunction-...`
   - `SightMateStack-ReadTextFunction-...`
   - `SightMateStack-VoiceCommandFunction-...`
3. Click on each function
4. Go to **Monitor** tab to see invocations
5. Go to **Logs** tab to see CloudWatch logs

### Test API Directly (Optional)

You can test the API using curl or Postman:

```powershell
# Example: Test analyze-image endpoint
# First, convert an image to base64
$imageBytes = [System.IO.File]::ReadAllBytes("path/to/image.jpg")
$imageBase64 = [System.Convert]::ToBase64String($imageBytes)

# Then call the API
$body = @{
    image = $imageBase64
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://YOUR_API_ID.execute-api.us-west-2.amazonaws.com/prod/analyze-image" -Method Post -Body $body -ContentType "application/json"
```

## Step 6: Monitor and Debug

### View CloudWatch Logs

1. Go to **CloudWatch** in AWS Console
2. Click **Log groups**
3. Find log groups for your Lambda functions:
   - `/aws/lambda/SightMateStack-AnalyzeImageFunction-...`
   - `/aws/lambda/SightMateStack-ReadTextFunction-...`
   - `/aws/lambda/SightMateStack-VoiceCommandFunction-...`
4. Click on a log group to see recent logs
5. Look for errors or debug messages

### Check API Gateway Logs

1. Go to **API Gateway** → Your API
2. Click **Stages** → `prod`
3. Click **Logs/Tracing** tab
4. Enable CloudWatch logs if not already enabled
5. View logs to see API requests and responses

### Common Issues and Solutions

| Issue | Solution |
|-------|----------|
| "Network request failed" | Check API endpoint URL is correct |
| "Invalid credentials" | Refresh AWS credentials (they may have expired) |
| Camera doesn't open | Grant camera permission in device settings |
| Microphone doesn't work | Grant microphone permission in device settings |
| Audio doesn't play | Check device volume, verify audio file format |
| Lambda timeout | Increase timeout in CDK stack (currently 30s) |
| CORS errors | Verify CORS is enabled in API Gateway |
| "Access Denied" | Check IAM role has necessary permissions |

## Step 7: Performance Testing

### Test Latency

1. Time how long each operation takes:
   - Scene description: Target < 2 seconds
   - Text reading: Target < 3 seconds
   - Voice command: Target < 5 seconds (includes transcription)

### Test with Different Images

Try various scenarios:
- ✅ Clear, well-lit photos
- ✅ Text documents (printed)
- ✅ Labels and signs
- ✅ Outdoor scenes
- ✅ Indoor scenes
- ⚠️ Low light images (may have issues)
- ⚠️ Handwritten text (may have issues)

## Step 8: End-to-End Test Scenario

**Complete User Journey:**

1. **Open app** → Should see 3 buttons
2. **Take photo of scene** → Tap "Describe Scene" → Get audio description
3. **Take photo of text** → Tap "Read Text" → Get text read aloud
4. **Use voice command** → Tap "Voice Command" → Say "describe" → Get response
5. **Verify all features work** → No errors, smooth experience

## Success Criteria

✅ All 3 features work (Describe, Read, Voice)  
✅ Audio plays correctly  
✅ Text displays on screen  
✅ No crashes or errors  
✅ Response time is reasonable (< 5 seconds)  
✅ Works on both iOS and Android (if testing both)  

## Next Steps After Testing

Once everything works:

1. **Optimize performance** if needed
2. **Add error handling** improvements
3. **Enhance UI/UX** based on testing
4. **Add more voice commands**
5. **Improve text extraction** for edge cases
6. **Add user preferences** (voice selection, etc.)

## Quick Test Checklist

- [ ] Backend deployed successfully
- [ ] API endpoint URL copied and configured
- [ ] Mobile app builds and runs
- [ ] Camera permission granted
- [ ] Microphone permission granted
- [ ] Scene description works
- [ ] Text reading works
- [ ] Voice command works
- [ ] Audio playback works
- [ ] No errors in CloudWatch logs
- [ ] Response times are acceptable

## Need Help?

- Check `DEPLOYMENT.md` for deployment issues
- Check `AWS_CREDENTIALS_SETUP.md` for credential issues
- Check CloudWatch logs for backend errors
- Check React Native logs for mobile app errors

