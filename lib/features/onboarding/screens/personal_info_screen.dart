import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icon_app/core/constants/app_colors.dart';
import 'package:icon_app/features/onboarding/widgets/progress_header.dart';
import 'package:icon_app/features/onboarding/widgets/steps/personal_info_step.dart';
import 'package:icon_app/features/onboarding/widgets/steps/fitness_goals_step.dart';
import 'package:icon_app/features/onboarding/widgets/steps/training_location_step.dart';
import 'package:icon_app/features/onboarding/widgets/steps/training_routine_step.dart';
import 'package:icon_app/features/onboarding/widgets/steps/simple_step.dart';
import 'package:icon_app/features/onboarding/widgets/steps/body_profile_step.dart';
import 'package:icon_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:icon_app/features/onboarding/bloc/onboarding_bloc_impl.dart';

/// Refactored Personal Information Screen using BLoC and separate step widgets
class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    // Update the BLoC with the new step
    context.read<OnboardingBloc>().add(GoToStep(page));
  }

  void _onBackPressed() {
    final bloc = context.read<OnboardingBloc>();
    final currentStep = bloc.getCurrentStep();

    if (currentStep == 0) {
      context.pop();
    } else {
      // Update the BLoC first
      bloc.add(PreviousStep());

      // Then animate the page controller to match
      if (_pageController.hasClients && currentStep != null) {
        _pageController.animateToPage(
          currentStep - 1, // Go to previous step
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingLoaded) {
          // Animate to the current step if it changed
          final currentStep = state.currentStep;
          if (_pageController.hasClients &&
              _pageController.page?.round() != currentStep) {
            _pageController.animateToPage(
              currentStep,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
      },
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          // Load fitness goals when the screen initializes
          if (state is OnboardingInitial) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<OnboardingBloc>().add(LoadFitnessGoals());
            });
          }

          // Get current step for progress header
          int currentStep = 0;
          if (state is OnboardingLoaded) {
            currentStep = state.currentStep;
          } else if (_pageController.hasClients) {
            // Fallback to page controller if BLoC state is not ready
            currentStep = _pageController.page?.round() ?? 0;
          }

          return Scaffold(
            backgroundColor: AppColors.primaryBackground,
            body: SafeArea(
              child: Column(
                children: [
                  // Progress Header - stays at top and updates with current step
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ProgressHeader(
                      currentStep: currentStep + 1,
                      totalSteps: 10,
                      onBackPressed: _onBackPressed,
                    ),
                  ),

                  // PageView for onboarding steps
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      children: [
                        // Step 1: Personal Information
                        const PersonalInfoStep(),

                        // Step 2: Fitness Goals
                        const FitnessGoalsStep(),

                        // Step 3: Training Location
                        const TrainingLocationStep(),

                        // Step 4: Training Routine
                        const TrainingRoutineStep(),

                        // Step 5: Body Profile
                        const BodyProfileStep(),

                        // Step 6: Experience Level
                        const SimpleStep(
                          title: "What's your experience level?",
                          description: "Are you a beginner or experienced?",
                          icon: Icons.trending_up,
                        ),

                        // Step 7: Available Time
                        const SimpleStep(
                          title: "How much time do you have?",
                          description:
                              "What's your daily workout time availability?",
                          icon: Icons.access_time,
                        ),

                        // Step 8: Equipment Access
                        const SimpleStep(
                          title: "What equipment do you have access to?",
                          description: "Tell us about your available resources",
                          icon: Icons.fitness_center,
                        ),

                        // Step 9: Health Information
                        const SimpleStep(
                          title: "Any health considerations?",
                          description:
                              "Let us know about any medical conditions",
                          icon: Icons.health_and_safety,
                        ),

                        // Step 10: Review & Complete
                        SimpleStep(
                          title: "Review your information",
                          description: "Let's make sure everything is correct",
                          icon: Icons.check_circle,
                          buttonText: 'Complete Setup',
                          onButtonPressed: () {
                            // Handle completion
                            // You can add completion logic here
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
