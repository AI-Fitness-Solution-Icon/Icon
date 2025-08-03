import 'package:equatable/equatable.dart';

/// Base class for AI Coach events
abstract class AiCoachEvent extends Equatable {
  const AiCoachEvent();

  @override
  List<Object?> get props => [];
}

/// Event to send a message to the AI coach
class SendMessageEvent extends AiCoachEvent {
  final String message;

  const SendMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}

/// Event to clear all messages
class ClearMessagesEvent extends AiCoachEvent {
  const ClearMessagesEvent();
}

/// Event to retry the last failed message
class RetryMessageEvent extends AiCoachEvent {
  const RetryMessageEvent();
} 