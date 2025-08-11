import 'package:icon_app/core/models/fitness_main_goal.dart';
import 'package:icon_app/core/models/user_main_goal.dart';
import 'package:icon_app/core/models/user_fitness_goal_detail.dart';
import 'package:icon_app/core/services/supabase_service.dart';
import 'package:icon_app/core/utils/app_print.dart';

/// Repository for managing fitness goals data
class FitnessGoalsRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  // ==================== FITNESS MAIN GOALS ====================

  /// Get all fitness main goals
  Future<List<FitnessMainGoal>> getAllMainGoals() async {
    try {
      AppPrint.printStep('Fetching all fitness main goals');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: FitnessMainGoal.tableName,
        select: '*',
      );

      final goals = response
          .map((json) => FitnessMainGoal.fromJson(json))
          .toList();

      AppPrint.printPerformance(
        'Get all main goals',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully fetched ${goals.length} main goals');

      return goals;
    } catch (e) {
      AppPrint.printError('Failed to fetch main goals: $e');
      rethrow;
    }
  }

  /// Get fitness main goal by ID
  Future<FitnessMainGoal?> getMainGoalById(String goalId) async {
    try {
      AppPrint.printStep('Fetching main goal by ID: $goalId');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: FitnessMainGoal.tableName,
        select: '*',
        filters: {'id': goalId},
      );

      if (response.isEmpty) {
        AppPrint.printWarning('Main goal not found with ID: $goalId');
        return null;
      }

      final goal = FitnessMainGoal.fromJson(response.first);

      AppPrint.printPerformance(
        'Get main goal by ID',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully fetched main goal: ${goal.name}');

      return goal;
    } catch (e) {
      AppPrint.printError('Failed to fetch main goal by ID: $e');
      rethrow;
    }
  }

  // ==================== USER MAIN GOALS ====================

  /// Get user's main goals
  Future<List<UserMainGoal>> getUserMainGoals(String userId) async {
    try {
      AppPrint.printStep('Fetching main goals for user: $userId');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: UserMainGoal.tableName,
        select: '*, fitness_main_goals(*)',
        filters: {'user_id': userId},
      );

      final userGoals = response
          .map((json) => UserMainGoal.fromJson(json))
          .toList();

      AppPrint.printPerformance(
        'Get user main goals',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully fetched ${userGoals.length} user main goals',
      );

      return userGoals;
    } catch (e) {
      AppPrint.printError('Failed to fetch user main goals: $e');
      rethrow;
    }
  }

  /// Add a main goal for a user
  Future<UserMainGoal?> addUserMainGoal({
    required String userId,
    required String mainGoalId,
  }) async {
    try {
      AppPrint.printStep(
        'Adding main goal for user: $userId, goal: $mainGoalId',
      );
      final startTime = DateTime.now();

      final data = {'user_id': userId, 'main_goal_id': mainGoalId};

      final response = await _supabaseService.insertData(
        table: UserMainGoal.tableName,
        data: data,
      );

      if (response.isNotEmpty) {
        final userGoal = UserMainGoal.fromJson(response.first);

        AppPrint.printPerformance(
          'Add user main goal',
          DateTime.now().difference(startTime),
        );
        AppPrint.printSuccess('Successfully added main goal for user');

        return userGoal;
      }

      return null;
    } catch (e) {
      AppPrint.printError('Failed to add user main goal: $e');
      rethrow;
    }
  }

  /// Remove a main goal for a user
  Future<bool> removeUserMainGoal({
    required String userId,
    required String mainGoalId,
  }) async {
    try {
      AppPrint.printStep(
        'Removing main goal for user: $userId, goal: $mainGoalId',
      );
      final startTime = DateTime.now();

      await _supabaseService.deleteData(
        table: UserMainGoal.tableName,
        filters: {'user_id': userId, 'main_goal_id': mainGoalId},
      );

      AppPrint.printPerformance(
        'Remove user main goal',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully removed main goal for user');

      return true;
    } catch (e) {
      AppPrint.printError('Failed to remove user main goal: $e');
      rethrow;
    }
  }

  // ==================== USER FITNESS GOAL DETAILS ====================

  /// Get user's fitness goal details
  Future<UserFitnessGoalDetail?> getUserFitnessGoalDetails(
    String userId,
  ) async {
    try {
      AppPrint.printStep('Fetching fitness goal details for user: $userId');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: UserFitnessGoalDetail.tableName,
        select: '*',
        filters: {'id': userId},
      );

      if (response.isEmpty) {
        AppPrint.printWarning(
          'Fitness goal details not found for user: $userId',
        );
        return null;
      }

      final details = UserFitnessGoalDetail.fromJson(response.first);

      AppPrint.printPerformance(
        'Get user fitness goal details',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully fetched fitness goal details');

      return details;
    } catch (e) {
      AppPrint.printError('Failed to fetch user fitness goal details: $e');
      rethrow;
    }
  }

  /// Create or update user's fitness goal details
  Future<UserFitnessGoalDetail?> saveUserFitnessGoalDetails({
    required String userId,
    required String experienceLevel,
    String? details,
  }) async {
    try {
      AppPrint.printStep('Saving fitness goal details for user: $userId');
      final startTime = DateTime.now();

      final data = {
        'id': userId,
        'experience_level': experienceLevel,
        'details': details,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Try to update first, if no rows affected, insert new
      try {
        await _supabaseService.client
            .from(UserFitnessGoalDetail.tableName)
            .update(data)
            .eq('id', userId);
      } catch (e) {
        // If update fails, insert new record
        data['created_at'] = DateTime.now().toIso8601String();
        final response = await _supabaseService.insertData(
          table: UserFitnessGoalDetail.tableName,
          data: data,
        );

        if (response.isNotEmpty) {
          final userDetails = UserFitnessGoalDetail.fromJson(response.first);

          AppPrint.printPerformance(
            'Save user fitness goal details',
            DateTime.now().difference(startTime),
          );
          AppPrint.printSuccess('Successfully created fitness goal details');

          return userDetails;
        }
      }

      // If update was successful, fetch the updated record
      final updatedDetails = await getUserFitnessGoalDetails(userId);

      AppPrint.printPerformance(
        'Save user fitness goal details',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully updated fitness goal details');

      return updatedDetails;
    } catch (e) {
      AppPrint.printError('Failed to save user fitness goal details: $e');
      rethrow;
    }
  }

  /// Update user's fitness goal details
  Future<UserFitnessGoalDetail?> updateUserFitnessGoalDetails({
    required String userId,
    String? experienceLevel,
    String? details,
  }) async {
    try {
      AppPrint.printStep('Updating fitness goal details for user: $userId');
      final startTime = DateTime.now();

      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (experienceLevel != null) {
        updateData['experience_level'] = experienceLevel;
      }
      if (details != null) {
        updateData['details'] = details;
      }

      await _supabaseService.client
          .from(UserFitnessGoalDetail.tableName)
          .update(updateData)
          .eq('id', userId);

      // Fetch the updated record
      final updatedDetails = await getUserFitnessGoalDetails(userId);

      AppPrint.printPerformance(
        'Update user fitness goal details',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully updated fitness goal details');

      return updatedDetails;
    } catch (e) {
      AppPrint.printError('Failed to update user fitness goal details: $e');
      rethrow;
    }
  }

  /// Delete user's fitness goal details
  Future<bool> deleteUserFitnessGoalDetails(String userId) async {
    try {
      AppPrint.printStep('Deleting fitness goal details for user: $userId');
      final startTime = DateTime.now();

      await _supabaseService.deleteData(
        table: UserFitnessGoalDetail.tableName,
        filters: {'id': userId},
      );

      AppPrint.printPerformance(
        'Delete user fitness goal details',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully deleted fitness goal details');

      return true;
    } catch (e) {
      AppPrint.printError('Failed to delete user fitness goal details: $e');
      rethrow;
    }
  }
}
