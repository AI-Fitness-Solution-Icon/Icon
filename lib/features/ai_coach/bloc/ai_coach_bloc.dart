import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/ai_response.dart';
import '../../../core/services/openai_service.dart';
import '../../../core/services/supabase_service.dart';
import 'ai_coach_event.dart';
import 'ai_coach_state.dart';

/// BLoC for managing AI Coach interactions
class AiCoachBloc extends Bloc<AiCoachEvent, AiCoachState> {
  late final OpenAIService _openAIService;
  late final SupabaseService _supabaseService;
  final List<AIResponse> _messages = [];

  AiCoachBloc({OpenAIService? openAIService, SupabaseService? supabaseService}) : super(const AiCoachInitial()) {
    _openAIService = openAIService ?? OpenAIService.instance;
    _supabaseService = supabaseService ?? SupabaseService.instance;
    on<SendMessageEvent>(_onSendMessage);
    on<ClearMessagesEvent>(_onClearMessages);
    on<RetryMessageEvent>(_onRetryMessage);
  }

  /// Get the current authenticated user ID
  String? _getCurrentUserId() {
    final user = _supabaseService.client.auth.currentUser;
    return user?.id;
  }

  /// Handle sending a message to the AI coach
  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<AiCoachState> emit,
  ) async {
    if (event.message.trim().isEmpty) return;

    // Get current user ID
    final userId = _getCurrentUserId();
    if (userId == null) {
      emit(const AiCoachError('User not authenticated', []));
      return;
    }

    // Add user message to the list
    final userMessage = AIResponse(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: event.message,
      createdAt: DateTime.now(),
      userId: userId,
    );
    _messages.add(userMessage);

    // Emit sending state
    emit(AiCoachSending(List.from(_messages), event.message));

    try {
      // Get AI response
      final response = await _openAIService.chatCompletion(message: event.message);
      final aiResponseText = response['choices'][0]['message']['content'] as String;
      
      // Add AI response to the list
      final aiMessage = AIResponse(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: aiResponseText,
        createdAt: DateTime.now(),
        userId: 'ai_coach',
      );
      _messages.add(aiMessage);

      // Emit loaded state with updated messages
      emit(AiCoachLoaded(List.from(_messages)));
    } catch (e) {
      // Emit error state
      emit(AiCoachError(e.toString(), List.from(_messages)));
    }
  }

  /// Handle clearing all messages
  void _onClearMessages(
    ClearMessagesEvent event,
    Emitter<AiCoachState> emit,
  ) {
    _messages.clear();
    emit(const AiCoachInitial());
  }

  /// Handle retrying the last failed message
  Future<void> _onRetryMessage(
    RetryMessageEvent event,
    Emitter<AiCoachState> emit,
  ) async {
    if (_messages.isEmpty) return;

    // Get current user ID
    final userId = _getCurrentUserId();
    if (userId == null) {
      emit(const AiCoachError('User not authenticated', []));
      return;
    }

    // Get the last user message
    final lastUserMessage = _messages
        .where((msg) => msg.userId == userId)
        .lastOrNull;

    if (lastUserMessage != null) {
      // Remove the last user message and any subsequent AI response
      while (_messages.isNotEmpty && 
             _messages.last.userId != userId) {
        _messages.removeLast();
      }

      // Retry sending the message
      add(SendMessageEvent(lastUserMessage.text));
    }
  }

  /// Get current messages
  List<AIResponse> get messages => List.unmodifiable(_messages);

  /// Check if currently loading
  bool get isLoading => state is AiCoachLoading || state is AiCoachSending;

  /// Get error message if any
  String? get error {
    if (state is AiCoachError) {
      return (state as AiCoachError).message;
    }
    return null;
  }
} 