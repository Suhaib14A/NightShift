import json
import base64
import boto3
import os
from datetime import datetime

rekognition = boto3.client('rekognition')
polly = boto3.client('polly')
s3 = boto3.client('s3')

MEDIA_BUCKET = os.environ['MEDIA_BUCKET']


def handler(event, context):
    """
    Analyze image using Rekognition and return text description with audio.
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
        
        # Store in S3 (optional, for logging)
        timestamp = datetime.utcnow().isoformat()
        s3_key = f'images/{timestamp}.jpg'
        s3.put_object(
            Bucket=MEDIA_BUCKET,
            Key=s3_key,
            Body=image_bytes,
            ContentType='image/jpeg',
        )

        # Call Rekognition
        response = rekognition.detect_labels(
            Image={'Bytes': image_bytes},
            MaxLabels=10,
            MinConfidence=70,
        )

        # Build description text
        labels = [label['Name'] for label in response['Labels']]
        if labels:
            # Create a natural language description
            if len(labels) == 1:
                description = f"I can see {labels[0]}."
            elif len(labels) == 2:
                description = f"I can see {labels[0]} and {labels[1]}."
            else:
                main_items = ', '.join(labels[:3])
                description = f"I can see {main_items}, and more."
        else:
            description = "I'm having trouble identifying what's in this image."

        # Generate speech using Polly
        polly_response = polly.synthesize_speech(
            Text=description,
            OutputFormat='mp3',
            VoiceId='Joanna',  # Clear, natural voice
        )

        # Convert audio to base64
        audio_base64 = base64.b64encode(
            polly_response['AudioStream'].read()
        ).decode('utf-8')

        # Log to CloudWatch
        print(f"Analyzed image: {description}")

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
            },
            'body': json.dumps({
                'text': description,
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
            'body': json.dumps({'error': 'Failed to analyze image'}),
        }

