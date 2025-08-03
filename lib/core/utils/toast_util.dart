import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'app_print.dart';

/// Utility class for showing toast messages
class ToastUtil {
  static OverlayEntry? _currentToast;
  static bool _isShowing = false;

  /// Show a success toast message
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showToast(
      context,
      message,
      type: ToastType.success,
      duration: duration,
    );
  }

  /// Show an error toast message
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    _showToast(
      context,
      message,
      type: ToastType.error,
      duration: duration,
    );
  }

  /// Show a warning toast message
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showToast(
      context,
      message,
      type: ToastType.warning,
      duration: duration,
    );
  }

  /// Show an info toast message
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showToast(
      context,
      message,
      type: ToastType.info,
      duration: duration,
    );
  }

  /// Show a progress toast message
  static void showProgress(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    _showToast(
      context,
      message,
      type: ToastType.progress,
      duration: duration,
    );
  }

  /// Show a custom toast message
  static void showCustom(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showToast(
      context,
      message,
      type: ToastType.custom,
      duration: duration,
      backgroundColor: backgroundColor,
      textColor: textColor,
      icon: icon,
    );
  }

  /// Hide the current toast
  static void hide() {
    if (_isShowing && _currentToast != null) {
      _currentToast!.remove();
      _currentToast = null;
      _isShowing = false;
    }
  }

  /// Internal method to show toast
  static void _showToast(
    BuildContext context,
    String message, {
    required ToastType type,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
  }) {
    // Hide any existing toast
    hide();

    AppPrint.printInfo('Showing toast: $message (${type.name})');

    final overlay = Overlay.of(context);

    _currentToast = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: _buildToastWidget(
            message,
            type,
            backgroundColor,
            textColor,
            icon,
          ),
        ),
      ),
    );

    overlay.insert(_currentToast!);
    _isShowing = true;

    // Auto-hide after duration
    Future.delayed(duration, () {
      hide();
    });
  }

  /// Build the toast widget
  static Widget _buildToastWidget(
    String message,
    ToastType type,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
  ) {
    Color bgColor;
    Color txtColor;
    IconData toastIcon;

    switch (type) {
      case ToastType.success:
        bgColor = Colors.green;
        txtColor = Colors.white;
        toastIcon = Icons.check_circle;
        break;
      case ToastType.error:
        bgColor = Colors.red;
        txtColor = Colors.white;
        toastIcon = Icons.error;
        break;
      case ToastType.warning:
        bgColor = Colors.orange;
        txtColor = Colors.white;
        toastIcon = Icons.warning;
        break;
      case ToastType.info:
        bgColor = Colors.blue;
        txtColor = Colors.white;
        toastIcon = Icons.info;
        break;
      case ToastType.progress:
        bgColor = AppColors.primary;
        txtColor = Colors.white;
        toastIcon = Icons.hourglass_empty;
        break;
      case ToastType.custom:
        bgColor = backgroundColor ?? Colors.black87;
        txtColor = textColor ?? Colors.white;
        toastIcon = icon ?? Icons.message;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              toastIcon,
              color: txtColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: txtColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: hide,
              child: Icon(
                Icons.close,
                color: txtColor,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show a snackbar (fallback for complex cases)
  static void showSnackBar(
    BuildContext context,
    String message, {
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case ToastType.success:
        backgroundColor = Colors.green;
        textColor = Colors.white;
        break;
      case ToastType.error:
        backgroundColor = Colors.red;
        textColor = Colors.white;
        break;
      case ToastType.warning:
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        break;
      case ToastType.info:
        backgroundColor = Colors.blue;
        textColor = Colors.white;
        break;
      case ToastType.progress:
        backgroundColor = AppColors.primary;
        textColor = Colors.white;
        break;
      case ToastType.custom:
        backgroundColor = Colors.black87;
        textColor = Colors.white;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Toast message types
enum ToastType {
  success,
  error,
  warning,
  info,
  progress,
  custom,
} 