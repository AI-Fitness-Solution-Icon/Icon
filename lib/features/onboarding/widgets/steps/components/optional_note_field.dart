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

  const OptionalNoteField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
    this.maxLines = 3,
    this.maxLength = 200,
  });

  @override
  Widget build(BuildContext context) {
    // Only small screen values are used, so all values are hardcoded for small screens
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title with Icon
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.textSecondary,
              size: 18, // small screen value
            ),
            SizedBox(width: 6), // small screen value
            Text(
              label,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14, // small screen value
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
            fontSize: 10, // small screen value
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: 12), // small screen value
        // Text Area
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(8), // small screen value
            border: Border.all(color: AppColors.surfaceDark, width: 1),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 14, // small screen value
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14, // small screen value
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12), // small screen value
              counterStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10, // small screen value
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
                fontSize: 10, // small screen value
              ),
            ),
          ),
        ],
      ],
    );
  }
}
