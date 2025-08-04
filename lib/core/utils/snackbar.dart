import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// SnackBar utility class for displaying different types of notifications
/// Matches the app's color scheme and provides consistent styling
class AppSnackBar {
  /// Shows a success snackbar with green styling
  /// [context] - BuildContext for showing the snackbar
  /// [content] - Widget to display in the snackbar
  /// [duration] - How long to show the snackbar (default: 4 seconds)
  static void showSuccess(
    BuildContext context, {
    required Widget content,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnackBar(
      context: context,
      content: content,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline,
      duration: duration,
    );
  }

  /// Shows a danger/error snackbar with red styling
  /// [context] - BuildContext for showing the snackbar
  /// [content] - Widget to display in the snackbar
  /// [duration] - How long to show the snackbar (default: 4 seconds)
  static void showDanger(
    BuildContext context, {
    required Widget content,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnackBar(
      context: context,
      content: content,
      backgroundColor: const Color(0xFFE57373), // Softer red for better readability
      icon: Icons.error_outline,
      duration: duration,
    );
  }

  /// Shows an info snackbar with blue styling
  /// [context] - BuildContext for showing the snackbar
  /// [content] - Widget to display in the snackbar
  /// [duration] - How long to show the snackbar (default: 4 seconds)
  static void showInfo(
    BuildContext context, {
    required Widget content,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnackBar(
      context: context,
      content: content,
      backgroundColor: AppColors.info,
      icon: Icons.info_outline,
      duration: duration,
    );
  }

  /// Shows a warning snackbar with yellow/orange styling
  /// [context] - BuildContext for showing the snackbar
  /// [content] - Widget to display in the snackbar
  /// [duration] - How long to show the snackbar (default: 4 seconds)
  static void showWarning(
    BuildContext context, {
    required Widget content,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnackBar(
      context: context,
      content: content,
      backgroundColor: AppColors.warning,
      icon: Icons.warning_amber_outlined,
      duration: duration,
    );
  }

  /// Shows a primary snackbar with the app's primary color
  /// [context] - BuildContext for showing the snackbar
  /// [content] - Widget to display in the snackbar
  /// [duration] - How long to show the snackbar (default: 4 seconds)
  static void showPrimary(
    BuildContext context, {
    required Widget content,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnackBar(
      context: context,
      content: content,
      backgroundColor: AppColors.primary,
      icon: Icons.notifications_outlined,
      duration: duration,
    );
  }

  /// Shows a secondary snackbar with the app's secondary color (orange)
  /// [context] - BuildContext for showing the snackbar
  /// [content] - Widget to display in the snackbar
  /// [duration] - How long to show the snackbar (default: 4 seconds)
  static void showSecondary(
    BuildContext context, {
    required Widget content,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnackBar(
      context: context,
      content: content,
      backgroundColor: AppColors.secondary,
      icon: Icons.star_outline,
      duration: duration,
    );
  }

  /// Shows a custom snackbar with specified styling
  /// [context] - BuildContext for showing the snackbar
  /// [content] - Widget to display in the snackbar
  /// [backgroundColor] - Background color for the snackbar
  /// [icon] - Icon to display (optional)
  /// [duration] - How long to show the snackbar (default: 4 seconds)
  static void showCustom(
    BuildContext context, {
    required Widget content,
    required Color backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnackBar(
      context: context,
      content: content,
      backgroundColor: backgroundColor,
      icon: icon,
      duration: duration,
    );
  }

  /// Internal method to create and show the snackbar
  /// [context] - BuildContext for showing the snackbar
  /// [content] - Widget to display in the snackbar
  /// [backgroundColor] - Background color for the snackbar
  /// [icon] - Icon to display (optional)
  /// [duration] - How long to show the snackbar
  static void _showSnackBar({
    required BuildContext context,
    required Widget content,
    required Color backgroundColor,
    IconData? icon,
    required Duration duration,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: AppColors.textLight,
              size: 20,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(child: content),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(16),
      duration: duration,
      elevation: 8,
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: AppColors.textLight,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Hides the currently displayed snackbar
  /// [context] - BuildContext for hiding the snackbar
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  /// Shows a simple text-based success snackbar
  /// [context] - BuildContext for showing the snackbar
  /// [message] - Text message to display
  /// [duration] - How long to show the snackbar (default: 4 seconds)
  static void showSuccessText(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    showSuccess(
      context,
      content: Text(
        message,
        style: const TextStyle(
          color: AppColors.textLight,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      duration: duration,
    );
  }

  /// Shows a simple text-based danger snackbar
  /// [context] - BuildContext for showing the snackbar
  /// [message] - Text message to display
  /// [duration] - How long to show the snackbar (default: 4 seconds)
  static void showDangerText(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    showDanger(
      context,
      content: Text(
        message,
        style: const TextStyle(
          color: AppColors.textLight,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      duration: duration,
    );
  }

  /// Shows a simple text-based info snackbar
  /// [context] - BuildContext for showing the snackbar
  /// [message] - Text message to display
  /// [duration] - How long to show the snackbar (default: 4 seconds)
  static void showInfoText(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    showInfo(
      context,
      content: Text(
        message,
        style: const TextStyle(
          color: AppColors.textLight,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      duration: duration,
    );
  }

  /// Shows a simple text-based warning snackbar
  /// [context] - BuildContext for showing the snackbar
  /// [message] - Text message to display
  /// [duration] - How long to show the snackbar (default: 4 seconds)
  static void showWarningText(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    showWarning(
      context,
      content: Text(
        message,
        style: const TextStyle(
          color: AppColors.textLight,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      duration: duration,
    );
  }
} 