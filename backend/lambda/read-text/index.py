import json
import base64
import boto3
import os
import re
from datetime import datetime

textract = boto3.client('textract')
polly = boto3.client('polly')
s3 = boto3.client('s3')

MEDIA_BUCKET = os.environ['MEDIA_BUCKET']


def clean_text(text):
    """Clean and format extracted text."""
    # Remove extra whitespace
    text = re.sub(r'\s+', ' ', text)
    # Remove special characters that might interfere with speech
    text = re.sub(r'[^\w\s.,!?;:\-]', '', text)
    return text.strip()


def handler(event, context):
    """
    Extract text from image using Textract and return text with audio.
    """
    try:
        # Parse request body
        if isinstance(event.get('body'), str):
            body = json.loads(event['body'])
        else:
            body = event.get('body', {})
        
        image_base64 = body.get('image')
        if not image_base64:
            return {
                'statusCode': 400,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*',
                },
                'body': json.dumps({'error': 'Missing image data'}),
            }

        # Decode image
        image_bytes = base64.b64decode(image_base64)
        
        # Store in S3
        timestamp = datetime.utcnow().isoformat()
        s3_key = f'text-images/{timestamp}.jpg'
        s3.put_object(
            Bucket=MEDIA_BUCKET,
            Key=s3_key,
            Body=image_bytes,
            ContentType='image/jpeg',
        )

        # Call Textract
        response = textract.detect_document_text(
            Document={'Bytes': image_bytes}
        )

        # Extract text from blocks
        extracted_text = ''
        for block in response.get('Blocks', []):
            if block['BlockType'] == 'LINE':
                extracted_text += block['Text'] + ' '

        # Clean the text
        cleaned_text = clean_text(extracted_text)

        if not cleaned_text:
            cleaned_text = "I couldn't find any readable text in this image."

        # Generate speech using Polly
        polly_response = polly.synthesize_speech(
            Text=cleaned_text,
            OutputFormat='mp3',
            VoiceId='Joanna',
        )

        # Convert audio to base64
        audio_base64 = base64.b64encode(
            polly_response['AudioStream'].read()
        ).decode('utf-8')

        # Log to CloudWatch
        print(f"Extracted text: {cleaned_text[:100]}...")

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
            },
            'body': json.dumps({
                'text': cleaned_text,
                'audio_b64': audio_base64,
            }),
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
            },
            'body': json.dumps({'error': 'Failed to read text'}),
        }

