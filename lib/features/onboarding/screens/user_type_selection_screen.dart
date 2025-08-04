import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../navigation/route_names.dart';
import '../../../core/services/settings_service.dart';

/// Screen for users to select their type (Trainer or Get Fit)
class UserTypeSelectionScreen extends StatelessWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              
              // Header
              Text(
                'Welcome to Icon',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              Text(
                'Choose your journey',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 80),
              
              // Trainer Option
              _buildUserTypeCard(
                context: context,
                title: 'I\'m a Trainer',
                subtitle: 'Create workouts and manage clients',
                icon: Icons.fitness_center,
                color: AppColors.secondary,
                onTap: () => _handleTrainerSelection(context),
              ),
              const SizedBox(height: 24),
              
              // Get Fit Option
              _buildUserTypeCard(
                context: context,
                title: 'I want to get Fit',
                subtitle: 'Follow workouts and track progress',
                icon: Icons.person,
                color: AppColors.primary,
                onTap: () => _handleGetFitSelection(context),
              ),
              const SizedBox(height: 40),
              
              // Additional info
              Text(
                'You can change this later in settings',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),
            const SizedBox(width: 20),
            
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _handleTrainerSelection(BuildContext context) async {
    // Store user type preference
    final settingsService = SettingsService();
    await settingsService.setUserType('trainer');
    
    // Navigate to trainer onboarding
    if (context.mounted) {
      context.go(RouteNames.trainerOnboardingPath);
    }
  }

  void _handleGetFitSelection(BuildContext context) async {
    // Store user type preference
    final settingsService = SettingsService();
    await settingsService.setUserType('get_fit');
    
    // Navigate to signup with get fit context
    if (context.mounted) {
      context.go(RouteNames.signupPath);
    }
  }
} 