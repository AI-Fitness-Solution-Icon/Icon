import 'package:equatable/equatable.dart';
import 'user.dart';

/// UserSettings model representing user settings in the Icon app
class UserSettings extends Equatable {
  static const String tableName = 'user_settings';

  final String settingId;
  final String userId;
  final String theme;
  final bool notificationEnabled;
  final String language;
  
  // Related models (optional, populated when joined)
  final User? user;

  const UserSettings({
    required this.settingId,
    required this.userId,
    this.theme = 'light',
    this.notificationEnabled = true,
    this.language = 'en',
    this.user,
  });

  /// Creates a UserSettings from JSON data
  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      settingId: json['setting_id'] as String,
      userId: json['user_id'] as String,
      theme: json['theme'] as String? ?? 'light',
      notificationEnabled: json['notification_enabled'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      user: json['user'] != null 
          ? User.fromJson(json['user'] as Map<String, dynamic>) 
          : null,
    );
  }

  /// Converts UserSettings to JSON data
  Map<String, dynamic> toJson() {
    return {
      'setting_id': settingId,
      'user_id': userId,
      'theme': theme,
      'notification_enabled': notificationEnabled,
      'language': language,
      'user': user?.toJson(),
    };
  }

  /// Creates a copy of UserSettings with updated fields
  UserSettings copyWith({
    String? settingId,
    String? userId,
    String? theme,
    bool? notificationEnabled,
    String? language,
    User? user,
  }) {
    return UserSettings(
      settingId: settingId ?? this.settingId,
      userId: userId ?? this.userId,
      theme: theme ?? this.theme,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      language: language ?? this.language,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
    settingId,
    userId,
    theme,
    notificationEnabled,
    language,
    user,
  ];

  @override
  String toString() {
    return 'UserSettings(settingId: $settingId, userId: $userId, theme: $theme, language: $language)';
  }
} 