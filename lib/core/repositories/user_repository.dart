import '../../../core/models/user.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/utils/app_print.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

/// Repository for User model operations
class UserRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;
  static const String _tableName = 'users';

  /// Get all users
  Future<List<User>> getAllUsers() async {
    try {
      AppPrint.printStep('Fetching all users');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, roles(*)',
      );

      final users = response.map((json) => User.fromJson(json)).toList();

      AppPrint.printPerformance(
        'Get all users',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully fetched ${users.length} users');

      return users;
    } catch (e) {
      AppPrint.printError('Failed to fetch users: $e');
      rethrow;
    }
  }

  /// Get user by ID
  Future<User?> getUserById(String userId) async {
    try {
      AppPrint.printStep('Fetching user by ID: $userId');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, roles(*)',
        filters: {'id': userId},
      );

      if (response.isEmpty) {
        AppPrint.printWarning('User not found with ID: $userId');
        return null;
      }

      final user = User.fromJson(response.first);

      AppPrint.printPerformance(
        'Get user by ID',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully fetched user: ${user.email}');

      return user;
    } catch (e) {
      AppPrint.printError('Failed to fetch user by ID: $e');
      rethrow;
    }
  }

  /// Get user by email
  Future<User?> getUserByEmail(String email) async {
    try {
      AppPrint.printStep('Fetching user by email: $email');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, roles(*)',
        filters: {'email': email},
      );

      if (response.isEmpty) {
        AppPrint.printWarning('User not found with email: $email');
        return null;
      }

      final user = User.fromJson(response.first);

      AppPrint.printPerformance(
        'Get user by email',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully fetched user: ${user.email}');

      return user;
    } catch (e) {
      AppPrint.printError('Failed to fetch user by email: $e');
      rethrow;
    }
  }

  /// Get users by role
  Future<List<User>> getUsersByRole(String roleId) async {
    try {
      AppPrint.printStep('Fetching users by role: $roleId');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, roles(*)',
        filters: {'role_id': roleId},
      );

      final users = response.map((json) => User.fromJson(json)).toList();

      AppPrint.printPerformance(
        'Get users by role',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully fetched ${users.length} users with role: $roleId',
      );

      return users;
    } catch (e) {
      AppPrint.printError('Failed to fetch users by role: $e');
      rethrow;
    }
  }

  /// Get active users
  Future<List<User>> getActiveUsers() async {
    try {
      AppPrint.printStep('Fetching active users');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, roles(*)',
        filters: {'is_active': true},
      );

      final users = response.map((json) => User.fromJson(json)).toList();

      AppPrint.printPerformance(
        'Get active users',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully fetched ${users.length} active users',
      );

      return users;
    } catch (e) {
      AppPrint.printError('Failed to fetch active users: $e');
      rethrow;
    }
  }

  /// Create a new user
  Future<User> createUser({
    required String roleId,
    required String email,
    required String passwordHash,
    String? firstName,
    String? lastName,
  }) async {
    try {
      AppPrint.printStep('Creating new user: $email');
      final startTime = DateTime.now();

      final userData = {
        'role_id': roleId,
        'email': email,
        'password_hash': passwordHash,
        'first_name': firstName,
        'last_name': lastName,
        'is_active': true,
      };

      final response = await _supabaseService.insertData(
        table: _tableName,
        data: userData,
      );

      final user = User.fromJson(response.first);

      AppPrint.printPerformance(
        'Create user',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully created user: ${user.email}');

      return user;
    } catch (e) {
      AppPrint.printError('Failed to create user: $e');
      rethrow;
    }
  }

  /// Update user
  Future<User?> updateUser(
    String userId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      AppPrint.printStep('Updating user: $userId');
      final startTime = DateTime.now();

      // Add updated_at timestamp
      updateData['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabaseService.client
          .from(_tableName)
          .update(updateData)
          .eq('id', userId)
          .select();

      if (response.isEmpty) {
        AppPrint.printWarning('User not found for update with ID: $userId');
        return null;
      }

      final user = User.fromJson(response.first);

      AppPrint.printPerformance(
        'Update user',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully updated user: ${user.email}');

      return user;
    } catch (e) {
      AppPrint.printError('Failed to update user: $e');
      rethrow;
    }
  }

  /// Update user profile
  Future<User?> updateUserProfile({
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? gender,
  }) async {
    AppPrint.printInfo('Updating profile for current user');

    final currentUser = _supabaseService.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user found');
    }

    final userId = supabase.Supabase.instance.client.auth.currentUser!.id;

    try {
      AppPrint.printStep('Updating user profile: $userId');

      final updateData = <String, dynamic>{};
      if (firstName != null) {
        updateData['first_name'] = firstName;
      }
      if (lastName != null) {
        updateData['last_name'] = lastName;
      }
      if (dateOfBirth != null) {
        updateData['date_of_birth'] = dateOfBirth.toIso8601String();
      }
      if (gender != null) {
        updateData['gender'] = gender;
      }
      updateData['email'] = currentUser.email;

      return await updateUser(userId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update user profile: $e');
      rethrow;
    }
  }

  /// Update user password
  Future<User?> updateUserPassword(
    String userId,
    String newPasswordHash,
  ) async {
    try {
      AppPrint.printStep('Updating user password: $userId');

      final updateData = {'password_hash': newPasswordHash};

      return await updateUser(userId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update user password: $e');
      rethrow;
    }
  }

  /// Update last login
  Future<User?> updateLastLogin(String userId) async {
    try {
      AppPrint.printStep('Updating last login: $userId');

      final updateData = {'last_login': DateTime.now().toIso8601String()};

      return await updateUser(userId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update last login: $e');
      rethrow;
    }
  }

  /// Deactivate user
  Future<User?> deactivateUser(String userId) async {
    try {
      AppPrint.printStep('Deactivating user: $userId');

      final updateData = {'is_active': false};

      return await updateUser(userId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to deactivate user: $e');
      rethrow;
    }
  }

  /// Activate user
  Future<User?> activateUser(String userId) async {
    try {
      AppPrint.printStep('Activating user: $userId');

      final updateData = {'is_active': true};

      return await updateUser(userId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to activate user: $e');
      rethrow;
    }
  }

  /// Delete user
  Future<bool> deleteUser(String userId) async {
    try {
      AppPrint.printStep('Deleting user: $userId');
      final startTime = DateTime.now();

      await _supabaseService.deleteData(
        table: _tableName,
        filters: {'id': userId},
      );

      AppPrint.printPerformance(
        'Delete user',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully deleted user: $userId');

      return true;
    } catch (e) {
      AppPrint.printError('Failed to delete user: $e');
      rethrow;
    }
  }

  /// Check if user exists
  Future<bool> userExists(String email) async {
    try {
      AppPrint.printStep('Checking if user exists: $email');

      final response = await _supabaseService.getData(
        table: _tableName,
        filters: {'email': email},
      );

      final exists = response.isNotEmpty;
      AppPrint.printInfo('User $email exists: $exists');

      return exists;
    } catch (e) {
      AppPrint.printError('Failed to check if user exists: $e');
      rethrow;
    }
  }

  /// Get users with pagination
  Future<List<User>> getUsersWithPagination({
    int limit = 10,
    int offset = 0,
    String? roleId,
    bool? isActive,
  }) async {
    try {
      AppPrint.printStep(
        'Fetching users with pagination (limit: $limit, offset: $offset)',
      );
      final startTime = DateTime.now();

      final filters = <String, dynamic>{};
      if (roleId != null) filters['role_id'] = roleId;
      if (isActive != null) filters['is_active'] = isActive;

      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, roles(*)',
        filters: filters.isNotEmpty ? filters : null,
        limit: limit,
        offset: offset,
      );

      final users = response.map((json) => User.fromJson(json)).toList();

      AppPrint.printPerformance(
        'Get users with pagination',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully fetched ${users.length} users');

      return users;
    } catch (e) {
      AppPrint.printError('Failed to fetch users with pagination: $e');
      rethrow;
    }
  }

  /// Get users count
  Future<int> getUsersCount({String? roleId, bool? isActive}) async {
    try {
      AppPrint.printStep('Getting users count');
      final startTime = DateTime.now();

      final filters = <String, dynamic>{};
      if (roleId != null) filters['role_id'] = roleId;
      if (isActive != null) filters['is_active'] = isActive;

      final response = await _supabaseService.getData(
        table: _tableName,
        filters: filters.isNotEmpty ? filters : null,
      );

      final count = response.length;

      AppPrint.printPerformance(
        'Get users count',
        DateTime.now().difference(startTime),
      );
      AppPrint.printInfo('Total users count: $count');

      return count;
    } catch (e) {
      AppPrint.printError('Failed to get users count: $e');
      rethrow;
    }
  }

  /// Search users by name or email
  Future<List<User>> searchUsers(String searchTerm) async {
    try {
      AppPrint.printStep('Searching users: $searchTerm');
      final startTime = DateTime.now();

      // Note: This is a simple search implementation
      // For production, you might want to use full-text search or more sophisticated filtering
      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, roles(*)',
      );

      final users = response.map((json) => User.fromJson(json)).toList();

      // Filter users based on search term
      final filteredUsers = users.where((user) {
        final searchLower = searchTerm.toLowerCase();
        return user.email.toLowerCase().contains(searchLower) ||
            (user.firstName?.toLowerCase().contains(searchLower) ?? false) ||
            (user.lastName?.toLowerCase().contains(searchLower) ?? false) ||
            user.fullName.toLowerCase().contains(searchLower);
      }).toList();

      AppPrint.printPerformance(
        'Search users',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Found ${filteredUsers.length} users matching: $searchTerm',
      );

      return filteredUsers;
    } catch (e) {
      AppPrint.printError('Failed to search users: $e');
      rethrow;
    }
  }
}
