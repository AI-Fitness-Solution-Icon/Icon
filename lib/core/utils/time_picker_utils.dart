import 'package:flutter/material.dart';

/// Utility class for time picker functionality
class TimePickerUtils {
  /// Shows a time picker dialog and returns the selected time
  static Future<TimeOfDay?> showTimePickerDialog({
    required BuildContext context,
    required TimeOfDay initialTime,
    String? title,
    String? cancelText,
    String? confirmText,
    bool use24HourFormat = false,
  }) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              hourMinuteTextColor: Theme.of(context).primaryColor,
              hourMinuteColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              dayPeriodTextColor: Theme.of(context).primaryColor,
              dayPeriodColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              dialHandColor: Theme.of(context).primaryColor,
              dialBackgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              dialTextColor: Theme.of(context).primaryColor,
              entryModeIconColor: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
      cancelText: cancelText,
      confirmText: confirmText,
      helpText: title,
    );
  }

  /// Shows a time picker dialog with custom styling
  static Future<TimeOfDay?> showCustomTimePicker({
    required BuildContext context,
    required TimeOfDay initialTime,
    String? title,
    Color? primaryColor,
    bool use24HourFormat = false,
  }) async {
    final theme = Theme.of(context);
    final color = primaryColor ?? theme.primaryColor;
    
    return await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: theme.scaffoldBackgroundColor,
              hourMinuteTextColor: color,
              hourMinuteColor: color.withValues(alpha: 0.1),
              dayPeriodTextColor: color,
              dayPeriodColor: color.withValues(alpha: 0.1),
              dialHandColor: color,
              dialBackgroundColor: color.withValues(alpha: 0.1),
              dialTextColor: color,
              entryModeIconColor: color,
            ),
          ),
          child: child!,
        );
      },
      helpText: title,
    );
  }

  /// Shows a time picker dialog for workout reminder time
  static Future<TimeOfDay?> showWorkoutReminderTimePicker({
    required BuildContext context,
    required TimeOfDay initialTime,
  }) async {
    return await showTimePickerDialog(
      context: context,
      initialTime: initialTime,
      title: 'Set Workout Reminder Time',
      cancelText: 'Cancel',
      confirmText: 'Set',
    );
  }

  /// Shows a time picker dialog for quiet hours
  static Future<TimeOfDay?> showQuietHoursTimePicker({
    required BuildContext context,
    required TimeOfDay initialTime,
    required String label,
  }) async {
    return await showTimePickerDialog(
      context: context,
      initialTime: initialTime,
      title: 'Set $label Time',
      cancelText: 'Cancel',
      confirmText: 'Set',
    );
  }

  /// Shows a time picker dialog for meal reminder time
  static Future<TimeOfDay?> showMealReminderTimePicker({
    required BuildContext context,
    required TimeOfDay initialTime,
  }) async {
    return await showTimePickerDialog(
      context: context,
      initialTime: initialTime,
      title: 'Set Meal Reminder Time',
      cancelText: 'Cancel',
      confirmText: 'Set',
    );
  }

  /// Shows a time picker dialog for sleep tracking
  static Future<TimeOfDay?> showSleepTimePicker({
    required BuildContext context,
    required TimeOfDay initialTime,
    required String label,
  }) async {
    return await showTimePickerDialog(
      context: context,
      initialTime: initialTime,
      title: 'Set $label Time',
      cancelText: 'Cancel',
      confirmText: 'Set',
    );
  }

  /// Formats TimeOfDay to string (HH:MM format)
  static String formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Formats TimeOfDay to string with AM/PM
  static String formatTimeOfDay12Hour(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  /// Converts TimeOfDay to minutes since midnight
  static int timeOfDayToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  /// Converts minutes since midnight to TimeOfDay
  static TimeOfDay minutesToTimeOfDay(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return TimeOfDay(hour: hours, minute: mins);
  }

  /// Validates if a time is within a range
  static bool isTimeInRange(TimeOfDay time, TimeOfDay start, TimeOfDay end) {
    final timeMinutes = timeOfDayToMinutes(time);
    final startMinutes = timeOfDayToMinutes(start);
    final endMinutes = timeOfDayToMinutes(end);
    
    if (startMinutes <= endMinutes) {
      return timeMinutes >= startMinutes && timeMinutes <= endMinutes;
    } else {
      // Handles cases where range crosses midnight
      return timeMinutes >= startMinutes || timeMinutes <= endMinutes;
    }
  }

  /// Gets the duration between two times
  static Duration getDurationBetween(TimeOfDay start, TimeOfDay end) {
    final startMinutes = timeOfDayToMinutes(start);
    final endMinutes = timeOfDayToMinutes(end);
    
    int durationMinutes;
    if (endMinutes >= startMinutes) {
      durationMinutes = endMinutes - startMinutes;
    } else {
      // Handles cases where end time is on the next day
      durationMinutes = (24 * 60) - startMinutes + endMinutes;
    }
    
    return Duration(minutes: durationMinutes);
  }

  /// Creates a time picker widget with custom styling
  static Widget buildTimePickerWidget({
    required String label,
    required TimeOfDay time,
    required ValueChanged<TimeOfDay> onChanged,
    required BuildContext context,
    String? hintText,
    bool enabled = true,
    Color? borderColor,
    Color? textColor,
    double? width,
  }) {
    final theme = Theme.of(context);
    final color = borderColor ?? theme.primaryColor;
    final textColorFinal = textColor ?? theme.textTheme.bodyLarge?.color;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: textColorFinal,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: enabled ? () async {
            final selectedTime = await showTimePickerDialog(
              context: context,
              initialTime: time,
              title: 'Select $label',
            );
            if (selectedTime != null) {
              onChanged(selectedTime);
            }
          } : null,
          child: Container(
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: enabled ? color : Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(4),
              color: enabled ? null : Colors.grey[100],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatTimeOfDay(time),
                  style: TextStyle(
                    fontSize: 16,
                    color: enabled ? textColorFinal : Colors.grey[600],
                  ),
                ),
                Icon(
                  Icons.access_time,
                  size: 20,
                  color: enabled ? color : Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
        if (hintText != null) ...[
          const SizedBox(height: 4),
          Text(
            hintText,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }
} 