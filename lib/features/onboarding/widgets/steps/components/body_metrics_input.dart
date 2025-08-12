import 'package:flutter/material.dart';
import 'package:icon_app/core/constants/app_colors.dart';

/// Component for collecting body metrics (weight, height, body fat)
/// Follows the established design patterns with proper unit selection
/// Now fully responsive to prevent overflow on any device
class BodyMetricsInput extends StatelessWidget {
  final TextEditingController weightController;
  final TextEditingController heightController;
  final TextEditingController bodyFatController;
  final String? selectedWeightUnit;
  final String? selectedHeightUnit;
  final String? selectedBodyFatMethod;
  final ValueChanged<String?> onWeightUnitChanged;
  final ValueChanged<String?> onHeightUnitChanged;
  final ValueChanged<String?> onBodyFatMethodChanged;
  final bool isSmallScreen;
  final bool isMediumScreen;

  const BodyMetricsInput({
    super.key,
    required this.weightController,
    required this.heightController,
    required this.bodyFatController,
    required this.selectedWeightUnit,
    required this.selectedHeightUnit,
    required this.selectedBodyFatMethod,
    required this.onWeightUnitChanged,
    required this.onHeightUnitChanged,
    required this.onBodyFatMethodChanged,
    required this.isSmallScreen,
    required this.isMediumScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          "Body Metrics",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 18 : 20,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Share your current measurements (optional)",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: isSmallScreen ? 11 : 13,
          ),
        ),
        const SizedBox(height: 20),

        // Weight Input with Unit Selection
        _buildMetricInput(
          context: context,
          label: "Weight",
          controller: weightController,
          hintText: "Enter weight",
          keyboardType: TextInputType.number,
          prefixIcon: Icons.monitor_weight_outlined,
          suffixWidget: _buildUnitSelector(
            context: context,
            selectedValue: selectedWeightUnit,
            options: const ['kg', 'lbs'],
            onChanged: onWeightUnitChanged,
            label: "Unit",
          ),
        ),

        SizedBox(height: isSmallScreen ? 14 : 20),

        _buildMetricInput(
          context: context,
          label: "Height",
          controller: heightController,
          hintText: "Enter height",
          keyboardType: TextInputType.number,
          prefixIcon: Icons.height_outlined,
          suffixWidget: _buildUnitSelector(
            context: context,
            selectedValue: selectedHeightUnit,
            options: const ['cm', 'ft'],
            onChanged: onHeightUnitChanged,
            label: "Unit",
          ),
        ),

        const SizedBox(width: 10),

        SizedBox(height: isSmallScreen ? 14 : 20),

        _buildMetricInput(
          context: context,
          label: "Body Fat %",
          controller: bodyFatController,
          hintText: "Enter body fat percentage",
          keyboardType: TextInputType.number,
          prefixIcon: Icons.pie_chart,
          suffixWidget: _buildUnitSelector(
            context: context,
            selectedValue: selectedBodyFatMethod,
            options: const ['DEXA', 'Calipers', 'Bioimpedance', 'Estimate'],
            onChanged: onBodyFatMethodChanged,

            label: "Method",
          ),
        ),
      ],
    );
  }

  Widget _buildMetricInput({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    required IconData prefixIcon,
    Widget? suffixWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: isSmallScreen ? 13 : 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),

        // Responsive layout: Stack vertically on small screens, horizontally on larger screens
        if (isSmallScreen) ...[
          // Vertical layout for small screens - prevents overflow
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: AppColors.textLight, fontSize: 15),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
              prefixIcon: Icon(
                prefixIcon,
                color: AppColors.textSecondary,
                size: 20,
              ),
              filled: true,
              fillColor: AppColors.surfaceDark,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.secondary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
            ),
          ),
          if (suffixWidget != null) ...[
            const SizedBox(height: 10),
            suffixWidget,
          ],
        ] else ...[
          // Horizontal layout for medium and large screens
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      prefixIcon,
                      color: AppColors.textSecondary,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceDark,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              if (suffixWidget != null) ...[
                const SizedBox(width: 12),
                suffixWidget,
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildUnitSelector({
    required BuildContext context,
    required String? selectedValue,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    required String label,
  }) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: isSmallScreen ? 9 : 11,
          ),
          filled: true,
          fillColor: AppColors.surfaceDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
            borderSide: const BorderSide(color: AppColors.secondary, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 6 : 8,
            vertical: isSmallScreen ? 12 : 14,
          ),
        ),
        dropdownColor: AppColors.surfaceDark,
        style: TextStyle(
          color: AppColors.textLight,
          fontSize: isSmallScreen ? 11 : 13,
        ),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.textSecondary,
          size: isSmallScreen ? 16 : 18,
        ),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(
              option,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: isSmallScreen ? 11 : 13,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
