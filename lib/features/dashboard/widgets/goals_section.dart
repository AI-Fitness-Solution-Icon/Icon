import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/goal.dart';
import '../models/progress.dart';

/// Goals section displaying metric cards with progress indicators
class GoalsSection extends StatelessWidget {
  final List<Goal> goals;
  final Progress progress;

  const GoalsSection({
    super.key,
    required this.goals,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Goals Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.primary.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(
                'Goals',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.list_alt,
                color: AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${goals.where((goal) => goal.isCompleted).length}/${goals.length}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Goals Cards
        Container(
          height: 200, // Fixed height to prevent overflow
          constraints: const BoxConstraints(maxHeight: 200), // Additional constraint
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4.0), // Add padding
            children: [
              _buildGoalCard(
                icon: Icons.build,
                title: 'Recovery Score',
                value: '${progress.recoveryScore}%',
                subtitle: 'Heart Rate',
                subtitleValue: '${progress.heartRate} bpm',
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B73FF), Color(0xFF000DFF)],
                ),
                progress: progress.recoveryScore / 100,
              ),
              const SizedBox(width: 12),
              _buildGoalCard(
                icon: Icons.apple,
                title: 'Calories Left',
                value: '${progress.caloriesLeft}',
                subtitle: 'Protein Left',
                subtitleValue: '${progress.proteinLeft}g',
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                ),
                progress: 1 - (progress.caloriesLeft / 2000), // Assuming 2000 daily goal
              ),
              const SizedBox(width: 12),
              _buildGoalCard(
                icon: Icons.fitness_center,
                title: 'Steps Left',
                value: '${progress.stepsLeft}',
                subtitle: 'Calories Burned',
                subtitleValue: '${progress.caloriesBurned}',
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                ),
                progress: 1 - (progress.stepsLeft / 10000), // Assuming 10k daily goal
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGoalCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required String subtitleValue,
    required Gradient gradient,
    required double progress,
  }) {
    return Container(
      width: 160,
      height: 180, // Fixed height to prevent overflow
      constraints: const BoxConstraints(maxHeight: 180), // Additional constraint
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Prevent overflow
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute content evenly
        children: [
          // Icon with progress ring
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 36, // Reduced size
                height: 36, // Reduced size
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              Icon(
                icon,
                color: Colors.white,
                size: 18, // Reduced size
              ),
            ],
          ),
          
          const SizedBox(height: 8), // Reduced spacing
          
          // Main value
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22, // Reduced font size
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis, // Prevent overflow
            maxLines: 1,
          ),
          
          // Title
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13, // Reduced font size
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis, // Prevent overflow
            maxLines: 1,
          ),
          
          const SizedBox(height: 6), // Reduced spacing
          
          // Subtitle
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11, // Reduced font size
            ),
            overflow: TextOverflow.ellipsis, // Prevent overflow
            maxLines: 1,
          ),
          
          // Subtitle value
          Text(
            subtitleValue,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14, // Reduced font size
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis, // Prevent overflow
            maxLines: 1,
          ),
        ],
      ),
    );
  }
} 