import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trainer_profile_model.dart';

/// Local data source for trainer onboarding data
/// Handles local storage operations using SharedPreferences
class TrainerOnboardingLocalDataSource {
  static const String _profileKey = 'trainer_onboarding_profile';
  static const String _stepKey = 'trainer_onboarding_step';

  /// Saves trainer profile to local storage
  Future<void> saveProfile(TrainerProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = profile.toJson();
    await prefs.setString(_profileKey, jsonEncode(profileJson));
  }

  /// Retrieves trainer profile from local storage
  Future<TrainerProfileModel?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileString = prefs.getString(_profileKey);
    
    if (profileString == null) return null;
    
    try {
      final profileJson = jsonDecode(profileString) as Map<String, dynamic>;
      return TrainerProfileModel.fromJson(profileJson);
    } catch (e) {
      // If data is corrupted, clear it and return null
      await clearProfile();
      return null;
    }
  }

  /// Updates trainer profile in local storage
  Future<void> updateProfile(TrainerProfileModel profile) async {
    await saveProfile(profile);
  }

  /// Clears trainer profile from local storage
  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
    await prefs.remove(_stepKey);
  }

  /// Saves current onboarding step
  Future<void> saveCurrentStep(int step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_stepKey, step);
  }

  /// Retrieves current onboarding step
  Future<int> getCurrentStep() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_stepKey) ?? 1;
  }
} 