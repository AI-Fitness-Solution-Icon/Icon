import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../navigation/route_names.dart';
import '../widgets/progress_header.dart';
import '../widgets/info_card.dart';
import '../widgets/primary_button.dart';

/// Step 4 of 5: Training Routine Screen
class TrainingRoutineScreen extends StatefulWidget {
  const TrainingRoutineScreen({super.key});

  @override
  State<TrainingRoutineScreen> createState() => _TrainingRoutineScreenState();
}

class _TrainingRoutineScreenState extends State<TrainingRoutineScreen> {
  String? _selectedDaysPerWeek;
  String? _selectedDuration;
  String? _selectedTime;
  TimeOfDay _preferredTime = const TimeOfDay(hour: 8, minute: 0);
  bool _shouldNavigate = false;

  final List<String> _daysPerWeek = ['1-2', '3-4', '5-6', 'Every day'];
  final List<String> _durations = ['15m', '30m', '45m', '60m', '90m', '90m+'];
  final List<String> _times = ['Morning', 'Midday', 'Evening'];

  @override
  Widget build(BuildContext context) {
    if (_shouldNavigate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go(RouteNames.nutritionGoalsPath);
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
                currentStep: 4,
                totalSteps: 5,
                onBackPressed: () => context.pop(),
              ),
              const SizedBox(height: 32),
              InfoCard(
                title: "Let's lock in your routine",
                description: "These questions will shape your training rhythm",
                icon: Icons.schedule,
              ),
              const SizedBox(height: 40),
              _buildDaysPerWeekSelection(),
              const SizedBox(height: 24),
              _buildDurationSelection(),
              const SizedBox(height: 24),
              _buildTimeSelection(),
              const Spacer(),
              PrimaryButton(
                text: 'Continue',
                onPressed: _canContinue() ? _onContinue : null,
                isEnabled: _canContinue(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDaysPerWeekSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How many days per week?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _daysPerWeek.map((days) {
            final isSelected = _selectedDaysPerWeek == days;
            return GestureDetector(
              onTap: () => setState(() => _selectedDaysPerWeek = days),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  days,
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

  Widget _buildDurationSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How long per session?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _durations.map((duration) {
            final isSelected = _selectedDuration == duration;
            return GestureDetector(
              onTap: () => setState(() => _selectedDuration = duration),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  duration,
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

  Widget _buildTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferred time to train?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We will remind you 15 minutes before (you can turn this off in settings)',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _times.map((time) {
            final isSelected = _selectedTime == time;
            return GestureDetector(
              onTap: () => setState(() => _selectedTime = time),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textLight,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _selectTime,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Text(
                  '${_preferredTime.hour.toString().padLeft(2, '0')}:${_preferredTime.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: AppColors.textLight, fontSize: 16),
                ),
                const Spacer(),
                const Icon(Icons.edit, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _preferredTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.secondary,
              onPrimary: Colors.white,
              surface: AppColors.surfaceDark,
              onSurface: AppColors.textLight,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _preferredTime = picked);
    }
  }

  bool _canContinue() {
    return _selectedDaysPerWeek != null && 
           _selectedDuration != null && 
           _selectedTime != null;
  }

  void _onContinue() {
    setState(() => _shouldNavigate = true);
  }
}
