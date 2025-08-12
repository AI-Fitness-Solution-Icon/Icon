import 'package:flutter/material.dart';
import 'package:icon_app/core/constants/app_colors.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Body Metrics",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Share your current measurements (optional)",
          style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
        const SizedBox(height: 20),

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

        SizedBox(height: 14),

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

        const SizedBox(height: 14),

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
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),

        if (suffixWidget != null)
          Row(
            children: [
              Expanded(
                child: TextFormField(
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
              ),
              const SizedBox(width: 12),
              suffixWidget,
            ],
          )
        else
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
    return SizedBox(
      width: 70, // Adjusted width for inline layout
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        onChanged: onChanged,
        isExpanded: true, // Make dropdown fill the available width
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColors.textSecondary, fontSize: 9),
          filled: true,
          fillColor: AppColors.surfaceDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.secondary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        ),
        dropdownColor: AppColors.surfaceDark,
        style: TextStyle(color: AppColors.textLight, fontSize: 11),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.textSecondary,
          size: 16,
        ),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(
              option,
              style: TextStyle(color: AppColors.textLight, fontSize: 11),
              overflow: TextOverflow.ellipsis, // Handle text overflow
            ),
          );
        }).toList(),
      ),
    );
  }
}
