import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_app/core/repositories/fitness_goals_repository.dart';
import 'package:icon_app/core/utils/app_print.dart';
import 'onboarding_bloc.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final FitnessGoalsRepository _fitnessGoalsRepository;

  OnboardingBloc({required FitnessGoalsRepository fitnessGoalsRepository})
    : _fitnessGoalsRepository = fitnessGoalsRepository,
      super(OnboardingInitial()) {
    on<LoadFitnessGoals>(_onLoadFitnessGoals);
    on<UpdatePersonalInfo>(_onUpdatePersonalInfo);
    on<UpdateFitnessGoals>(_onUpdateFitnessGoals);
    on<UpdateExperienceLevel>(_onUpdateExperienceLevel);
    on<UpdateOptionalDetails>(_onUpdateOptionalDetails);
    on<NextStep>(_onNextStep);
    on<PreviousStep>(_onPreviousStep);
    on<GoToStep>(_onGoToStep);
  }

  Future<void> _onLoadFitnessGoals(
    LoadFitnessGoals event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      AppPrint.printStep('Loading fitness goals');

      // If we already have goals loaded, don't reload
      if (state is OnboardingLoaded) {
        final currentState = state as OnboardingLoaded;
        if (currentState.availableGoals.isNotEmpty) {
          return;
        }
      }

      emit(
        OnboardingLoaded(
          currentStep: 0,
          data: const OnboardingData(),
          availableGoals: [],
          isLoadingGoals: true,
        ),
      );

      final goals = await _fitnessGoalsRepository.getAllMainGoals();
      AppPrint.printInfo('Loaded ${goals.length} fitness goals');

      emit(
        OnboardingLoaded(
          currentStep: 0,
          data: const OnboardingData(),
          availableGoals: goals,
          isLoadingGoals: false,
        ),
      );
    } catch (e) {
      AppPrint.printError('Failed to load fitness goals: $e');
      emit(
        OnboardingLoaded(
          currentStep: 0,
          data: const OnboardingData(),
          availableGoals: [],
          isLoadingGoals: false,
          goalsError: 'Failed to load fitness goals: $e',
        ),
      );
    }
  }

  void _onUpdatePersonalInfo(
    UpdatePersonalInfo event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingLoaded) {
      final currentState = state as OnboardingLoaded;
      final updatedData = currentState.data.copyWith(
        firstName: event.firstName,
        lastName: event.lastName,
        dateOfBirth: event.dateOfBirth,
        gender: event.gender,
      );

      emit(currentState.copyWith(data: updatedData));
    } else {
      // If state is not loaded yet, create a new loaded state with the personal info
      final updatedData = OnboardingData(
        firstName: event.firstName,
        lastName: event.lastName,
        dateOfBirth: event.dateOfBirth,
        gender: event.gender,
      );

      emit(
        OnboardingLoaded(
          currentStep: 0,
          data: updatedData,
          availableGoals: [],
          isLoadingGoals: false,
        ),
      );
    }
  }

  void _onUpdateFitnessGoals(
    UpdateFitnessGoals event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingLoaded) {
      final currentState = state as OnboardingLoaded;
      final updatedData = currentState.data.copyWith(
        selectedGoalIds: event.selectedGoalIds,
      );

      emit(currentState.copyWith(data: updatedData));
    } else {
      // If state is not loaded yet, create a new loaded state with the fitness goals
      final updatedData = OnboardingData(
        selectedGoalIds: event.selectedGoalIds,
      );

      emit(
        OnboardingLoaded(
          currentStep: 0,
          data: updatedData,
          availableGoals: [],
          isLoadingGoals: false,
        ),
      );
    }
  }

  void _onUpdateExperienceLevel(
    UpdateExperienceLevel event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingLoaded) {
      final currentState = state as OnboardingLoaded;
      final updatedData = currentState.data.copyWith(
        experienceLevel: event.experienceLevel,
      );

      emit(currentState.copyWith(data: updatedData));
    } else {
      // If state is not loaded yet, create a new loaded state with the experience level
      final updatedData = OnboardingData(
        experienceLevel: event.experienceLevel,
      );

      emit(
        OnboardingLoaded(
          currentStep: 0,
          data: updatedData,
          availableGoals: [],
          isLoadingGoals: false,
        ),
      );
    }
  }

  void _onUpdateOptionalDetails(
    UpdateOptionalDetails event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingLoaded) {
      final currentState = state as OnboardingLoaded;
      final updatedData = currentState.data.copyWith(
        optionalDetails: event.details,
      );

      emit(currentState.copyWith(data: updatedData));
    } else {
      // If state is not loaded yet, create a new loaded state with the optional details
      final updatedData = OnboardingData(optionalDetails: event.details);

      emit(
        OnboardingLoaded(
          currentStep: 0,
          data: updatedData,
          availableGoals: [],
          isLoadingGoals: false,
        ),
      );
    }
  }

  void _onNextStep(NextStep event, Emitter<OnboardingState> emit) {
    if (state is OnboardingLoaded) {
      final currentState = state as OnboardingLoaded;
      final nextStep = currentState.currentStep + 1;

      if (nextStep < 10) {
        // 10 total steps
        emit(currentState.copyWith(currentStep: nextStep));
      }
    }
  }

  void _onPreviousStep(PreviousStep event, Emitter<OnboardingState> emit) {
    if (state is OnboardingLoaded) {
      final currentState = state as OnboardingLoaded;
      final previousStep = currentState.currentStep - 1;

      if (previousStep >= 0) {
        emit(currentState.copyWith(currentStep: previousStep));
      }
    }
  }

  void _onGoToStep(GoToStep event, Emitter<OnboardingState> emit) {
    if (state is OnboardingLoaded) {
      final currentState = state as OnboardingLoaded;
      final targetStep = event.stepIndex;

      if (targetStep >= 0 && targetStep < 10) {
        emit(currentState.copyWith(currentStep: targetStep));
      }
    }
  }

  /// Check if the current step can be completed
  bool canCompleteCurrentStep() {
    if (state is OnboardingLoaded) {
      final currentState = state as OnboardingLoaded;
      final currentStep = currentState.currentStep;
      final data = currentState.data;

      switch (currentStep) {
        case 0: // Personal Info
          return data.isPersonalInfoComplete;
        case 1: // Fitness Goals
          return data.isFitnessGoalsComplete;
        case 2: // Training Location
          return true; // Always can proceed
        case 3: // Training Routine
          return true; // Always can proceed
        case 4: // Nutrition Goals
          return true; // Always can proceed
        case 5: // Experience Level
          return data.isExperienceLevelComplete;
        case 6: // Available Time
          return true; // Always can proceed
        case 7: // Equipment Access
          return true; // Always can proceed
        case 8: // Health Information
          return true; // Always can proceed
        case 9: // Review & Complete
          return true; // Always can proceed
        default:
          return false;
      }
    }
    return false;
  }

  /// Get the current step data
  OnboardingData? getCurrentData() {
    if (state is OnboardingLoaded) {
      return (state as OnboardingLoaded).data;
    }
    return null;
  }

  /// Get the current step index
  int getCurrentStep() {
    if (state is OnboardingLoaded) {
      return (state as OnboardingLoaded).currentStep;
    }
    return 0;
  }
}
