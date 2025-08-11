import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_app/core/constants/app_colors.dart';
import 'package:icon_app/features/onboarding/widgets/info_card.dart';
import 'package:icon_app/features/onboarding/widgets/primary_button.dart';
import 'package:icon_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:icon_app/features/onboarding/bloc/onboarding_bloc_impl.dart';

/// Step 3: Training Location Step Widget
class TrainingLocationStep extends StatefulWidget {
  const TrainingLocationStep({super.key});

  @override
  State<TrainingLocationStep> createState() => _TrainingLocationStepState();
}

class _TrainingLocationStepState extends State<TrainingLocationStep> {
  String? _selectedLocation;

  @override
  void initState() {
    super.initState();
    // Load existing selection if available
    final bloc = context.read<OnboardingBloc>();
    final currentData = bloc.getCurrentData();
    if (currentData?.trainingLocation != null) {
      _selectedLocation = currentData!.trainingLocation;
    }
  }

  void _onLocationSelected(String location) {
    setState(() {
      _selectedLocation = location;
    });

    // Update BLoC with the selection
    context.read<OnboardingBloc>().add(UpdateTrainingLocation(location));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Animated Info Card
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: InfoCard(
                          title: "Where do you usually train?",
                          description:
                              "We can tailor your plan to match your space",
                          icon: Icons.location_on,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Training Location Section with staggered animation
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
                              'Training Location',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 20),
                            _buildLocationOptions(),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Animated Continue Button
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.8 + (0.2 * value),
                      child: Opacity(
                        opacity: value,
                        child: PrimaryButton(
                          text: 'Continue',
                          onPressed: _selectedLocation != null
                              ? () => context.read<OnboardingBloc>().add(
                                  NextStep(),
                                )
                              : null,
                          isEnabled: _selectedLocation != null,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(
                  height: 40,
                ), // Bottom padding for scrollable content
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationOptions() {
    final locations = [
      {
        'id': 'gym',
        'title': 'Gym',
        'subtitle': 'Mix of gym and home workouts',
        'icon': Icons.fitness_center,
      },
      {
        'id': 'home',
        'title': 'Home',
        'subtitle': 'Mix of gym and home workouts',
        'icon': Icons.home,
      },
      {
        'id': 'both',
        'title': 'Both',
        'subtitle': 'Mix of gym and home workouts',
        'icon': Icons.swap_horiz,
      },
    ];

    return Row(
      children: locations.asMap().entries.map((entry) {
        final index = entry.key;
        final location = entry.value;
        final isSelected = _selectedLocation == location['id'];

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
                    child: _buildLocationButton(context, location, isSelected),
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLocationButton(
    BuildContext context,
    Map<String, dynamic> location,
    bool isSelected,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.secondary : AppColors.surfaceDark,
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
          onTap: () => _onLocationSelected(location['id'] as String),
          splashColor: AppColors.secondary.withValues(alpha: 0.2),
          highlightColor: AppColors.secondary.withValues(alpha: 0.1),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Location icon
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
                    location['icon'] as IconData,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    size: 24,
                  ),
                ),

                const SizedBox(height: 16),

                // Location title
                Text(
                  location['title'] as String,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textLight,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Location subtitle
                Text(
                  location['subtitle'] as String,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.8)
                        : AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

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
}
