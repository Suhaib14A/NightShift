# How to Configure AWS Credentials

This guide will help you set up AWS credentials for deploying SightMate.

## Prerequisites

✅ AWS CLI is installed (v2.32.2)

## Step 1: Get Your AWS Credentials

You need two pieces of information from your AWS account:

1. **AWS Access Key ID** - Looks like: `AKIAIOSFODNN7EXAMPLE`
2. **AWS Secret Access Key** - Looks like: `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY`

### How to Get AWS Credentials

#### Option A: Create New IAM User (Recommended for Development)

1. Go to [AWS Console](https://console.aws.amazon.com/)
2. Navigate to **IAM** (Identity and Access Management)
3. Click **Users** in the left sidebar
4. Click **Create user**
5. Enter a username (e.g., `sightmate-dev`)
6. Click **Next**
7. Select **Attach policies directly**
8. For development, you can attach:
   - `AdministratorAccess` (full access - for development only)
   - OR create a custom policy with specific permissions (see below)
9. Click **Next**, then **Create user**
10. Click on the newly created user
11. Go to **Security credentials** tab
12. Click **Create access key**
13. Select **Command Line Interface (CLI)**
14. Click **Next**, then **Create access key**
15. **IMPORTANT**: Copy both the **Access Key ID** and **Secret Access Key**

- You can only see the secret key once!
- Save them securely

#### Option B: Use Existing Credentials

If you already have AWS credentials, use those.

## Step 2: Configure AWS CLI

Open PowerShell and run:

```powershell
aws configure
```

You'll be prompted for 4 pieces of information:

### 1. AWS Access Key ID

```
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
```

Paste your Access Key ID and press Enter.

### 2. AWS Secret Access Key

```
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

Paste your Secret Access Key and press Enter.

### 3. Default region name

```
Default region name [None]: us-east-1
```

Enter your preferred AWS region. Common options:

- `us-east-1` (N. Virginia) - Recommended
- `us-west-2` (Oregon)
- `eu-west-1` (Ireland)
- `ap-southeast-1` (Singapore)

### 4. Default output format

```
Default output format [None]: json
```

Just press Enter to use `json` (recommended).

## Step 3: Verify Configuration

Test that your credentials work:

```powershell
aws sts get-caller-identity
```

You should see output like:

```json
{
  "UserId": "AIDAEXAMPLE",
  "Account": "123456789012",
  "Arn": "arn:aws:iam::123456789012:user/sightmate-dev"
}
```

If you see this, your credentials are configured correctly! ✅

## Step 4: Test AWS Access

Verify you can access AWS services:

```powershell
aws s3 ls
```

This should list your S3 buckets (or show empty if you have none).

## Where Are Credentials Stored?

AWS CLI stores credentials in:

- **Windows**: `C:\Users\YourUsername\.aws\credentials`
- **Linux/Mac**: `~/.aws/credentials`

The file looks like:

```ini
[default]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

Region is stored in:

- **Windows**: `C:\Users\YourUsername\.aws\config`
- **Linux/Mac**: `~/.aws/config`

## Multiple AWS Profiles

If you need to use multiple AWS accounts, you can create named profiles:

```powershell
aws configure --profile production
aws configure --profile development
```

Then use them with:

```powershell
aws s3 ls --profile production
cdk deploy --profile production
```

## Security Best Practices

⚠️ **Important Security Tips:**

1. **Never commit credentials to Git**

   - The `.aws` folder is already in `.gitignore`
   - Never share credentials publicly

2. **Use IAM roles for production**

   - For production, use IAM roles instead of access keys
   - Access keys are for development/testing

3. **Rotate credentials regularly**

   - Change access keys every 90 days
   - Delete old/unused keys

4. **Use least privilege**

   - Don't use AdministratorAccess in production
   - Grant only necessary permissions

5. **Enable MFA**
   - Use Multi-Factor Authentication for your AWS account
   - Especially important for root account

## Required Permissions for SightMate

For deploying SightMate, your IAM user needs permissions for:

- **CloudFormation** (CDK uses this)
- **Lambda** (create/update functions)
- **API Gateway** (create/update APIs)
- **S3** (create buckets, store files)
- **IAM** (create roles for Lambda)
- **CloudWatch** (create log groups)
- **Rekognition** (for scene description)
- **Textract** (for text reading)
- **Transcribe** (for voice commands)
- **Polly** (for text-to-speech)

### Minimal IAM Policy (Advanced)

If you want to create a custom policy instead of AdministratorAccess:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudformation:*",
        "lambda:*",
        "apigateway:*",
        "s3:*",
        "iam:*",
        "logs:*",
        "rekognition:*",
        "textract:*",
        "transcribe:*",
        "polly:*"
      ],
      "Resource": "*"
    }
  ]
}
```

## Troubleshooting

### "Unable to locate credentials"

- Make sure you ran `aws configure`
- Check that credentials file exists: `C:\Users\YourUsername\.aws\credentials`
- Verify the file has correct format

### "Access Denied" errors

- Check your IAM user has necessary permissions
- Verify the access key is active
- Make sure you're using the correct region

### "Invalid credentials"

- Verify Access Key ID and Secret Access Key are correct
- Check if the access key was deleted or deactivated
- Create a new access key if needed

### Region issues

- Make sure your region supports all AWS services
- Some services aren't available in all regions
- `us-east-1` has the best service availability

## Next Steps

Once credentials are configured:

1. Verify: `aws sts get-caller-identity`
2. Deploy: `cd backend && cdk deploy`

## Need Help?

- AWS Documentation: https://docs.aws.amazon.com/cli/
- IAM User Guide: https://docs.aws.amazon.com/IAM/latest/UserGuide/
- AWS Support: https://aws.amazon.com/support/
