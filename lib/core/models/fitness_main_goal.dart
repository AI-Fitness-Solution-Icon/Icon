import 'package:equatable/equatable.dart';

/// Model representing a fitness main goal in the Icon app
class FitnessMainGoal extends Equatable {
  static const String tableName = 'fitness_main_goals';

  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;

  const FitnessMainGoal({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
  });

  /// Creates a FitnessMainGoal from JSON data
  factory FitnessMainGoal.fromJson(Map<String, dynamic> json) {
    return FitnessMainGoal(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Converts FitnessMainGoal to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Creates a copy of FitnessMainGoal with updated fields
  FitnessMainGoal copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
  }) {
    return FitnessMainGoal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, description, createdAt];

  @override
  String toString() {
    return 'FitnessMainGoal(id: $id, name: $name, description: $description, createdAt: $createdAt)';
  }
}
