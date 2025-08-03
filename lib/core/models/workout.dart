import 'package:equatable/equatable.dart';
import 'coach.dart';

/// Workout model representing a workout template in the Icon app
class Workout extends Equatable {
  static const String tableName = 'workouts';

  final String workoutId;
  final String creatorId;
  final String name;
  final String? description;
  final int duration;
  final String difficultyLevel;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Related models (optional, populated when joined)
  final Coach? creator;

  const Workout({
    required this.workoutId,
    required this.creatorId,
    required this.name,
    this.description,
    required this.duration,
    this.difficultyLevel = 'Beginner',
    required this.createdAt,
    required this.updatedAt,
    this.creator,
  });

  /// Creates a Workout from JSON data
  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      workoutId: json['workout_id'] as String,
      creatorId: json['creator_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      duration: json['duration'] as int,
      difficultyLevel: json['difficulty_level'] as String? ?? 'Beginner',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      creator: json['creator'] != null 
          ? Coach.fromJson(json['creator'] as Map<String, dynamic>) 
          : null,
    );
  }

  /// Converts Workout to JSON data
  Map<String, dynamic> toJson() {
    return {
      'workout_id': workoutId,
      'creator_id': creatorId,
      'name': name,
      'description': description,
      'duration': duration,
      'difficulty_level': difficultyLevel,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'creator': creator?.toJson(),
    };
  }

  /// Creates a copy of Workout with updated fields
  Workout copyWith({
    String? workoutId,
    String? creatorId,
    String? name,
    String? description,
    int? duration,
    String? difficultyLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
    Coach? creator,
  }) {
    return Workout(
      workoutId: workoutId ?? this.workoutId,
      creatorId: creatorId ?? this.creatorId,
      name: name ?? this.name,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      creator: creator ?? this.creator,
    );
  }

  @override
  List<Object?> get props => [
    workoutId,
    creatorId,
    name,
    description,
    duration,
    difficultyLevel,
    createdAt,
    updatedAt,
    creator,
  ];

  @override
  String toString() {
    return 'Workout(workoutId: $workoutId, name: $name, difficultyLevel: $difficultyLevel)';
  }
}

/// Workout status enum for workout sessions
enum WorkoutStatus {
  planned,
  inProgress,
  completed,
  cancelled,
} 