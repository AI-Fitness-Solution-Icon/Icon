import 'package:equatable/equatable.dart';

/// Model representing a user goal
class Goal extends Equatable {
  final String id;
  final String title;
  final String description;
  final GoalType type;
  final double target;
  final double current;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.target,
    required this.current,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
  });

  /// Get progress percentage
  double get progressPercentage {
    if (target == 0) return 0;
    return (current / target).clamp(0.0, 1.0);
  }

  /// Create a copy with updated values
  Goal copyWith({
    String? id,
    String? title,
    String? description,
    GoalType? type,
    double? target,
    double? current,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      target: target ?? this.target,
      current: current ?? this.current,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// Create from JSON
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: GoalType.values.firstWhere(
        (e) => e.toString() == 'GoalType.${json['type']}',
        orElse: () => GoalType.general,
      ),
      target: (json['target'] as num).toDouble(),
      current: (json['current'] as num).toDouble(),
      isCompleted: json['is_completed'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'target': target,
      'current': current,
      'is_completed': isCompleted,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    type,
    target,
    current,
    isCompleted,
    createdAt,
    completedAt,
  ];
}

/// Types of goals
enum GoalType {
  steps,
  calories,
  protein,
  recovery,
  workout,
  general,
} 