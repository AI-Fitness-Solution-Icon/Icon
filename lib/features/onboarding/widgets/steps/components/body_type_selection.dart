import 'package:flutter/material.dart';
import 'package:icon_app/core/constants/app_colors.dart';

/// Component for selecting body type/profile
/// Uses a list-based selection pattern for better responsiveness
/// Now fully responsive to prevent overflow on any device
class BodyTypeSelection extends StatelessWidget {
  final String? selectedBodyType;
  final ValueChanged<String?> onBodyTypeChanged;

  const BodyTypeSelection({
    super.key,
    required this.selectedBodyType,
    required this.onBodyTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          "Body Profile",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Select the body type that best describes you (optional)",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 24),

        // Body Type List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _bodyTypes.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final bodyType = _bodyTypes[index];
            final isSelected = selectedBodyType == bodyType.id;

            return _buildBodyTypeCard(
              context: context,
              bodyType: bodyType,
              isSelected: isSelected,
              onTap: () =>
                  onBodyTypeChanged(isSelected ? null : bodyType.id),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBodyTypeCard({
    required BuildContext context,
    required BodyTypeOption bodyType,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppColors.secondary, width: 2)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Colors.white.withValues(alpha: 0.2)
                      : AppColors.accentBlueLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    bodyType.icon,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bodyType.title,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textLight,
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      ),
                    ),
                    if (bodyType.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        bodyType.subtitle!,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.8)
                              : AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Selection Indicator
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.secondary,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Body type options with icons and descriptions
  static const List<BodyTypeOption> _bodyTypes = [
    BodyTypeOption(
      id: 'ectomorph',
      title: 'Ectomorph',
      subtitle: 'Naturally thin and lean build',
      icon: Icons.person_outline,
    ),
    BodyTypeOption(
      id: 'mesomorph',
      title: 'Mesomorph',
      subtitle: 'Athletic and muscular build',
      icon: Icons.fitness_center,
    ),
    BodyTypeOption(
      id: 'endomorph',
      title: 'Endomorph',
      subtitle: 'Naturally curvy and rounded build',
      icon: Icons.person,
    ),
    BodyTypeOption(
      id: 'combination',
      title: 'Combination',
      subtitle: 'Mixed body type characteristics',
      icon: Icons.person_2,
    ),
    BodyTypeOption(
      id: 'not_sure',
      title: 'Not Sure',
      subtitle: 'I\'ll figure this out later',
      icon: Icons.help_outline,
    ),
    BodyTypeOption(
      id: 'prefer_not',
      title: 'Prefer Not to Say',
      subtitle: 'I\'d rather skip this question',
      icon: Icons.block,
    ),
  ];
}

/// Data class for body type options
class BodyTypeOption {
  final String id;
  final String title;
  final String? subtitle;
  final IconData icon;

  const BodyTypeOption({
    required this.id,
    required this.title,
    this.subtitle,
    required this.icon,
  });
}
