import 'package:equatable/equatable.dart';
import 'user.dart';

/// Coach model representing a coach profile in the Icon app
class Coach extends Equatable {
  static const String tableName = 'coaches';

  final String coachId;
  final String? bio;
  final List<String> certifications;
  final List<String> specialties;
  
  // Related models (optional, populated when joined)
  final User? user;

  const Coach({
    required this.coachId,
    this.bio,
    this.certifications = const [],
    this.specialties = const [],
    this.user,
  });

  /// Creates a Coach from JSON data
  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      coachId: json['coach_id'] as String,
      bio: json['bio'] as String?,
      certifications: (json['certifications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      specialties: (json['specialties'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      user: json['user'] != null 
          ? User.fromJson(json['user'] as Map<String, dynamic>) 
          : null,
    );
  }

  /// Converts Coach to JSON data
  Map<String, dynamic> toJson() {
    return {
      'coach_id': coachId,
      'bio': bio,
      'certifications': certifications,
      'specialties': specialties,
      'user': user?.toJson(),
    };
  }

  /// Creates a copy of Coach with updated fields
  Coach copyWith({
    String? coachId,
    String? bio,
    List<String>? certifications,
    List<String>? specialties,
    User? user,
  }) {
    return Coach(
      coachId: coachId ?? this.coachId,
      bio: bio ?? this.bio,
      certifications: certifications ?? this.certifications,
      specialties: specialties ?? this.specialties,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
    coachId, 
    bio, 
    certifications, 
    specialties,
    user,
  ];

  @override
  String toString() {
    return 'Coach(coachId: $coachId, bio: $bio, certifications: $certifications, specialties: $specialties)';
  }
} 