import '../../../core/services/supabase_service.dart';
import '../../../core/utils/app_print.dart';

/// Service for handling data operations
class DataService {
  final SupabaseService _supabaseService = SupabaseService.instance;

  /// Download user data
  Future<bool> downloadUserData() async {
    try {
      AppPrint.printInfo('Starting user data download...');
      
      final currentUser = _supabaseService.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      // Get user profile data
      final userData = await _supabaseService.getUserData(currentUser.id);
      if (userData == null) {
        throw Exception('Failed to retrieve user data');
      }

      // Get user's fitness data (workouts, activities, etc.)
      final fitnessData = await _getFitnessData(currentUser.id);
      
      // Get user's settings data
      final settingsData = await _getSettingsData(currentUser.id);

      // Combine all data
      final allUserData = {
        'user_profile': userData,
        'fitness_data': fitnessData,
        'settings': settingsData,
        'download_timestamp': DateTime.now().toIso8601String(),
      };

      // In a real app, you would:
      // 1. Generate a JSON file with this data
      // 2. Send it to a backend service for processing
      // 3. Send an email to the user with a download link
      // 4. Store the request in a database for tracking

      AppPrint.printInfo('User data prepared for download');
      
      // Simulate sending email notification
      await _sendDataDownloadEmail(currentUser.email!);
      
      return true;
    } catch (e) {
      AppPrint.printError('Failed to download user data: $e');
      rethrow;
    }
  }

  /// Get user's fitness data
  Future<Map<String, dynamic>> _getFitnessData(String userId) async {
    try {
      // Get workouts
      final workouts = await _supabaseService.getData(
        table: 'workouts',
        filters: {'user_id': userId},
      );

      // Get activities
      final activities = await _supabaseService.getData(
        table: 'activities',
        filters: {'user_id': userId},
      );

      // Get goals
      final goals = await _supabaseService.getData(
        table: 'goals',
        filters: {'user_id': userId},
      );

      return {
        'workouts': workouts,
        'activities': activities,
        'goals': goals,
      };
    } catch (e) {
      AppPrint.printError('Failed to get fitness data: $e');
      return {};
    }
  }

  /// Get user's settings data
  Future<Map<String, dynamic>> _getSettingsData(String userId) async {
    try {
      // Get user preferences
      final preferences = await _supabaseService.getData(
        table: 'user_preferences',
        filters: {'user_id': userId},
      );

      return {
        'preferences': preferences,
      };
    } catch (e) {
      AppPrint.printError('Failed to get settings data: $e');
      return {};
    }
  }

  /// Send data download email notification
  Future<void> _sendDataDownloadEmail(String email) async {
    try {
      // In a real app, this would be handled by a backend service
      // For now, we'll just log it
      AppPrint.printInfo('Sending data download email to: $email');
      
      // Simulate email sending delay
      await Future.delayed(const Duration(seconds: 1));
      
      AppPrint.printInfo('Data download email sent successfully');
    } catch (e) {
      AppPrint.printError('Failed to send data download email: $e');
      rethrow;
    }
  }
} 