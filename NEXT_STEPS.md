# Next Steps - Ready to Deploy!

✅ **Prerequisites Installed:**
- Node.js v24.11.1
- npm v11.6.2
- AWS CDK v2.1033.0
- Backend dependencies installed

## Deploy the Backend

You're now ready to deploy the AWS infrastructure. Run these commands:

```powershell
# Make sure you're in the backend directory
cd backend

# Bootstrap CDK (first time only - sets up CDK resources in your AWS account)
cdk bootstrap

# Deploy the infrastructure
cdk deploy
```

### Before Deploying

1. **Configure AWS Credentials** (if not already done):
   ```powershell
   aws configure
   ```
   You'll need:
   - AWS Access Key ID
   - AWS Secret Access Key
   - Default region (e.g., `us-east-1`)
   - Default output format (can leave as `json`)

2. **Verify AWS Access**:
   ```powershell
   aws sts get-caller-identity
   ```
   This should show your AWS account ID and user info.

### After Deployment

CDK will output the API Gateway endpoint URL. **Copy this URL** - you'll need it for the mobile app!

Example output:
```
SightMateStack.ApiEndpoint = https://abc123xyz.execute-api.us-east-1.amazonaws.com/prod
```

## Update Mobile App

After getting the API endpoint:

1. Open `mobile/src/services/api.js`
2. Replace `YOUR_API_ID` with your actual API Gateway endpoint
3. Save the file

## Run Mobile App

```powershell
cd mobile
npm install
npm run android  # or npm run ios
```

## Troubleshooting

**CDK bootstrap fails?**
- Check AWS credentials: `aws sts get-caller-identity`
- Verify you have permissions to create CloudFormation stacks

**CDK deploy fails?**
- Check CloudWatch logs for specific errors
- Verify all AWS services are available in your region
- Make sure you have sufficient AWS account limits

**Need help?**
- See `DEPLOYMENT.md` for detailed instructions
- See `SETUP_WINDOWS.md` for Windows-specific setup

