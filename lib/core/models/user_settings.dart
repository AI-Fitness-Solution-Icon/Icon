import 'package:equatable/equatable.dart';
import 'user.dart';

/// UserSettings model representing user preferences and settings
class UserSettings extends Equatable {
  static const String tableName = 'user_settings';

  final String settingId;
  final String id;
  final String theme;
  final String language;
  final bool notificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Related models (optional, populated when joined)
  final User? user;

  const UserSettings({
    required this.settingId,
    required this.id,
    this.theme = 'dark',
    this.language = 'en',
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  /// Creates a UserSettings from JSON data
  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      settingId: json['setting_id'] as String,
      id: json['id'] as String,
      theme: json['theme'] as String? ?? 'dark',
      language: json['language'] as String? ?? 'en',
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      soundEnabled: json['sound_enabled'] as bool? ?? true,
      vibrationEnabled: json['vibration_enabled'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts UserSettings to JSON data
  Map<String, dynamic> toJson() {
    return {
      'setting_id': settingId,
      'id': id,
      'theme': theme,
      'language': language,
      'notifications_enabled': notificationsEnabled,
      'sound_enabled': soundEnabled,
      'vibration_enabled': vibrationEnabled,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Creates a copy of UserSettings with updated fields
  UserSettings copyWith({
    String? settingId,
    String? id,
    String? theme,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) {
    return UserSettings(
      settingId: settingId ?? this.settingId,
      id: id ?? this.id,
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
    settingId,
    id,
    theme,
    notificationsEnabled,
    soundEnabled,
    vibrationEnabled,
    createdAt,
    updatedAt,
    user,
  ];

  @override
  String toString() {
    return 'UserSettings(settingId: $settingId, id: $id, theme: $theme, language: $language)';
  }
}
