import '../models/user_injury_model.dart';

/// Repository interface for user injury operations
/// Defines the contract for CRUD operations on user_injuries table
abstract class UserInjuryRepository {
  /// Creates a new user injury record
  /// Returns the created injury with generated ID
  Future<UserInjuryModel> createUserInjury(UserInjuryModel injury);

  /// Retrieves a user injury by its ID
  /// Returns null if not found
  Future<UserInjuryModel?> getUserInjuryById(int id);

  /// Retrieves all injuries for a specific user
  /// Optionally filters by active status
  Future<List<UserInjuryModel>> getUserInjuries({
    required String userId,
    bool? isActive,
  });

  /// Retrieves all injuries of a specific type for a user
  Future<List<UserInjuryModel>> getUserInjuriesByType({
    required String userId,
    required int injuryTypeId,
    bool? isActive,
  });

  /// Updates an existing user injury record
  /// Returns the updated injury
  Future<UserInjuryModel> updateUserInjury(UserInjuryModel injury);

  /// Marks an injury as resolved
  /// Sets isActive to false and resolvedAt to current timestamp
  Future<UserInjuryModel> resolveInjury(int injuryId);

  /// Marks an injury as active again
  /// Sets isActive to true and clears resolvedAt
  Future<UserInjuryModel> reactivateInjury(int injuryId);

  /// Updates the details of an injury
  Future<UserInjuryModel> updateInjuryDetails({
    required int injuryId,
    required String details,
  });

  /// Soft deletes an injury by marking it as inactive
  /// Keeps the record but sets isActive to false
  Future<void> deactivateInjury(int injuryId);

  /// Hard deletes an injury record from the database
  /// Use with caution - this permanently removes the record
  Future<void> deleteUserInjury(int id);

  /// Retrieves injury statistics for a user
  /// Returns count of active, resolved, and total injuries
  Future<Map<String, int>> getUserInjuryStats(String userId);

  /// Searches injuries by text in details field
  Future<List<UserInjuryModel>> searchUserInjuries({
    required String userId,
    required String searchTerm,
    bool? isActive,
  });

  /// Retrieves injuries within a date range
  Future<List<UserInjuryModel>> getUserInjuriesByDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    bool? isActive,
  });

  /// Checks if a user has any active injuries
  Future<bool> hasActiveInjuries(String userId);

  /// Gets the most recent injury for a user
  Future<UserInjuryModel?> getMostRecentInjury(String userId);
}
