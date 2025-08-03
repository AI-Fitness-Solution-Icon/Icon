import '../../../core/models/workout.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/utils/app_print.dart';

/// Repository for Workout model operations
class WorkoutRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;
  static const String _tableName = 'workouts';

  /// Get all workouts
  Future<List<Workout>> getAllWorkouts() async {
    try {
      AppPrint.printStep('Fetching all workouts');
      final startTime = DateTime.now();
      
      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, creator:coaches(*)',
      );
      
      final workouts = response.map((json) => Workout.fromJson(json)).toList();
      
      AppPrint.printPerformance('Get all workouts', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Successfully fetched ${workouts.length} workouts');
      
      return workouts;
    } catch (e) {
      AppPrint.printError('Failed to fetch workouts: $e');
      rethrow;
    }
  }

  /// Get workout by ID
  Future<Workout?> getWorkoutById(String workoutId) async {
    try {
      AppPrint.printStep('Fetching workout by ID: $workoutId');
      final startTime = DateTime.now();
      
      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, creator:coaches(*)',
        filters: {'workout_id': workoutId},
      );
      
      if (response.isEmpty) {
        AppPrint.printWarning('Workout not found with ID: $workoutId');
        return null;
      }
      
      final workout = Workout.fromJson(response.first);
      
      AppPrint.printPerformance('Get workout by ID', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Successfully fetched workout: ${workout.name}');
      
      return workout;
    } catch (e) {
      AppPrint.printError('Failed to fetch workout by ID: $e');
      rethrow;
    }
  }

  /// Get workouts by creator
  Future<List<Workout>> getWorkoutsByCreator(String creatorId) async {
    try {
      AppPrint.printStep('Fetching workouts by creator: $creatorId');
      final startTime = DateTime.now();
      
      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, creator:coaches(*)',
        filters: {'creator_id': creatorId},
      );
      
      final workouts = response.map((json) => Workout.fromJson(json)).toList();
      
      AppPrint.printPerformance('Get workouts by creator', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Successfully fetched ${workouts.length} workouts for creator: $creatorId');
      
      return workouts;
    } catch (e) {
      AppPrint.printError('Failed to fetch workouts by creator: $e');
      rethrow;
    }
  }

  /// Get workouts by difficulty level
  Future<List<Workout>> getWorkoutsByDifficulty(String difficultyLevel) async {
    try {
      AppPrint.printStep('Fetching workouts by difficulty: $difficultyLevel');
      final startTime = DateTime.now();
      
      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, creator:coaches(*)',
        filters: {'difficulty_level': difficultyLevel},
      );
      
      final workouts = response.map((json) => Workout.fromJson(json)).toList();
      
      AppPrint.printPerformance('Get workouts by difficulty', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Successfully fetched ${workouts.length} workouts with difficulty: $difficultyLevel');
      
      return workouts;
    } catch (e) {
      AppPrint.printError('Failed to fetch workouts by difficulty: $e');
      rethrow;
    }
  }

  /// Get workouts by duration range
  Future<List<Workout>> getWorkoutsByDurationRange(int minDuration, int maxDuration) async {
    try {
      AppPrint.printStep('Fetching workouts by duration range: $minDuration-$maxDuration minutes');
      final startTime = DateTime.now();
      
      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, creator:coaches(*)',
      );
      
      final workouts = response.map((json) => Workout.fromJson(json)).toList();
      
      // Filter workouts by duration range
      final filteredWorkouts = workouts.where((workout) {
        return workout.duration >= minDuration && workout.duration <= maxDuration;
      }).toList();
      
      AppPrint.printPerformance('Get workouts by duration range', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Successfully fetched ${filteredWorkouts.length} workouts in duration range: $minDuration-$maxDuration');
      
      return filteredWorkouts;
    } catch (e) {
      AppPrint.printError('Failed to fetch workouts by duration range: $e');
      rethrow;
    }
  }

  /// Create a new workout
  Future<Workout> createWorkout({
    required String creatorId,
    required String name,
    String? description,
    required int duration,
    String? difficultyLevel,
  }) async {
    try {
      AppPrint.printStep('Creating new workout: $name');
      final startTime = DateTime.now();
      
      final workoutData = {
        'creator_id': creatorId,
        'name': name,
        'description': description,
        'duration': duration,
        'difficulty_level': difficultyLevel ?? 'Beginner',
      };
      
      final response = await _supabaseService.insertData(
        table: _tableName,
        data: workoutData,
      );
      
      final workout = Workout.fromJson(response.first);
      
      AppPrint.printPerformance('Create workout', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Successfully created workout: ${workout.name}');
      
      return workout;
    } catch (e) {
      AppPrint.printError('Failed to create workout: $e');
      rethrow;
    }
  }

  /// Update workout
  Future<Workout?> updateWorkout(String workoutId, Map<String, dynamic> updateData) async {
    try {
      AppPrint.printStep('Updating workout: $workoutId');
      final startTime = DateTime.now();
      
      // Add updated_at timestamp
      updateData['updated_at'] = DateTime.now().toIso8601String();
      
      final response = await _supabaseService.updateData(
        table: _tableName,
        data: updateData,
        filters: {'workout_id': workoutId},
      );
      
      if (response.isEmpty) {
        AppPrint.printWarning('Workout not found for update with ID: $workoutId');
        return null;
      }
      
      final workout = Workout.fromJson(response.first);
      
      AppPrint.printPerformance('Update workout', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Successfully updated workout: ${workout.name}');
      
      return workout;
    } catch (e) {
      AppPrint.printError('Failed to update workout: $e');
      rethrow;
    }
  }

  /// Update workout name
  Future<Workout?> updateWorkoutName(String workoutId, String name) async {
    try {
      AppPrint.printStep('Updating workout name: $workoutId');
      
      final updateData = {
        'name': name,
      };
      
      return await updateWorkout(workoutId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update workout name: $e');
      rethrow;
    }
  }

  /// Update workout description
  Future<Workout?> updateWorkoutDescription(String workoutId, String description) async {
    try {
      AppPrint.printStep('Updating workout description: $workoutId');
      
      final updateData = {
        'description': description,
      };
      
      return await updateWorkout(workoutId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update workout description: $e');
      rethrow;
    }
  }

  /// Update workout duration
  Future<Workout?> updateWorkoutDuration(String workoutId, int duration) async {
    try {
      AppPrint.printStep('Updating workout duration: $workoutId');
      
      final updateData = {
        'duration': duration,
      };
      
      return await updateWorkout(workoutId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update workout duration: $e');
      rethrow;
    }
  }

  /// Update workout difficulty level
  Future<Workout?> updateWorkoutDifficulty(String workoutId, String difficultyLevel) async {
    try {
      AppPrint.printStep('Updating workout difficulty: $workoutId');
      
      final updateData = {
        'difficulty_level': difficultyLevel,
      };
      
      return await updateWorkout(workoutId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update workout difficulty: $e');
      rethrow;
    }
  }

  /// Delete workout
  Future<bool> deleteWorkout(String workoutId) async {
    try {
      AppPrint.printStep('Deleting workout: $workoutId');
      final startTime = DateTime.now();
      
      await _supabaseService.deleteData(
        table: _tableName,
        filters: {'workout_id': workoutId},
      );
      
      AppPrint.printPerformance('Delete workout', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Successfully deleted workout: $workoutId');
      
      return true;
    } catch (e) {
      AppPrint.printError('Failed to delete workout: $e');
      rethrow;
    }
  }

  /// Check if workout exists
  Future<bool> workoutExists(String workoutId) async {
    try {
      AppPrint.printStep('Checking if workout exists: $workoutId');
      
      final response = await _supabaseService.getData(
        table: _tableName,
        filters: {'workout_id': workoutId},
      );
      
      final exists = response.isNotEmpty;
      AppPrint.printInfo('Workout $workoutId exists: $exists');
      
      return exists;
    } catch (e) {
      AppPrint.printError('Failed to check if workout exists: $e');
      rethrow;
    }
  }

  /// Get workouts with pagination
  Future<List<Workout>> getWorkoutsWithPagination({
    int limit = 10,
    int offset = 0,
    String? creatorId,
    String? difficultyLevel,
  }) async {
    try {
      AppPrint.printStep('Fetching workouts with pagination (limit: $limit, offset: $offset)');
      final startTime = DateTime.now();
      
      final filters = <String, dynamic>{};
      if (creatorId != null) filters['creator_id'] = creatorId;
      if (difficultyLevel != null) filters['difficulty_level'] = difficultyLevel;
      
      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, creator:coaches(*)',
        filters: filters.isNotEmpty ? filters : null,
        limit: limit,
        offset: offset,
      );
      
      final workouts = response.map((json) => Workout.fromJson(json)).toList();
      
      AppPrint.printPerformance('Get workouts with pagination', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Successfully fetched ${workouts.length} workouts');
      
      return workouts;
    } catch (e) {
      AppPrint.printError('Failed to fetch workouts with pagination: $e');
      rethrow;
    }
  }

  /// Get workouts count
  Future<int> getWorkoutsCount({String? creatorId, String? difficultyLevel}) async {
    try {
      AppPrint.printStep('Getting workouts count');
      final startTime = DateTime.now();
      
      final filters = <String, dynamic>{};
      if (creatorId != null) filters['creator_id'] = creatorId;
      if (difficultyLevel != null) filters['difficulty_level'] = difficultyLevel;
      
      final response = await _supabaseService.getData(
        table: _tableName,
        filters: filters.isNotEmpty ? filters : null,
      );
      
      final count = response.length;
      
      AppPrint.printPerformance('Get workouts count', DateTime.now().difference(startTime));
      AppPrint.printInfo('Total workouts count: $count');
      
      return count;
    } catch (e) {
      AppPrint.printError('Failed to get workouts count: $e');
      rethrow;
    }
  }

  /// Search workouts by name or description
  Future<List<Workout>> searchWorkouts(String searchTerm) async {
    try {
      AppPrint.printStep('Searching workouts: $searchTerm');
      final startTime = DateTime.now();
      
      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, creator:coaches(*)',
      );
      
      final workouts = response.map((json) => Workout.fromJson(json)).toList();
      
      // Filter workouts based on search term
      final filteredWorkouts = workouts.where((workout) {
        final searchLower = searchTerm.toLowerCase();
        return workout.name.toLowerCase().contains(searchLower) ||
               (workout.description?.toLowerCase().contains(searchLower) ?? false) ||
               workout.difficultyLevel.toLowerCase().contains(searchLower);
      }).toList();
      
      AppPrint.printPerformance('Search workouts', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Found ${filteredWorkouts.length} workouts matching: $searchTerm');
      
      return filteredWorkouts;
    } catch (e) {
      AppPrint.printError('Failed to search workouts: $e');
      rethrow;
    }
  }

  /// Get recent workouts
  Future<List<Workout>> getRecentWorkouts({int limit = 10}) async {
    try {
      AppPrint.printStep('Fetching recent workouts');
      final startTime = DateTime.now();
      
      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, creator:coaches(*)',
        limit: limit,
      );
      
      final workouts = response.map((json) => Workout.fromJson(json)).toList();
      
      // Sort by creation date (newest first)
      workouts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      AppPrint.printPerformance('Get recent workouts', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Successfully fetched ${workouts.length} recent workouts');
      
      return workouts;
    } catch (e) {
      AppPrint.printError('Failed to fetch recent workouts: $e');
      rethrow;
    }
  }
} 