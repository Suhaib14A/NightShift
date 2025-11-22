import json
import base64
import boto3
import os
import time
from datetime import datetime

transcribe = boto3.client('transcribe')
polly = boto3.client('polly')
s3 = boto3.client('s3')

MEDIA_BUCKET = os.environ['MEDIA_BUCKET']


def detect_intent(text):
    """Simple intent detection based on keywords."""
    text_lower = text.lower()
    
    if any(word in text_lower for word in ['describe', 'what', 'see', 'scene', 'picture']):
        return 'describe'
    elif any(word in text_lower for word in ['read', 'text', 'document', 'label']):
        return 'read'
    else:
        return 'unknown'


def handler(event, context):
    """
    Process voice command using Transcribe and return intent with response.
    """
    try:
        # Parse request body
        if isinstance(event.get('body'), str):
            body = json.loads(event['body'])
        else:
            body = event.get('body', {})
        
        # Check if audio or text was sent
        audio_base64 = body.get('audio')
        text_input = body.get('text')  # For direct text input from mobile
        
        if not audio_base64 and not text_input:
            return {
                'statusCode': 400,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*',
                },
                'body': json.dumps({'error': 'Missing audio or text data'}),
            }

        # If text is provided directly (from mobile voice recognition), use it
        if text_input:
            transcribed_text = text_input
        else:
            # Decode audio
            audio_bytes = base64.b64decode(audio_base64)
            
            # Store in S3
            timestamp = datetime.utcnow().isoformat()
            s3_key = f'voice-commands/{timestamp}.mp3'
            s3.put_object(
                Bucket=MEDIA_BUCKET,
                Key=s3_key,
                Body=audio_bytes,
                ContentType='audio/mpeg',
            )

            # Upload to S3 for Transcribe (Transcribe needs S3 URI)
            transcribe_s3_key = f'transcribe-input/{timestamp}.mp3'
            s3.put_object(
                Bucket=MEDIA_BUCKET,
                Key=transcribe_s3_key,
                Body=audio_bytes,
                ContentType='audio/mpeg',
            )

            # Start transcription job
            job_name = f'sightmate-{int(time.time())}'
            transcribe_uri = f's3://{MEDIA_BUCKET}/{transcribe_s3_key}'
            
            transcribe.start_transcription_job(
                TranscriptionJobName=job_name,
                Media={'MediaFileUri': transcribe_uri},
                MediaFormat='mp3',
                LanguageCode='en-US',
            )

            # Wait for transcription to complete
            max_wait = 30
            wait_time = 0
            while wait_time < max_wait:
                job = transcribe.get_transcription_job(TranscriptionJobName=job_name)
                status = job['TranscriptionJob']['TranscriptionJobStatus']
                
                if status == 'COMPLETED':
                    # Get transcription result
                    transcript_uri = job['TranscriptionJob']['Transcript']['TranscriptFileUri']
                    import urllib.request
                    import ssl
                    ssl_context = ssl.create_default_context()
                    with urllib.request.urlopen(transcript_uri, context=ssl_context) as response:
                        transcript_data = json.loads(response.read())
                    transcribed_text = transcript_data['results']['transcripts'][0]['transcript']
                    break
                elif status == 'FAILED':
                    raise Exception('Transcription job failed')
                
                time.sleep(1)
                wait_time += 1
            
            if wait_time >= max_wait:
                raise Exception('Transcription timeout')

        # Detect intent
        intent = detect_intent(transcribed_text)

        # Generate response text
        if intent == 'describe':
            response_text = "I'll help you describe the scene. Please take a photo."
        elif intent == 'read':
            response_text = "I'll help you read text. Please take a photo of the document."
        else:
            response_text = f"I heard: {transcribed_text}. How can I help you?"

        # Generate speech using Polly
        polly_response = polly.synthesize_speech(
            Text=response_text,
            OutputFormat='mp3',
            VoiceId='Joanna',
        )

        # Convert audio to base64
        audio_base64 = base64.b64encode(
            polly_response['AudioStream'].read()
        ).decode('utf-8')

        # Log to CloudWatch
        print(f"Voice command: {transcribed_text}, Intent: {intent}")

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
            },
            'body': json.dumps({
                'intent': intent,
                'text': response_text,
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
            'body': json.dumps({'error': 'Failed to process voice command'}),
        }

