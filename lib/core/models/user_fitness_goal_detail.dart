import 'package:equatable/equatable.dart';

/// Model representing a user's fitness goal details in the Icon app
class UserFitnessGoalDetail extends Equatable {
  static const String tableName = 'user_fitness_goal_details';

  final String id;
  final String experienceLevel;
  final String? details;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserFitnessGoalDetail({
    required this.id,
    required this.experienceLevel,
    this.details,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a UserFitnessGoalDetail from JSON data
  factory UserFitnessGoalDetail.fromJson(Map<String, dynamic> json) {
    return UserFitnessGoalDetail(
      id: json['id'] as String,
      experienceLevel: json['experience_level'] as String,
      details: json['details'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts UserFitnessGoalDetail to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'experience_level': experienceLevel,
      'details': details,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Creates a copy of UserFitnessGoalDetail with updated fields
  UserFitnessGoalDetail copyWith({
    String? id,
    String? experienceLevel,
    String? details,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserFitnessGoalDetail(
      id: id ?? this.id,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get experience level as enum for type safety
  ExperienceLevel get experienceLevelEnum {
    switch (experienceLevel.toLowerCase()) {
      case 'beginner':
        return ExperienceLevel.beginner;
      case 'intermediate':
        return ExperienceLevel.intermediate;
      case 'advanced':
        return ExperienceLevel.advanced;
      default:
        return ExperienceLevel.beginner;
    }
  }

  /// Check if experience level is beginner
  bool get isBeginner => experienceLevelEnum == ExperienceLevel.beginner;

  /// Check if experience level is intermediate
  bool get isIntermediate =>
      experienceLevelEnum == ExperienceLevel.intermediate;

  /// Check if experience level is advanced
  bool get isAdvanced => experienceLevelEnum == ExperienceLevel.advanced;

  @override
  List<Object?> get props => [
    id,
    experienceLevel,
    details,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'UserFitnessGoalDetail(id: $id, experienceLevel: $experienceLevel, details: $details, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// Experience level enum for type safety
enum ExperienceLevel { beginner, intermediate, advanced }

/// Extension methods for ExperienceLevel enum
extension ExperienceLevelExtension on ExperienceLevel {
  /// Get display name
  String get displayName {
    switch (this) {
      case ExperienceLevel.beginner:
        return 'Beginner';
      case ExperienceLevel.intermediate:
        return 'Intermediate';
      case ExperienceLevel.advanced:
        return 'Advanced';
    }
  }

  /// Get description
  String get description {
    switch (this) {
      case ExperienceLevel.beginner:
        return 'New to fitness or getting back into it';
      case ExperienceLevel.intermediate:
        return 'Some experience with regular workouts';
      case ExperienceLevel.advanced:
        return 'Experienced with consistent training';
    }
  }

  /// Get icon
  String get icon {
    switch (this) {
      case ExperienceLevel.beginner:
        return 'trending_up';
      case ExperienceLevel.intermediate:
        return 'fitness_center';
      case ExperienceLevel.advanced:
        return 'emoji_events';
    }
  }
}
