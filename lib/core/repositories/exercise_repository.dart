import '../../../core/models/exercise.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/utils/app_print.dart';

/// Repository for Exercise model operations
class ExerciseRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;
  static const String _tableName = 'exercises';

  /// Get all exercises
  Future<List<Exercise>> getAllExercises() async {
    try {
      AppPrint.printStep('Fetching all exercises');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(table: _tableName);

      final exercises = response
          .map((json) => Exercise.fromJson(json))
          .toList();

      AppPrint.printPerformance(
        'Get all exercises',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully fetched ${exercises.length} exercises',
      );

      return exercises;
    } catch (e) {
      AppPrint.printError('Failed to fetch exercises: $e');
      rethrow;
    }
  }

  /// Get exercise by ID
  Future<Exercise?> getExerciseById(String exerciseId) async {
    try {
      AppPrint.printStep('Fetching exercise by ID: $exerciseId');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: _tableName,
        filters: {'exercise_id': exerciseId},
      );

      if (response.isEmpty) {
        AppPrint.printWarning('Exercise not found with ID: $exerciseId');
        return null;
      }

      final exercise = Exercise.fromJson(response.first);

      AppPrint.printPerformance(
        'Get exercise by ID',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully fetched exercise: ${exercise.name}');

      return exercise;
    } catch (e) {
      AppPrint.printError('Failed to fetch exercise by ID: $e');
      rethrow;
    }
  }

  /// Get exercises by muscle group
  Future<List<Exercise>> getExercisesByMuscleGroup(String muscleGroup) async {
    try {
      AppPrint.printStep('Fetching exercises by muscle group: $muscleGroup');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(table: _tableName);

      final exercises = response
          .map((json) => Exercise.fromJson(json))
          .toList();

      // Filter exercises by muscle group
      final filteredExercises = exercises.where((exercise) {
        return exercise.muscleGroups.contains(muscleGroup);
      }).toList();

      AppPrint.printPerformance(
        'Get exercises by muscle group',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully fetched ${filteredExercises.length} exercises for muscle group: $muscleGroup',
      );

      return filteredExercises;
    } catch (e) {
      AppPrint.printError('Failed to fetch exercises by muscle group: $e');
      rethrow;
    }
  }

  /// Get exercises by equipment
  Future<List<Exercise>> getExercisesByEquipment(String equipment) async {
    try {
      AppPrint.printStep('Fetching exercises by equipment: $equipment');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(table: _tableName);

      final exercises = response
          .map((json) => Exercise.fromJson(json))
          .toList();

      // Filter exercises by equipment
      final filteredExercises = exercises.where((exercise) {
        return exercise.equipmentNeeded.contains(equipment);
      }).toList();

      AppPrint.printPerformance(
        'Get exercises by equipment',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully fetched ${filteredExercises.length} exercises for equipment: $equipment',
      );

      return filteredExercises;
    } catch (e) {
      AppPrint.printError('Failed to fetch exercises by equipment: $e');
      rethrow;
    }
  }

  /// Get exercises that require no equipment
  Future<List<Exercise>> getBodyweightExercises() async {
    try {
      AppPrint.printStep('Fetching bodyweight exercises');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(table: _tableName);

      final exercises = response
          .map((json) => Exercise.fromJson(json))
          .toList();

      // Filter exercises that require no equipment
      final bodyweightExercises = exercises.where((exercise) {
        return exercise.equipmentNeeded.isEmpty;
      }).toList();

      AppPrint.printPerformance(
        'Get bodyweight exercises',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully fetched ${bodyweightExercises.length} bodyweight exercises',
      );

      return bodyweightExercises;
    } catch (e) {
      AppPrint.printError('Failed to fetch bodyweight exercises: $e');
      rethrow;
    }
  }

  /// Create a new exercise
  Future<Exercise> createExercise({
    required String name,
    String? description,
    List<String>? muscleGroups,
    List<String>? equipmentNeeded,
    String? videoUrl,
  }) async {
    try {
      AppPrint.printStep('Creating new exercise: $name');
      final startTime = DateTime.now();

      final exerciseData = {
        'name': name,
        'description': description,
        'muscle_groups': muscleGroups ?? [],
        'equipment_needed': equipmentNeeded ?? [],
        'video_url': videoUrl,
      };

      final response = await _supabaseService.insertData(
        table: _tableName,
        data: exerciseData,
      );

      final exercise = Exercise.fromJson(response.first);

      AppPrint.printPerformance(
        'Create exercise',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully created exercise: ${exercise.name}');

      return exercise;
    } catch (e) {
      AppPrint.printError('Failed to create exercise: $e');
      rethrow;
    }
  }

  /// Update exercise
  Future<Exercise?> updateExercise(
    String exerciseId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      AppPrint.printStep('Updating exercise: $exerciseId');
      final startTime = DateTime.now();

      // Add updated_at timestamp
      updateData['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabaseService.client
          .from(_tableName)
          .update(updateData)
          .eq('exercise_id', exerciseId)
          .select();

      if (response.isEmpty) {
        AppPrint.printWarning(
          'Exercise not found for update with ID: $exerciseId',
        );
        return null;
      }

      final exercise = Exercise.fromJson(response.first);

      AppPrint.printPerformance(
        'Update exercise',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully updated exercise: ${exercise.name}');

      return exercise;
    } catch (e) {
      AppPrint.printError('Failed to update exercise: $e');
      rethrow;
    }
  }

  /// Update exercise name
  Future<Exercise?> updateExerciseName(String exerciseId, String name) async {
    try {
      AppPrint.printStep('Updating exercise name: $exerciseId');

      final updateData = {'name': name};

      return await updateExercise(exerciseId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update exercise name: $e');
      rethrow;
    }
  }

  /// Update exercise description
  Future<Exercise?> updateExerciseDescription(
    String exerciseId,
    String description,
  ) async {
    try {
      AppPrint.printStep('Updating exercise description: $exerciseId');

      final updateData = {'description': description};

      return await updateExercise(exerciseId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update exercise description: $e');
      rethrow;
    }
  }

  /// Update exercise muscle groups
  Future<Exercise?> updateExerciseMuscleGroups(
    String exerciseId,
    List<String> muscleGroups,
  ) async {
    try {
      AppPrint.printStep('Updating exercise muscle groups: $exerciseId');

      final updateData = {'muscle_groups': muscleGroups};

      return await updateExercise(exerciseId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update exercise muscle groups: $e');
      rethrow;
    }
  }

  /// Update exercise equipment needed
  Future<Exercise?> updateExerciseEquipment(
    String exerciseId,
    List<String> equipmentNeeded,
  ) async {
    try {
      AppPrint.printStep('Updating exercise equipment: $exerciseId');

      final updateData = {'equipment_needed': equipmentNeeded};

      return await updateExercise(exerciseId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update exercise equipment: $e');
      rethrow;
    }
  }

  /// Update exercise video URL
  Future<Exercise?> updateExerciseVideoUrl(
    String exerciseId,
    String videoUrl,
  ) async {
    try {
      AppPrint.printStep('Updating exercise video URL: $exerciseId');

      final updateData = {'video_url': videoUrl};

      return await updateExercise(exerciseId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update exercise video URL: $e');
      rethrow;
    }
  }

  /// Add muscle group to exercise
  Future<Exercise?> addMuscleGroupToExercise(
    String exerciseId,
    String muscleGroup,
  ) async {
    try {
      AppPrint.printStep('Adding muscle group to exercise: $exerciseId');

      final currentExercise = await getExerciseById(exerciseId);
      if (currentExercise == null) {
        AppPrint.printWarning('Exercise not found: $exerciseId');
        return null;
      }

      final updatedMuscleGroups = List<String>.from(
        currentExercise.muscleGroups,
      );
      if (!updatedMuscleGroups.contains(muscleGroup)) {
        updatedMuscleGroups.add(muscleGroup);
      }

      return await updateExerciseMuscleGroups(exerciseId, updatedMuscleGroups);
    } catch (e) {
      AppPrint.printError('Failed to add muscle group to exercise: $e');
      rethrow;
    }
  }

  /// Add equipment to exercise
  Future<Exercise?> addEquipmentToExercise(
    String exerciseId,
    String equipment,
  ) async {
    try {
      AppPrint.printStep('Adding equipment to exercise: $exerciseId');

      final currentExercise = await getExerciseById(exerciseId);
      if (currentExercise == null) {
        AppPrint.printWarning('Exercise not found: $exerciseId');
        return null;
      }

      final updatedEquipment = List<String>.from(
        currentExercise.equipmentNeeded,
      );
      if (!updatedEquipment.contains(equipment)) {
        updatedEquipment.add(equipment);
      }

      return await updateExerciseEquipment(exerciseId, updatedEquipment);
    } catch (e) {
      AppPrint.printError('Failed to add equipment to exercise: $e');
      rethrow;
    }
  }

  /// Remove muscle group from exercise
  Future<Exercise?> removeMuscleGroupFromExercise(
    String exerciseId,
    String muscleGroup,
  ) async {
    try {
      AppPrint.printStep('Removing muscle group from exercise: $exerciseId');

      final currentExercise = await getExerciseById(exerciseId);
      if (currentExercise == null) {
        AppPrint.printWarning('Exercise not found: $exerciseId');
        return null;
      }

      final updatedMuscleGroups = List<String>.from(
        currentExercise.muscleGroups,
      );
      updatedMuscleGroups.remove(muscleGroup);

      return await updateExerciseMuscleGroups(exerciseId, updatedMuscleGroups);
    } catch (e) {
      AppPrint.printError('Failed to remove muscle group from exercise: $e');
      rethrow;
    }
  }

  /// Remove equipment from exercise
  Future<Exercise?> removeEquipmentFromExercise(
    String exerciseId,
    String equipment,
  ) async {
    try {
      AppPrint.printStep('Removing equipment from exercise: $exerciseId');

      final currentExercise = await getExerciseById(exerciseId);
      if (currentExercise == null) {
        AppPrint.printWarning('Exercise not found: $exerciseId');
        return null;
      }

      final updatedEquipment = List<String>.from(
        currentExercise.equipmentNeeded,
      );
      updatedEquipment.remove(equipment);

      return await updateExerciseEquipment(exerciseId, updatedEquipment);
    } catch (e) {
      AppPrint.printError('Failed to remove equipment from exercise: $e');
      rethrow;
    }
  }

  /// Delete exercise
  Future<bool> deleteExercise(String exerciseId) async {
    try {
      AppPrint.printStep('Deleting exercise: $exerciseId');
      final startTime = DateTime.now();

      await _supabaseService.deleteData(
        table: _tableName,
        filters: {'exercise_id': exerciseId},
      );

      AppPrint.printPerformance(
        'Delete exercise',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully deleted exercise: $exerciseId');

      return true;
    } catch (e) {
      AppPrint.printError('Failed to delete exercise: $e');
      rethrow;
    }
  }

  /// Check if exercise exists
  Future<bool> exerciseExists(String exerciseId) async {
    try {
      AppPrint.printStep('Checking if exercise exists: $exerciseId');

      final response = await _supabaseService.getData(
        table: _tableName,
        filters: {'exercise_id': exerciseId},
      );

      final exists = response.isNotEmpty;
      AppPrint.printInfo('Exercise $exerciseId exists: $exists');

      return exists;
    } catch (e) {
      AppPrint.printError('Failed to check if exercise exists: $e');
      rethrow;
    }
  }

  /// Get exercises with pagination
  Future<List<Exercise>> getExercisesWithPagination({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      AppPrint.printStep(
        'Fetching exercises with pagination (limit: $limit, offset: $offset)',
      );
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: _tableName,
        limit: limit,
        offset: offset,
      );

      final exercises = response
          .map((json) => Exercise.fromJson(json))
          .toList();

      AppPrint.printPerformance(
        'Get exercises with pagination',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully fetched ${exercises.length} exercises',
      );

      return exercises;
    } catch (e) {
      AppPrint.printError('Failed to fetch exercises with pagination: $e');
      rethrow;
    }
  }

  /// Get exercises count
  Future<int> getExercisesCount() async {
    try {
      AppPrint.printStep('Getting exercises count');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(table: _tableName);

      final count = response.length;

      AppPrint.printPerformance(
        'Get exercises count',
        DateTime.now().difference(startTime),
      );
      AppPrint.printInfo('Total exercises count: $count');

      return count;
    } catch (e) {
      AppPrint.printError('Failed to get exercises count: $e');
      rethrow;
    }
  }

  /// Search exercises by name or description
  Future<List<Exercise>> searchExercises(String searchTerm) async {
    try {
      AppPrint.printStep('Searching exercises: $searchTerm');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(table: _tableName);

      final exercises = response
          .map((json) => Exercise.fromJson(json))
          .toList();

      // Filter exercises based on search term
      final filteredExercises = exercises.where((exercise) {
        final searchLower = searchTerm.toLowerCase();
        return exercise.name.toLowerCase().contains(searchLower) ||
            (exercise.description?.toLowerCase().contains(searchLower) ??
                false) ||
            exercise.muscleGroups.any(
              (muscle) => muscle.toLowerCase().contains(searchLower),
            ) ||
            exercise.equipmentNeeded.any(
              (equipment) => equipment.toLowerCase().contains(searchLower),
            );
      }).toList();

      AppPrint.printPerformance(
        'Search exercises',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Found ${filteredExercises.length} exercises matching: $searchTerm',
      );

      return filteredExercises;
    } catch (e) {
      AppPrint.printError('Failed to search exercises: $e');
      rethrow;
    }
  }

  /// Get all unique muscle groups
  Future<List<String>> getAllMuscleGroups() async {
    try {
      AppPrint.printStep('Fetching all unique muscle groups');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(table: _tableName);

      final exercises = response
          .map((json) => Exercise.fromJson(json))
          .toList();

      // Extract all unique muscle groups
      final muscleGroups = <String>{};
      for (final exercise in exercises) {
        muscleGroups.addAll(exercise.muscleGroups);
      }

      final uniqueMuscleGroups = muscleGroups.toList()..sort();

      AppPrint.printPerformance(
        'Get all muscle groups',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully fetched ${uniqueMuscleGroups.length} unique muscle groups',
      );

      return uniqueMuscleGroups;
    } catch (e) {
      AppPrint.printError('Failed to fetch muscle groups: $e');
      rethrow;
    }
  }

  /// Get all unique equipment
  Future<List<String>> getAllEquipment() async {
    try {
      AppPrint.printStep('Fetching all unique equipment');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(table: _tableName);

      final exercises = response
          .map((json) => Exercise.fromJson(json))
          .toList();

      // Extract all unique equipment
      final equipment = <String>{};
      for (final exercise in exercises) {
        equipment.addAll(exercise.equipmentNeeded);
      }

      final uniqueEquipment = equipment.toList()..sort();

      AppPrint.printPerformance(
        'Get all equipment',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully fetched ${uniqueEquipment.length} unique equipment',
      );

      return uniqueEquipment;
    } catch (e) {
      AppPrint.printError('Failed to fetch equipment: $e');
      rethrow;
    }
  }
}
