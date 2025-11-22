import * as cdk from 'aws-cdk-lib';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as apigateway from 'aws-cdk-lib/aws-apigateway';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as logs from 'aws-cdk-lib/aws-logs';
import { Construct } from 'constructs';

export class SightMateStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // S3 bucket for storing media files
    const mediaBucket = new s3.Bucket(this, 'SightMateMediaBucket', {
      bucketName: `sightmate-media-${this.account}-${this.region}`,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
      autoDeleteObjects: true,
      lifecycleRules: [
        {
          id: 'DeleteOldFiles',
          expiration: cdk.Duration.days(1), // TTL for ephemeral storage
        },
      ],
    });

    // IAM role for Lambda functions
    const lambdaRole = new iam.Role(this, 'SightMateLambdaRole', {
      assumedBy: new iam.ServicePrincipal('lambda.amazonaws.com'),
      managedPolicies: [
        iam.ManagedPolicy.fromAwsManagedPolicyName(
          'service-role/AWSLambdaBasicExecutionRole',
        ),
      ],
    });

    // Grant permissions for AWS AI services
    lambdaRole.addToPolicy(
      new iam.PolicyStatement({
        effect: iam.Effect.ALLOW,
        actions: [
          'rekognition:DetectLabels',
          'textract:DetectDocumentText',
          'transcribe:StartTranscriptionJob',
          'transcribe:GetTranscriptionJob',
          'polly:SynthesizeSpeech',
          's3:PutObject',
          's3:GetObject',
          's3:DeleteObject',
        ],
        resources: ['*'],
      }),
    );

    // Grant S3 access
    mediaBucket.grantReadWrite(lambdaRole);

    // Lambda function for scene analysis
    const analyzeImageFunction = new lambda.Function(
      this,
      'AnalyzeImageFunction',
      {
        runtime: lambda.Runtime.PYTHON_3_11,
        handler: 'index.handler',
        code: lambda.Code.fromAsset('lambda/analyze-image'),
        role: lambdaRole,
        timeout: cdk.Duration.seconds(30),
        memorySize: 512,
        logRetention: logs.RetentionDays.ONE_WEEK,
        environment: {
          MEDIA_BUCKET: mediaBucket.bucketName,
        },
      },
    );

    // Lambda function for text reading
    const readTextFunction = new lambda.Function(this, 'ReadTextFunction', {
      runtime: lambda.Runtime.PYTHON_3_11,
      handler: 'index.handler',
      code: lambda.Code.fromAsset('lambda/read-text'),
      role: lambdaRole,
      timeout: cdk.Duration.seconds(30),
      memorySize: 512,
      logRetention: logs.RetentionDays.ONE_WEEK,
      environment: {
        MEDIA_BUCKET: mediaBucket.bucketName,
      },
    });

    // Lambda function for voice commands
    const voiceCommandFunction = new lambda.Function(
      this,
      'VoiceCommandFunction',
      {
        runtime: lambda.Runtime.PYTHON_3_11,
        handler: 'index.handler',
        code: lambda.Code.fromAsset('lambda/voice-command'),
        role: lambdaRole,
        timeout: cdk.Duration.seconds(30),
        memorySize: 512,
        logRetention: logs.RetentionDays.ONE_WEEK,
        environment: {
          MEDIA_BUCKET: mediaBucket.bucketName,
        },
      },
    );

    // API Gateway
    const api = new apigateway.RestApi(this, 'SightMateApi', {
      restApiName: 'SightMate API',
      description: 'API for SightMate mobile app',
      defaultCorsPreflightOptions: {
        allowOrigins: apigateway.Cors.ALL_ORIGINS,
        allowMethods: apigateway.Cors.ALL_METHODS,
        allowHeaders: ['Content-Type', 'X-Amz-Date', 'Authorization'],
      },
    });

    // API Gateway integrations
    const analyzeImageIntegration = new apigateway.LambdaIntegration(
      analyzeImageFunction,
    );
    const readTextIntegration = new apigateway.LambdaIntegration(
      readTextFunction,
    );
    const voiceCommandIntegration = new apigateway.LambdaIntegration(
      voiceCommandFunction,
    );

    // API endpoints
    api.root.addResource('analyze-image').addMethod('POST', analyzeImageIntegration);
    api.root.addResource('read-text').addMethod('POST', readTextIntegration);
    api.root.addResource('voice-command').addMethod('POST', voiceCommandIntegration);

    // Output API endpoint
    new cdk.CfnOutput(this, 'ApiEndpoint', {
      value: api.url,
      description: 'API Gateway endpoint URL',
    });
  }
}

