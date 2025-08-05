import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../../navigation/route_names.dart';

/// Reusable back button widget for screens without bottom navigation
class BackButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? iconColor;
  final double? iconSize;
  final String? fallbackRoute;

  const BackButtonWidget({
    super.key,
    this.onPressed,
    this.iconColor,
    this.iconSize,
    this.fallbackRoute,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: iconColor ?? AppColors.textLight,
        size: iconSize ?? 24,
      ),
      onPressed: onPressed ?? () => _handleBackNavigation(context),
    );
  }

  void _handleBackNavigation(BuildContext context) {
    try {
      // Check if we can pop from the current route
      if (context.canPop()) {
        context.pop();
      } else {
        // If we can't pop, navigate to a fallback route
        final route = fallbackRoute ?? RouteNames.homePath;
        
        // Use go() instead of push() to avoid stack issues
        if (context.mounted) {
          context.go(route);
        }
      }
    } catch (e) {
      // If there's any error, navigate to home as a last resort
      if (context.mounted) {
        context.go(RouteNames.homePath);
      }
    }
  }
} 