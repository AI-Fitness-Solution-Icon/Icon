import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Reusable info card component for onboarding prompts
/// Shows an icon, title, and description in a styled card
class InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData? icon;
  final Widget? customIcon;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const InfoCard({
    super.key,
    required this.title,
    required this.description,
    this.icon,
    this.customIcon,
    this.padding,
    this.borderRadius,
  }) : assert(icon == null || customIcon == null, 'Cannot provide both icon and customIcon');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.secondary,
                width: 2,
              ),
            ),
            child: Center(
              child: customIcon ?? Icon(
                icon ?? Icons.person_outline,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 