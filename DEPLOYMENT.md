# SightMate Deployment Guide

## Prerequisites

1. AWS Account with appropriate permissions
2. Node.js 16+ installed
3. AWS CLI configured with credentials
4. AWS CDK installed: `npm install -g aws-cdk`
5. React Native development environment set up

## Backend Deployment

### Step 1: Install Dependencies

```bash
cd backend
npm install
```

### Step 2: Bootstrap CDK (First Time Only)

```bash
cdk bootstrap
```

This sets up the CDK toolkit stack in your AWS account.

### Step 3: Deploy Infrastructure

```bash
cdk deploy
```

This will:
- Create S3 bucket for media storage
- Create Lambda functions
- Create API Gateway
- Set up IAM roles and permissions

### Step 4: Get API Endpoint

After deployment, CDK will output the API Gateway endpoint URL. Copy this URL.

Example output:
```
SightMateStack.ApiEndpoint = https://abc123.execute-api.us-east-1.amazonaws.com/prod
```

## Mobile App Setup

### Step 1: Install Dependencies

```bash
cd mobile
npm install
```

### Step 2: Configure API Endpoint

Update `mobile/src/services/api.js` with your API Gateway endpoint:

```javascript
const API_BASE_URL = 'https://YOUR_API_ID.execute-api.us-east-1.amazonaws.com/prod';
```

Or update `mobile/src/config.js`:

```javascript
export const API_CONFIG = {
  BASE_URL: 'https://YOUR_API_ID.execute-api.us-east-1.amazonaws.com/prod',
};
```

### Step 3: iOS Setup

```bash
cd ios
pod install
cd ..
```

### Step 4: Run the App

**iOS:**
```bash
npm run ios
```

**Android:**
```bash
npm run android
```

## Testing

### Test Scene Description
1. Open the app
2. Tap "Describe Scene"
3. Take a photo
4. Wait for audio response

### Test Text Reading
1. Open the app
2. Tap "Read Text"
3. Take a photo of text
4. Wait for audio response

### Test Voice Command
1. Open the app
2. Tap "Voice Command"
3. Speak a command (e.g., "describe" or "read")
4. Wait for response

## Troubleshooting

### Backend Issues

**Lambda timeout errors:**
- Increase timeout in `backend/lib/sightmate-stack.ts`
- Check CloudWatch logs for errors

**Permission errors:**
- Verify IAM role has all required permissions
- Check S3 bucket permissions

**API Gateway CORS errors:**
- Verify CORS is enabled in stack configuration

### Mobile App Issues

**Camera not working:**
- Check permissions in AndroidManifest.xml (Android)
- Check Info.plist permissions (iOS)
- Grant permissions in device settings

**Audio not playing:**
- Check device volume
- Verify audio file format (MP3)
- Check React Native Sound library setup

**Network errors:**
- Verify API endpoint URL is correct
- Check internet connection
- Verify API Gateway is deployed and accessible

## Cost Optimization

- S3 lifecycle policy deletes files after 1 day
- Lambda functions use minimal memory (512MB)
- CloudWatch logs retention: 1 week
- Monitor AWS Free Tier usage

## Cleanup

To remove all resources:

```bash
cd backend
cdk destroy
```

This will delete:
- All Lambda functions
- API Gateway
- S3 bucket (if empty)
- IAM roles
- CloudWatch log groups

**Note:** Make sure S3 bucket is empty before destroying, or it will fail.

