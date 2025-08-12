import 'package:flutter/material.dart';
import 'package:icon_app/core/constants/app_colors.dart';

/// Component for optional notes/additional information
/// Follows the established design patterns with proper styling
/// Now fully responsive to prevent overflow on any device
class OptionalNoteField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final int? maxLines;
  final int? maxLength;
  final bool isSmallScreen;

  const OptionalNoteField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
    this.maxLines = 3,
    this.maxLength = 200,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title with Icon
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.textSecondary,
              size: isSmallScreen ? 18 : 20,
            ),
            SizedBox(width: isSmallScreen ? 6 : 8),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "Optional - Add any additional information you'd like to share",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: isSmallScreen ? 10 : 12,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: isSmallScreen ? 12 : 16),

        // Text Area
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
            border: Border.all(color: AppColors.surfaceDark, width: 1),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: isSmallScreen ? 14 : 16,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: isSmallScreen ? 14 : 16,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              counterStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: isSmallScreen ? 10 : 12,
              ),
            ),
            onChanged: (value) {
              // Optional: Add any validation or state management here
            },
          ),
        ),

        // Character count indicator
        if (maxLength != null) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${controller.text.length}/$maxLength',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: isSmallScreen ? 10 : 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
