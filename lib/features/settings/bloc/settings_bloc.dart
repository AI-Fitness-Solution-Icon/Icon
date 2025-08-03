import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/services/settings_service.dart';

// Events
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ToggleDarkMode extends SettingsEvent {
  final bool isDark;

  const ToggleDarkMode(this.isDark);

  @override
  List<Object?> get props => [isDark];
}

class ToggleNotifications extends SettingsEvent {
  final bool enabled;

  const ToggleNotifications(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class ToggleSound extends SettingsEvent {
  final bool enabled;

  const ToggleSound(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class ToggleVibration extends SettingsEvent {
  final bool enabled;

  const ToggleVibration(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

// States
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;

  const SettingsLoaded({
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.soundEnabled,
    required this.vibrationEnabled,
  });

  @override
  List<Object?> get props => [
        isDarkMode,
        notificationsEnabled,
        soundEnabled,
        vibrationEnabled,
      ];

  SettingsLoaded copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return SettingsLoaded(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsService _settingsService;

  SettingsBloc(this._settingsService) : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleDarkMode>(_onToggleDarkMode);
    on<ToggleNotifications>(_onToggleNotifications);
    on<ToggleSound>(_onToggleSound);
    on<ToggleVibration>(_onToggleVibration);
  }

  Future<void> _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final isDarkMode = await _settingsService.isDarkMode();
      final notificationsEnabled = await _settingsService.areNotificationsEnabled();
      final soundEnabled = await _settingsService.isSoundEnabled();
      final vibrationEnabled = await _settingsService.isVibrationEnabled();

      emit(SettingsLoaded(
        isDarkMode: isDarkMode,
        notificationsEnabled: notificationsEnabled,
        soundEnabled: soundEnabled,
        vibrationEnabled: vibrationEnabled,
      ));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> _onToggleDarkMode(ToggleDarkMode event, Emitter<SettingsState> emit) async {
    try {
      await _settingsService.setDarkMode(event.isDark);
      if (state is SettingsLoaded) {
        final currentState = state as SettingsLoaded;
        emit(currentState.copyWith(isDarkMode: event.isDark));
      }
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> _onToggleNotifications(ToggleNotifications event, Emitter<SettingsState> emit) async {
    try {
      await _settingsService.setNotificationsEnabled(event.enabled);
      if (state is SettingsLoaded) {
        final currentState = state as SettingsLoaded;
        emit(currentState.copyWith(notificationsEnabled: event.enabled));
      }
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> _onToggleSound(ToggleSound event, Emitter<SettingsState> emit) async {
    try {
      await _settingsService.setSoundEnabled(event.enabled);
      if (state is SettingsLoaded) {
        final currentState = state as SettingsLoaded;
        emit(currentState.copyWith(soundEnabled: event.enabled));
      }
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> _onToggleVibration(ToggleVibration event, Emitter<SettingsState> emit) async {
    try {
      await _settingsService.setVibrationEnabled(event.enabled);
      if (state is SettingsLoaded) {
        final currentState = state as SettingsLoaded;
        emit(currentState.copyWith(vibrationEnabled: event.enabled));
      }
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
} 