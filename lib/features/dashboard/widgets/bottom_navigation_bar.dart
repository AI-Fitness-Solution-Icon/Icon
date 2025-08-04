import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../navigation/route_names.dart';

/// Custom bottom navigation bar for the dashboard
class DashboardBottomNavigationBar extends StatelessWidget {
  const DashboardBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context: context,
            icon: Icons.home,
            label: 'Home',
            isSelected: true, // Home is selected by default
            onTap: () => context.go(RouteNames.homePath),
          ),
          _buildNavItem(
            context: context,
            icon: Icons.bar_chart,
            label: 'Progress',
            isSelected: false,
            onTap: () => context.go(RouteNames.workoutPath),
          ),
          _buildNavItem(
            context: context,
            icon: Icons.fitness_center,
            label: 'Workout',
            isSelected: false,
            onTap: () => context.go(RouteNames.workoutPath),
          ),
          _buildNavItem(
            context: context,
            icon: Icons.group,
            label: 'Community',
            isSelected: false,
            hasNotification: true, // Show notification dot
            onTap: () => context.go('/community'),
          ),
          _buildNavItem(
            context: context,
            icon: Icons.person,
            label: 'Profile',
            isSelected: false,
            onTap: () => context.go(RouteNames.profilePath),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    bool hasNotification = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textLight,
                size: 24,
              ),
              if (hasNotification)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
} 