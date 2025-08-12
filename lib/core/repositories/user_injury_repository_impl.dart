import 'package:flutter/foundation.dart';
import '../models/user_injury_model.dart';
import 'user_injury_repository.dart';
import '../services/supabase_service.dart';

/// Implementation of UserInjuryRepository using Supabase
/// Handles all CRUD operations on the user_injuries table
class UserInjuryRepositoryImpl implements UserInjuryRepository {
  final SupabaseService _supabaseService;

  UserInjuryRepositoryImpl(this._supabaseService);

  @override
  Future<UserInjuryModel> createUserInjury(UserInjuryModel injury) async {
    try {
      final response = await _supabaseService.client
          .from('user_injuries')
          .insert(injury.toJson())
          .select()
          .single();

      return UserInjuryModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating user injury: $e');
      }
      throw Exception('Failed to create user injury: $e');
    }
  }

  @override
  Future<UserInjuryModel?> getUserInjuryById(int id) async {
    try {
      final response = await _supabaseService.client
          .from('user_injuries')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return UserInjuryModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user injury by ID: $e');
      }
      throw Exception('Failed to get user injury by ID: $e');
    }
  }

  @override
  Future<List<UserInjuryModel>> getUserInjuries({
    required String userId,
    bool? isActive,
  }) async {
    try {
      var query = _supabaseService.client
          .from('user_injuries')
          .select()
          .eq('user_id', userId);

      if (isActive != null) {
        query = query.eq('is_active', isActive);
      }

      final response = await query.order('reported_at', ascending: false);
      return response.map((json) => UserInjuryModel.fromJson(json)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user injuries: $e');
      }
      throw Exception('Failed to get user injuries: $e');
    }
  }

  @override
  Future<List<UserInjuryModel>> getUserInjuriesByType({
    required String userId,
    required int injuryTypeId,
    bool? isActive,
  }) async {
    try {
      var query = _supabaseService.client
          .from('user_injuries')
          .select()
          .eq('user_id', userId)
          .eq('injury_type_id', injuryTypeId);

      if (isActive != null) {
        query = query.eq('is_active', isActive);
      }

      final response = await query.order('reported_at', ascending: false);
      return response.map((json) => UserInjuryModel.fromJson(json)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user injuries by type: $e');
      }
      throw Exception('Failed to get user injuries by type: $e');
    }
  }

  @override
  Future<UserInjuryModel> updateUserInjury(UserInjuryModel injury) async {
    try {
      if (injury.id == null) {
        throw Exception('Cannot update injury without ID');
      }

      final response = await _supabaseService.client
          .from('user_injuries')
          .update(injury.toJson())
          .eq('id', injury.id!)
          .select()
          .single();

      return UserInjuryModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user injury: $e');
      }
      throw Exception('Failed to update user injury: $e');
    }
  }

  @override
  Future<UserInjuryModel> resolveInjury(int injuryId) async {
    try {
      final now = DateTime.now();
      final response = await _supabaseService.client
          .from('user_injuries')
          .update({
            'is_active': false,
            'resolved_at': now.toIso8601String(),
          })
          .eq('id', injuryId)
          .select()
          .single();

      return UserInjuryModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error resolving injury: $e');
      }
      throw Exception('Failed to resolve injury: $e');
    }
  }

  @override
  Future<UserInjuryModel> reactivateInjury(int injuryId) async {
    try {
      final response = await _supabaseService.client
          .from('user_injuries')
          .update({
            'is_active': true,
            'resolved_at': null,
          })
          .eq('id', injuryId)
          .select()
          .single();

      return UserInjuryModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error reactivating injury: $e');
      }
      throw Exception('Failed to reactivate injury: $e');
    }
  }

  @override
  Future<UserInjuryModel> updateInjuryDetails({
    required int injuryId,
    required String details,
  }) async {
    try {
      final response = await _supabaseService.client
          .from('user_injuries')
          .update({'details': details})
          .eq('id', injuryId)
          .select()
          .single();

      return UserInjuryModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating injury details: $e');
      }
      throw Exception('Failed to update injury details: $e');
    }
  }

  @override
  Future<void> deactivateInjury(int injuryId) async {
    try {
      await _supabaseService.client
          .from('user_injuries')
          .update({'is_active': false})
          .eq('id', injuryId);
    } catch (e) {
      if (kDebugMode) {
        print('Error deactivating injury: $e');
      }
      throw Exception('Failed to deactivate injury: $e');
    }
  }

  @override
  Future<void> deleteUserInjury(int id) async {
    try {
      await _supabaseService.client
          .from('user_injuries')
          .delete()
          .eq('id', id);
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting user injury: $e');
      }
      throw Exception('Failed to delete user injury: $e');
    }
  }

  @override
  Future<Map<String, int>> getUserInjuryStats(String userId) async {
    try {
      final allInjuries = await getUserInjuries(userId: userId);
      final activeInjuries = await getUserInjuries(userId: userId, isActive: true);
      final resolvedInjuries = await getUserInjuries(userId: userId, isActive: false);

      return {
        'total': allInjuries.length,
        'active': activeInjuries.length,
        'resolved': resolvedInjuries.length,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user injury stats: $e');
      }
      throw Exception('Failed to get user injury stats: $e');
    }
  }

  @override
  Future<List<UserInjuryModel>> searchUserInjuries({
    required String userId,
    required String searchTerm,
    bool? isActive,
  }) async {
    try {
      var query = _supabaseService.client
          .from('user_injuries')
          .select()
          .eq('user_id', userId)
          .ilike('details', '%$searchTerm%');

      if (isActive != null) {
        query = query.eq('is_active', isActive);
      }

      final response = await query.order('reported_at', ascending: false);
      return response.map((json) => UserInjuryModel.fromJson(json)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error searching user injuries: $e');
      }
      throw Exception('Failed to search user injuries: $e');
    }
  }

  @override
  Future<List<UserInjuryModel>> getUserInjuriesByDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    bool? isActive,
  }) async {
    try {
      var query = _supabaseService.client
          .from('user_injuries')
          .select()
          .eq('user_id', userId)
          .gte('reported_at', startDate.toIso8601String())
          .lte('reported_at', endDate.toIso8601String());

      if (isActive != null) {
        query = query.eq('is_active', isActive);
      }

      final response = await query.order('reported_at', ascending: false);
      return response.map((json) => UserInjuryModel.fromJson(json)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user injuries by date range: $e');
      }
      throw Exception('Failed to get user injuries by date range: $e');
    }
  }

  @override
  Future<bool> hasActiveInjuries(String userId) async {
    try {
      final activeInjuries = await getUserInjuries(userId: userId, isActive: true);
      return activeInjuries.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking if user has active injuries: $e');
      }
      throw Exception('Failed to check if user has active injuries: $e');
    }
  }

  @override
  Future<UserInjuryModel?> getMostRecentInjury(String userId) async {
    try {
      final injuries = await getUserInjuries(userId: userId);
      if (injuries.isEmpty) return null;
      
      // Since getUserInjuries already orders by reported_at desc, first item is most recent
      return injuries.first;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting most recent injury: $e');
      }
      throw Exception('Failed to get most recent injury: $e');
    }
  }
}
