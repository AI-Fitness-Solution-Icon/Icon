import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/trainer_profile.dart';
import '../domain/repositories/trainer_onboarding_repository.dart';
import '../domain/usecases/save_trainer_profile_usecase.dart';
import '../domain/usecases/create_trainer_account_usecase.dart';
import 'trainer_onboarding_event.dart';
import 'trainer_onboarding_state.dart';

/// BLoC for managing trainer onboarding state
class TrainerOnboardingBloc extends Bloc<TrainerOnboardingEvent, TrainerOnboardingState> {
  final SaveTrainerProfileUseCase saveProfileUseCase;
  final CreateTrainerAccountUseCase createAccountUseCase;
  final TrainerOnboardingRepository repository;

  TrainerOnboardingBloc({
    required this.saveProfileUseCase,
    required this.createAccountUseCase,
    required this.repository,
  }) : super(const TrainerOnboardingInitial()) {
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<UpdateProfileFieldEvent>(_onUpdateProfileField);
    on<AddDescriptiveWordEvent>(_onAddDescriptiveWord);
    on<RemoveDescriptiveWordEvent>(_onRemoveDescriptiveWord);
    on<AddCertificationEvent>(_onAddCertification);
    on<RemoveCertificationEvent>(_onRemoveCertification);
    on<AddTrainingPhilosophyEvent>(_onAddTrainingPhilosophy);
    on<RemoveTrainingPhilosophyEvent>(_onRemoveTrainingPhilosophy);
    on<CreateAccountEvent>(_onCreateAccount);
    on<SetCurrentStepEvent>(_onSetCurrentStep);
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
    on<ValidateEmailEvent>(_onValidateEmail);
    on<ClearErrorEvent>(_onClearError);
  }

