import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/user.dart' as app_user;
import '../../../core/services/supabase_service.dart';
import '../../../core/repositories/user_repository.dart';
import '../../../core/utils/app_print.dart';

/// Repository for authentication operations
class AuthRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  /// Sign in with email and password
  Future<app_user.User?> signInWithEmail(String email, String password) async {
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

  void openEmail(String email) {
    // This method attempts to open the default email app so the user can check their email.
    // Note: This requires the 'url_launcher' package to be added to pubspec.yaml.
    // Usage: openEmail(userEmail);
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    // ignore: deprecated_member_use
    launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
  }

  /// Sign up with email and password
  Future<app_user.User?> signUpWithEmail(String email, String password) async {
    try {
      AppPrint.printInfo('Signing up user: $email');
      final response = await _supabaseService.signUpWithEmail(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login failed. Please try again.');
      }
      
      if (response.user != null) {
        return await _supabaseService.convertSupabaseUserToAppUser(response.user);
      }
      
      return null;
    } on AuthException catch (e) {
      String errorMsg = 'Failed to sign up';

      if (e.message.contains('Invalid login credentials')) {
        errorMsg =
            'Invalid email or password. Please check your credentials and try again.';
      } else if (e.message.contains('Email not confirmed')) {
        errorMsg = 'Please verify your email address before signing in.';

      // open the amil client for the user to check it . 
      openEmail(email);

      } else if (e.message.contains('Too many requests')) {
        errorMsg = 'Too many login attempts. Please try again later.';
      } else if (e.message.contains('network')) {
        errorMsg =
            'Network error. Please check your internet connection and try again.';
      }

      throw Exception(errorMsg);
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
  app_user.User? getCurrentUser() {
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
  Future<app_user.User?> getCurrentUserAsync() async {
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
  Future<app_user.User?> updateProfile({
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