import 'package:equatable/equatable.dart';

/// Exercise model representing an exercise in the Icon app
class Exercise extends Equatable {
  static const String tableName = 'exercises';

  final String exerciseId;
  final String name;
  final String? description;
  final List<String> muscleGroups;
  final List<String> equipmentNeeded;
  final String? videoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Exercise({
    required this.exerciseId,
    required this.name,
    this.description,
    this.muscleGroups = const [],
    this.equipmentNeeded = const [],
    this.videoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates an Exercise from JSON data
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      exerciseId: json['exercise_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      muscleGroups: (json['muscle_groups'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      equipmentNeeded: (json['equipment_needed'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      videoUrl: json['video_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts Exercise to JSON data
  Map<String, dynamic> toJson() {
    return {
      'exercise_id': exerciseId,
      'name': name,
      'description': description,
      'muscle_groups': muscleGroups,
      'equipment_needed': equipmentNeeded,
      'video_url': videoUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Creates a copy of Exercise with updated fields
  Exercise copyWith({
    String? exerciseId,
    String? name,
    String? description,
    List<String>? muscleGroups,
    List<String>? equipmentNeeded,
    String? videoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Exercise(
      exerciseId: exerciseId ?? this.exerciseId,
      name: name ?? this.name,
      description: description ?? this.description,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      equipmentNeeded: equipmentNeeded ?? this.equipmentNeeded,
      videoUrl: videoUrl ?? this.videoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    exerciseId,
    name,
    description,
    muscleGroups,
    equipmentNeeded,
    videoUrl,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'Exercise(exerciseId: $exerciseId, name: $name, muscleGroups: $muscleGroups)';
  }
} 