  /// Handle updating the entire profile
  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<TrainerOnboardingState> emit,
  ) async {
    try {
      emit(TrainerOnboardingLoading(
        profile: event.profile,
        currentStep: event.profile.currentStep,
      ));

      await saveProfileUseCase.execute(event.profile);

      emit(TrainerOnboardingLoaded(
        profile: event.profile,
        currentStep: event.profile.currentStep,
        progressPercentage: event.profile.currentStep / TrainerProfile.totalSteps,
      ));
    } catch (e) {
      emit(TrainerOnboardingError(
        message: e.toString(),
        profile: event.profile,
        currentStep: event.profile.currentStep,
      ));
    }
  }

  /// Handle updating specific profile fields
  void _onUpdateProfileField(
    UpdateProfileFieldEvent event,
    Emitter<TrainerOnboardingState> emit,
  ) {
    final currentProfile = state is TrainerOnboardingLoaded 
        ? (state as TrainerOnboardingLoaded).profile
        : state is TrainerOnboardingError 
            ? (state as TrainerOnboardingError).profile
            : state is TrainerOnboardingLoading
                ? (state as TrainerOnboardingLoading).profile
                : const TrainerProfile();

    final updatedProfile = currentProfile.copyWith(
      fullName: event.fullName,
      pronouns: event.pronouns,
      customPronouns: event.customPronouns,
      nickname: event.nickname,
      experienceLevel: event.experienceLevel,
      descriptiveWords: event.descriptiveWords,
      motivation: event.motivation,
      certifications: event.certifications,
      coachingExperience: event.coachingExperience,
      equipmentDetails: event.equipmentDetails,
      trainingPhilosophy: event.trainingPhilosophy,
      email: event.email,
      password: event.password,
    );

    final currentStep = state is TrainerOnboardingLoaded 
        ? (state as TrainerOnboardingLoaded).currentStep
        : state is TrainerOnboardingError 
            ? (state as TrainerOnboardingError).currentStep
            : state is TrainerOnboardingLoading
                ? (state as TrainerOnboardingLoading).currentStep
                : 1;

    emit(TrainerOnboardingLoaded(
      profile: updatedProfile,
      currentStep: currentStep,
      progressPercentage: currentStep / TrainerProfile.totalSteps,
    ));
  }

  /// Handle adding a descriptive word
  void _onAddDescriptiveWord(
    AddDescriptiveWordEvent event,
    Emitter<TrainerOnboardingState> emit,
  ) {
    final currentProfile = _getCurrentProfile();
    if (!currentProfile.descriptiveWords.contains(event.word)) {
      final updatedWords = List<String>.from(currentProfile.descriptiveWords)..add(event.word);
      final updatedProfile = currentProfile.copyWith(descriptiveWords: updatedWords);
      emit(TrainerOnboardingLoaded(
        profile: updatedProfile,
        currentStep: updatedProfile.currentStep,
        progressPercentage: updatedProfile.currentStep / TrainerProfile.totalSteps,
      ));
    }
  }

  /// Handle removing a descriptive word
  void _onRemoveDescriptiveWord(
    RemoveDescriptiveWordEvent event,
    Emitter<TrainerOnboardingState> emit,
  ) {
    final currentProfile = _getCurrentProfile();
    final updatedWords = List<String>.from(currentProfile.descriptiveWords)..remove(event.word);
    final updatedProfile = currentProfile.copyWith(descriptiveWords: updatedWords);
    emit(TrainerOnboardingLoaded(
      profile: updatedProfile,
      currentStep: updatedProfile.currentStep,
      progressPercentage: updatedProfile.currentStep / TrainerProfile.totalSteps,
    ));
  }

  /// Handle adding a certification
  void _onAddCertification(
    AddCertificationEvent event,
    Emitter<TrainerOnboardingState> emit,
  ) {
    final currentProfile = _getCurrentProfile();
    if (!currentProfile.certifications.contains(event.certification)) {
      final updatedCertifications = List<String>.from(currentProfile.certifications)..add(event.certification);
      final updatedProfile = currentProfile.copyWith(certifications: updatedCertifications);
      emit(TrainerOnboardingLoaded(
        profile: updatedProfile,
        currentStep: updatedProfile.currentStep,
        progressPercentage: updatedProfile.currentStep / TrainerProfile.totalSteps,
      ));
    }
  }

  /// Handle removing a certification
  void _onRemoveCertification(
    RemoveCertificationEvent event,
    Emitter<TrainerOnboardingState> emit,
  ) {
    final currentProfile = _getCurrentProfile();
    final updatedCertifications = List<String>.from(currentProfile.certifications)..remove(event.certification);
    final updatedProfile = currentProfile.copyWith(certifications: updatedCertifications);
    emit(TrainerOnboardingLoaded(
      profile: updatedProfile,
      currentStep: updatedProfile.currentStep,
      progressPercentage: updatedProfile.currentStep / TrainerProfile.totalSteps,
    ));
  }

  /// Handle adding training philosophy
  void _onAddTrainingPhilosophy(
    AddTrainingPhilosophyEvent event,
    Emitter<TrainerOnboardingState> emit,
  ) {
    final currentProfile = _getCurrentProfile();
    if (!currentProfile.trainingPhilosophy.contains(event.philosophy)) {
      final updatedPhilosophy = List<String>.from(currentProfile.trainingPhilosophy)..add(event.philosophy);
      final updatedProfile = currentProfile.copyWith(trainingPhilosophy: updatedPhilosophy);
      emit(TrainerOnboardingLoaded(
        profile: updatedProfile,
        currentStep: updatedProfile.currentStep,
        progressPercentage: updatedProfile.currentStep / TrainerProfile.totalSteps,
      ));
    }
  }

  /// Handle removing training philosophy
  void _onRemoveTrainingPhilosophy(
    RemoveTrainingPhilosophyEvent event,
    Emitter<TrainerOnboardingState> emit,
  ) {
    final currentProfile = _getCurrentProfile();
    final updatedPhilosophy = List<String>.from(currentProfile.trainingPhilosophy)..remove(event.philosophy);
    final updatedProfile = currentProfile.copyWith(trainingPhilosophy: updatedPhilosophy);
    emit(TrainerOnboardingLoaded(
      profile: updatedProfile,
      currentStep: updatedProfile.currentStep,
      progressPercentage: updatedProfile.currentStep / TrainerProfile.totalSteps,
    ));
  }

  /// Handle creating the trainer account
  Future<void> _onCreateAccount(
    CreateAccountEvent event,
    Emitter<TrainerOnboardingState> emit,
  ) async {
    final currentProfile = _getCurrentProfile();
    
    if (!currentProfile.isCompleteForAccountCreation) {
      emit(TrainerOnboardingError(
        message: 'Please complete all required fields',
        profile: currentProfile,
        currentStep: currentProfile.currentStep,
      ));
      return;
    }

    try {
      emit(TrainerOnboardingCreatingAccount(
        profile: currentProfile,
        currentStep: currentProfile.currentStep,
      ));

      await createAccountUseCase.execute(currentProfile);

      emit(TrainerOnboardingAccountCreated(profile: currentProfile));
    } catch (e) {
      emit(TrainerOnboardingError(
        message: e.toString(),
        profile: currentProfile,
        currentStep: currentProfile.currentStep,
      ));
    }
  }

  /// Handle setting current step
  void _onSetCurrentStep(
    SetCurrentStepEvent event,
    Emitter<TrainerOnboardingState> emit,
  ) {
    if (event.step >= 1 && event.step <= TrainerProfile.totalSteps) {
      final currentProfile = _getCurrentProfile();
      emit(TrainerOnboardingLoaded(
        profile: currentProfile,
        currentStep: event.step,
        progressPercentage: event.step / TrainerProfile.totalSteps,
      ));
    }
  }

  /// Handle going to next step
  void _onNextStep(
    NextStepEvent event,
    Emitter<TrainerOnboardingState> emit,
  ) {
    final currentStep = _getCurrentStep();
    if (currentStep < TrainerProfile.totalSteps) {
      final currentProfile = _getCurrentProfile();
      emit(TrainerOnboardingLoaded(
        profile: currentProfile,
        currentStep: currentStep + 1,
        progressPercentage: (currentStep + 1) / TrainerProfile.totalSteps,
      ));
    }
  }

  /// Handle going to previous step
  void _onPreviousStep(
    PreviousStepEvent event,
    Emitter<TrainerOnboardingState> emit,
  ) {
    final currentStep = _getCurrentStep();
    if (currentStep > 1) {
      final currentProfile = _getCurrentProfile();
      emit(TrainerOnboardingLoaded(
        profile: currentProfile,
        currentStep: currentStep - 1,
        progressPercentage: (currentStep - 1) / TrainerProfile.totalSteps,
      ));
    }
  }

  /// Handle email validation
  Future<void> _onValidateEmail(
    ValidateEmailEvent event,
    Emitter<TrainerOnboardingState> emit,
  ) async {
    final currentProfile = _getCurrentProfile();
    final currentStep = _getCurrentStep();

    try {
      emit(TrainerOnboardingValidatingEmail(
        profile: currentProfile,
        currentStep: currentStep,
        email: event.email,
      ));

      // Basic email format validation
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
      if (!emailRegex.hasMatch(event.email)) {
        emit(TrainerOnboardingError(
          message: 'Please enter a valid email address',
          profile: currentProfile,
          currentStep: currentStep,
        ));
        return;
      }

      // Check email availability through repository
      final isAvailable = await repository.validateEmail(event.email);
      
      if (!isAvailable) {
        emit(TrainerOnboardingError(
          message: 'This email is already taken. Please use a different email address.',
          profile: currentProfile,
          currentStep: currentStep,
        ));
        return;
      }

      // Email is valid and available
      emit(TrainerOnboardingLoaded(
        profile: currentProfile,
        currentStep: currentStep,
        progressPercentage: currentStep / TrainerProfile.totalSteps,
      ));
    } catch (e) {
      emit(TrainerOnboardingError(
        message: 'Failed to validate email. Please try again.',
        profile: currentProfile,
        currentStep: currentStep,
      ));
    }
  }

  /// Handle clearing error
  void _onClearError(
    ClearErrorEvent event,
    Emitter<TrainerOnboardingState> emit,
  ) {
    final currentProfile = _getCurrentProfile();
    final currentStep = _getCurrentStep();
    emit(TrainerOnboardingLoaded(
      profile: currentProfile,
      currentStep: currentStep,
      progressPercentage: currentStep / TrainerProfile.totalSteps,
    ));
  }

  /// Helper method to get current profile from state
  TrainerProfile _getCurrentProfile() {
    if (state is TrainerOnboardingLoaded) {
      return (state as TrainerOnboardingLoaded).profile;
    } else if (state is TrainerOnboardingError) {
      return (state as TrainerOnboardingError).profile;
    } else if (state is TrainerOnboardingLoading) {
      return (state as TrainerOnboardingLoading).profile;
    } else if (state is TrainerOnboardingCreatingAccount) {
      return (state as TrainerOnboardingCreatingAccount).profile;
    } else if (state is TrainerOnboardingValidatingEmail) {
      return (state as TrainerOnboardingValidatingEmail).profile;
    } else if (state is TrainerOnboardingAccountCreated) {
      return (state as TrainerOnboardingAccountCreated).profile;
    }
    return const TrainerProfile();
  }

  /// Helper method to get current step from state
  int _getCurrentStep() {
    if (state is TrainerOnboardingLoaded) {
      return (state as TrainerOnboardingLoaded).currentStep;
    } else if (state is TrainerOnboardingError) {
      return (state as TrainerOnboardingError).currentStep;
    } else if (state is TrainerOnboardingLoading) {
      return (state as TrainerOnboardingLoading).currentStep;
    } else if (state is TrainerOnboardingCreatingAccount) {
      return (state as TrainerOnboardingCreatingAccount).currentStep;
    } else if (state is TrainerOnboardingValidatingEmail) {
      return (state as TrainerOnboardingValidatingEmail).currentStep;
    }
    return 1;
  }



  /// Check if the current step is valid to proceed
  bool canProceedFromCurrentStep() {
    final profile = _getCurrentProfile();
    final currentStep = _getCurrentStep();
    
    switch (currentStep) {
      case 1:
        return profile.fullName != null && 
               profile.fullName!.isNotEmpty &&
               profile.experienceLevel != null &&
               profile.experienceLevel!.isNotEmpty &&
               profile.descriptiveWords.isNotEmpty &&
               profile.motivation != null &&
               profile.motivation!.isNotEmpty;
      case 2:
        return profile.certifications.isNotEmpty &&
               profile.coachingExperience != null &&
               profile.coachingExperience!.isNotEmpty;
      case 3:
        return profile.trainingPhilosophy.isNotEmpty;
      case 4:
        return profile.isCompleteForAccountCreation;
      default:
        return false;
    }
  }
} 