
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing app settings
class SettingsService {
  static const String _themeKey = 'theme_mode';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _soundKey = 'sound_enabled';
  static const String _vibrationKey = 'vibration_enabled';
  static const String _biometricAuthKey = 'biometric_auth_enabled';
  static const String _twoFactorAuthKey = 'two_factor_auth_enabled';
  static const String _dataSharingKey = 'data_sharing_enabled';
  static const String _analyticsKey = 'analytics_enabled';
  static const String _locationServicesKey = 'location_services_enabled';

  final SharedPreferences _prefs;

  SettingsService._(this._prefs);

  static Future<SettingsService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsService._(prefs);
  }

  /// Theme settings
  Future<bool> isDarkMode() async {
    return _prefs.getBool(_themeKey) ?? false;
  }

  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool(_themeKey, isDark);
  }

  /// Notification settings
  Future<bool> areNotificationsEnabled() async {
    return _prefs.getBool(_notificationsKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_notificationsKey, enabled);
  }

  /// Sound settings
  Future<bool> isSoundEnabled() async {
    return _prefs.getBool(_soundKey) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(_soundKey, enabled);
  }

  /// Vibration settings
  Future<bool> isVibrationEnabled() async {
    return _prefs.getBool(_vibrationKey) ?? true;
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    await _prefs.setBool(_vibrationKey, enabled);
  }

  /// Privacy settings
  Future<bool> isBiometricAuthEnabled() async {
    return _prefs.getBool(_biometricAuthKey) ?? false;
  }

  Future<void> setBiometricAuthEnabled(bool enabled) async {
    await _prefs.setBool(_biometricAuthKey, enabled);
  }

  Future<bool> isTwoFactorAuthEnabled() async {
    return _prefs.getBool(_twoFactorAuthKey) ?? false;
  }

  Future<void> setTwoFactorAuthEnabled(bool enabled) async {
    await _prefs.setBool(_twoFactorAuthKey, enabled);
  }

  Future<bool> isDataSharingEnabled() async {
    return _prefs.getBool(_dataSharingKey) ?? true;
  }

  Future<void> setDataSharingEnabled(bool enabled) async {
    await _prefs.setBool(_dataSharingKey, enabled);
  }

  Future<bool> isAnalyticsEnabled() async {
    return _prefs.getBool(_analyticsKey) ?? true;
  }

  Future<void> setAnalyticsEnabled(bool enabled) async {
    await _prefs.setBool(_analyticsKey, enabled);
  }

  Future<bool> isLocationServicesEnabled() async {
    return _prefs.getBool(_locationServicesKey) ?? true;
  }

  Future<void> setLocationServicesEnabled(bool enabled) async {
    await _prefs.setBool(_locationServicesKey, enabled);
  }

  /// Save all privacy settings
  Future<void> savePrivacySettings({
    required bool biometricAuth,
    required bool twoFactorAuth,
    required bool dataSharing,
    required bool analytics,
    required bool locationServices,
  }) async {
    await Future.wait([
      setBiometricAuthEnabled(biometricAuth),
      setTwoFactorAuthEnabled(twoFactorAuth),
      setDataSharingEnabled(dataSharing),
      setAnalyticsEnabled(analytics),
      setLocationServicesEnabled(locationServices),
    ]);
  }

  /// Clear all settings
  Future<void> clearSettings() async {
    await _prefs.remove(_themeKey);
    await _prefs.remove(_notificationsKey);
    await _prefs.remove(_soundKey);
    await _prefs.remove(_vibrationKey);
    await _prefs.remove(_biometricAuthKey);
    await _prefs.remove(_twoFactorAuthKey);
    await _prefs.remove(_dataSharingKey);
    await _prefs.remove(_analyticsKey);
    await _prefs.remove(_locationServicesKey);
  }
} 