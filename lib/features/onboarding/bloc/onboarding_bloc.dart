import 'package:equatable/equatable.dart';
import 'package:icon_app/core/models/fitness_main_goal.dart';

// Events
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class LoadFitnessGoals extends OnboardingEvent {}

class UpdatePersonalInfo extends OnboardingEvent {
  final String? firstName;
  final String? lastName;
  final DateTime? dateOfBirth;
  final String? gender;

  const UpdatePersonalInfo({
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.gender,
  });

  @override
  List<Object?> get props => [firstName, lastName, dateOfBirth, gender];
}

class UpdateFitnessGoals extends OnboardingEvent {
  final Set<String> selectedGoalIds;

  const UpdateFitnessGoals(this.selectedGoalIds);

  @override
  List<Object?> get props => [selectedGoalIds];
}

class UpdateExperienceLevel extends OnboardingEvent {
  final String experienceLevel;

  const UpdateExperienceLevel(this.experienceLevel);

  @override
  List<Object?> get props => [experienceLevel];
}

class UpdateOptionalDetails extends OnboardingEvent {
  final String? details;

  const UpdateOptionalDetails(this.details);

  @override
  List<Object?> get props => [details];
}

class NextStep extends OnboardingEvent {}

class PreviousStep extends OnboardingEvent {}

class GoToStep extends OnboardingEvent {
  final int stepIndex;

  const GoToStep(this.stepIndex);

  @override
  List<Object?> get props => [stepIndex];
}

// States
abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingLoaded extends OnboardingState {
  final int currentStep;
  final OnboardingData data;
  final List<FitnessMainGoal> availableGoals;
  final bool isLoadingGoals;
  final String? goalsError;

  const OnboardingLoaded({
    required this.currentStep,
    required this.data,
    required this.availableGoals,
    this.isLoadingGoals = false,
    this.goalsError,
  });

  OnboardingLoaded copyWith({
    int? currentStep,
    OnboardingData? data,
    List<FitnessMainGoal>? availableGoals,
    bool? isLoadingGoals,
    String? goalsError,
  }) {
    return OnboardingLoaded(
      currentStep: currentStep ?? this.currentStep,
      data: data ?? this.data,
      availableGoals: availableGoals ?? this.availableGoals,
      isLoadingGoals: isLoadingGoals ?? this.isLoadingGoals,
      goalsError: goalsError ?? this.goalsError,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    data,
    availableGoals,
    isLoadingGoals,
    goalsError,
  ];
}

class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError(this.message);

  @override
  List<Object?> get props => [message];
}

// Data Model
class OnboardingData extends Equatable {
  final String? firstName;
  final String? lastName;
  final DateTime? dateOfBirth;
  final String? gender;
  final Set<String> selectedGoalIds;
  final String? experienceLevel;
  final String? optionalDetails;

  const OnboardingData({
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.gender,
    this.selectedGoalIds = const {},
    this.experienceLevel,
    this.optionalDetails,
  });

  OnboardingData copyWith({
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? gender,
    Set<String>? selectedGoalIds,
    String? experienceLevel,
    String? optionalDetails,
  }) {
    return OnboardingData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      selectedGoalIds: selectedGoalIds ?? this.selectedGoalIds,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      optionalDetails: optionalDetails ?? this.optionalDetails,
    );
  }

  bool get isPersonalInfoComplete =>
      firstName?.isNotEmpty == true &&
      lastName?.isNotEmpty == true &&
      dateOfBirth != null &&
      gender != null;

  bool get isFitnessGoalsComplete => selectedGoalIds.isNotEmpty;

  bool get isExperienceLevelComplete => experienceLevel != null;

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    dateOfBirth,
    gender,
    selectedGoalIds,
    experienceLevel,
    optionalDetails,
  ];
}
