import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../navigation/route_names.dart';
import '../widgets/progress_header.dart';
import '../widgets/info_card.dart';
import '../widgets/primary_button.dart';

/// Step 5 of 5: Nutrition Goals Screen
class NutritionGoalsScreen extends StatefulWidget {
  const NutritionGoalsScreen({super.key});

  @override
  State<NutritionGoalsScreen> createState() => _NutritionGoalsScreenState();
}

class _NutritionGoalsScreenState extends State<NutritionGoalsScreen> {
  String? _selectedActivityLevel;
  String? _selectedSleepHours;
  bool _shouldNavigate = false;

  final List<String> _activityLevels = [
    'Sedentary (Office job, little exercise)',
    'Lightly Active (Light exercise 1-3 days/week)',
    'Moderately Active (Moderate exercise 3-5 days/week)',
    'Very Active (Hard exercise 6-7 days/week)',
    'Extremely Active (Very hard exercise, physical job)',
  ];

  final List<String> _sleepHours = [
    'Less than 6 hours',
    '6-8 hours',
    '8-10 hours',
    'More than 10 hours',
  ];

  @override
  Widget build(BuildContext context) {
    if (_shouldNavigate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go(RouteNames.homePath);
        }
      });
    }
    
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProgressHeader(
                currentStep: 5,
                totalSteps: 5,
                onBackPressed: () => context.pop(),
              ),
              const SizedBox(height: 32),
              InfoCard(
                title: "Let's personalize your experience",
                description: "This helps us create a more tailored plan for you",
                icon: Icons.restaurant,
              ),
              const SizedBox(height: 40),
              _buildActivityLevelSelection(),
              const SizedBox(height: 32),
              _buildSleepSelection(),
              const Spacer(),
              PrimaryButton(
                text: 'Complete Setup',
                onPressed: _canComplete() ? _onComplete : null,
                isEnabled: _canComplete(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityLevelSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Level Outside of Training',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...(_activityLevels.asMap().entries.map((entry) {
          final activity = entry.value;
          final isSelected = _selectedActivityLevel == activity;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedActivityLevel = activity),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? Colors.white : AppColors.textSecondary.withValues(alpha: 0.3),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, size: 14, color: AppColors.primary)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        activity,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textLight,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList()),
      ],
    );
  }

  Widget _buildSleepSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Average Sleep Per Night',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _sleepHours.map((hours) {
            final isSelected = _selectedSleepHours == hours;
            return GestureDetector(
              onTap: () => setState(() => _selectedSleepHours = hours),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.secondary : AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? AppColors.secondary : AppColors.textSecondary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  hours,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textLight,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  bool _canComplete() {
    return _selectedActivityLevel != null && _selectedSleepHours != null;
  }

  void _onComplete() {
    setState(() => _shouldNavigate = true);
  }
}
