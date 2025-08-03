import 'package:equatable/equatable.dart';

/// Role model representing user roles in the Icon app
class Role extends Equatable {
  static const String tableName = 'roles';

  final String roleId;
  final String roleName;

  const Role({
    required this.roleId,
    required this.roleName,
  });

  /// Creates a Role from JSON data
  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      roleId: json['role_id'] as String,
      roleName: json['role_name'] as String,
    );
  }

  /// Converts Role to JSON data
  Map<String, dynamic> toJson() {
    return {
      'role_id': roleId,
      'role_name': roleName,
    };
  }

  /// Creates a copy of Role with updated fields
  Role copyWith({
    String? roleId,
    String? roleName,
  }) {
    return Role(
      roleId: roleId ?? this.roleId,
      roleName: roleName ?? this.roleName,
    );
  }

  @override
  List<Object?> get props => [roleId, roleName];

  @override
  String toString() {
    return 'Role(roleId: $roleId, roleName: $roleName)';
  }
} 