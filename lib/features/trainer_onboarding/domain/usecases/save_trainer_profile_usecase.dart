import '../entities/trainer_profile.dart';
import '../repositories/trainer_onboarding_repository.dart';

/// Use case for saving trainer profile data
/// Contains business logic for profile saving operations
class SaveTrainerProfileUseCase {
  final TrainerOnboardingRepository repository;

  SaveTrainerProfileUseCase(this.repository);

  /// Executes the save trainer profile operation
  /// Validates the profile data before saving
  Future<TrainerProfile> execute(TrainerProfile profile) async {
    // Business logic validation
    if (profile.fullName != null && profile.fullName!.trim().isEmpty) {
      throw TrainerOnboardingException('Full name cannot be empty');
    }

    if (profile.email != null && !_isValidEmail(profile.email!)) {
      throw TrainerOnboardingException('Invalid email format');
    }

    try {
      return await repository.saveTrainerProfile(profile);
    } catch (e) {
      throw TrainerOnboardingException('Failed to save trainer profile: $e');
    }
  }

  /// Validates email format using business rules
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }
}

/// Domain-specific exception for trainer onboarding operations
class TrainerOnboardingException implements Exception {
  final String message;

  TrainerOnboardingException(this.message);

  @override
  String toString() => 'TrainerOnboardingException: $message';
} 