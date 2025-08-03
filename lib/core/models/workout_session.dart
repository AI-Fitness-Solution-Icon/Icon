import 'package:equatable/equatable.dart';
import 'client.dart';
import 'workout.dart';

/// WorkoutSession model representing a workout session in the Icon app
class WorkoutSession extends Equatable {
  static const String tableName = 'workout_sessions';

  final String sessionId;
  final String clientId;
  final String workoutId;
  final DateTime startTime;
  final DateTime? endTime;
  final String status;
  final String? feedback;
  
  // Related models (optional, populated when joined)
  final Client? client;
  final Workout? workout;

  const WorkoutSession({
    required this.sessionId,
    required this.clientId,
    required this.workoutId,
    required this.startTime,
    this.endTime,
    this.status = 'in_progress',
    this.feedback,
    this.client,
    this.workout,
  });

  /// Creates a WorkoutSession from JSON data
  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      sessionId: json['session_id'] as String,
      clientId: json['client_id'] as String,
      workoutId: json['workout_id'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] != null 
          ? DateTime.parse(json['end_time'] as String) 
          : null,
      status: json['status'] as String? ?? 'in_progress',
      feedback: json['feedback'] as String?,
      client: json['client'] != null 
          ? Client.fromJson(json['client'] as Map<String, dynamic>) 
          : null,
      workout: json['workout'] != null 
          ? Workout.fromJson(json['workout'] as Map<String, dynamic>) 
          : null,
    );
  }

  /// Converts WorkoutSession to JSON data
  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'client_id': clientId,
      'workout_id': workoutId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'status': status,
      'feedback': feedback,
      'client': client?.toJson(),
      'workout': workout?.toJson(),
    };
  }

  /// Creates a copy of WorkoutSession with updated fields
  WorkoutSession copyWith({
    String? sessionId,
    String? clientId,
    String? workoutId,
    DateTime? startTime,
    DateTime? endTime,
    String? status,
    String? feedback,
    Client? client,
    Workout? workout,
  }) {
    return WorkoutSession(
      sessionId: sessionId ?? this.sessionId,
      clientId: clientId ?? this.clientId,
      workoutId: workoutId ?? this.workoutId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      feedback: feedback ?? this.feedback,
      client: client ?? this.client,
      workout: workout ?? this.workout,
    );
  }

  /// Get session duration
  Duration? get duration {
    if (endTime == null) return null;
    return endTime!.difference(startTime);
  }

  /// Checks if session is completed
  bool get isCompleted => status == 'completed';

  /// Checks if session is in progress
  bool get isInProgress => status == 'in_progress';

  /// Checks if session is cancelled
  bool get isCancelled => status == 'cancelled';

  @override
  List<Object?> get props => [
    sessionId,
    clientId,
    workoutId,
    startTime,
    endTime,
    status,
    feedback,
    client,
    workout,
  ];

  @override
  String toString() {
    return 'WorkoutSession(sessionId: $sessionId, clientId: $clientId, status: $status)';
  }
} 