/// Data model for trainer profile
/// Handles JSON serialization/deserialization for data layer
class TrainerProfileModel {
  final String? id;
  final String? fullName;
  final String? pronouns;
  final String? customPronouns;
  final String? nickname;
  final String? experienceLevel;
  final List<String> descriptiveWords;
  final String? motivation;
  final List<String> certifications;
  final String? coachingExperience;
  final String? equipmentDetails;
  final List<String> trainingPhilosophy;
  final String? email;
  final String? password;

  TrainerProfileModel({
    this.id,
    this.fullName,
    this.pronouns,
    this.customPronouns,
    this.nickname,
    this.experienceLevel,
    this.descriptiveWords = const [],
    this.motivation,
    this.certifications = const [],
    this.coachingExperience,
    this.equipmentDetails,
    this.trainingPhilosophy = const [],
    this.email,
    this.password,
  });

  /// Creates a TrainerProfileModel from JSON
  factory TrainerProfileModel.fromJson(Map<String, dynamic> json) {
    return TrainerProfileModel(
      id: json['id'],
      fullName: json['full_name'],
      pronouns: json['pronouns'],
      customPronouns: json['custom_pronouns'],
      nickname: json['nickname'],
      experienceLevel: json['experience_level'],
      descriptiveWords: List<String>.from(json['descriptive_words'] ?? []),
      motivation: json['motivation'],
      certifications: List<String>.from(json['certifications'] ?? []),
      coachingExperience: json['coaching_experience'],
      equipmentDetails: json['equipment_details'],
      trainingPhilosophy: List<String>.from(json['training_philosophy'] ?? []),
      email: json['email'],
      password: json['password'], // Note: This should be handled securely in production
    );
  }

  /// Converts TrainerProfileModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'pronouns': pronouns,
      'custom_pronouns': customPronouns,
      'nickname': nickname,
      'experience_level': experienceLevel,
      'descriptive_words': descriptiveWords,
      'motivation': motivation,
      'certifications': certifications,
      'coaching_experience': coachingExperience,
      'equipment_details': equipmentDetails,
      'training_philosophy': trainingPhilosophy,
      'email': email,
      'password': password, // Note: This should be handled securely in production
    };
  }

  /// Creates a copy of this TrainerProfileModel with the given fields replaced
  TrainerProfileModel copyWith({
    String? id,
    String? fullName,
    String? pronouns,
    String? customPronouns,
    String? nickname,
    String? experienceLevel,
    List<String>? descriptiveWords,
    String? motivation,
    List<String>? certifications,
    String? coachingExperience,
    String? equipmentDetails,
    List<String>? trainingPhilosophy,
    String? email,
    String? password,
  }) {
    return TrainerProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      pronouns: pronouns ?? this.pronouns,
      customPronouns: customPronouns ?? this.customPronouns,
      nickname: nickname ?? this.nickname,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      descriptiveWords: descriptiveWords ?? this.descriptiveWords,
      motivation: motivation ?? this.motivation,
      certifications: certifications ?? this.certifications,
      coachingExperience: coachingExperience ?? this.coachingExperience,
      equipmentDetails: equipmentDetails ?? this.equipmentDetails,
      trainingPhilosophy: trainingPhilosophy ?? this.trainingPhilosophy,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrainerProfileModel &&
        other.id == id &&
        other.fullName == fullName &&
        other.pronouns == pronouns &&
        other.customPronouns == customPronouns &&
        other.nickname == nickname &&
        other.experienceLevel == experienceLevel &&
        other.descriptiveWords == descriptiveWords &&
        other.motivation == motivation &&
        other.certifications == certifications &&
        other.coachingExperience == coachingExperience &&
        other.equipmentDetails == equipmentDetails &&
        other.trainingPhilosophy == trainingPhilosophy &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      fullName,
      pronouns,
      customPronouns,
      nickname,
      experienceLevel,
      descriptiveWords,
      motivation,
      certifications,
      coachingExperience,
      equipmentDetails,
      trainingPhilosophy,
      email,
      password,
    );
  }

  @override
  String toString() {
    return 'TrainerProfileModel(id: $id, fullName: $fullName, email: $email)';
  }
} 