import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../utils/app_print.dart';

/// Voice service for speech-to-text and text-to-speech functionality
class VoiceService {
  static VoiceService? _instance;
  late final SpeechToText _speechToText;
  late final FlutterTts _flutterTts;

  VoiceService._() {
    _speechToText = SpeechToText();
    _flutterTts = FlutterTts();
    _initializeServices();
  }

  /// Singleton instance of VoiceService
  static VoiceService get instance {
    _instance ??= VoiceService._();
    return _instance!;
  }

  /// Initialize speech-to-text and text-to-speech services
  Future<void> _initializeServices() async {
    // Initialize speech-to-text
    await _speechToText.initialize(
      onError: (error) => AppPrint.printError('Speech to text error: $error'),
      onStatus: (status) => AppPrint.printInfo('Speech to text status: $status'),
    );

    // Initialize text-to-speech
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  /// Get speech-to-text instance
  SpeechToText get speechToText => _speechToText;

  /// Get text-to-speech instance
  FlutterTts get flutterTts => _flutterTts;

  /// Check if speech-to-text is available
  Future<bool> isSpeechToTextAvailable() async {
    return await _speechToText.initialize();
  }

  /// Start listening for speech input
  Future<void> startListening({
    Function(String text)? onResult,
    Function()? onListeningComplete,
  }) async {
    if (await isSpeechToTextAvailable()) {
      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            onResult?.call(result.recognizedWords);
            onListeningComplete?.call();
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        localeId: 'en_US',
        listenOptions: SpeechListenOptions(
          partialResults: true,
          cancelOnError: true,
          listenMode: ListenMode.confirmation,
        ),
      );
    }
  }

  /// Stop listening for speech input
  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  /// Check if currently listening
  bool get isListening => _speechToText.isListening;

  /// Speak text using text-to-speech
  Future<void> speak({
    required String text,
    Function()? onStart,
    Function()? onComplete,
    Function(String error)? onError,
  }) async {
    try {
      onStart?.call();
      
      await _flutterTts.speak(text);
      
      _flutterTts.setCompletionHandler(() {
        onComplete?.call();
      });
      
      _flutterTts.setErrorHandler((error) {
        onError?.call(error);
      });
    } catch (e) {
      onError?.call(e.toString());
    }
  }

  /// Stop speaking
  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }

  /// Check if currently speaking (placeholder - not available in FlutterTts)
  bool get isSpeaking => false;

  /// Set speech rate (0.0 to 1.0)
  Future<void> setSpeechRate(double rate) async {
    await _flutterTts.setSpeechRate(rate);
  }

  /// Set speech volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    await _flutterTts.setVolume(volume);
  }

  /// Set speech pitch (0.5 to 2.0)
  Future<void> setPitch(double pitch) async {
    await _flutterTts.setPitch(pitch);
  }

  /// Set language for text-to-speech
  Future<void> setLanguage(String languageCode) async {
    await _flutterTts.setLanguage(languageCode);
  }

  /// Get available languages for text-to-speech
  Future<List<Map<String, String>>> getAvailableLanguages() async {
    final languages = await _flutterTts.getLanguages;
    return languages.cast<Map<String, String>>();
  }

  /// Get available voices for text-to-speech
  Future<List<Map<String, String>>> getAvailableVoices() async {
    final voices = await _flutterTts.getVoices;
    return voices.cast<Map<String, String>>();
  }

  /// Set voice for text-to-speech
  Future<void> setVoice(String voice) async {
    await _flutterTts.setVoice({'name': voice, 'locale': 'en-US'});
  }

  /// Dispose of resources
  void dispose() {
    _speechToText.cancel();
    _flutterTts.stop();
  }
} 