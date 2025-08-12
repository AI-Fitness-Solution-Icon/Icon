import 'package:flutter/material.dart';
import 'package:icon_app/core/constants/app_colors.dart';

/// Component for selecting body type/profile
/// Uses a grid-based selection pattern similar to other onboarding steps
/// Now fully responsive to prevent overflow on any device
class BodyTypeSelection extends StatelessWidget {
  final String? selectedBodyType;
  final ValueChanged<String?> onBodyTypeChanged;
  final bool isSmallScreen;
  final bool isMediumScreen;

  const BodyTypeSelection({
    super.key,
    required this.selectedBodyType,
    required this.onBodyTypeChanged,
    required this.isSmallScreen,
    required this.isMediumScreen,
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
            fontSize: isSmallScreen ? 12 : 14,
          ),
        ),
        const SizedBox(height: 24),

        // Responsive Body Type Grid
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: isSmallScreen ? 160.0 : 200.0,
            maxHeight: isSmallScreen ? 240.0 : 300.0,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Adaptive grid based on screen size
              int crossAxisCount;
              double childAspectRatio;
              double spacing;

              if (isSmallScreen) {
                crossAxisCount = 2; // 2 columns for small screens
                childAspectRatio = 1.0;
                spacing = 8.0;
              } else if (isMediumScreen) {
                crossAxisCount = 3; // 3 columns for medium screens
                childAspectRatio = 1.1;
                spacing = 10.0;
              } else {
                crossAxisCount = 3; // 3 columns for large screens
                childAspectRatio = 1.2;
                spacing = 12.0;
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: _bodyTypes.length,
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
              );
            },
          ),
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
          borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
          border: isSelected
              ? Border.all(color: AppColors.secondary, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(
              bodyType.icon,
              color: isSelected ? Colors.white : AppColors.textSecondary,
              size: isSmallScreen ? 24 : 32,
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),

            // Title
            Text(
              bodyType.title,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textLight,
                fontSize: isSmallScreen ? 10 : 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Subtitle
            if (bodyType.subtitle != null) ...[
              SizedBox(height: isSmallScreen ? 2 : 4),
              Text(
                bodyType.subtitle!,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.8)
                      : AppColors.textSecondary,
                  fontSize: isSmallScreen ? 8 : 10,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Body type options with icons and descriptions
  static const List<BodyTypeOption> _bodyTypes = [
    BodyTypeOption(
      id: 'ectomorph',
      title: 'Ectomorph',
      subtitle: 'Naturally thin',
      icon: Icons.person_outline,
    ),
    BodyTypeOption(
      id: 'mesomorph',
      title: 'Mesomorph',
      subtitle: 'Athletic build',
      icon: Icons.fitness_center,
    ),
    BodyTypeOption(
      id: 'endomorph',
      title: 'Endomorph',
      subtitle: 'Naturally curvy',
      icon: Icons.person,
    ),
    BodyTypeOption(
      id: 'combination',
      title: 'Combination',
      subtitle: 'Mixed type',
      icon: Icons.person_2,
    ),
    BodyTypeOption(
      id: 'not_sure',
      title: 'Not Sure',
      subtitle: 'Skip for now',
      icon: Icons.help_outline,
    ),
    BodyTypeOption(
      id: 'prefer_not',
      title: 'Prefer Not',
      subtitle: 'Skip this',
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
