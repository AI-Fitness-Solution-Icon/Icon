import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../constants/api_config.dart';
import '../models/user.dart';

/// Supabase service for database operations and authentication
class SupabaseService {
  static SupabaseService? _instance;
  late final supabase.SupabaseClient _client;

  SupabaseService._() {
    _client = supabase.Supabase.instance.client;
  }

  /// Singleton instance of SupabaseService
  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  /// Get the Supabase client instance
  supabase.SupabaseClient get client => _client;

  /// Initialize Supabase with configuration
  static Future<void> initialize() async {
    await supabase.Supabase.initialize(
      url: ApiConfig.supabaseUrl,
      anonKey: ApiConfig.supabaseAnonKey,
    );
  }

  /// Get current user session
  supabase.User? get currentUser => _client.auth.currentUser;

  /// Get current session
  supabase.Session? get currentSession => _client.auth.currentSession;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Reset password
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  /// Update user password
  Future<supabase.UserResponse> updatePassword(String newPassword) async {
    return await _client.auth.updateUser(
      supabase.UserAttributes(password: newPassword),
    );
  }

  /// Stream of auth state changes
  Stream<supabase.AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;

  /// Get data from a table
  Future<List<Map<String, dynamic>>> getData({
    required String table,
    String? select,
    Map<String, dynamic>? filters,
    int? limit,
    int? offset,
  }) async {
    return await _client.from(table).select(select ?? '*');
  }

  /// Insert data into a table
  Future<List<Map<String, dynamic>>> insertData({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    return await _client.from(table).insert(data).select();
  }

  /// Delete data from a table
  Future<void> deleteData({
    required String table,
    required Map<String, dynamic> filters,
  }) async {
    await _client.from(table).delete();
  }

  /// Upload file to storage
  Future<String> uploadFile({
    required String bucket,
    required String path,
    required Uint8List fileBytes,
    String? contentType,
  }) async {
    await _client.storage
        .from(bucket)
        .uploadBinary(
          path,
          fileBytes,
          fileOptions: supabase.FileOptions(contentType: contentType),
        );

    return _client.storage.from(bucket).getPublicUrl(path);
  }

  /// Download file from storage
  Future<Uint8List> downloadFile({
    required String bucket,
    required String path,
  }) async {
    return await _client.storage.from(bucket).download(path);
  }

  /// Delete file from storage
  Future<void> deleteFile({
    required String bucket,
    required String path,
  }) async {
    await _client.storage.from(bucket).remove([path]);
  }

  /// Get user data from database by user ID
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select('*, roles(*)')
          .eq('user_id', userId)
          .single();
      return response;
    } catch (e) {
      return null;
    }
  }

  /// Convert Supabase User to app User model
  Future<User?> convertSupabaseUserToAppUser(
    supabase.User? supabaseUser,
  ) async {
    if (supabaseUser == null) return null;

    try {
      final userData = await getUserData(supabaseUser.id);
      if (userData == null) return null;

      return User.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  /// Delete current user account
  Future<void> deleteUser() async {
    await _client.auth.admin.deleteUser(currentUser!.id);
  }
}
