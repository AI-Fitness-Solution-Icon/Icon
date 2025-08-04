import '../../domain/entities/trainer_profile.dart';
import '../../domain/repositories/trainer_onboarding_repository.dart';
import '../datasources/trainer_onboarding_local_datasource.dart';
import '../mappers/trainer_profile_mapper.dart';
import '../../../../core/services/supabase_service.dart';

/// Implementation of TrainerOnboardingRepository
/// Coordinates between local and remote data sources
class TrainerOnboardingRepositoryImpl implements TrainerOnboardingRepository {
  final TrainerOnboardingLocalDataSource localDataSource;
  final TrainerProfileMapper mapper;
  final SupabaseService supabaseService;

  TrainerOnboardingRepositoryImpl({
    required this.localDataSource,
    required this.mapper,
    required this.supabaseService,
  });

  @override
  Future<TrainerProfile> saveTrainerProfile(TrainerProfile profile) async {
    try {
      final profileModel = mapper.toModel(profile);
      await localDataSource.saveProfile(profileModel);
      return profile;
    } catch (e) {
      throw Exception('Failed to save trainer profile: $e');
    }
  }

  @override
  Future<TrainerProfile?> getCurrentProfile() async {
    try {
      final profileModel = await localDataSource.getProfile();
      if (profileModel == null) return null;
      return mapper.toEntity(profileModel);
    } catch (e) {
      throw Exception('Failed to get current profile: $e');
    }
  }

  @override
  Future<TrainerProfile> updateTrainerProfile(TrainerProfile profile) async {
    try {
      final profileModel = mapper.toModel(profile);
      await localDataSource.updateProfile(profileModel);
      return profile;
    } catch (e) {
      throw Exception('Failed to update trainer profile: $e');
    }
  }

  @override
  Future<TrainerProfile> createTrainerAccount(TrainerProfile profile) async {
    try {
      // Create user account in Supabase
      final response = await supabaseService.client.auth.signUp(
        email: profile.email!,
        password: profile.password!,
      );

      if (response.user == null) {
        throw Exception('Failed to create user account. Please try again.');
      }

      // Save trainer profile to database
      final profileData = {
        'id': response.user!.id,
        'full_name': profile.fullName,
        'pronouns': profile.pronouns,
        'custom_pronouns': profile.customPronouns,
        'nickname': profile.nickname,
        'experience_level': profile.experienceLevel,
        'descriptive_words': profile.descriptiveWords,
        'motivation': profile.motivation,
        'certifications': profile.certifications,
        'coaching_experience': profile.coachingExperience,
        'equipment_details': profile.equipmentDetails,
        'training_philosophy': profile.trainingPhilosophy,
        'user_type': 'trainer',
        'created_at': DateTime.now().toIso8601String(),
      };

      await supabaseService.client
          .from('trainer_profiles')
          .insert(profileData);

      // Clear local onboarding data
      await localDataSource.clearProfile();

      // Return profile with generated ID
      return profile.copyWith(id: response.user!.id);
    } catch (e) {
      // Provide more specific error messages
      if (e.toString().contains('User already registered')) {
        throw Exception('An account with this email already exists. Please use a different email or try signing in.');
      } else if (e.toString().contains('Invalid email')) {
        throw Exception('Please enter a valid email address.');
      } else if (e.toString().contains('Password')) {
        throw Exception('Password does not meet security requirements. Please choose a stronger password.');
      } else if (e.toString().contains('network') || e.toString().contains('connection')) {
        throw Exception('Network error. Please check your internet connection and try again.');
      } else {
        throw Exception('Failed to create account. Please try again later.');
      }
    }
  }

  @override
  Future<bool> validateEmail(String email) async {
    try {
      // Try to sign up with the email to see if it's available
      // This is a workaround since we don't have admin access
      await supabaseService.client.auth.signUp(
        email: email,
        password: 'temporary_password_for_validation',
      );
      
      // If successful, the email is available
      // We need to clean up the temporary user
      await supabaseService.client.auth.signOut();
      return true;
    } catch (e) {
      // If sign up fails with "User already registered", email is taken
      if (e.toString().contains('User already registered') ||
          e.toString().contains('already registered')) {
        return false;
      }
      // For other errors, assume email is available
      return true;
    }
  }

  @override
  Future<void> clearOnboardingData() async {
    try {
      await localDataSource.clearProfile();
    } catch (e) {
      throw Exception('Failed to clear onboarding data: $e');
    }
  }
} 