import '../../../core/models/user.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/repositories/user_repository.dart';
import '../../../core/utils/app_print.dart';

/// Repository for authentication operations
class AuthRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  /// Sign in with email and password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      AppPrint.printInfo('Signing in user: $email');
      final response = await _supabaseService.signInWithEmail(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        return await _supabaseService.convertSupabaseUserToAppUser(response.user);
      }
      
      return null;
    } catch (e) {
      AppPrint.printError('Sign in failed: $e');
      rethrow;
    }
  }

  /// Sign up with email and password
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      AppPrint.printInfo('Signing up user: $email');
      final response = await _supabaseService.signUpWithEmail(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        return await _supabaseService.convertSupabaseUserToAppUser(response.user);
      }
      
      return null;
    } catch (e) {
      AppPrint.printError('Sign up failed: $e');
      rethrow;
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      AppPrint.printInfo('Signing out user');
      await _supabaseService.signOut();
    } catch (e) {
      AppPrint.printError('Sign out failed: $e');
      rethrow;
    }
  }

  /// Get current user
  User? getCurrentUser() {
    try {
      final supabaseUser = _supabaseService.currentUser;
      if (supabaseUser != null) {
        // Note: This is synchronous, so we can't use the async conversion method
        // In a real app, you might want to cache the user data or handle this differently
        return null;
      }
      return null;
    } catch (e) {
      AppPrint.printError('Get current user failed: $e');
      return null;
    }
  }

  /// Get current user asynchronously
  Future<User?> getCurrentUserAsync() async {
    try {
      final supabaseUser = _supabaseService.currentUser;
      if (supabaseUser != null) {
        return await _supabaseService.convertSupabaseUserToAppUser(supabaseUser);
      }
      return null;
    } catch (e) {
      AppPrint.printError('Get current user failed: $e');
      return null;
    }
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _supabaseService.isAuthenticated;
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      AppPrint.printInfo('Resetting password for: $email');
      await _supabaseService.resetPassword(email);
    } catch (e) {
      AppPrint.printError('Reset password failed: $e');
      rethrow;
    }
  }

  /// Change password
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      AppPrint.printInfo('Changing password for current user');
      
      // First, verify the current password by attempting to sign in
      final currentUser = _supabaseService.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }
      
      // Verify current password by attempting to sign in with current credentials
      // This is a common pattern to verify the current password before changing it
      await _supabaseService.signInWithEmail(
        email: currentUser.email!,
        password: currentPassword,
      );
      
      // If sign in succeeds, update the password
      await _supabaseService.updatePassword(newPassword);
      
      AppPrint.printInfo('Password changed successfully');
    } catch (e) {
      AppPrint.printError('Change password failed: $e');
      rethrow;
    }
  }

  /// Update user profile
  Future<User?> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      AppPrint.printInfo('Updating profile for current user');
      
      final currentUser = _supabaseService.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      // Use UserRepository to update the profile
      final userRepository = UserRepository();
      final updatedUser = await userRepository.updateUserProfile(
        userId: currentUser.id,
        firstName: firstName,
        lastName: lastName,
        email: email,
      );

      if (updatedUser != null) {
        AppPrint.printInfo('Profile updated successfully');
        return updatedUser;
      }
      
      return null;
    } catch (e) {
      AppPrint.printError('Update profile failed: $e');
      rethrow;
    }
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    try {
      AppPrint.printInfo('Deleting user account');
      
      final currentUser = _supabaseService.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      // Delete user data from the database first
      final userRepository = UserRepository();
      await userRepository.deleteUser(currentUser.id);
      
      // Delete the user account from Supabase
      await _supabaseService.deleteUser();
      
      AppPrint.printInfo('Account deleted successfully');
    } catch (e) {
      AppPrint.printError('Delete account failed: $e');
      rethrow;
    }
  }
} 