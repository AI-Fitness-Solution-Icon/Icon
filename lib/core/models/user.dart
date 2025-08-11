import 'package:equatable/equatable.dart';
import 'role.dart';

/// User model representing a user profile in the Icon app
class User extends Equatable {
  static const String tableName = 'users';

  final String userId;
  final String roleId;
  final String? firstName;
  final String? lastName;
  final String email;
  final String passwordHash;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLogin;
  final bool isActive;
  final DateTime? dateOfBirth;
  final String? gender;

  // Related models (optional, populated when joined)
  final Role? role;

  const User({
    required this.userId,
    required this.roleId,
    this.firstName,
    this.lastName,
    required this.email,
    required this.passwordHash,
    required this.createdAt,
    required this.updatedAt,
    this.lastLogin,
    this.isActive = true,
    this.dateOfBirth,
    this.gender,
    this.role,
  });

  /// Creates a User from JSON data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] as String,
      roleId: json['role_id'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String,
      passwordHash: json['password'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      gender: json['gender'] as String?,
      role: json['role'] != null
          ? Role.fromJson(json['role'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Converts User to JSON data
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'role_id': roleId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': passwordHash,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
      'is_active': isActive,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'role': role?.toJson(),
    };
  }

  /// Creates a copy of User with updated fields
  User copyWith({
    String? userId,
    String? roleId,
    String? firstName,
    String? lastName,
    String? email,
    String? passwordHash,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
    bool? isActive,
    DateTime? dateOfBirth,
    String? gender,
    Role? role,
  }) {
    return User(
      userId: userId ?? this.userId,
      roleId: roleId ?? this.roleId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      role: role ?? this.role,
    );
  }

  /// Get full name
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    }
    return email;
  }

  @override
  List<Object?> get props => [
    userId,
    roleId,
    firstName,
    lastName,
    email,
    passwordHash,
    createdAt,
    updatedAt,
    lastLogin,
    isActive,
    dateOfBirth,
    gender,
    role,
  ];

  @override
  String toString() {
    return 'User(userId: $userId, email: $email, fullName: $fullName, isActive: $isActive)';
  }
}

/// User roles in the Icon app (legacy enum for backward compatibility)
enum UserRole { athlete, trainer, admin }
