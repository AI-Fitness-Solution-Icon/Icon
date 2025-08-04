import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/muscle_group.dart';

/// Anatomical models section showing body views with highlighted muscle groups
class AnatomicalModels extends StatelessWidget {
  final List<MuscleGroup> muscleGroups;
  final DateTime selectedDate;

  const AnatomicalModels({
    super.key,
    required this.muscleGroups,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Body Overview',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  child: _buildBodyView(
                    title: 'Front',
                    icon: Icons.person,
                    muscleGroups: muscleGroups.where((m) => m.view == BodyView.front).toList(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildBodyView(
                    title: 'Back',
                    icon: Icons.person_outline,
                    muscleGroups: muscleGroups.where((m) => m.view == BodyView.back).toList(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildBodyView(
                    title: 'Systems',
                    icon: Icons.favorite,
                    muscleGroups: muscleGroups.where((m) => m.view == BodyView.internal).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyView({
    required String title,
    required IconData icon,
    required List<MuscleGroup> muscleGroups,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Base body outline
                Icon(
                  icon,
                  size: 80,
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                ),
                // Highlighted muscle groups
                ...muscleGroups.map((muscle) => _buildMuscleHighlight(muscle)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${muscleGroups.length} groups',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMuscleHighlight(MuscleGroup muscle) {
    return Positioned(
      left: muscle.position.dx,
      top: muscle.position.dy,
      child: Container(
        width: muscle.size.width,
        height: muscle.size.height,
        decoration: BoxDecoration(
          color: muscle.color.withValues(alpha: 0.6),
          shape: BoxShape.circle,
          border: Border.all(
            color: muscle.color,
            width: 2,
          ),
        ),
      ),
    );
  }
} 