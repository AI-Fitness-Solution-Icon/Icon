import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_print.dart';
import '../../../core/services/url_service.dart';
import '../../../core/services/settings_service.dart';
import '../../../core/services/data_service.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../auth/bloc/auth_event.dart';

/// Privacy settings screen for managing privacy and security preferences
class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _biometricAuthEnabled = false;
  bool _twoFactorAuthEnabled = false;
  bool _dataSharingEnabled = true;
  bool _analyticsEnabled = true;
  bool _locationServicesEnabled = true;
  bool _isLoading = false;
  
  late SettingsService _settingsService;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _settingsService = await SettingsService.create();
    
    setState(() {
      _biometricAuthEnabled = false; // Will be loaded from settings
      _twoFactorAuthEnabled = false; // Will be loaded from settings
      _dataSharingEnabled = true; // Will be loaded from settings
      _analyticsEnabled = true; // Will be loaded from settings
      _locationServicesEnabled = true; // Will be loaded from settings
    });

    // Load actual settings
    final biometricAuth = await _settingsService.isBiometricAuthEnabled();
    final twoFactorAuth = await _settingsService.isTwoFactorAuthEnabled();
    final dataSharing = await _settingsService.isDataSharingEnabled();
    final analytics = await _settingsService.isAnalyticsEnabled();
    final locationServices = await _settingsService.isLocationServicesEnabled();

    setState(() {
      _biometricAuthEnabled = biometricAuth;
      _twoFactorAuthEnabled = twoFactorAuth;
      _dataSharingEnabled = dataSharing;
      _analyticsEnabled = analytics;
      _locationServicesEnabled = locationServices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AccountDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account deleted successfully.'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to login screen
          context.go('/login');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Privacy & Security'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          actions: [
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: 24),

              // Security Settings
              _buildSectionHeader('Security'),
              _buildSwitchTile(
                icon: Icons.fingerprint,
                title: 'Biometric Authentication',
                subtitle: 'Use fingerprint or face ID to unlock the app',
                value: _biometricAuthEnabled,
                onChanged: (value) {
                  setState(() {
                    _biometricAuthEnabled = value;
                  });
                  _saveSettings();
                },
              ),
              _buildSwitchTile(
                icon: Icons.security,
                title: 'Two-Factor Authentication',
                subtitle: 'Add an extra layer of security to your account',
                value: _twoFactorAuthEnabled,
                onChanged: (value) {
                  setState(() {
                    _twoFactorAuthEnabled = value;
                  });
                  _saveSettings();
                },
              ),
              const SizedBox(height: 24),

              // Data Privacy
              _buildSectionHeader('Data Privacy'),
              _buildSwitchTile(
                icon: Icons.share,
                title: 'Data Sharing',
                subtitle: 'Allow sharing of anonymous fitness data for research',
                value: _dataSharingEnabled,
                onChanged: (value) {
                  setState(() {
                    _dataSharingEnabled = value;
                  });
                  _saveSettings();
                },
              ),
              _buildSwitchTile(
                icon: Icons.analytics,
                title: 'Analytics',
                subtitle: 'Help improve the app by sharing usage analytics',
                value: _analyticsEnabled,
                onChanged: (value) {
                  setState(() {
                    _analyticsEnabled = value;
                  });
                  _saveSettings();
                },
              ),
              const SizedBox(height: 24),

              // Location Services
              _buildSectionHeader('Location Services'),
              _buildSwitchTile(
                icon: Icons.location_on,
                title: 'Location Services',
                subtitle: 'Allow access to your location for workout tracking',
                value: _locationServicesEnabled,
                onChanged: (value) {
                  setState(() {
                    _locationServicesEnabled = value;
                  });
                  _saveSettings();
                },
              ),
              const SizedBox(height: 24),

              // Privacy Actions
              _buildSectionHeader('Privacy Actions'),
              _buildActionTile(
                icon: Icons.download,
                title: 'Download My Data',
                subtitle: 'Get a copy of all your personal data',
                onTap: () => _downloadData(),
              ),
              _buildActionTile(
                icon: Icons.delete_forever,
                title: 'Delete Account',
                subtitle: 'Permanently delete your account and all data',
                onTap: () => _showDeleteAccountDialog(),
                textColor: Colors.red,
              ),
              const SizedBox(height: 24),

              // Privacy Policy
              _buildSectionHeader('Legal'),
              _buildActionTile(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: () => _openPrivacyPolicy(),
              ),
              _buildActionTile(
                icon: Icons.description,
                title: 'Terms of Service',
                subtitle: 'Read our terms of service',
                onTap: () => _openTermsOfService(),
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveAllSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Save Settings',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.security,
              color: AppColors.primary,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy & Security',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Manage your privacy and security preferences',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
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

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
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
        trailing: Icon(
          Icons.chevron_right,
          color: textColor ?? Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }

  Future<void> _downloadData() async {
    try {
      AppPrint.printInfo('Downloading user data...');
      
      // Implement data download logic
      final success = await _dataService.downloadUserData();
      
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data download started. You will receive an email when ready.'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to start data download. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      AppPrint.printError('Failed to download data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    try {
      AppPrint.printInfo('Deleting account...');
      
      // Implement account deletion logic
      context.read<AuthBloc>().add(const DeleteAccountRequested());
      
    } catch (e) {
      AppPrint.printError('Failed to delete account: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete account: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _openPrivacyPolicy() {
    // Implement privacy policy navigation
    AppPrint.printInfo('Opening privacy policy...');
    UrlService.openPrivacyPolicy().then((success) {
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to open privacy policy. Please check your internet connection.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  void _openTermsOfService() {
    // Implement terms of service navigation
    AppPrint.printInfo('Opening terms of service...');
    UrlService.openTermsOfService().then((success) {
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to open terms of service. Please check your internet connection.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  Future<void> _saveSettings() async {
    // Implement settings save logic
    AppPrint.printInfo('Saving privacy settings...');
    
    try {
      await _settingsService.savePrivacySettings(
        biometricAuth: _biometricAuthEnabled,
        twoFactorAuth: _twoFactorAuthEnabled,
        dataSharing: _dataSharingEnabled,
        analytics: _analyticsEnabled,
        locationServices: _locationServicesEnabled,
      );
      
      AppPrint.printInfo('Privacy settings saved successfully');
    } catch (e) {
      AppPrint.printError('Failed to save privacy settings: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveAllSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Implement settings save logic
      AppPrint.printInfo('Saving all privacy settings...');
      
      await _settingsService.savePrivacySettings(
        biometricAuth: _biometricAuthEnabled,
        twoFactorAuth: _twoFactorAuthEnabled,
        dataSharing: _dataSharingEnabled,
        analytics: _analyticsEnabled,
        locationServices: _locationServicesEnabled,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Privacy settings saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      AppPrint.printError('Failed to save settings: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
} 