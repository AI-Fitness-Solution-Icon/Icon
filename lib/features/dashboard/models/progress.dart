import 'package:equatable/equatable.dart';

/// Model representing user progress data
class Progress extends Equatable {
  final int recoveryScore;
  final int heartRate;
  final int caloriesLeft;
  final int proteinLeft;
  final int stepsLeft;
  final int caloriesBurned;
  final DateTime date;

  const Progress({
    required this.recoveryScore,
    required this.heartRate,
    required this.caloriesLeft,
    required this.proteinLeft,
    required this.stepsLeft,
    required this.caloriesBurned,
    required this.date,
  });

  /// Create from JSON
  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      recoveryScore: json['recovery_score'] as int? ?? 0,
      heartRate: json['heart_rate'] as int? ?? 0,
      caloriesLeft: json['calories_left'] as int? ?? 0,
      proteinLeft: json['protein_left'] as int? ?? 0,
      stepsLeft: json['steps_left'] as int? ?? 0,
      caloriesBurned: json['calories_burned'] as int? ?? 0,
      date: DateTime.parse(json['date'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'recovery_score': recoveryScore,
      'heart_rate': heartRate,
      'calories_left': caloriesLeft,
      'protein_left': proteinLeft,
      'steps_left': stepsLeft,
      'calories_burned': caloriesBurned,
      'date': date.toIso8601String(),
    };
  }

  /// Create a copy with updated values
  Progress copyWith({
    int? recoveryScore,
    int? heartRate,
    int? caloriesLeft,
    int? proteinLeft,
    int? stepsLeft,
    int? caloriesBurned,
    DateTime? date,
  }) {
    return Progress(
      recoveryScore: recoveryScore ?? this.recoveryScore,
      heartRate: heartRate ?? this.heartRate,
      caloriesLeft: caloriesLeft ?? this.caloriesLeft,
      proteinLeft: proteinLeft ?? this.proteinLeft,
      stepsLeft: stepsLeft ?? this.stepsLeft,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [
    recoveryScore,
    heartRate,
    caloriesLeft,
    proteinLeft,
    stepsLeft,
    caloriesBurned,
    date,
  ];
} 