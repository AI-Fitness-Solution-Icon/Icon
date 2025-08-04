import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_challenge.dart';

/// Workout challenge card showing challenges from friends
class WorkoutChallengeCard extends StatelessWidget {
  final List<WorkoutChallenge> challenges;
  final Function(WorkoutChallenge) onAccept;
  final Function(WorkoutChallenge) onDismiss;

  const WorkoutChallengeCard({
    super.key,
    required this.challenges,
    required this.onAccept,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    if (challenges.isEmpty) return const SizedBox.shrink();

    final challenge = challenges.first; // Show the first challenge
    
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
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.secondary,
                  AppColors.primary,
                ],
              ),
            ),
            child: const Icon(
              Icons.person,
              color: AppColors.textLight,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Challenge Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${challenge.senderName} +${challenges.length - 1} others',
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'have sent you workout challenges',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Action Buttons
          Row(
            children: [
              // Dismiss Button
              GestureDetector(
                onTap: () => onDismiss(challenge),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.red,
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Accept Button
              GestureDetector(
                onTap: () => onAccept(challenge),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: AppColors.textLight,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 