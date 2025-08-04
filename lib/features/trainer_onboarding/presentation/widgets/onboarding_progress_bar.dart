import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Progress bar widget for trainer onboarding
class OnboardingProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double progressPercentage;

  const OnboardingProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.progressPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Step indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step $currentStep of $totalSteps',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(progressPercentage * 100).toInt()}%',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Progress bar
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progressPercentage,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 