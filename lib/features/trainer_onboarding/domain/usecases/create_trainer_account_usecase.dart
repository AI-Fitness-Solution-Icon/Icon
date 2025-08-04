import '../entities/trainer_profile.dart';
import '../repositories/trainer_onboarding_repository.dart';

/// Use case for creating the final trainer account
/// Contains business logic for account creation
class CreateTrainerAccountUseCase {
  final TrainerOnboardingRepository repository;

  CreateTrainerAccountUseCase(this.repository);

  /// Executes the create trainer account operation
  /// Validates that the profile is complete before creating account
  Future<TrainerProfile> execute(TrainerProfile profile) async {
    // Business logic validation
    if (!profile.isCompleteForAccountCreation) {
      throw TrainerOnboardingException('Profile is not complete for account creation');
    }

    if (!_isValidPassword(profile.password!)) {
      throw TrainerOnboardingException(
        'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character'
      );
    }

    if (!_isValidEmail(profile.email!)) {
      throw TrainerOnboardingException('Invalid email format');
    }

    try {
      // Validate email availability
      final isEmailAvailable = await repository.validateEmail(profile.email!);
      if (!isEmailAvailable) {
        throw TrainerOnboardingException('Email is already taken');
      }

      return await repository.createTrainerAccount(profile);
    } catch (e) {
      if (e is TrainerOnboardingException) {
        rethrow;
      }
      throw TrainerOnboardingException('Failed to create trainer account: $e');
    }
  }

  /// Validates email format using business rules
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  /// Validates password strength using business rules
  bool _isValidPassword(String password) {
    // At least 8 characters long
    if (password.length < 8) return false;
    
    // Contains at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    
    // Contains at least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    
    // Contains at least one number
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    
    // Contains at least one special character
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    
    return true;
  }
}

/// Domain-specific exception for trainer onboarding operations
class TrainerOnboardingException implements Exception {
  final String message;

  TrainerOnboardingException(this.message);

  @override
  String toString() => 'TrainerOnboardingException: $message';
} 