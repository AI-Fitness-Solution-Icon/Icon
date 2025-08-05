import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_print.dart';
import '../../../core/services/settings_service.dart';
import '../../../core/widgets/back_button_widget.dart';


/// Notification settings screen for managing notification preferences
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  late final SettingsService _settingsService;
  
  bool _pushNotificationsEnabled = true;
  bool _emailNotificationsEnabled = true;
  bool _workoutRemindersEnabled = true;
  bool _achievementNotificationsEnabled = true;
  bool _weeklyReportsEnabled = true;
  bool _promotionalNotificationsEnabled = false;
  bool _isLoading = false;
  
  // Time picker state
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    super.initState();
    _settingsService = SettingsService();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      setState(() {
        _pushNotificationsEnabled = _settingsService.notificationEnabled;
        _workoutRemindersEnabled = _settingsService.workoutReminders;
        _achievementNotificationsEnabled = _settingsService.progressUpdates;
        _weeklyReportsEnabled = _settingsService.motivationalMessages;
        
        // Load quiet hours
        final startTime = _settingsService.quietHoursStart;
        final endTime = _settingsService.quietHoursEnd;
        
        _quietHoursStart = _parseTimeString(startTime);
        _quietHoursEnd = _parseTimeString(endTime);
      });
    } catch (e) {
      AppPrint.printError('Failed to load settings: $e');
    }
  }

  TimeOfDay _parseTimeString(String timeString) {
    final parts = timeString.split(':');
    if (parts.length == 2) {
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      return TimeOfDay(hour: hour, minute: minute);
    }
    return const TimeOfDay(hour: 22, minute: 0);
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(fallbackRoute: '/settings'),
        title: const Text('Notification Settings'),
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

            // General Notifications
            _buildSectionHeader('General Notifications'),
            _buildSwitchTile(
              icon: Icons.notifications,
              title: 'Push Notifications',
              subtitle: 'Receive notifications on your device',
              value: _pushNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _pushNotificationsEnabled = value;
                });
                _saveSettings();
              },
            ),
            _buildSwitchTile(
              icon: Icons.email,
              title: 'Email Notifications',
              subtitle: 'Receive notifications via email',
              value: _emailNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _emailNotificationsEnabled = value;
                });
                _saveSettings();
              },
            ),
            const SizedBox(height: 24),

            // Workout Notifications
            _buildSectionHeader('Workout Notifications'),
            _buildSwitchTile(
              icon: Icons.fitness_center,
              title: 'Workout Reminders',
              subtitle: 'Get reminded about scheduled workouts',
              value: _workoutRemindersEnabled,
              onChanged: (value) {
                setState(() {
                  _workoutRemindersEnabled = value;
                });
                _saveSettings();
              },
            ),
            _buildSwitchTile(
              icon: Icons.emoji_events,
              title: 'Achievement Notifications',
              subtitle: 'Celebrate your fitness achievements',
              value: _achievementNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _achievementNotificationsEnabled = value;
                });
                _saveSettings();
              },
            ),
            const SizedBox(height: 24),

            // Reports and Analytics
            _buildSectionHeader('Reports & Analytics'),
            _buildSwitchTile(
              icon: Icons.analytics,
              title: 'Weekly Progress Reports',
              subtitle: 'Receive weekly fitness progress summaries',
              value: _weeklyReportsEnabled,
              onChanged: (value) {
                setState(() {
                  _weeklyReportsEnabled = value;
                });
                _saveSettings();
              },
            ),
            const SizedBox(height: 24),

            // Promotional Notifications
            _buildSectionHeader('Promotional'),
            _buildSwitchTile(
              icon: Icons.local_offer,
              title: 'Promotional Notifications',
              subtitle: 'Receive offers and promotions',
              value: _promotionalNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _promotionalNotificationsEnabled = value;
                });
                _saveSettings();
              },
            ),
            const SizedBox(height: 24),

            // Notification Schedule
            _buildSectionHeader('Notification Schedule'),
            _buildScheduleCard(),
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
              Icons.notifications_active,
              color: AppColors.primary,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notification Preferences',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Customize how and when you receive notifications',
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

  Widget _buildScheduleCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Quiet Hours',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Set times when you don\'t want to receive notifications',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTimePicker(
                    label: 'Start Time',
                    time: _quietHoursStart,
                    onChanged: (time) {
                      setState(() {
                        _quietHoursStart = time;
                      });
                      _saveSettings();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimePicker(
                    label: 'End Time',
                    time: _quietHoursEnd,
                    onChanged: (time) {
                      setState(() {
                        _quietHoursEnd = time;
                      });
                      _saveSettings();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker({
    required String label,
    required TimeOfDay time,
    required ValueChanged<TimeOfDay> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final selectedTime = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (selectedTime != null) {
              onChanged(selectedTime);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 16),
                ),
                const Icon(Icons.access_time, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveSettings() async {
    try {
      await _settingsService.saveNotificationSettings(
        notificationEnabled: _pushNotificationsEnabled,
        workoutReminders: _workoutRemindersEnabled,
        progressUpdates: _achievementNotificationsEnabled,
        motivationalMessages: _weeklyReportsEnabled,
        quietHoursEnabled: true, // Always enabled for now
        quietHoursStart: _formatTimeOfDay(_quietHoursStart),
        quietHoursEnd: _formatTimeOfDay(_quietHoursEnd),
      );
      
      AppPrint.printInfo('Notification settings saved successfully');
    } catch (e) {
      AppPrint.printError('Failed to save notification settings: $e');
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
      await _settingsService.saveNotificationSettings(
        notificationEnabled: _pushNotificationsEnabled,
        workoutReminders: _workoutRemindersEnabled,
        progressUpdates: _achievementNotificationsEnabled,
        motivationalMessages: _weeklyReportsEnabled,
        quietHoursEnabled: true, // Always enabled for now
        quietHoursStart: _formatTimeOfDay(_quietHoursStart),
        quietHoursEnd: _formatTimeOfDay(_quietHoursEnd),
      );
      
      AppPrint.printInfo('All notification settings saved successfully');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification settings saved successfully!'),
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