import '../entities/trainer_profile.dart';

/// Repository interface for trainer onboarding operations
/// This defines the contract for data operations in the domain layer
abstract class TrainerOnboardingRepository {
  /// Saves the trainer profile data
  /// Returns the saved profile with generated ID
  Future<TrainerProfile> saveTrainerProfile(TrainerProfile profile);
  
  /// Retrieves the current trainer profile from local storage
  /// Returns null if no profile exists
  Future<TrainerProfile?> getCurrentProfile();
  
  /// Updates the trainer profile data
  /// Returns the updated profile
  Future<TrainerProfile> updateTrainerProfile(TrainerProfile profile);
  
  /// Creates the trainer account with the completed profile
  /// Returns the created trainer profile
  Future<TrainerProfile> createTrainerAccount(TrainerProfile profile);
  
  /// Validates email format and availability
  /// Returns true if email is valid and available
  Future<bool> validateEmail(String email);
  
  /// Clears the onboarding data (used when starting over)
  Future<void> clearOnboardingData();
} 