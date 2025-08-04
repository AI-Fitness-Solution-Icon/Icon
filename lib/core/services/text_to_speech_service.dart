import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import '../utils/app_print.dart';

/// Service for handling text-to-speech functionality
class TextToSpeechService {
  static final TextToSpeechService _instance = TextToSpeechService._internal();
  factory TextToSpeechService() => _instance;
  TextToSpeechService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  bool _isSpeaking = false;
  Timer? _speechTimer;

  // Configuration
  static const Duration _maxSpeechDuration = Duration(seconds: 30);
  static const double _defaultRate = 0.5;
  static const double _defaultPitch = 1.0;
  static const double _defaultVolume = 1.0;

  // Callbacks
  Function()? _onSpeechStarted;
  Function()? _onSpeechCompleted;
  Function(String error)? _onSpeechError;

  /// Initialize the text-to-speech service
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Set default language
      await _flutterTts.setLanguage("en-US");
      
      // Set default voice
      final voices = await _flutterTts.getVoices;
      if (voices != null && voices.isNotEmpty) {
        // Try to find a good default voice
        final defaultVoice = voices.firstWhere(
          (voice) => voice['name'].toString().contains('en-US'),
          orElse: () => voices.first,
        );
        await _flutterTts.setVoice(defaultVoice);
      }

      // Set default parameters
      await _flutterTts.setSpeechRate(_defaultRate);
      await _flutterTts.setPitch(_defaultPitch);
      await _flutterTts.setVolume(_defaultVolume);

      // Set callbacks
      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
        _onSpeechStarted?.call();
        AppPrint.printInfo('Text-to-speech started');
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
        _stopSpeechTimer();
        _onSpeechCompleted?.call();
        AppPrint.printInfo('Text-to-speech completed');
      });

      _flutterTts.setErrorHandler((msg) {
        _isSpeaking = false;
        _stopSpeechTimer();
        _onSpeechError?.call(msg);
        AppPrint.printError('Text-to-speech error: $msg');
      });

      _isInitialized = true;
      AppPrint.printInfo('Text-to-speech service initialized successfully');
      return true;
    } catch (e) {
      AppPrint.printError('Error initializing text-to-speech: $e');
      return false;
    }
  }

  /// Speak text
  Future<bool> speak({
    required String text,
    Function()? onSpeechStarted,
    Function()? onSpeechCompleted,
    Function(String error)? onSpeechError,
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return false;
    }

    if (_isSpeaking) {
      AppPrint.printWarning('Already speaking, stopping current speech');
      await stop();
    }

    // Set callbacks
    _onSpeechStarted = onSpeechStarted;
    _onSpeechCompleted = onSpeechCompleted;
    _onSpeechError = onSpeechError;

    try {
      final result = await _flutterTts.speak(text);
      
      if (result == 1) {
        _startSpeechTimer();
        AppPrint.printInfo('Started speaking: $text');
        return true;
      } else {
        AppPrint.printError('Failed to start speaking');
        return false;
      }
    } catch (e) {
      AppPrint.printError('Error speaking text: $e');
      _onSpeechError?.call('Failed to speak text: $e');
      return false;
    }
  }

  /// Stop speaking
  Future<void> stop() async {
    if (!_isSpeaking) return;

    try {
      await _flutterTts.stop();
      _isSpeaking = false;
      _stopSpeechTimer();
      AppPrint.printInfo('Stopped speaking');
    } catch (e) {
      AppPrint.printError('Error stopping speech: $e');
    }
  }

  /// Pause speaking
  Future<void> pause() async {
    if (!_isSpeaking) return;

    try {
      await _flutterTts.pause();
      AppPrint.printInfo('Paused speaking');
    } catch (e) {
      AppPrint.printError('Error pausing speech: $e');
    }
  }

  /// Resume speaking (not supported by flutter_tts, restart instead)
  Future<void> resume() async {
    AppPrint.printWarning('Resume not supported by flutter_tts');
  }

  /// Set speech rate (0.1 to 1.0)
  Future<void> setSpeechRate(double rate) async {
    try {
      await _flutterTts.setSpeechRate(rate.clamp(0.1, 1.0));
      AppPrint.printInfo('Speech rate set to: $rate');
    } catch (e) {
      AppPrint.printError('Error setting speech rate: $e');
    }
  }

  /// Set speech pitch (0.5 to 2.0)
  Future<void> setSpeechPitch(double pitch) async {
    try {
      await _flutterTts.setPitch(pitch.clamp(0.5, 2.0));
      AppPrint.printInfo('Speech pitch set to: $pitch');
    } catch (e) {
      AppPrint.printError('Error setting speech pitch: $e');
    }
  }

  /// Set speech volume (0.0 to 1.0)
  Future<void> setSpeechVolume(double volume) async {
    try {
      await _flutterTts.setVolume(volume.clamp(0.0, 1.0));
      AppPrint.printInfo('Speech volume set to: $volume');
    } catch (e) {
      AppPrint.printError('Error setting speech volume: $e');
    }
  }

  /// Set language
  Future<void> setLanguage(String language) async {
    try {
      await _flutterTts.setLanguage(language);
      AppPrint.printInfo('Language set to: $language');
    } catch (e) {
      AppPrint.printError('Error setting language: $e');
    }
  }

  /// Get available languages
  Future<List<Map<String, dynamic>>> getAvailableLanguages() async {
    try {
      final languages = await _flutterTts.getLanguages;
      return languages ?? [];
    } catch (e) {
      AppPrint.printError('Error getting available languages: $e');
      return [];
    }
  }

  /// Get available voices
  Future<List<Map<String, dynamic>>> getAvailableVoices() async {
    try {
      final voices = await _flutterTts.getVoices;
      return voices ?? [];
    } catch (e) {
      AppPrint.printError('Error getting available voices: $e');
      return [];
    }
  }

  /// Check if currently speaking
  bool get isSpeaking => _isSpeaking;

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Start speech timer for safety
  void _startSpeechTimer() {
    _speechTimer?.cancel();
    _speechTimer = Timer(_maxSpeechDuration, () {
      if (_isSpeaking) {
        AppPrint.printWarning('Speech timeout, stopping automatically');
        stop();
      }
    });
  }

  /// Stop speech timer
  void _stopSpeechTimer() {
    _speechTimer?.cancel();
  }

  /// Dispose resources
  void dispose() {
    stop();
    _speechTimer?.cancel();
  }
} 