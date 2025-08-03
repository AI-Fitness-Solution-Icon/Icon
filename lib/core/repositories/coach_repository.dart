import '../../../core/models/coach.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/utils/app_print.dart';

/// Repository for Coach model operations
class CoachRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;
  static const String _tableName = 'coaches';

  /// Get all coaches
  Future<List<Coach>> getAllCoaches() async {
    try {
      AppPrint.printStep('Fetching all coaches');
      final startTime = DateTime.now();
      
      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, user:users(*)',
      );
      
      final coaches = response.map((json) => Coach.fromJson(json)).toList();
      
      AppPrint.printPerformance('Get all coaches', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Successfully fetched ${coaches.length} coaches');
      
      return coaches;
    } catch (e) {
      AppPrint.printError('Failed to fetch coaches: $e');
      rethrow;
    }
  }

  /// Get coach by ID
  Future<Coach?> getCoachById(String coachId) async {
    try {
      AppPrint.printStep('Fetching coach by ID: $coachId');
      final startTime = DateTime.now();
      
      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, user:users(*)',
        filters: {'coach_id': coachId},
      );
      
      if (response.isEmpty) {
        AppPrint.printWarning('Coach not found with ID: $coachId');
        return null;
      }
      
      final coach = Coach.fromJson(response.first);
      
      AppPrint.printPerformance('Get coach by ID', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Successfully fetched coach: ${coach.coachId}');
      
      return coach;
    } catch (e) {
      AppPrint.printError('Failed to fetch coach by ID: $e');
      rethrow;
    }
  }

  /// Get coaches by specialty
  Future<List<Coach>> getCoachesBySpecialty(String specialty) async {
    try {
      AppPrint.printStep('Fetching coaches by specialty: $specialty');
      final startTime = DateTime.now();
      
      // Note: This is a simple implementation. For production, you might want to use
      // PostgreSQL's array operators for more efficient filtering
      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, user:users(*)',
      );
      
      final coaches = response.map((json) => Coach.fromJson(json)).toList();
      
      // Filter coaches by specialty
      final filteredCoaches = coaches.where((coach) {
        return coach.specialties.contains(specialty);
      }).toList();
      
      AppPrint.printPerformance('Get coaches by specialty', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Successfully fetched ${filteredCoaches.length} coaches with specialty: $specialty');
      
      return filteredCoaches;
    } catch (e) {
      AppPrint.printError('Failed to fetch coaches by specialty: $e');
      rethrow;
    }
  }

  /// Get coaches by certification
  Future<List<Coach>> getCoachesByCertification(String certification) async {
    try {
      AppPrint.printStep('Fetching coaches by certification: $certification');
      final startTime = DateTime.now();
      
      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, user:users(*)',
      );
      
      final coaches = response.map((json) => Coach.fromJson(json)).toList();
      
      // Filter coaches by certification
      final filteredCoaches = coaches.where((coach) {
        return coach.certifications.contains(certification);
      }).toList();
      
      AppPrint.printPerformance('Get coaches by certification', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Successfully fetched ${filteredCoaches.length} coaches with certification: $certification');
      
      return filteredCoaches;
    } catch (e) {
      AppPrint.printError('Failed to fetch coaches by certification: $e');
      rethrow;
    }
  }

  /// Create a new coach
  Future<Coach> createCoach({
    required String coachId,
    String? bio,
    List<String>? certifications,
    List<String>? specialties,
  }) async {
    try {
      AppPrint.printStep('Creating new coach: $coachId');
      final startTime = DateTime.now();
      
      final coachData = {
        'coach_id': coachId,
        'bio': bio,
        'certifications': certifications ?? [],
        'specialties': specialties ?? [],
      };
      
      final response = await _supabaseService.insertData(
        table: _tableName,
        data: coachData,
      );
      
      final coach = Coach.fromJson(response.first);
      
      AppPrint.printPerformance('Create coach', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Successfully created coach: ${coach.coachId}');
      
      return coach;
    } catch (e) {
      AppPrint.printError('Failed to create coach: $e');
      rethrow;
    }
  }

  /// Update coach
  Future<Coach?> updateCoach(String coachId, Map<String, dynamic> updateData) async {
    try {
      AppPrint.printStep('Updating coach: $coachId');
      final startTime = DateTime.now();
      
      final response = await _supabaseService.updateData(
        table: _tableName,
        data: updateData,
        filters: {'coach_id': coachId},
      );
      
      if (response.isEmpty) {
        AppPrint.printWarning('Coach not found for update with ID: $coachId');
        return null;
      }
      
      final coach = Coach.fromJson(response.first);
      
      AppPrint.printPerformance('Update coach', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Successfully updated coach: ${coach.coachId}');
      
      return coach;
    } catch (e) {
      AppPrint.printError('Failed to update coach: $e');
      rethrow;
    }
  }

  /// Update coach bio
  Future<Coach?> updateCoachBio(String coachId, String bio) async {
    try {
      AppPrint.printStep('Updating coach bio: $coachId');
      
      final updateData = {
        'bio': bio,
      };
      
      return await updateCoach(coachId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update coach bio: $e');
      rethrow;
    }
  }

  /// Update coach certifications
  Future<Coach?> updateCoachCertifications(String coachId, List<String> certifications) async {
    try {
      AppPrint.printStep('Updating coach certifications: $coachId');
      
      final updateData = {
        'certifications': certifications,
      };
      
      return await updateCoach(coachId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update coach certifications: $e');
      rethrow;
    }
  }

  /// Update coach specialties
  Future<Coach?> updateCoachSpecialties(String coachId, List<String> specialties) async {
    try {
      AppPrint.printStep('Updating coach specialties: $coachId');
      
      final updateData = {
        'specialties': specialties,
      };
      
      return await updateCoach(coachId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update coach specialties: $e');
      rethrow;
    }
  }

  /// Add certification to coach
  Future<Coach?> addCoachCertification(String coachId, String certification) async {
    try {
      AppPrint.printStep('Adding certification to coach: $coachId');
      
      final currentCoach = await getCoachById(coachId);
      if (currentCoach == null) {
        AppPrint.printWarning('Coach not found: $coachId');
        return null;
      }
      
      final updatedCertifications = List<String>.from(currentCoach.certifications);
      if (!updatedCertifications.contains(certification)) {
        updatedCertifications.add(certification);
      }
      
      return await updateCoachCertifications(coachId, updatedCertifications);
    } catch (e) {
      AppPrint.printError('Failed to add coach certification: $e');
      rethrow;
    }
  }

  /// Add specialty to coach
  Future<Coach?> addCoachSpecialty(String coachId, String specialty) async {
    try {
      AppPrint.printStep('Adding specialty to coach: $coachId');
      
      final currentCoach = await getCoachById(coachId);
      if (currentCoach == null) {
        AppPrint.printWarning('Coach not found: $coachId');
        return null;
      }
      
      final updatedSpecialties = List<String>.from(currentCoach.specialties);
      if (!updatedSpecialties.contains(specialty)) {
        updatedSpecialties.add(specialty);
      }
      
      return await updateCoachSpecialties(coachId, updatedSpecialties);
    } catch (e) {
      AppPrint.printError('Failed to add coach specialty: $e');
      rethrow;
    }
  }

  /// Remove certification from coach
  Future<Coach?> removeCoachCertification(String coachId, String certification) async {
    try {
      AppPrint.printStep('Removing certification from coach: $coachId');
      
      final currentCoach = await getCoachById(coachId);
      if (currentCoach == null) {
        AppPrint.printWarning('Coach not found: $coachId');
        return null;
      }
      
      final updatedCertifications = List<String>.from(currentCoach.certifications);
      updatedCertifications.remove(certification);
      
      return await updateCoachCertifications(coachId, updatedCertifications);
    } catch (e) {
      AppPrint.printError('Failed to remove coach certification: $e');
      rethrow;
    }
  }

  /// Remove specialty from coach
  Future<Coach?> removeCoachSpecialty(String coachId, String specialty) async {
    try {
      AppPrint.printStep('Removing specialty from coach: $coachId');
      
      final currentCoach = await getCoachById(coachId);
      if (currentCoach == null) {
        AppPrint.printWarning('Coach not found: $coachId');
        return null;
      }
      
      final updatedSpecialties = List<String>.from(currentCoach.specialties);
      updatedSpecialties.remove(specialty);
      
      return await updateCoachSpecialties(coachId, updatedSpecialties);
    } catch (e) {
      AppPrint.printError('Failed to remove coach specialty: $e');
      rethrow;
    }
  }

  /// Delete coach
  Future<bool> deleteCoach(String coachId) async {
    try {
      AppPrint.printStep('Deleting coach: $coachId');
      final startTime = DateTime.now();
      
      await _supabaseService.deleteData(
        table: _tableName,
        filters: {'coach_id': coachId},
      );
      
      AppPrint.printPerformance('Delete coach', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Successfully deleted coach: $coachId');
      
      return true;
    } catch (e) {
      AppPrint.printError('Failed to delete coach: $e');
      rethrow;
    }
  }

  /// Check if coach exists
  Future<bool> coachExists(String coachId) async {
    try {
      AppPrint.printStep('Checking if coach exists: $coachId');
      
      final response = await _supabaseService.getData(
        table: _tableName,
        filters: {'coach_id': coachId},
      );
      
      final exists = response.isNotEmpty;
      AppPrint.printInfo('Coach $coachId exists: $exists');
      
      return exists;
    } catch (e) {
      AppPrint.printError('Failed to check if coach exists: $e');
      rethrow;
    }
  }

  /// Get coaches with pagination
  Future<List<Coach>> getCoachesWithPagination({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      AppPrint.printStep('Fetching coaches with pagination (limit: $limit, offset: $offset)');
      final startTime = DateTime.now();
      
      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, user:users(*)',
        limit: limit,
        offset: offset,
      );
      
      final coaches = response.map((json) => Coach.fromJson(json)).toList();
      
      AppPrint.printPerformance('Get coaches with pagination', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Successfully fetched ${coaches.length} coaches');
      
      return coaches;
    } catch (e) {
      AppPrint.printError('Failed to fetch coaches with pagination: $e');
      rethrow;
    }
  }

  /// Get coaches count
  Future<int> getCoachesCount() async {
    try {
      AppPrint.printStep('Getting coaches count');
      final startTime = DateTime.now();
      
      final response = await _supabaseService.getData(table: _tableName);
      
      final count = response.length;
      
      AppPrint.printPerformance('Get coaches count', DateTime.now().difference(startTime));
      AppPrint.printInfo('Total coaches count: $count');
      
      return count;
    } catch (e) {
      AppPrint.printError('Failed to get coaches count: $e');
      rethrow;
    }
  }

  /// Search coaches by bio or specialties
  Future<List<Coach>> searchCoaches(String searchTerm) async {
    try {
      AppPrint.printStep('Searching coaches: $searchTerm');
      final startTime = DateTime.now();
      
      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, user:users(*)',
      );
      
      final coaches = response.map((json) => Coach.fromJson(json)).toList();
      
      // Filter coaches based on search term
      final filteredCoaches = coaches.where((coach) {
        final searchLower = searchTerm.toLowerCase();
        return (coach.bio?.toLowerCase().contains(searchLower) ?? false) ||
               coach.specialties.any((specialty) => specialty.toLowerCase().contains(searchLower)) ||
               coach.certifications.any((cert) => cert.toLowerCase().contains(searchLower)) ||
               (coach.user?.fullName.toLowerCase().contains(searchLower) ?? false);
      }).toList();
      
      AppPrint.printPerformance('Search coaches', DateTime.now().difference(startTime));
      AppPrint.printSuccess('Found ${filteredCoaches.length} coaches matching: $searchTerm');
      
      return filteredCoaches;
    } catch (e) {
      AppPrint.printError('Failed to search coaches: $e');
      rethrow;
    }
  }
} 