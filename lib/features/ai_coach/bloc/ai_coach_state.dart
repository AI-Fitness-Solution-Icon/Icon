import 'package:equatable/equatable.dart';
import '../../../core/models/ai_response.dart';

/// Base class for AI Coach states
abstract class AiCoachState extends Equatable {
  const AiCoachState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the AI coach is first loaded
class AiCoachInitial extends AiCoachState {
  const AiCoachInitial();
}

/// State when messages are being loaded or sent
class AiCoachLoading extends AiCoachState {
  final List<AIResponse> messages;

  const AiCoachLoading(this.messages);

  @override
  List<Object?> get props => [messages];
}

/// State when messages are successfully loaded
class AiCoachLoaded extends AiCoachState {
  final List<AIResponse> messages;

  const AiCoachLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

/// State when an error occurs
class AiCoachError extends AiCoachState {
  final String message;
  final List<AIResponse> messages;

  const AiCoachError(this.message, this.messages);

  @override
  List<Object?> get props => [message, messages];
}

/// State when sending a message
class AiCoachSending extends AiCoachState {
  final List<AIResponse> messages;
  final String currentMessage;

  const AiCoachSending(this.messages, this.currentMessage);

  @override
  List<Object?> get props => [messages, currentMessage];
} 