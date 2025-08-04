/// Domain entity representing a trainer's profile information
/// This is a pure business object with no external dependencies
class TrainerProfile {
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

  const TrainerProfile({
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

  /// Creates a copy of this TrainerProfile with the given fields replaced
  TrainerProfile copyWith({
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
    return TrainerProfile(
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

  /// Checks if the profile is complete for account creation
  bool get isCompleteForAccountCreation {
    return fullName != null && 
           fullName!.isNotEmpty &&
           email != null && 
           email!.isNotEmpty &&
           password != null && 
           password!.isNotEmpty;
  }

  /// Gets the current step number based on filled data
  int get currentStep {
    if (fullName == null || fullName!.isEmpty) return 1;
    if (experienceLevel == null || experienceLevel!.isEmpty) return 1;
    if (descriptiveWords.isEmpty) return 1;
    if (motivation == null || motivation!.isEmpty) return 1;
    if (certifications.isEmpty) return 2;
    if (coachingExperience == null || coachingExperience!.isEmpty) return 2;
    if (trainingPhilosophy.isEmpty) return 3;
    if (email == null || email!.isEmpty) return 4;
    if (password == null || password!.isEmpty) return 4;
    return 4; // Complete
  }

  /// Gets the total number of steps in the onboarding process
  static const int totalSteps = 4;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrainerProfile &&
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
    return 'TrainerProfile(id: $id, fullName: $fullName, email: $email, currentStep: $currentStep)';
  }
} 