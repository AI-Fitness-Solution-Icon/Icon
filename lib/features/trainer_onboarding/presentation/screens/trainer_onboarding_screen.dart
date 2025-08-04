import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/service_locator.dart';
import '../../bloc/trainer_onboarding_bloc.dart';
import '../../bloc/trainer_onboarding_event.dart';
import '../../bloc/trainer_onboarding_state.dart';
import '../widgets/onboarding_progress_bar.dart';
import 'identity_introduction_screen.dart';
import 'credentials_experience_screen.dart';
import 'training_philosophy_screen.dart';
import 'account_creation_screen.dart';
import '../../../../navigation/route_names.dart';

/// Main trainer onboarding screen that manages step navigation
class TrainerOnboardingScreen extends StatefulWidget {
  const TrainerOnboardingScreen({super.key});

  @override
  State<TrainerOnboardingScreen> createState() => _TrainerOnboardingScreenState();
}

class _TrainerOnboardingScreenState extends State<TrainerOnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceLocator().trainerOnboardingBloc,
      child: BlocBuilder<TrainerOnboardingBloc, TrainerOnboardingState>(
        builder: (context, state) {
          if (state is TrainerOnboardingInitial) {
            return const Scaffold(
              backgroundColor: AppColors.primaryBackground,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final currentStep = state is TrainerOnboardingLoaded 
              ? state.currentStep
              : state is TrainerOnboardingError 
                  ? state.currentStep
                  : state is TrainerOnboardingLoading
                      ? state.currentStep
                      : state is TrainerOnboardingValidatingEmail
                          ? state.currentStep
                          : 1;

          final progressPercentage = state is TrainerOnboardingLoaded 
              ? state.progressPercentage
              : currentStep / 4.0; // Assuming 4 total steps

          return Scaffold(
            backgroundColor: AppColors.primaryBackground,
            body: SafeArea(
              child: Column(
                children: [
                  // Progress bar
                  OnboardingProgressBar(
                    currentStep: currentStep,
                    totalSteps: 4,
                    progressPercentage: progressPercentage,
                  ),
                  
                  // Back button
                  if (currentStep > 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () {
                            context.read<TrainerOnboardingBloc>().add(const PreviousStepEvent());
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          label: const Text(
                            'Back',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  
                  // Step content
                  Expanded(
                    child: _buildStepContent(context, state),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the content for the current step
  Widget _buildStepContent(BuildContext context, TrainerOnboardingState state) {
    final currentStep = state is TrainerOnboardingLoaded 
        ? state.currentStep
        : state is TrainerOnboardingError 
            ? state.currentStep
            : state is TrainerOnboardingLoading
                ? state.currentStep
                : state is TrainerOnboardingValidatingEmail
                    ? state.currentStep
                    : 1;

    switch (currentStep) {
      case 1:
        return IdentityIntroductionScreen(
          onContinue: () => context.read<TrainerOnboardingBloc>().add(const NextStepEvent()),
        );
      case 2:
        return CredentialsExperienceScreen(
          onContinue: () => context.read<TrainerOnboardingBloc>().add(const NextStepEvent()),
        );
      case 3:
        return TrainingPhilosophyScreen(
          onContinue: () => context.read<TrainerOnboardingBloc>().add(const NextStepEvent()),
        );
      case 4:
        return AccountCreationScreen(
          onAccountCreated: () => _handleAccountCreated(context),
        );
      default:
        return const Center(
          child: Text(
            'Unknown step',
            style: TextStyle(color: AppColors.textLight),
          ),
        );
    }
  }

  /// Handles successful account creation
  void _handleAccountCreated(BuildContext context) {
    // Navigate to dashboard or email verification
    context.go(RouteNames.dashboardPath);
  }
} 