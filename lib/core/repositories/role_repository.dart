import '../../../core/models/role.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/utils/app_print.dart';

/// Repository for Role model operations
class RoleRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;
  static const String _tableName = 'roles';

  /// Get all roles
  Future<List<Role>> getAllRoles() async {
    try {
      AppPrint.printStep('Fetching all roles');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(table: _tableName);

      final roles = response.map((json) => Role.fromJson(json)).toList();

      AppPrint.printPerformance(
        'Get all roles',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully fetched ${roles.length} roles');

      return roles;
    } catch (e) {
      AppPrint.printError('Failed to fetch roles: $e');
      rethrow;
    }
  }

  /// Get role by ID
  Future<Role?> getRoleById(String roleId) async {
    try {
      AppPrint.printStep('Fetching role by ID: $roleId');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: _tableName,
        filters: {'role_id': roleId},
      );

      if (response.isEmpty) {
        AppPrint.printWarning('Role not found with ID: $roleId');
        return null;
      }

      final role = Role.fromJson(response.first);

      AppPrint.printPerformance(
        'Get role by ID',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully fetched role: ${role.roleName}');

      return role;
    } catch (e) {
      AppPrint.printError('Failed to fetch role by ID: $e');
      rethrow;
    }
  }

  /// Get role by name
  Future<Role?> getRoleByName(String roleName) async {
    try {
      AppPrint.printStep('Fetching role by name: $roleName');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: _tableName,
        filters: {'role_name': roleName},
      );

      if (response.isEmpty) {
        AppPrint.printWarning('Role not found with name: $roleName');
        return null;
      }

      final role = Role.fromJson(response.first);

      AppPrint.printPerformance(
        'Get role by name',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully fetched role: ${role.roleName}');

      return role;
    } catch (e) {
      AppPrint.printError('Failed to fetch role by name: $e');
      rethrow;
    }
  }

  /// Create a new role
  Future<Role> createRole(String roleName) async {
    try {
      AppPrint.printStep('Creating new role: $roleName');
      final startTime = DateTime.now();

      final roleData = {'role_name': roleName};

      final response = await _supabaseService.insertData(
        table: _tableName,
        data: roleData,
      );

      final role = Role.fromJson(response.first);

      AppPrint.printPerformance(
        'Create role',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully created role: ${role.roleName}');

      return role;
    } catch (e) {
      AppPrint.printError('Failed to create role: $e');
      rethrow;
    }
  }

  /// Update role
  Future<Role?> updateRole(String roleId, String newRoleName) async {
    try {
      AppPrint.printStep('Updating role: $roleId with new name: $newRoleName');
      final startTime = DateTime.now();

      final updateData = {'role_name': newRoleName};

      final response = await _supabaseService.client
          .from(_tableName)
          .update(updateData)
          .eq('role_id', roleId)
          .select();

      if (response.isEmpty) {
        AppPrint.printWarning('Role not found for update with ID: $roleId');
        return null;
      }

      final role = Role.fromJson(response.first);

      AppPrint.printPerformance(
        'Update role',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully updated role: ${role.roleName}');

      return role;
    } catch (e) {
      AppPrint.printError('Failed to update role: $e');
      rethrow;
    }
  }

  /// Delete role
  Future<bool> deleteRole(String roleId) async {
    try {
      AppPrint.printStep('Deleting role: $roleId');
      final startTime = DateTime.now();

      await _supabaseService.deleteData(
        table: _tableName,
        filters: {'role_id': roleId},
      );

      AppPrint.printPerformance(
        'Delete role',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully deleted role: $roleId');

      return true;
    } catch (e) {
      AppPrint.printError('Failed to delete role: $e');
      rethrow;
    }
  }

  /// Check if role exists
  Future<bool> roleExists(String roleName) async {
    try {
      AppPrint.printStep('Checking if role exists: $roleName');

      final response = await _supabaseService.getData(
        table: _tableName,
        filters: {'role_name': roleName},
      );

      final exists = response.isNotEmpty;
      AppPrint.printInfo('Role $roleName exists: $exists');

      return exists;
    } catch (e) {
      AppPrint.printError('Failed to check if role exists: $e');
      rethrow;
    }
  }

  /// Get roles with pagination
  Future<List<Role>> getRolesWithPagination({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      AppPrint.printStep(
        'Fetching roles with pagination (limit: $limit, offset: $offset)',
      );
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: _tableName,
        limit: limit,
        offset: offset,
      );

      final roles = response.map((json) => Role.fromJson(json)).toList();

      AppPrint.printPerformance(
        'Get roles with pagination',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully fetched ${roles.length} roles');

      return roles;
    } catch (e) {
      AppPrint.printError('Failed to fetch roles with pagination: $e');
      rethrow;
    }
  }

  /// Get roles count
  Future<int> getRolesCount() async {
    try {
      AppPrint.printStep('Getting roles count');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(table: _tableName);

      final count = response.length;

      AppPrint.printPerformance(
        'Get roles count',
        DateTime.now().difference(startTime),
      );
      AppPrint.printInfo('Total roles count: $count');

      return count;
    } catch (e) {
      AppPrint.printError('Failed to get roles count: $e');
      rethrow;
    }
  }
}
