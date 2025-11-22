import React, {useState, useEffect} from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  ActivityIndicator,
  Alert,
  Platform,
} from 'react-native';
import {launchCamera} from 'react-native-image-picker';
import Voice from '@react-native-voice/voice';
import Sound from 'react-native-sound';
import {analyzeImage, readText, voiceCommand} from '../services/api';
import RNFS from 'react-native-fs';

Sound.setCategory('Playback');

const HomeScreen = () => {
  const [loading, setLoading] = useState(false);
  const [responseText, setResponseText] = useState('');

  useEffect(() => {
    // Cleanup voice listeners on unmount
    return () => {
      Voice.destroy().then(Voice.removeAllListeners);
    };
  }, []);

  const handleDescribe = async () => {
    try {
      setLoading(true);
      setResponseText('');

      const result = await launchCamera({
        mediaType: 'photo',
        quality: 0.8,
        includeBase64: true,
      });

      if (result.didCancel || result.errorCode) {
        setLoading(false);
        return;
      }

      const imageBase64 = result.assets[0].base64;
      const response = await analyzeImage(imageBase64);

      setResponseText(response.text);
      playAudio(response.audio_b64);
    } catch (error) {
      console.error('Describe error:', error);
      Alert.alert('Error', 'Failed to analyze image. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const handleRead = async () => {
    try {
      setLoading(true);
      setResponseText('');

      const result = await launchCamera({
        mediaType: 'photo',
        quality: 0.8,
        includeBase64: true,
      });

      if (result.didCancel || result.errorCode) {
        setLoading(false);
        return;
      }

      const imageBase64 = result.assets[0].base64;
      const response = await readText(imageBase64);

      setResponseText(response.text);
      playAudio(response.audio_b64);
    } catch (error) {
      console.error('Read error:', error);
      Alert.alert('Error', 'Failed to read text. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const handleVoiceCommand = async () => {
    try {
      setLoading(true);
      setResponseText('');

      // Start voice recognition
      await Voice.start('en-US');

      // Set up event handlers
      Voice.onSpeechResults = async (e) => {
        if (e.value && e.value.length > 0) {
          try {
            // Send the transcribed text directly to backend
            const response = await voiceCommand(e.value[0]);
            setResponseText(response.text);
            if (response.audio_b64) {
              playAudio(response.audio_b64);
            }

            // Handle intent-based routing
            if (response.intent === 'describe') {
              // Could trigger describe flow automatically
              Alert.alert('Ready', 'Please take a photo to describe the scene.');
            } else if (response.intent === 'read') {
              // Could trigger read flow automatically
              Alert.alert('Ready', 'Please take a photo of the text to read.');
            }
          } catch (error) {
            console.error('Voice command error:', error);
            Alert.alert('Error', 'Failed to process voice command.');
          } finally {
            setLoading(false);
            await Voice.stop();
          }
        }
      };

      Voice.onSpeechError = (e) => {
        console.error('Speech error:', e);
        Alert.alert('Error', 'Failed to record audio.');
        setLoading(false);
      };

      // Auto-stop after 5 seconds
      setTimeout(async () => {
        try {
          await Voice.stop();
        } catch (error) {
          console.error('Stop voice error:', error);
        }
      }, 5000);
    } catch (error) {
      console.error('Voice recording error:', error);
      Alert.alert('Error', 'Failed to start voice recording.');
      setLoading(false);
    }
  };

  const playAudio = (audioBase64) => {
    try {
      const audioPath = RNFS.DocumentDirectoryPath + '/response.mp3';
      RNFS.writeFile(audioPath, audioBase64, 'base64').then(() => {
        const sound = new Sound(audioPath, '', (error) => {
          if (error) {
            console.error('Sound error:', error);
            return;
          }
          sound.play((success) => {
            if (success) {
              sound.release();
            }
          });
        });
      });
    } catch (error) {
      console.error('Audio playback error:', error);
    }
  };

  return (
    <View style={styles.container}>
      <View style={styles.content}>
        <Text style={styles.title}>What would you like to do?</Text>

        <TouchableOpacity
          style={[styles.button, styles.describeButton]}
          onPress={handleDescribe}
          disabled={loading}
          accessibilityLabel="Describe scene">
          <Text style={styles.buttonText}>Describe Scene</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={[styles.button, styles.readButton]}
          onPress={handleRead}
          disabled={loading}
          accessibilityLabel="Read text">
          <Text style={styles.buttonText}>Read Text</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={[styles.button, styles.voiceButton]}
          onPress={handleVoiceCommand}
          disabled={loading}
          accessibilityLabel="Voice command">
          <Text style={styles.buttonText}>Voice Command</Text>
        </TouchableOpacity>

        {loading && (
          <View style={styles.loadingContainer}>
            <ActivityIndicator size="large" color="#4A90E2" />
            <Text style={styles.loadingText}>Processing...</Text>
          </View>
        )}

        {responseText ? (
          <View style={styles.responseContainer}>
            <Text style={styles.responseLabel}>Response:</Text>
            <Text style={styles.responseText}>{responseText}</Text>
          </View>
        ) : null}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5F5F5',
  },
  content: {
    flex: 1,
    padding: 20,
    justifyContent: 'center',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    textAlign: 'center',
    marginBottom: 40,
    color: '#333',
  },
  button: {
    paddingVertical: 20,
    paddingHorizontal: 30,
    borderRadius: 12,
    marginBottom: 20,
    minHeight: 80,
    justifyContent: 'center',
    alignItems: 'center',
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: {width: 0, height: 2},
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
  },
  describeButton: {
    backgroundColor: '#4A90E2',
  },
  readButton: {
    backgroundColor: '#50C878',
  },
  voiceButton: {
    backgroundColor: '#FF6B6B',
  },
  buttonText: {
    color: '#fff',
    fontSize: 20,
    fontWeight: 'bold',
  },
  loadingContainer: {
    alignItems: 'center',
    marginTop: 20,
  },
  loadingText: {
    marginTop: 10,
    fontSize: 16,
    color: '#666',
  },
  responseContainer: {
    marginTop: 30,
    padding: 15,
    backgroundColor: '#fff',
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#ddd',
  },
  responseLabel: {
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 10,
    color: '#333',
  },
  responseText: {
    fontSize: 16,
    color: '#666',
    lineHeight: 24,
  },
});

export default HomeScreen;

