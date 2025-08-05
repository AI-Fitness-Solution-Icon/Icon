import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../navigation/route_names.dart';
import '../widgets/progress_header.dart';
import '../widgets/info_card.dart';
import '../widgets/primary_button.dart';

/// Step 3 of 5: Training Location Screen
class TrainingLocationScreen extends StatefulWidget {
  const TrainingLocationScreen({super.key});

  @override
  State<TrainingLocationScreen> createState() => _TrainingLocationScreenState();
}

class _TrainingLocationScreenState extends State<TrainingLocationScreen> {
  String? _selectedLocation;
  final Set<String> _selectedEquipment = {};
  bool _shouldNavigate = false;

  final List<String> _trainingLocations = ['Gym', 'Home', 'Both'];
  final List<String> _equipmentOptions = [
    'Dumbbells', 'Barbell', 'Kettlebell', 'Resistance Band',
    'Pull-up Bar', 'Bench', 'Bodyweight Only', 'Cardio Equipment'
  ];

  @override
  Widget build(BuildContext context) {
    if (_shouldNavigate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go(RouteNames.trainingRoutinePath);
        }
      });
    }
    
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProgressHeader(
                currentStep: 3,
                totalSteps: 5,
                onBackPressed: () => context.pop(),
              ),
              const SizedBox(height: 32),
              InfoCard(
                title: "Where do you usually train?",
                description: "We can tailor your plan to match your space and equipment",
                icon: Icons.location_on,
              ),
              const SizedBox(height: 40),
              _buildLocationSelection(),
              const SizedBox(height: 32),
              _buildEquipmentSelection(),
              const Spacer(),
              PrimaryButton(
                text: 'Continue',
                onPressed: _selectedLocation != null ? _onContinue : null,
                isEnabled: _selectedLocation != null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Training Location',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: _trainingLocations.map((location) {
            final isSelected = _selectedLocation == location;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedLocation = location),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    location,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textLight,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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

  Widget _buildEquipmentSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What equipment do you have?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _equipmentOptions.map((equipment) {
            final isSelected = _selectedEquipment.contains(equipment);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedEquipment.remove(equipment);
                  } else {
                    _selectedEquipment.add(equipment);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.secondary : AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.secondary : AppColors.textSecondary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  equipment,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textLight,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _onContinue() {
    setState(() => _shouldNavigate = true);
  }
} 