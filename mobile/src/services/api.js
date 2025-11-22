import axios from 'axios';

// API Gateway endpoint - deployed to us-west-2
const API_BASE_URL = 'https://4pov2vc0o8.execute-api.us-west-2.amazonaws.com/prod';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 30000, // 30 seconds
});

export const analyzeImage = async (imageBase64) => {
  try {
    const response = await api.post('/analyze-image', {
      image: imageBase64,
    });
    return response.data;
  } catch (error) {
    console.error('Analyze image error:', error);
    throw error;
  }
};

export const readText = async (imageBase64) => {
  try {
    const response = await api.post('/read-text', {
      image: imageBase64,
    });
    return response.data;
  } catch (error) {
    console.error('Read text error:', error);
    throw error;
  }
};

export const voiceCommand = async (textOrAudio) => {
  try {
    // If it's a string, treat as text; otherwise treat as audio base64
    const payload = typeof textOrAudio === 'string' && textOrAudio.length < 1000
      ? { text: textOrAudio }
      : { audio: textOrAudio };
    
    const response = await api.post('/voice-command', payload);
    return response.data;
  } catch (error) {
    console.error('Voice command error:', error);
    throw error;
  }
};

