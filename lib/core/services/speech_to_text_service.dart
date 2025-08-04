import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../utils/app_print.dart';

/// Service for handling speech-to-text functionality
class SpeechToTextService {
  static final SpeechToTextService _instance = SpeechToTextService._internal();
  factory SpeechToTextService() => _instance;
  SpeechToTextService._internal();

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;
  Timer? _silenceTimer;
  Timer? _confidenceTimer;

  // Configuration
  static const Duration _silenceTimeout = Duration(seconds: 3);
  static const double _minConfidence = 0.7;

  // Callbacks
  Function(String text)? _onResult;
  Function(String text)? _onPartialResult;
  Function()? _onListeningStarted;
  Function()? _onListeningStopped;
  Function(String error)? _onError;

  /// Initialize the speech recognition service
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Request microphone permission
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        AppPrint.printError('Microphone permission denied');
        return false;
      }

      // Initialize speech recognition
      _isInitialized = await _speech.initialize(
        onError: (error) {
          AppPrint.printError('Speech recognition error: ${error.errorMsg}');
          _onError?.call(error.errorMsg);
        },
        onStatus: (status) {
          AppPrint.printInfo('Speech status: $status');
          _handleStatusChange(status);
        },
      );

      if (_isInitialized) {
        AppPrint.printInfo('Speech-to-text service initialized successfully');
      } else {
        AppPrint.printError('Failed to initialize speech recognition');
      }

      return _isInitialized;
    } catch (e) {
      AppPrint.printError('Error initializing speech recognition: $e');
      return false;
    }
  }

  /// Start listening for speech
  Future<bool> startListening({
    Function(String text)? onResult,
    Function(String text)? onPartialResult,
    Function()? onListeningStarted,
    Function()? onListeningStopped,
    Function(String error)? onError,
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return false;
    }

    if (_isListening) {
      AppPrint.printWarning('Already listening');
      return true;
    }

    // Set callbacks
    _onResult = onResult;
    _onPartialResult = onPartialResult;
    _onListeningStarted = onListeningStarted;
    _onListeningStopped = onListeningStopped;
    _onError = onError;

    try {
      final available = await _speech.initialize();
      if (!available) {
        AppPrint.printError('Speech recognition not available');
        return false;
      }

      _isListening = await _speech.listen(
        onResult: (result) {
          _handleSpeechResult(result);
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        localeId: 'en_US',
      );

      if (_isListening) {
        _onListeningStarted?.call();
        _startSilenceTimer();
        AppPrint.printInfo('Started listening for speech');
      }

      return _isListening;
    } catch (e) {
      AppPrint.printError('Error starting speech recognition: $e');
      _onError?.call('Failed to start listening: $e');
      return false;
    }
  }

  /// Stop listening for speech
  Future<void> stopListening() async {
    if (!_isListening) return;

    try {
      await _speech.stop();
      _isListening = false;
      _stopSilenceTimer();
      _stopConfidenceTimer();
      _onListeningStopped?.call();
      AppPrint.printInfo('Stopped listening for speech');
    } catch (e) {
      AppPrint.printError('Error stopping speech recognition: $e');
    }
  }

  /// Cancel speech recognition
  Future<void> cancel() async {
    try {
      await _speech.cancel();
      _isListening = false;
      _stopSilenceTimer();
      _stopConfidenceTimer();
      _onListeningStopped?.call();
      AppPrint.printInfo('Cancelled speech recognition');
    } catch (e) {
      AppPrint.printError('Error cancelling speech recognition: $e');
    }
  }

  /// Check if currently listening
  bool get isListening => _isListening;

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Get available locales
  Future<List<stt.LocaleName>> getAvailableLocales() async {
    try {
      return await _speech.locales();
    } catch (e) {
      AppPrint.printError('Error getting available locales: $e');
      return [];
    }
  }

  /// Handle speech recognition results
  void _handleSpeechResult(dynamic result) {
    if (result.finalResult) {
      // Final result
      if (result.confidence >= _minConfidence) {
        final text = result.recognizedWords.trim();
        if (text.isNotEmpty) {
          AppPrint.printInfo('Final speech result: $text (confidence: ${result.confidence})');
          _onResult?.call(text);
        }
      } else {
        AppPrint.printWarning('Low confidence result: ${result.recognizedWords} (${result.confidence})');
        _onError?.call('Speech not clear enough, please try again');
      }
      _stopSilenceTimer();
    } else {
      // Partial result
      final text = result.recognizedWords.trim();
      if (text.isNotEmpty) {
        AppPrint.printInfo('Partial speech result: $text');
        _onPartialResult?.call(text);
        _resetSilenceTimer();
      }
    }
  }

  /// Handle status changes
  void _handleStatusChange(String status) {
    switch (status) {
      case 'listening':
        _resetSilenceTimer();
        break;
      case 'notListening':
        _stopSilenceTimer();
        break;
      case 'done':
        _isListening = false;
        _stopSilenceTimer();
        _onListeningStopped?.call();
        break;
    }
  }

  /// Start silence detection timer
  void _startSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(_silenceTimeout, () {
      if (_isListening) {
        AppPrint.printInfo('Silence detected, stopping listening');
        stopListening();
      }
    });
  }

  /// Reset silence detection timer
  void _resetSilenceTimer() {
    _silenceTimer?.cancel();
    _startSilenceTimer();
  }

  /// Stop silence detection timer
  void _stopSilenceTimer() {
    _silenceTimer?.cancel();
  }

  /// Stop confidence check timer
  void _stopConfidenceTimer() {
    _confidenceTimer?.cancel();
  }

  /// Dispose resources
  void dispose() {
    stopListening();
    _silenceTimer?.cancel();
    _confidenceTimer?.cancel();
  }
} 