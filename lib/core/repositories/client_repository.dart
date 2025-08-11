import 'package:icon_app/core/models/client.dart';
import 'package:icon_app/core/services/supabase_service.dart';
import 'package:icon_app/core/utils/app_print.dart';

/// Repository for Client model operations
class ClientRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;
  static const String _tableName = 'clients';

  /// Get all clients
  Future<List<Client>> getAllClients() async {
    try {
      AppPrint.printStep('Fetching all clients');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, user:users(*), coach:coaches(*)',
      );

      final clients = response.map((json) => Client.fromJson(json)).toList();

      AppPrint.printPerformance(
        'Get all clients',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully fetched ${clients.length} clients');

      return clients;
    } catch (e) {
      AppPrint.printError('Failed to fetch clients: $e');
      rethrow;
    }
  }

  /// Get client by ID
  Future<Client?> getClientById(String clientId) async {
    try {
      AppPrint.printStep('Fetching client by ID: $clientId');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, user:users(*), coach:coaches(*)',
        filters: {'client_id': clientId},
      );

      if (response.isEmpty) {
        AppPrint.printWarning('Client not found with ID: $clientId');
        return null;
      }

      final client = Client.fromJson(response.first);

      AppPrint.printPerformance(
        'Get client by ID',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully fetched client: ${client.clientId}');

      return client;
    } catch (e) {
      AppPrint.printError('Failed to fetch client by ID: $e');
      rethrow;
    }
  }

  /// Get clients by coach
  Future<List<Client>> getClientsByCoach(String coachId) async {
    try {
      AppPrint.printStep('Fetching clients by coach: $coachId');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, user:users(*), coach:coaches(*)',
        filters: {'coach_id': coachId},
      );

      final clients = response.map((json) => Client.fromJson(json)).toList();

      AppPrint.printPerformance(
        'Get clients by coach',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully fetched ${clients.length} clients for coach: $coachId',
      );

      return clients;
    } catch (e) {
      AppPrint.printError('Failed to fetch clients by coach: $e');
      rethrow;
    }
  }

  /// Get clients by activity level
  Future<List<Client>> getClientsByActivityLevel(String activityLevel) async {
    try {
      AppPrint.printStep('Fetching clients by activity level: $activityLevel');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, user:users(*), coach:coaches(*)',
        filters: {'preferred_activity_level': activityLevel},
      );

      final clients = response.map((json) => Client.fromJson(json)).toList();

      AppPrint.printPerformance(
        'Get clients by activity level',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully fetched ${clients.length} clients with activity level: $activityLevel',
      );

      return clients;
    } catch (e) {
      AppPrint.printError('Failed to fetch clients by activity level: $e');
      rethrow;
    }
  }

  /// Get clients who completed onboarding
  Future<List<Client>> getClientsWithCompletedOnboarding() async {
    try {
      AppPrint.printStep('Fetching clients with completed onboarding');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, user:users(*), coach:coaches(*)',
        filters: {'onboarding_completed': true},
      );

      final clients = response.map((json) => Client.fromJson(json)).toList();

      AppPrint.printPerformance(
        'Get clients with completed onboarding',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully fetched ${clients.length} clients with completed onboarding',
      );

      return clients;
    } catch (e) {
      AppPrint.printError(
        'Failed to fetch clients with completed onboarding: $e',
      );
      rethrow;
    }
  }

  /// Get clients who haven't completed onboarding
  Future<List<Client>> getClientsWithIncompleteOnboarding() async {
    try {
      AppPrint.printStep('Fetching clients with incomplete onboarding');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, user:users(*), coach:coaches(*)',
        filters: {'onboarding_completed': false},
      );

      final clients = response.map((json) => Client.fromJson(json)).toList();

      AppPrint.printPerformance(
        'Get clients with incomplete onboarding',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully fetched ${clients.length} clients with incomplete onboarding',
      );

      return clients;
    } catch (e) {
      AppPrint.printError(
        'Failed to fetch clients with incomplete onboarding: $e',
      );
      rethrow;
    }
  }

  /// Create a new client
  Future<Client> createClient({
    required String clientId,
    String? coachId,
    DateTime? dateOfBirth,
    String? gender,
    double? height,
    double? weight,
    String? fitnessGoals,
    String? healthConditions,
    String? preferredActivityLevel,
    int? targetCaloriesPerDay,
    bool? onboardingCompleted,
  }) async {
    try {
      AppPrint.printStep('Creating new client: $clientId');
      final startTime = DateTime.now();

      final clientData = {
        'client_id': clientId,
        'coach_id': coachId,
        'date_of_birth': dateOfBirth?.toIso8601String(),
        'gender': gender,
        'height': height,
        'weight': weight,
        'fitness_goals': fitnessGoals,
        'health_conditions': healthConditions,
        'preferred_activity_level': preferredActivityLevel ?? 'Beginner',
        'target_calories_per_day': targetCaloriesPerDay,
        'onboarding_completed': onboardingCompleted ?? false,
      };

      final response = await _supabaseService.insertData(
        table: _tableName,
        data: clientData,
      );

      final client = Client.fromJson(response.first);

      AppPrint.printPerformance(
        'Create client',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully created client: ${client.clientId}');

      return client;
    } catch (e) {
      AppPrint.printError('Failed to create client: $e');
      rethrow;
    }
  }

  /// Update client
  Future<Client?> updateClient(
    String clientId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      AppPrint.printStep('Updating client: $clientId');
      final startTime = DateTime.now();

      final response = await _supabaseService.client
          .from(_tableName)
          .update(updateData)
          .eq('client_id', clientId)
          .select();

      if (response.isEmpty) {
        AppPrint.printWarning('Client not found for update with ID: $clientId');
        return null;
      }

      final client = Client.fromJson(response.first);

      AppPrint.printPerformance(
        'Update client',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully updated client: ${client.clientId}');

      return client;
    } catch (e) {
      AppPrint.printError('Failed to update client: $e');
      rethrow;
    }
  }

  /// Update client profile
  Future<Client?> updateClientProfile({
    required String clientId,
    DateTime? dateOfBirth,
    String? gender,
    double? height,
    double? weight,
    String? fitnessGoals,
    String? healthConditions,
    String? preferredActivityLevel,
    int? targetCaloriesPerDay,
  }) async {
    try {
      AppPrint.printStep('Updating client profile: $clientId');

      final updateData = <String, dynamic>{};
      if (dateOfBirth != null) updateData['date_of_birth'] = dateOfBirth;
      if (gender != null) updateData['gender'] = gender;
      if (height != null) updateData['height'] = height;
      if (weight != null) updateData['weight'] = weight;
      if (fitnessGoals != null) updateData['fitness_goals'] = fitnessGoals;
      if (healthConditions != null) {
        updateData['health_conditions'] = healthConditions;
      }
      if (preferredActivityLevel != null) {
        updateData['preferred_activity_level'] = preferredActivityLevel;
      }
      if (targetCaloriesPerDay != null) {
        updateData['target_calories_per_day'] = targetCaloriesPerDay;
      }

      return await updateClient(clientId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update client profile: $e');
      rethrow;
    }
  }

  /// Assign coach to client
  Future<Client?> assignCoachToClient(String clientId, String coachId) async {
    try {
      AppPrint.printStep('Assigning coach $coachId to client $clientId');

      final updateData = {'coach_id': coachId};

      return await updateClient(clientId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to assign coach to client: $e');
      rethrow;
    }
  }

  /// Remove coach from client
  Future<Client?> removeCoachFromClient(String clientId) async {
    try {
      AppPrint.printStep('Removing coach from client $clientId');

      final updateData = {'coach_id': null};

      return await updateClient(clientId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to remove coach from client: $e');
      rethrow;
    }
  }

  /// Mark onboarding as completed
  Future<Client?> markOnboardingCompleted(String clientId) async {
    try {
      AppPrint.printStep(
        'Marking onboarding as completed for client: $clientId',
      );

      final updateData = {'onboarding_completed': true};

      return await updateClient(clientId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to mark onboarding as completed: $e');
      rethrow;
    }
  }

  /// Update client weight
  Future<Client?> updateClientWeight(String clientId, double weight) async {
    try {
      AppPrint.printStep('Updating client weight: $clientId');

      final updateData = {'weight': weight};

      return await updateClient(clientId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update client weight: $e');
      rethrow;
    }
  }

  /// Update client target calories
  Future<Client?> updateClientTargetCalories(
    String clientId,
    int targetCalories,
  ) async {
    try {
      AppPrint.printStep('Updating client target calories: $clientId');

      final updateData = {'target_calories_per_day': targetCalories};

      return await updateClient(clientId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update client target calories: $e');
      rethrow;
    }
  }

  /// Delete client
  Future<bool> deleteClient(String clientId) async {
    try {
      AppPrint.printStep('Deleting client: $clientId');
      final startTime = DateTime.now();

      await _supabaseService.deleteData(
        table: _tableName,
        filters: {'client_id': clientId},
      );

      AppPrint.printPerformance(
        'Delete client',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully deleted client: $clientId');

      return true;
    } catch (e) {
      AppPrint.printError('Failed to delete client: $e');
      rethrow;
    }
  }

  /// Check if client exists
  Future<bool> clientExists(String clientId) async {
    try {
      AppPrint.printStep('Checking if client exists: $clientId');

      final response = await _supabaseService.getData(
        table: _tableName,
        filters: {'client_id': clientId},
      );

      final exists = response.isNotEmpty;
      AppPrint.printInfo('Client $clientId exists: $exists');

      return exists;
    } catch (e) {
      AppPrint.printError('Failed to check if client exists: $e');
      rethrow;
    }
  }

  /// Get clients with pagination
  Future<List<Client>> getClientsWithPagination({
    int limit = 10,
    int offset = 0,
    String? coachId,
    bool? onboardingCompleted,
  }) async {
    try {
      AppPrint.printStep(
        'Fetching clients with pagination (limit: $limit, offset: $offset)',
      );
      final startTime = DateTime.now();

      final filters = <String, dynamic>{};
      if (coachId != null) filters['coach_id'] = coachId;
      if (onboardingCompleted != null) {
        filters['onboarding_completed'] = onboardingCompleted;
      }

      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, user:users(*), coach:coaches(*)',
        filters: filters.isNotEmpty ? filters : null,
        limit: limit,
        offset: offset,
      );

      final clients = response.map((json) => Client.fromJson(json)).toList();

      AppPrint.printPerformance(
        'Get clients with pagination',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully fetched ${clients.length} clients');

      return clients;
    } catch (e) {
      AppPrint.printError('Failed to fetch clients with pagination: $e');
      rethrow;
    }
  }

  /// Get clients count
  Future<int> getClientsCount({
    String? coachId,
    bool? onboardingCompleted,
  }) async {
    try {
      AppPrint.printStep('Getting clients count');
      final startTime = DateTime.now();

      final filters = <String, dynamic>{};
      if (coachId != null) filters['coach_id'] = coachId;
      if (onboardingCompleted != null) {
        filters['onboarding_completed'] = onboardingCompleted;
      }

      final response = await _supabaseService.getData(
        table: _tableName,
        filters: filters.isNotEmpty ? filters : null,
      );

      final count = response.length;

      AppPrint.printPerformance(
        'Get clients count',
        DateTime.now().difference(startTime),
      );
      AppPrint.printInfo('Total clients count: $count');

      return count;
    } catch (e) {
      AppPrint.printError('Failed to get clients count: $e');
      rethrow;
    }
  }

  /// Search clients by fitness goals or health conditions
  Future<List<Client>> searchClients(String searchTerm) async {
    try {
      AppPrint.printStep('Searching clients: $searchTerm');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: _tableName,
        select: '*, user:users(*), coach:coaches(*)',
      );

      final clients = response.map((json) => Client.fromJson(json)).toList();

      // Filter clients based on search term
      final filteredClients = clients.where((client) {
        final searchLower = searchTerm.toLowerCase();
        return (client.fitnessGoals?.toLowerCase().contains(searchLower) ??
                false) ||
            (client.healthConditions?.toLowerCase().contains(searchLower) ??
                false) ||
            (client.gender?.toLowerCase().contains(searchLower) ?? false) ||
            client.preferredActivityLevel.toLowerCase().contains(searchLower) ||
            (client.user?.fullName.toLowerCase().contains(searchLower) ??
                false);
      }).toList();

      AppPrint.printPerformance(
        'Search clients',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Found ${filteredClients.length} clients matching: $searchTerm',
      );

      return filteredClients;
    } catch (e) {
      AppPrint.printError('Failed to search clients: $e');
      rethrow;
    }
  }
}
