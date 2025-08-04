
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

/// Service for handling app settings
class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  final Logger _logger = Logger();
  late SharedPreferences _prefs;

  /// Initialize the settings service
  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _logger.i('Settings service initialized successfully');
    } catch (e) {
      _logger.e('Failed to initialize settings service: $e');
      rethrow;
    }
  }

  // Theme Settings
  static const String _keyDarkMode = 'dark_mode';
  
  // Notification Settings
  static const String _keyNotificationEnabled = 'notification_enabled';
  static const String _keyWorkoutReminders = 'workout_reminders';
  static const String _keyProgressUpdates = 'progress_updates';
  static const String _keyMotivationalMessages = 'motivational_messages';
  static const String _keyQuietHoursEnabled = 'quiet_hours_enabled';
  static const String _keyQuietHoursStart = 'quiet_hours_start';
  static const String _keyQuietHoursEnd = 'quiet_hours_end';

  // Sound and Vibration Settings
  static const String _keySoundEnabled = 'sound_enabled';
  static const String _keyVibrationEnabled = 'vibration_enabled';

  // Privacy Settings
  static const String _keyBiometricAuthEnabled = 'biometric_auth_enabled';
  static const String _keyTwoFactorAuthEnabled = 'two_factor_auth_enabled';
  static const String _keyDataSharingEnabled = 'data_sharing_enabled';
  static const String _keyAnalyticsEnabled = 'analytics_enabled';
  static const String _keyLocationServicesEnabled = 'location_services_enabled';

  // User Preferences
  static const String _keyUserType = 'user_type';
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  // Fitness Goals
  static const String _keyPrimaryGoal = 'primary_goal';
  static const String _keyFitnessLevel = 'fitness_level';
  static const String _keyWeightGoal = 'weight_goal';
  static const String _keyWorkoutDaysPerWeek = 'workout_days_per_week';
  static const String _keyDailyCalorieGoal = 'daily_calorie_goal';
  static const String _keyDailyStepsGoal = 'daily_steps_goal';
  static const String _keyWorkoutDays = 'workout_days';
  static const String _keyCaloriesGoal = 'calories_goal';
  static const String _keyStepsGoal = 'steps_goal';

  // Theme Settings Methods
  bool get isDarkMode => _prefs.getBool(_keyDarkMode) ?? false;
  
  Future<void> setDarkMode(bool enabled) async {
    await _prefs.setBool(_keyDarkMode, enabled);
    _logger.i('Dark mode: $enabled');
  }

  // Notification Settings Methods
  bool get notificationEnabled => _prefs.getBool(_keyNotificationEnabled) ?? true;
  bool get workoutReminders => _prefs.getBool(_keyWorkoutReminders) ?? true;
  bool get progressUpdates => _prefs.getBool(_keyProgressUpdates) ?? true;
  bool get motivationalMessages => _prefs.getBool(_keyMotivationalMessages) ?? true;
  bool get quietHoursEnabled => _prefs.getBool(_keyQuietHoursEnabled) ?? false;

  String get quietHoursStart => _prefs.getString(_keyQuietHoursStart) ?? '22:00';
  String get quietHoursEnd => _prefs.getString(_keyQuietHoursEnd) ?? '08:00';

  // Sound and Vibration Settings Methods
  bool get isSoundEnabled => _prefs.getBool(_keySoundEnabled) ?? true;
  bool get isVibrationEnabled => _prefs.getBool(_keyVibrationEnabled) ?? true;

  // Privacy Settings Methods
  bool get isBiometricAuthEnabled => _prefs.getBool(_keyBiometricAuthEnabled) ?? false;
  bool get isTwoFactorAuthEnabled => _prefs.getBool(_keyTwoFactorAuthEnabled) ?? false;
  bool get isDataSharingEnabled => _prefs.getBool(_keyDataSharingEnabled) ?? true;
  bool get isAnalyticsEnabled => _prefs.getBool(_keyAnalyticsEnabled) ?? true;
  bool get isLocationServicesEnabled => _prefs.getBool(_keyLocationServicesEnabled) ?? false;

  // User Preferences Methods
  String get userType => _prefs.getString(_keyUserType) ?? 'get_fit';
  bool get isOnboardingCompleted => _prefs.getBool(_keyOnboardingCompleted) ?? false;

  // Alias methods for compatibility
  bool get areNotificationsEnabled => notificationEnabled;

  Future<void> setNotificationEnabled(bool enabled) async {
    await _prefs.setBool(_keyNotificationEnabled, enabled);
    _logger.i('Notification enabled: $enabled');
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await setNotificationEnabled(enabled);
  }

  Future<void> setWorkoutReminders(bool enabled) async {
    await _prefs.setBool(_keyWorkoutReminders, enabled);
    _logger.i('Workout reminders: $enabled');
  }

  Future<void> setProgressUpdates(bool enabled) async {
    await _prefs.setBool(_keyProgressUpdates, enabled);
    _logger.i('Progress updates: $enabled');
  }

  Future<void> setMotivationalMessages(bool enabled) async {
    await _prefs.setBool(_keyMotivationalMessages, enabled);
    _logger.i('Motivational messages: $enabled');
  }

  Future<void> setQuietHoursEnabled(bool enabled) async {
    await _prefs.setBool(_keyQuietHoursEnabled, enabled);
    _logger.i('Quiet hours enabled: $enabled');
  }

  Future<void> setQuietHoursStart(String time) async {
    await _prefs.setString(_keyQuietHoursStart, time);
    _logger.i('Quiet hours start: $time');
  }

  Future<void> setQuietHoursEnd(String time) async {
    await _prefs.setString(_keyQuietHoursEnd, time);
    _logger.i('Quiet hours end: $time');
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(_keySoundEnabled, enabled);
    _logger.i('Sound enabled: $enabled');
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    await _prefs.setBool(_keyVibrationEnabled, enabled);
    _logger.i('Vibration enabled: $enabled');
  }

  Future<void> setBiometricAuthEnabled(bool enabled) async {
    await _prefs.setBool(_keyBiometricAuthEnabled, enabled);
    _logger.i('Biometric auth enabled: $enabled');
  }

  Future<void> setTwoFactorAuthEnabled(bool enabled) async {
    await _prefs.setBool(_keyTwoFactorAuthEnabled, enabled);
    _logger.i('Two factor auth enabled: $enabled');
  }

  Future<void> setDataSharingEnabled(bool enabled) async {
    await _prefs.setBool(_keyDataSharingEnabled, enabled);
    _logger.i('Data sharing enabled: $enabled');
  }

  Future<void> setAnalyticsEnabled(bool enabled) async {
    await _prefs.setBool(_keyAnalyticsEnabled, enabled);
    _logger.i('Analytics enabled: $enabled');
  }

  Future<void> setLocationServicesEnabled(bool enabled) async {
    await _prefs.setBool(_keyLocationServicesEnabled, enabled);
    _logger.i('Location services enabled: $enabled');
  }

  Future<void> setUserType(String userType) async {
    await _prefs.setString(_keyUserType, userType);
    _logger.i('User type set: $userType');
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(_keyOnboardingCompleted, completed);
    _logger.i('Onboarding completed: $completed');
  }

  // Fitness Goals Methods
  String get primaryGoal => _prefs.getString(_keyPrimaryGoal) ?? 'Weight Loss';
  String get fitnessLevel => _prefs.getString(_keyFitnessLevel) ?? 'Beginner';
  double get weightGoal => _prefs.getDouble(_keyWeightGoal) ?? 70.0;
  int get workoutDaysPerWeek => _prefs.getInt(_keyWorkoutDaysPerWeek) ?? 4;
  int get dailyCalorieGoal => _prefs.getInt(_keyDailyCalorieGoal) ?? 2000;
  int get dailyStepsGoal => _prefs.getInt(_keyDailyStepsGoal) ?? 10000;
  int get workoutDays => _prefs.getInt(_keyWorkoutDays) ?? 4;
  int get caloriesGoal => _prefs.getInt(_keyCaloriesGoal) ?? 2000;
  int get stepsGoal => _prefs.getInt(_keyStepsGoal) ?? 10000;

  Future<void> setPrimaryGoal(String goal) async {
    await _prefs.setString(_keyPrimaryGoal, goal);
    _logger.i('Primary goal set: $goal');
  }

  Future<void> setFitnessLevel(String level) async {
    await _prefs.setString(_keyFitnessLevel, level);
    _logger.i('Fitness level set: $level');
  }

  Future<void> setWeightGoal(double weight) async {
    await _prefs.setDouble(_keyWeightGoal, weight);
    _logger.i('Weight goal set: $weight');
  }

  Future<void> setWorkoutDays(int days) async {
    await _prefs.setInt(_keyWorkoutDays, days);
    _logger.i('Workout days set: $days');
  }

  Future<void> setCaloriesGoal(int calories) async {
    await _prefs.setInt(_keyCaloriesGoal, calories);
    _logger.i('Calories goal set: $calories');
  }

  Future<void> setStepsGoal(int steps) async {
    await _prefs.setInt(_keyStepsGoal, steps);
    _logger.i('Steps goal set: $steps');
  }

  Future<void> setWorkoutDaysPerWeek(int days) async {
    await _prefs.setInt(_keyWorkoutDaysPerWeek, days);
    _logger.i('Workout days per week set: $days');
  }

  Future<void> setDailyCalorieGoal(int calories) async {
    await _prefs.setInt(_keyDailyCalorieGoal, calories);
    _logger.i('Daily calorie goal set: $calories');
  }

  Future<void> setDailyStepsGoal(int steps) async {
    await _prefs.setInt(_keyDailyStepsGoal, steps);
    _logger.i('Daily steps goal set: $steps');
  }

  // Save all notification settings
  Future<void> saveNotificationSettings({
    required bool notificationEnabled,
    required bool workoutReminders,
    required bool progressUpdates,
    required bool motivationalMessages,
    required bool quietHoursEnabled,
    required String quietHoursStart,
    required String quietHoursEnd,
  }) async {
    try {
      await Future.wait([
        setNotificationEnabled(notificationEnabled),
        setWorkoutReminders(workoutReminders),
        setProgressUpdates(progressUpdates),
        setMotivationalMessages(motivationalMessages),
        setQuietHoursEnabled(quietHoursEnabled),
        setQuietHoursStart(quietHoursStart),
        setQuietHoursEnd(quietHoursEnd),
      ]);
      
      _logger.i('All notification settings saved successfully');
    } catch (e) {
      _logger.e('Failed to save notification settings: $e');
      rethrow;
    }
  }

  // Save all privacy settings
  Future<void> savePrivacySettings({
    required bool biometricAuthEnabled,
    required bool twoFactorAuthEnabled,
    required bool dataSharingEnabled,
    required bool analyticsEnabled,
    required bool locationServicesEnabled,
  }) async {
    try {
      await Future.wait([
        setBiometricAuthEnabled(biometricAuthEnabled),
        setTwoFactorAuthEnabled(twoFactorAuthEnabled),
        setDataSharingEnabled(dataSharingEnabled),
        setAnalyticsEnabled(analyticsEnabled),
        setLocationServicesEnabled(locationServicesEnabled),
      ]);
      
      _logger.i('All privacy settings saved successfully');
    } catch (e) {
      _logger.e('Failed to save privacy settings: $e');
      rethrow;
    }
  }

  // Save all fitness goals
  Future<void> saveFitnessGoals({
    required String primaryGoal,
    required String fitnessLevel,
    required double weightGoal,
    required int workoutDays,
    required int caloriesGoal,
    required int stepsGoal,
  }) async {
    try {
      await Future.wait([
        setPrimaryGoal(primaryGoal),
        setFitnessLevel(fitnessLevel),
        setWeightGoal(weightGoal),
        setWorkoutDays(workoutDays),
        setCaloriesGoal(caloriesGoal),
        setStepsGoal(stepsGoal),
      ]);
      
      _logger.i('All fitness goals saved successfully');
    } catch (e) {
      _logger.e('Failed to save fitness goals: $e');
      rethrow;
    }
  }

  // Clear all settings
  Future<void> clearAllSettings() async {
    try {
      await _prefs.clear();
      _logger.i('All settings cleared');
    } catch (e) {
      _logger.e('Failed to clear settings: $e');
      rethrow;
    }
  }
} 