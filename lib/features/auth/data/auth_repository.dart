
import 'package:supabase_flutter/supabase_flutter.dart';


import '../../../core/models/user.dart' as app_user;
import '../../../core/services/supabase_service.dart';
import '../../../core/repositories/user_repository.dart';
import '../../../core/utils/app_print.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

/// Repository for authentication operations
class AuthRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  /// Sign in with email and password
  Future<supabase.User?> signInWithEmail(String email, String password) async {
    try {
      AppPrint.printInfo('Signing in user: $email');
      final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
      
      if (response.user != null) {
        return response.user;
      }
      
      return null;
    } catch (e) {
      AppPrint.printError('Sign in failed: $e');
      rethrow;
    }
  }

  /// Sign up with email and password
  Future<Map<String, dynamic>> signUpWithEmail(String email, String password) async {
    try {
      AppPrint.printInfo('Signing up user: $email');
      final AuthResponse response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: "icon://login-callback",
      );

      if (response.user == null) {
        throw Exception('Sign up failed. Please try again.');
      }

      // Check if email confirmation is required
      if (response.session == null) {
        // Email confirmation is required
        return {
          'user': response.user,
          'requiresEmailConfirmation': true,
        };
      } else {
        // User is immediately authenticated (email confirmation not required)
        return {
          'user': response.user,
          'requiresEmailConfirmation': false,
        };
      }
    } on AuthException catch (e) {
      String errorMsg = 'Failed to sign up';

      if (e.message.contains('Invalid login credentials')) {
        errorMsg =
            'Invalid email or password. Please check your credentials and try again.';
      } else if (e.message.contains('Email not confirmed')) {
        errorMsg = 'Please verify your email address before signing in.';
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
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      AppPrint.printError('Sign out failed: $e');
      rethrow;
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
      await Supabase.instance.client.auth.signInWithPassword(
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