import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/speech_to_text_service.dart';
import '../../../core/services/text_to_speech_service.dart';
import '../bloc/ai_coach_bloc.dart';
import '../bloc/ai_coach_event.dart';
import '../bloc/ai_coach_state.dart';
import '../widgets/voice_visualizer.dart';
import '../widgets/voice_controls.dart';

/// Enhanced voice interaction screen for AI coach
class VoiceInteractionScreen extends StatefulWidget {
  const VoiceInteractionScreen({super.key});

  @override
  State<VoiceInteractionScreen> createState() => _VoiceInteractionScreenState();
}

class _VoiceInteractionScreenState extends State<VoiceInteractionScreen> {
  final SpeechToTextService _speechToTextService = SpeechToTextService();
  final TextToSpeechService _textToSpeechService = TextToSpeechService();
  
  String _currentText = '';
  String _partialText = '';
  final double _audioLevel = 0.0;
  final double _confidence = 0.0;
  String _status = 'Ready to listen';

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  @override
  void dispose() {
    _speechToTextService.dispose();
    _textToSpeechService.dispose();
    super.dispose();
  }

  Future<void> _initializeServices() async {
    await _speechToTextService.initialize();
    await _textToSpeechService.initialize();
  }

  Future<void> _startListening() async {
    setState(() {
      _status = 'Starting...';
    });

    final success = await _speechToTextService.startListening(
      onResult: (text) {
        setState(() {
          _currentText = text;
          _partialText = '';
          _status = 'Processing...';
        });
        
        // Send to AI coach
        context.read<AiCoachBloc>().add(SendMessageEvent(text));
      },
      onPartialResult: (text) {
        setState(() {
          _partialText = text;
          _status = 'Listening...';
        });
      },
      onListeningStarted: () {
        setState(() {
          _status = 'Listening...';
        });
      },
      onListeningStopped: () {
        setState(() {
          _status = 'Ready to listen';
        });
      },
      onError: (error) {
        setState(() {
          _status = 'Error: $error';
        });
        _showErrorSnackBar(error);
      },
    );

    if (!success) {
      setState(() {
        _status = 'Failed to start listening';
      });
    }
  }

  Future<void> _stopListening() async {
    await _speechToTextService.stopListening();
  }

  Future<void> _stopSpeaking() async {
    await _textToSpeechService.stop();
  }

  Future<void> _emergencyStop() async {
    await _speechToTextService.stopListening();
    await _textToSpeechService.stop();
    setState(() {
      _status = 'Stopped';
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildSettingsDialog(),
    );
  }

  Widget _buildSettingsDialog() {
    return AlertDialog(
      title: const Text('Voice Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Speech Rate'),
            subtitle: Slider(
              value: 0.5,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              onChanged: (value) {
                _textToSpeechService.setSpeechRate(value);
              },
            ),
          ),
          ListTile(
            title: const Text('Speech Pitch'),
            subtitle: Slider(
              value: 1.0,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              onChanged: (value) {
                _textToSpeechService.setSpeechPitch(value);
              },
            ),
          ),
          ListTile(
            title: const Text('Speech Volume'),
            subtitle: Slider(
              value: 1.0,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              onChanged: (value) {
                _textToSpeechService.setSpeechVolume(value);
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Voice Coach'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              // Navigate to chat screen
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: BlocListener<AiCoachBloc, AiCoachState>(
        listener: (context, state) {
          if (state is AiCoachLoading) {
            setState(() {
              _status = 'Processing...';
            });
          } else if (state is AiCoachLoaded) {
            setState(() {
              _status = 'Speaking...';
            });
            
            // Speak the AI response
            final lastMessage = state.messages.isNotEmpty ? state.messages.last : null;
            if (lastMessage != null && lastMessage.userId == 'ai_coach') {
              _textToSpeechService.speak(
                text: lastMessage.text,
                onSpeechStarted: () {
                  setState(() {
                    _status = 'Speaking...';
                  });
                },
                onSpeechCompleted: () {
                  setState(() {
                    _status = 'Ready to listen';
                  });
                },
                onSpeechError: (error) {
                  setState(() {
                    _status = 'Speech error';
                  });
                  _showErrorSnackBar(error);
                },
              );
            }
          } else if (state is AiCoachError) {
            setState(() {
              _status = 'Error occurred';
            });
            _showErrorSnackBar(state.message);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Voice Visualizer
                Expanded(
                  flex: 2,
                  child: Center(
                    child: VoiceVisualizer(
                      isListening: _speechToTextService.isListening,
                      isSpeaking: _textToSpeechService.isSpeaking,
                      audioLevel: _audioLevel,
                      confidence: _confidence,
                      status: _status,
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Voice Controls
                Expanded(
                  flex: 1,
                  child: VoiceControls(
                    isListening: _speechToTextService.isListening,
                    isSpeaking: _textToSpeechService.isSpeaking,
                    isLoading: context.watch<AiCoachBloc>().state is AiCoachLoading,
                    onStartListening: _startListening,
                    onStopListening: _stopListening,
                    onStopSpeaking: _stopSpeaking,
                    onEmergencyStop: _emergencyStop,
                    onSettings: _showSettingsDialog,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Conversation Display
                if (_currentText.isNotEmpty || _partialText.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_currentText.isNotEmpty) ...[
                          Text(
                            'You said:',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _currentText,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                        if (_partialText.isNotEmpty && _partialText != _currentText) ...[
                          if (_currentText.isNotEmpty) const SizedBox(height: 16),
                          Text(
                            'Listening:',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _partialText,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 