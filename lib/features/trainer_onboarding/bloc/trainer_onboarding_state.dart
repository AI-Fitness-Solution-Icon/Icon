import 'package:equatable/equatable.dart';
import '../domain/entities/trainer_profile.dart';

/// Base class for trainer onboarding states
abstract class TrainerOnboardingState extends Equatable {
  const TrainerOnboardingState();

  @override
  List<Object?> get props => [];
}

/// Initial state when trainer onboarding is first loaded
class TrainerOnboardingInitial extends TrainerOnboardingState {
  const TrainerOnboardingInitial();
}

/// State when trainer onboarding is loading
class TrainerOnboardingLoading extends TrainerOnboardingState {
  final TrainerProfile profile;
  final int currentStep;

  const TrainerOnboardingLoading({
    required this.profile,
    required this.currentStep,
  });

  @override
  List<Object?> get props => [profile, currentStep];
}

/// State when trainer onboarding is successfully loaded
class TrainerOnboardingLoaded extends TrainerOnboardingState {
  final TrainerProfile profile;
  final int currentStep;
  final double progressPercentage;

  const TrainerOnboardingLoaded({
    required this.profile,
    required this.currentStep,
    required this.progressPercentage,
  });

  @override
  List<Object?> get props => [profile, currentStep, progressPercentage];
}

/// State when an error occurs during trainer onboarding
class TrainerOnboardingError extends TrainerOnboardingState {
  final String message;
  final TrainerProfile profile;
  final int currentStep;

  const TrainerOnboardingError({
    required this.message,
    required this.profile,
    required this.currentStep,
  });

  @override
  List<Object?> get props => [message, profile, currentStep];
}

/// State when creating the trainer account
class TrainerOnboardingCreatingAccount extends TrainerOnboardingState {
  final TrainerProfile profile;
  final int currentStep;

  const TrainerOnboardingCreatingAccount({
    required this.profile,
    required this.currentStep,
  });

  @override
  List<Object?> get props => [profile, currentStep];
}

/// State when validating email
class TrainerOnboardingValidatingEmail extends TrainerOnboardingState {
  final TrainerProfile profile;
  final int currentStep;
  final String email;

  const TrainerOnboardingValidatingEmail({
    required this.profile,
    required this.currentStep,
    required this.email,
  });

  @override
  List<Object?> get props => [profile, currentStep, email];
}

/// State when trainer account is successfully created
class TrainerOnboardingAccountCreated extends TrainerOnboardingState {
  final TrainerProfile profile;

  const TrainerOnboardingAccountCreated({
    required this.profile,
  });

  @override
  List<Object?> get props => [profile];
} 