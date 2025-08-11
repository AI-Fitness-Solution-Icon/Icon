import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_app/core/constants/app_colors.dart';
import 'package:icon_app/features/onboarding/widgets/info_card.dart';
import 'package:icon_app/features/onboarding/widgets/primary_button.dart';
import 'package:icon_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:icon_app/features/onboarding/bloc/onboarding_bloc_impl.dart';
import 'package:icon_app/core/models/fitness_main_goal.dart';

/// Step 2: Fitness Goals Step Widget
class FitnessGoalsStep extends StatelessWidget {
  const FitnessGoalsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingLoaded) {
          return _buildContent(context, state);
        }

        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, OnboardingLoaded state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Animated Info Card
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: InfoCard(
                      title: "Nice to meet you!",
                      description:
                          "What's your main fitness goal right now, and how experienced are you? Remember - there are no wrong answers!",
                      icon: Icons.fitness_center,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // Main Goal Section with staggered animation
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "What's your main goal?",
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 20),
                        _buildGoalSelectionArea(context, state),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // Experience Level Section with staggered animation
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "How experienced are you?",
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 20),
                        _buildExperienceButtons(context, state),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // Optional Details Section with staggered animation
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1000),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Want to tell us more about your goal? (Optional)",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 16),
                        _buildOptionalDetailsField(context, state),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // Animated Continue Button
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1200),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * value),
                  child: Opacity(
                    opacity: value,
                    child: PrimaryButton(
                      text: 'Continue',
                      onPressed: state.data.selectedGoalIds.isNotEmpty
                          ? () => context.read<OnboardingBloc>().add(NextStep())
                          : null,
                      isEnabled: state.data.selectedGoalIds.isNotEmpty,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40), // Bottom padding for scrollable content
          ],
        ),
      ),
    );
  }

  /// Build the goal selection area with loading state and error handling
  Widget _buildGoalSelectionArea(BuildContext context, OnboardingLoaded state) {
    if (state.isLoadingGoals) {
      return _buildGoalsLoadingState();
    }

    if (state.goalsError != null) {
      return _buildGoalsErrorState(context, state);
    }

    if (state.availableGoals.isEmpty) {
      return _buildNoGoalsState();
    }

    return _buildGoalsWidget(context, state);
  }

  /// Build loading state for goals
  Widget _buildGoalsLoadingState() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
            ),
            SizedBox(height: 16),
            Text(
              'Loading fitness goals...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  /// Build error state for goals
  Widget _buildGoalsErrorState(BuildContext context, OnboardingLoaded state) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red, width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 32),
            const SizedBox(height: 8),
            Text(
              'Failed to load goals',
              style: TextStyle(color: Colors.red[300], fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () =>
                  context.read<OnboardingBloc>().add(LoadFitnessGoals()),
              child: const Text(
                'Retry',
                style: TextStyle(color: AppColors.secondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build no goals state
  Widget _buildNoGoalsState() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!, width: 1),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center_outlined, color: Colors.grey, size: 32),
            SizedBox(height: 8),
            Text(
              'No fitness goals available',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the goals grid
  Widget _buildGoalsWidget(BuildContext context, OnboardingLoaded state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate optimal item width for uniform appearance
        final double availableWidth =
            constraints.maxWidth - 24; // Account for padding
        final double itemWidth =
            (availableWidth - 24) / 2; // 2 items per row with spacing

        return Column(
          children: [
            // Header text
            Text(
              'Select one or more goals that resonate with you:',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Goals grid
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: List.generate(state.availableGoals.length, (index) {
                final goal = state.availableGoals[index];
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 300 + (index * 50)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: SizedBox(
                          width: itemWidth,
                          child: _buildAnimatedGoalButton(
                            context,
                            goal,
                            index,
                            state,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedGoalButton(
    BuildContext context,
    FitnessMainGoal goal,
    int index,
    OnboardingLoaded state,
  ) {
    final isSelected = state.data.selectedGoalIds.contains(goal.id);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.secondary
            : AppColors.surfaceDark.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? AppColors.secondary
              : AppColors.textSecondary.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppColors.secondary.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: isSelected ? 8 : 4,
            offset: Offset(0, isSelected ? 4 : 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _toggleGoalSelection(context, goal.id, state),
          splashColor: AppColors.secondary.withValues(alpha: 0.2),
          highlightColor: AppColors.secondary.withValues(alpha: 0.1),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Goal icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.2)
                        : AppColors.textSecondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getGoalIcon(goal.name),
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    size: 24,
                  ),
                ),

                const SizedBox(height: 16),

                // Goal name
                Text(
                  goal.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textLight,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 16,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Selection indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: AppColors.secondary,
                          size: 14,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Get appropriate icon for each goal type
  IconData _getGoalIcon(String goalName) {
    final lowerGoal = goalName.toLowerCase();

    if (lowerGoal.contains('weight') || lowerGoal.contains('strength')) {
      return Icons.fitness_center;
    } else if (lowerGoal.contains('cardio') ||
        lowerGoal.contains('endurance')) {
      return Icons.directions_run;
    } else if (lowerGoal.contains('flexibility') ||
        lowerGoal.contains('mobility')) {
      return Icons.accessibility_new;
    } else if (lowerGoal.contains('weight loss') ||
        lowerGoal.contains('fat loss')) {
      return Icons.trending_down;
    } else if (lowerGoal.contains('muscle') || lowerGoal.contains('bulk')) {
      return Icons.trending_up;
    } else if (lowerGoal.contains('general') || lowerGoal.contains('overall')) {
      return Icons.health_and_safety;
    } else if (lowerGoal.contains('sport') ||
        lowerGoal.contains('performance')) {
      return Icons.emoji_events;
    } else if (lowerGoal.contains('recovery') ||
        lowerGoal.contains('wellness')) {
      return Icons.spa;
    } else {
      return Icons.fitness_center;
    }
  }

  void _toggleGoalSelection(
    BuildContext context,
    String goalId,
    OnboardingLoaded state,
  ) {
    final newSelectedGoals = Set<String>.from(state.data.selectedGoalIds);
    if (newSelectedGoals.contains(goalId)) {
      newSelectedGoals.remove(goalId);
    } else {
      newSelectedGoals.add(goalId);
    }

    context.read<OnboardingBloc>().add(UpdateFitnessGoals(newSelectedGoals));
  }

  // Experience level buttons with staggered animations
  Widget _buildExperienceButtons(BuildContext context, OnboardingLoaded state) {
    final experiences = [
      {
        'level': 'Beginner',
        'description': 'New to fitness or getting back into it',
        'icon': Icons.trending_up,
      },
      {
        'level': 'Intermediate',
        'description': 'Some experience with regular workouts',
        'icon': Icons.fitness_center,
      },
      {
        'level': 'Advanced',
        'description': 'Experienced with consistent training',
        'icon': Icons.emoji_events,
      },
    ];

    return Row(
      children: experiences.asMap().entries.map((entry) {
        final index = entry.key;
        final experience = entry.value;
        final isSelected = state.data.experienceLevel == experience['level'];

        return Expanded(
          child: TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 600 + (index * 200)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Padding(
                    padding: EdgeInsets.only(right: index < 2 ? 12 : 0),
                    child: _buildAnimatedExperienceButton(
                      context,
                      experience,
                      index,
                      isSelected,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAnimatedExperienceButton(
    BuildContext context,
    Map<String, dynamic> experience,
    int index,
    bool isSelected,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.secondary : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.secondary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.read<OnboardingBloc>().add(
            UpdateExperienceLevel(experience['level'] as String),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(
                  experience['icon'] as IconData,
                  color: isSelected ? Colors.white : AppColors.secondary,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  experience['level'] as String,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  experience['description'] as String,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Optional details text field with animation
  Widget _buildOptionalDetailsField(
    BuildContext context,
    OnboardingLoaded state,
  ) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[700]!, width: 1),
              ),
              child: TextField(
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText:
                      'Add any specific details about your fitness goals...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                onChanged: (value) => context.read<OnboardingBloc>().add(
                  UpdateOptionalDetails(value.isEmpty ? null : value),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
