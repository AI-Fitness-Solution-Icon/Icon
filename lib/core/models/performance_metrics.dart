import 'package:equatable/equatable.dart';
import 'workout_session.dart';
import 'exercise.dart';

/// PerformanceMetrics model representing performance metrics in the Icon app
class PerformanceMetrics extends Equatable {
  static const String tableName = 'performance_metrics';

  final String metricId;
  final String sessionId;
  final String exerciseId;
  final int? repsCompleted;
  final double? weightUsed;
  final int? timeTaken;
  
  // Related models (optional, populated when joined)
  final WorkoutSession? session;
  final Exercise? exercise;

  const PerformanceMetrics({
    required this.metricId,
    required this.sessionId,
    required this.exerciseId,
    this.repsCompleted,
    this.weightUsed,
    this.timeTaken,
    this.session,
    this.exercise,
  });

  /// Creates a PerformanceMetrics from JSON data
  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) {
    return PerformanceMetrics(
      metricId: json['metric_id'] as String,
      sessionId: json['session_id'] as String,
      exerciseId: json['exercise_id'] as String,
      repsCompleted: json['reps_completed'] as int?,
      weightUsed: (json['weight_used'] as num?)?.toDouble(),
      timeTaken: json['time_taken'] as int?,
      session: json['session'] != null 
          ? WorkoutSession.fromJson(json['session'] as Map<String, dynamic>) 
          : null,
      exercise: json['exercise'] != null 
          ? Exercise.fromJson(json['exercise'] as Map<String, dynamic>) 
          : null,
    );
  }

  /// Converts PerformanceMetrics to JSON data
  Map<String, dynamic> toJson() {
    return {
      'metric_id': metricId,
      'session_id': sessionId,
      'exercise_id': exerciseId,
      'reps_completed': repsCompleted,
      'weight_used': weightUsed,
      'time_taken': timeTaken,
      'session': session?.toJson(),
      'exercise': exercise?.toJson(),
    };
  }

  /// Creates a copy of PerformanceMetrics with updated fields
  PerformanceMetrics copyWith({
    String? metricId,
    String? sessionId,
    String? exerciseId,
    int? repsCompleted,
    double? weightUsed,
    int? timeTaken,
    WorkoutSession? session,
    Exercise? exercise,
  }) {
    return PerformanceMetrics(
      metricId: metricId ?? this.metricId,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      repsCompleted: repsCompleted ?? this.repsCompleted,
      weightUsed: weightUsed ?? this.weightUsed,
      timeTaken: timeTaken ?? this.timeTaken,
      session: session ?? this.session,
      exercise: exercise ?? this.exercise,
    );
  }

  @override
  List<Object?> get props => [
    metricId,
    sessionId,
    exerciseId,
    repsCompleted,
    weightUsed,
    timeTaken,
    session,
    exercise,
  ];

  @override
  String toString() {
    return 'PerformanceMetrics(metricId: $metricId, sessionId: $sessionId, exerciseId: $exerciseId)';
  }
} 