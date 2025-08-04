import 'package:equatable/equatable.dart';
import '../domain/entities/trainer_profile.dart';

/// Base class for trainer onboarding events
abstract class TrainerOnboardingEvent extends Equatable {
  const TrainerOnboardingEvent();

  @override
  List<Object?> get props => [];
}

/// Event to update the trainer profile
class UpdateProfileEvent extends TrainerOnboardingEvent {
  final TrainerProfile profile;

  const UpdateProfileEvent(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// Event to update specific profile fields
class UpdateProfileFieldEvent extends TrainerOnboardingEvent {
  final String? fullName;
  final String? pronouns;
  final String? customPronouns;
  final String? nickname;
  final String? experienceLevel;
  final List<String>? descriptiveWords;
  final String? motivation;
  final List<String>? certifications;
  final String? coachingExperience;
  final String? equipmentDetails;
  final List<String>? trainingPhilosophy;
  final String? email;
  final String? password;

  const UpdateProfileFieldEvent({
    this.fullName,
    this.pronouns,
    this.customPronouns,
    this.nickname,
    this.experienceLevel,
    this.descriptiveWords,
    this.motivation,
    this.certifications,
    this.coachingExperience,
    this.equipmentDetails,
    this.trainingPhilosophy,
    this.email,
    this.password,
  });

  @override
  List<Object?> get props => [
    fullName,
    pronouns,
    customPronouns,
    nickname,
    experienceLevel,
    descriptiveWords,
    motivation,
    certifications,
    coachingExperience,
    equipmentDetails,
    trainingPhilosophy,
    email,
    password,
  ];
}

/// Event to add a descriptive word
class AddDescriptiveWordEvent extends TrainerOnboardingEvent {
  final String word;

  const AddDescriptiveWordEvent(this.word);

  @override
  List<Object?> get props => [word];
}

/// Event to remove a descriptive word
class RemoveDescriptiveWordEvent extends TrainerOnboardingEvent {
  final String word;

  const RemoveDescriptiveWordEvent(this.word);

  @override
  List<Object?> get props => [word];
}

/// Event to add a certification
class AddCertificationEvent extends TrainerOnboardingEvent {
  final String certification;

  const AddCertificationEvent(this.certification);

  @override
  List<Object?> get props => [certification];
}

/// Event to remove a certification
class RemoveCertificationEvent extends TrainerOnboardingEvent {
  final String certification;

  const RemoveCertificationEvent(this.certification);

  @override
  List<Object?> get props => [certification];
}

/// Event to add training philosophy
class AddTrainingPhilosophyEvent extends TrainerOnboardingEvent {
  final String philosophy;

  const AddTrainingPhilosophyEvent(this.philosophy);

  @override
  List<Object?> get props => [philosophy];
}

/// Event to remove training philosophy
class RemoveTrainingPhilosophyEvent extends TrainerOnboardingEvent {
  final String philosophy;

  const RemoveTrainingPhilosophyEvent(this.philosophy);

  @override
  List<Object?> get props => [philosophy];
}

/// Event to create the trainer account
class CreateAccountEvent extends TrainerOnboardingEvent {
  const CreateAccountEvent();
}

/// Event to set current step
class SetCurrentStepEvent extends TrainerOnboardingEvent {
  final int step;

  const SetCurrentStepEvent(this.step);

  @override
  List<Object?> get props => [step];
}

/// Event to go to next step
class NextStepEvent extends TrainerOnboardingEvent {
  const NextStepEvent();
}

/// Event to go to previous step
class PreviousStepEvent extends TrainerOnboardingEvent {
  const PreviousStepEvent();
}

/// Event to validate email
class ValidateEmailEvent extends TrainerOnboardingEvent {
  final String email;

  const ValidateEmailEvent(this.email);

  @override
  List<Object?> get props => [email];
}

/// Event to clear error
class ClearErrorEvent extends TrainerOnboardingEvent {
  const ClearErrorEvent();
} 