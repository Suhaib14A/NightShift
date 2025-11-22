# SightMate Backend

AWS serverless backend for SightMate mobile app.

## Architecture

- **API Gateway**: REST API endpoints
- **Lambda**: Three functions for image analysis, text reading, and voice commands
- **S3**: Media storage with 1-day TTL
- **Rekognition**: Scene description
- **Textract**: OCR for text extraction
- **Transcribe**: Voice command transcription
- **Polly**: Text-to-speech synthesis

## Setup

1. Install dependencies:
```bash
npm install
```

2. Install AWS CDK (if not already installed):
```bash
npm install -g aws-cdk
```

3. Bootstrap CDK (first time only):
```bash
cdk bootstrap
```

4. Deploy:
```bash
cdk deploy
```

After deployment, you'll get an API Gateway endpoint URL. Update the mobile app configuration with this URL.

## Lambda Functions

### analyze-image
- Receives base64 image
- Uses Rekognition to detect labels
- Generates natural language description
- Uses Polly to create audio response

### read-text
- Receives base64 image
- Uses Textract to extract text
- Cleans and formats text
- Uses Polly to create audio response

### voice-command
- Receives base64 audio or text
- Uses Transcribe (if audio) to get text
- Detects intent (describe/read)
- Returns response with audio

## IAM Permissions

The Lambda role has permissions for:
- Rekognition: DetectLabels
- Textract: DetectDocumentText
- Transcribe: StartTranscriptionJob, GetTranscriptionJob
- Polly: SynthesizeSpeech
- S3: PutObject, GetObject, DeleteObject

## Cost Optimization

- S3 lifecycle policy deletes files after 1 day
- Lambda functions use minimal memory (512MB)
- CloudWatch logs retention: 1 week
- All services use free tier where available

