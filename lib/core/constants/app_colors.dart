import 'package:flutter/material.dart';

/// Color palette for the Icon app
/// Defines primary, secondary, and utility colors based on the design system
class AppColors {
  // Primary background color (from image)
  static const Color primaryBackground = Color(0xFF212E3E);
  
  // Primary colors
  static const Color primary = Color(0xFF3F4A5C);
  static const Color primaryDark = Color(0xFF212E3E);
  static const Color primaryLight = Color(0xFF57647B);
  
  // Secondary colors
  static const Color secondary = Color(0xFFFF9800); // Linear gradient orange
  static const Color secondaryDark = Color(0xFFF57C00);
  static const Color secondaryLight = Color(0xFFFFE0B2);
  
  // Background colors
  static const Color background = Color(0xFF212E3E); // Primary background
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF3E4754);
  
  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF); // White text on dark background
  static const Color textSecondary = Color(0xFF54637A);
  static const Color textLight = Color(0xFFFFFFFF);
  
  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Workout specific colors
  static const Color workoutCard = Color(0xFF3F4A5C);
  static const Color exerciseCard = Color(0xFF57647B);
  static const Color progressBar = Color(0xFF4CAF50);
  
  // Additional colors from the palette
  static const Color accentBlue = Color(0xFF3E4754);
  static const Color accentBlueLight = Color(0xFF54637A);
  static const Color transparent = Color(0x00D9D9D9); // 0% opacity
}

/// Extension on Color to add opacity manipulation
/// Uses withValues for efficient color modification
extension ColorExtension on Color {
  /// Adjusts the opacity of a color using withValues
  /// [opacity] should be between 0.0 and 1.0
  Color opacify(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0, 'Opacity must be between 0.0 and 1.0');
    return withValues(alpha: opacity);
  }
  
  /// Creates a lighter version of the color
  Color lighten(double amount) {
    assert(amount >= 0.0 && amount <= 1.0, 'Amount must be between 0.0 and 1.0');
    return withValues(
      red: (r + (255 - r) * amount) / 255,
      green: (g + (255 - g) * amount) / 255,
      blue: (b + (255 - b) * amount) / 255,
    );
  }
  
  /// Creates a darker version of the color
  Color darken(double amount) {
    assert(amount >= 0.0 && amount <= 1.0, 'Amount must be between 0.0 and 1.0');
    return withValues(
      red: (r * (1 - amount)) / 255,
      green: (g * (1 - amount)) / 255,
      blue: (b * (1 - amount)) / 255,
    );
  }
} 