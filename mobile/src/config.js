// API Configuration
// Update this with your deployed API Gateway endpoint
export const API_CONFIG = {
  BASE_URL: __DEV__
    ? 'http://localhost:3000'
    : 'https://YOUR_API_ID.execute-api.us-east-1.amazonaws.com/prod',
};

