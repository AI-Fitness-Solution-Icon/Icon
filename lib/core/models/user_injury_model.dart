import 'package:flutter/foundation.dart';

/// Model representing a user injury record
/// Maps to the user_injuries table in the database
class UserInjuryModel {
  final int? id; // nullable because it's serial (auto-generated)
  final String userId; // UUID as string
  final int injuryTypeId;
  final String? details; // nullable as per schema
  final DateTime reportedAt;
  final bool isActive;
  final DateTime? resolvedAt; // nullable as per schema

  const UserInjuryModel({
    this.id,
    required this.userId,
    required this.injuryTypeId,
    this.details,
    required this.reportedAt,
    required this.isActive,
    this.resolvedAt,
  });

  /// Creates a UserInjuryModel from a JSON map
  factory UserInjuryModel.fromJson(Map<String, dynamic> json) {
    return UserInjuryModel(
      id: json['id'] as int?,
      userId: json['user_id'] as String,
      injuryTypeId: json['injury_type_id'] as int,
      details: json['details'] as String?,
      reportedAt: DateTime.parse(json['reported_at'] as String),
      isActive: json['is_active'] as bool,
      resolvedAt: json['resolved_at'] != null 
          ? DateTime.parse(json['resolved_at'] as String)
          : null,
    );
  }

  /// Converts the UserInjuryModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'injury_type_id': injuryTypeId,
      'details': details,
      'reported_at': reportedAt.toIso8601String(),
      'is_active': isActive,
      'resolved_at': resolvedAt?.toIso8601String(),
    };
  }

  /// Creates a UserInjuryModel for database insertion (without ID)
  factory UserInjuryModel.forInsert({
    required String userId,
    required int injuryTypeId,
    String? details,
    DateTime? reportedAt,
    bool isActive = true,
    DateTime? resolvedAt,
  }) {
    return UserInjuryModel(
      userId: userId,
      injuryTypeId: injuryTypeId,
      details: details,
      reportedAt: reportedAt ?? DateTime.now(),
      isActive: isActive,
      resolvedAt: resolvedAt,
    );
  }

  /// Creates a copy of the UserInjuryModel with updated values
  UserInjuryModel copyWith({
    int? id,
    String? userId,
    int? injuryTypeId,
    String? details,
    DateTime? reportedAt,
    bool? isActive,
    DateTime? resolvedAt,
  }) {
    return UserInjuryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      injuryTypeId: injuryTypeId ?? this.injuryTypeId,
      details: details ?? this.details,
      reportedAt: reportedAt ?? this.reportedAt,
      isActive: isActive ?? this.isActive,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }

  /// Marks the injury as resolved
  UserInjuryModel markAsResolved() {
    return copyWith(
      isActive: false,
      resolvedAt: DateTime.now(),
    );
  }

  /// Marks the injury as active again
  UserInjuryModel markAsActive() {
    return copyWith(
      isActive: true,
      resolvedAt: null,
    );
  }

  /// Updates the injury details
  UserInjuryModel updateDetails(String newDetails) {
    return copyWith(details: newDetails);
  }

  /// Checks if the injury is resolved
  bool get isResolved => resolvedAt != null;

  /// Gets the duration since the injury was reported
  Duration get durationSinceReported => DateTime.now().difference(reportedAt);

  /// Gets the duration since the injury was resolved (if resolved)
  Duration? get durationSinceResolved {
    if (resolvedAt == null) return null;
    return DateTime.now().difference(resolvedAt!);
  }

  /// Prints the user injury information in a readable format
  void printInfo() {
    if (kDebugMode) {
      print('UserInjuryModel:');
      print('  ID: $id');
      print('  User ID: $userId');
      print('  Injury Type ID: $injuryTypeId');
      print('  Details: ${details ?? "No details"}');
      print('  Reported At: $reportedAt');
      print('  Is Active: $isActive');
      print('  Resolved At: ${resolvedAt ?? "Not resolved"}');
      print('  Is Resolved: $isResolved');
      print('  Duration Since Reported: $durationSinceReported');
      if (resolvedAt != null) {
        print('  Duration Since Resolved: $durationSinceResolved');
      }
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserInjuryModel &&
        other.id == id &&
        other.userId == userId &&
        other.injuryTypeId == injuryTypeId &&
        other.details == details &&
        other.reportedAt == reportedAt &&
        other.isActive == isActive &&
        other.resolvedAt == resolvedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        injuryTypeId.hashCode ^
        details.hashCode ^
        reportedAt.hashCode ^
        isActive.hashCode ^
        resolvedAt.hashCode;
  }

  @override
  String toString() {
    return 'UserInjuryModel('
        'id: $id, '
        'userId: $userId, '
        'injuryTypeId: $injuryTypeId, '
        'details: $details, '
        'reportedAt: $reportedAt, '
        'isActive: $isActive, '
        'resolvedAt: $resolvedAt)';
  }
}
