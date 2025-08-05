import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_print.dart';
import '../../../core/services/settings_service.dart';
import '../../../core/widgets/back_button_widget.dart';
import '../../../navigation/route_names.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';

import '../bloc/settings_bloc.dart';

/// Settings screen for app settings management
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsService _settingsService;
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  Future<void> _initializeSettings() async {
    _settingsService = SettingsService();
    _settingsBloc = SettingsBloc(_settingsService);
    _settingsBloc.add(LoadSettings());
  }

  @override
  void dispose() {
    _settingsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(fallbackRoute: RouteNames.homePath),
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Unauthenticated) {
                AppPrint.printInfo('User signed out successfully');
                context.go(RouteNames.loginPath);
              } else if (state is AuthError) {
                AppPrint.printError('Sign out failed: ${state.message}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<SettingsBloc, SettingsState>(
            listener: (context, state) {
              if (state is SettingsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          bloc: _settingsBloc,
          builder: (context, state) {
            if (state is SettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final settings = state is SettingsLoaded ? state : null;
            
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Profile Section
                _buildSectionHeader('Profile'),
                _buildListTile(
                  icon: Icons.person,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () => context.go('/profile'),
                ),
                _buildListTile(
                  icon: Icons.fitness_center,
                  title: 'Fitness Goals',
                  subtitle: 'Set and track your fitness objectives',
                  onTap: () => _navigateToFitnessGoals(context),
                ),
                const SizedBox(height: 24),

                // App Settings Section
                _buildSectionHeader('App Settings'),
                _buildSwitchTile(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  subtitle: 'Switch between light and dark themes',
                  value: settings?.isDarkMode ?? false,
                  onChanged: (value) => _toggleDarkMode(value),
                ),
                _buildSwitchTile(
                  icon: Icons.notifications,
                  title: 'Push Notifications',
                  subtitle: 'Receive workout reminders and updates',
                  value: settings?.notificationsEnabled ?? true,
                  onChanged: (value) => _toggleNotifications(value),
                ),
                _buildSwitchTile(
                  icon: Icons.volume_up,
                  title: 'Sound Effects',
                  subtitle: 'Play sounds during workouts',
                  value: settings?.soundEnabled ?? true,
                  onChanged: (value) => _toggleSound(value),
                ),
                _buildSwitchTile(
                  icon: Icons.vibration,
                  title: 'Vibration',
                  subtitle: 'Vibrate on workout events',
                  value: settings?.vibrationEnabled ?? true,
                  onChanged: (value) => _toggleVibration(value),
                ),
                const SizedBox(height: 24),

                // Subscription Section
                _buildSectionHeader('Subscription'),
                _buildListTile(
                  icon: Icons.card_membership,
                  title: 'Manage Subscription',
                  subtitle: 'View and modify your subscription plan',
                  onTap: () => context.go('/subscription'),
                ),
                _buildListTile(
                  icon: Icons.payment,
                  title: 'Payment History',
                  subtitle: 'View your payment transactions',
                  onTap: () => _navigateToPaymentHistory(context),
                ),
                const SizedBox(height: 24),

                // Support Section
                _buildSectionHeader('Support'),
                _buildListTile(
                  icon: Icons.help,
                  title: 'Help & FAQ',
                  subtitle: 'Get help and find answers',
                  onTap: () => _navigateToHelp(context),
                ),
                _buildListTile(
                  icon: Icons.feedback,
                  title: 'Send Feedback',
                  subtitle: 'Share your thoughts with us',
                  onTap: () => _openFeedbackForm(context),
                ),
                _buildListTile(
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  onTap: () => _openPrivacyPolicy(context),
                ),
                _buildListTile(
                  icon: Icons.description,
                  title: 'Terms of Service',
                  subtitle: 'Read our terms of service',
                  onTap: () => _openTermsOfService(context),
                ),
                const SizedBox(height: 24),

                // Account Section
                _buildSectionHeader('Account'),
                _buildListTile(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  subtitle: 'Sign out of your account',
                  onTap: () => _showSignOutDialog(context),
                  textColor: Colors.red,
                ),
                const SizedBox(height: 24),

                // App Info
                _buildSectionHeader('App Info'),
                _buildListTile(
                  icon: Icons.info,
                  title: 'Version',
                  subtitle: '1.0.0',
                  onTap: null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    Color? textColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: textColor ?? AppColors.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
                  subtitle: Text(
            subtitle,
            style: TextStyle(
              color: textColor?.withValues(alpha: 0.7) ?? Colors.grey[600],
            ),
          ),
        trailing: onTap != null
            ? Icon(
                Icons.chevron_right,
                color: textColor ?? Colors.grey,
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.primary,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ),
    );
  }

  // Navigation methods
  void _navigateToFitnessGoals(BuildContext context) {
    context.push(RouteNames.fitnessGoalsSettingsPath);
  }

  void _navigateToPaymentHistory(BuildContext context) {
    context.push(RouteNames.paymentHistoryPath);
  }

  void _navigateToHelp(BuildContext context) {
    context.push(RouteNames.helpPath);
  }

  void _openFeedbackForm(BuildContext context) {
    context.push(RouteNames.feedbackPath);
  }

  void _openPrivacyPolicy(BuildContext context) {
    context.push('${RouteNames.webviewPath}?title=Privacy Policy&url=https://iconapp.com/privacy-policy');
  }

  void _openTermsOfService(BuildContext context) {
    context.push('${RouteNames.webviewPath}?title=Terms of Service&url=https://iconapp.com/terms-of-service');
  }

  // Settings toggle methods
  void _toggleDarkMode(bool value) {
    _settingsBloc.add(ToggleDarkMode(value));
    AppPrint.printInfo('Theme changed to: ${value ? 'Dark' : 'Light'}');
  }

  void _toggleNotifications(bool value) {
    _settingsBloc.add(ToggleNotifications(value));
    AppPrint.printInfo('Notifications ${value ? 'enabled' : 'disabled'}');
  }

  void _toggleSound(bool value) {
    _settingsBloc.add(ToggleSound(value));
    AppPrint.printInfo('Sound effects ${value ? 'enabled' : 'disabled'}');
  }

  void _toggleVibration(bool value) {
    _settingsBloc.add(ToggleVibration(value));
    AppPrint.printInfo('Vibration ${value ? 'enabled' : 'disabled'}');
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                context.read<AuthBloc>().add(const SignOutRequested());
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
} 