import 'package:equatable/equatable.dart';
import 'user.dart';

/// Client model representing a client profile in the Icon app
class Client extends Equatable {
  static const String tableName = 'clients';

  final String clientId;
  final String? coachId;
  final DateTime? dateOfBirth;
  final String? gender;
  final double? height;
  final double? weight;
  final String? fitnessGoals;
  final String? healthConditions;
  final String preferredActivityLevel;
  final int? targetCaloriesPerDay;
  final bool onboardingCompleted;

  // Related models (optional, populated when joined)
  final User? user;

  const Client({
    required this.clientId,
    this.coachId,
    this.dateOfBirth,
    this.gender,
    this.height,
    this.weight,
    this.fitnessGoals,
    this.healthConditions,
    this.preferredActivityLevel = 'Beginner',
    this.targetCaloriesPerDay,
    this.onboardingCompleted = false,
    this.user,
  });

  /// Creates a Client from JSON data
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      clientId: json['client_id'] as String,
      coachId: json['coach_id'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      gender: json['gender'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      fitnessGoals: json['fitness_goals'] as String?,
      healthConditions: json['health_conditions'] as String?,
      preferredActivityLevel:
          json['preferred_activity_level'] as String? ?? 'Beginner',
      targetCaloriesPerDay: json['target_calories_per_day'] as int?,
      onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Converts Client to JSON data
  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'coach_id': coachId,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'height': height,
      'weight': weight,
      'fitness_goals': fitnessGoals,
      'health_conditions': healthConditions,
      'preferred_activity_level': preferredActivityLevel,
      'target_calories_per_day': targetCaloriesPerDay,
      'onboarding_completed': onboardingCompleted,
      'user': user?.toJson(),
    };
  }

  /// Creates a copy of Client with updated fields
  Client copyWith({
    String? clientId,
    String? coachId,
    DateTime? dateOfBirth,
    String? gender,
    double? height,
    double? weight,
    String? fitnessGoals,
    String? healthConditions,
    String? preferredActivityLevel,
    int? targetCaloriesPerDay,
    bool? onboardingCompleted,
    User? user,
  }) {
    return Client(
      clientId: clientId ?? this.clientId,
      coachId: coachId ?? this.coachId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      fitnessGoals: fitnessGoals ?? this.fitnessGoals,
      healthConditions: healthConditions ?? this.healthConditions,
      preferredActivityLevel:
          preferredActivityLevel ?? this.preferredActivityLevel,
      targetCaloriesPerDay: targetCaloriesPerDay ?? this.targetCaloriesPerDay,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      user: user ?? this.user,
    );
  }

  /// Calculate age from date of birth
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  @override
  List<Object?> get props => [
    clientId,
    coachId,
    dateOfBirth,
    gender,
    height,
    weight,
    fitnessGoals,
    healthConditions,
    preferredActivityLevel,
    targetCaloriesPerDay,
    onboardingCompleted,
    user,
  ];

  @override
  String toString() {
    return 'Client(clientId: $clientId, onboardingCompleted: $onboardingCompleted)';
  }
}
