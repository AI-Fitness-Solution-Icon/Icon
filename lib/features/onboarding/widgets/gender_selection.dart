import 'package:flutter/material.dart';
import 'package:icon_app/core/constants/app_colors.dart';

/// Gender option for selection
enum Gender { male, female, others }

/// Reusable gender selection component for onboarding screens
class GenderSelection extends StatelessWidget {
  final Gender? selectedGender;
  final ValueChanged<Gender>? onGenderChanged;

  const GenderSelection({super.key, this.selectedGender, this.onGenderChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        const Text(
          'Gender',
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),

        // Gender options
        Row(
          children: Gender.values.map((gender) {
            final isSelected = selectedGender == gender;
            return Expanded(
              child: GestureDetector(
                onTap: () => onGenderChanged?.call(gender),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.secondary
                        : AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.secondary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    _getGenderText(gender),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getGenderText(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.others:
        return 'Others';
    }
  }
}
