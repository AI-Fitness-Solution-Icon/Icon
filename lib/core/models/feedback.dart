import 'package:equatable/equatable.dart';
import 'workout_session.dart';
import 'exercise.dart';

/// Feedback model representing feedback in the Icon app
class Feedback extends Equatable {
  static const String tableName = 'feedback';

  final String feedbackId;
  final String sessionId;
  final String? exerciseId;
  final String feedbackType;
  final String content;
  final DateTime timestamp;
  
  // Related models (optional, populated when joined)
  final WorkoutSession? session;
  final Exercise? exercise;

  const Feedback({
    required this.feedbackId,
    required this.sessionId,
    this.exerciseId,
    required this.feedbackType,
    required this.content,
    required this.timestamp,
    this.session,
    this.exercise,
  });

  /// Creates a Feedback from JSON data
  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      feedbackId: json['feedback_id'] as String,
      sessionId: json['session_id'] as String,
      exerciseId: json['exercise_id'] as String?,
      feedbackType: json['feedback_type'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      session: json['session'] != null 
          ? WorkoutSession.fromJson(json['session'] as Map<String, dynamic>) 
          : null,
      exercise: json['exercise'] != null 
          ? Exercise.fromJson(json['exercise'] as Map<String, dynamic>) 
          : null,
    );
  }

  /// Converts Feedback to JSON data
  Map<String, dynamic> toJson() {
    return {
      'feedback_id': feedbackId,
      'session_id': sessionId,
      'exercise_id': exerciseId,
      'feedback_type': feedbackType,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'session': session?.toJson(),
      'exercise': exercise?.toJson(),
    };
  }

  /// Creates a copy of Feedback with updated fields
  Feedback copyWith({
    String? feedbackId,
    String? sessionId,
    String? exerciseId,
    String? feedbackType,
    String? content,
    DateTime? timestamp,
    WorkoutSession? session,
    Exercise? exercise,
  }) {
    return Feedback(
      feedbackId: feedbackId ?? this.feedbackId,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      feedbackType: feedbackType ?? this.feedbackType,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      session: session ?? this.session,
      exercise: exercise ?? this.exercise,
    );
  }

  @override
  List<Object?> get props => [
    feedbackId,
    sessionId,
    exerciseId,
    feedbackType,
    content,
    timestamp,
    session,
    exercise,
  ];

  @override
  String toString() {
    return 'Feedback(feedbackId: $feedbackId, sessionId: $sessionId, feedbackType: $feedbackType)';
  }
} 