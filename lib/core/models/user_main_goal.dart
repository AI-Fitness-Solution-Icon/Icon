import 'package:equatable/equatable.dart';
import 'fitness_main_goal.dart';

/// Model representing a user's main fitness goal in the Icon app
class UserMainGoal extends Equatable {
  static const String tableName = 'user_main_goals';

  final String id;
  final String userId;
  final String mainGoalId;
  final DateTime createdAt;

  // Related models (optional, populated when joined)
  final FitnessMainGoal? mainGoal;

  const UserMainGoal({
    required this.id,
    required this.userId,
    required this.mainGoalId,
    required this.createdAt,
    this.mainGoal,
  });

  /// Creates a UserMainGoal from JSON data
  factory UserMainGoal.fromJson(Map<String, dynamic> json) {
    return UserMainGoal(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      mainGoalId: json['main_goal_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      mainGoal: json['main_goal'] != null
          ? FitnessMainGoal.fromJson(json['main_goal'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Converts UserMainGoal to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'main_goal_id': mainGoalId,
      'created_at': createdAt.toIso8601String(),
      'main_goal': mainGoal?.toJson(),
    };
  }

  /// Creates a copy of UserMainGoal with updated fields
  UserMainGoal copyWith({
    String? id,
    String? userId,
    String? mainGoalId,
    DateTime? createdAt,
    FitnessMainGoal? mainGoal,
  }) {
    return UserMainGoal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mainGoalId: mainGoalId ?? this.mainGoalId,
      createdAt: createdAt ?? this.createdAt,
      mainGoal: mainGoal ?? this.mainGoal,
    );
  }

  @override
  List<Object?> get props => [id, userId, mainGoalId, createdAt, mainGoal];

  @override
  String toString() {
    return 'UserMainGoal(id: $id, userId: $userId, mainGoalId: $mainGoalId, createdAt: $createdAt)';
  }
}
