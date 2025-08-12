import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_app/core/constants/app_colors.dart';
import 'package:icon_app/features/onboarding/widgets/info_card.dart';
import 'package:icon_app/features/onboarding/widgets/primary_button.dart';
import 'package:icon_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:icon_app/features/onboarding/bloc/onboarding_bloc_impl.dart';

/// Step 4: Training Routine Step Widget
class TrainingRoutineStep extends StatefulWidget {
  const TrainingRoutineStep({super.key});

  @override
  State<TrainingRoutineStep> createState() => _TrainingRoutineStepState();
}

class _TrainingRoutineStepState extends State<TrainingRoutineStep> {
  String? _selectedDaysPerWeek;
  String? _selectedSessionDuration;
  String? _selectedPreferredTime;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    super.initState();
    // Load existing selections if available
    final bloc = context.read<OnboardingBloc>();
    final currentData = bloc.getCurrentData();
    if (currentData?.trainingDaysPerWeek != null) {
      _selectedDaysPerWeek = currentData!.trainingDaysPerWeek;
    }
    if (currentData?.trainingSessionDuration != null) {
      _selectedSessionDuration = currentData!.trainingSessionDuration;
    }
    if (currentData?.trainingPreferredTime != null) {
      _selectedPreferredTime = currentData!.trainingPreferredTime;
    }
    if (currentData?.trainingTime != null) {
      _selectedTime = currentData!.trainingTime!;
    }
  }

  void _onDaysPerWeekSelected(String days) {
    setState(() {
      _selectedDaysPerWeek = days;
    });

    // Update BLoC with the selection
    context.read<OnboardingBloc>().add(UpdateTrainingDaysPerWeek(days));
  }

  void _onSessionDurationSelected(String duration) {
    setState(() {
      _selectedSessionDuration = duration;
    });

    // Update BLoC with the selection
    context.read<OnboardingBloc>().add(UpdateTrainingSessionDuration(duration));
  }

  void _onPreferredTimeSelected(String time) {
    setState(() {
      _selectedPreferredTime = time;
    });

    // Update BLoC with the selection
    context.read<OnboardingBloc>().add(UpdateTrainingPreferredTime(time));
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
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

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });

      // Check if widget is still mounted before using BuildContext
      if (mounted) {
        // Update BLoC with the new time
        context.read<OnboardingBloc>().add(UpdateTrainingTime(picked));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Animated Info Card
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: InfoCard(
                          title: "Let's lock in your routine.",
                          description:
                              "These questions will shape your training rhythm.",
                          icon: Icons.schedule,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Days per week section
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: _buildDaysPerWeekSection(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Session duration section
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: _buildSessionDurationSection(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Preferred time section
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1200),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: _buildPreferredTimeSection(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Animated Continue Button
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1400),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.8 + (0.2 * value),
                      child: Opacity(
                        opacity: value,
                        child: PrimaryButton(
                          text: 'Continue',
                          onPressed: _canContinue()
                              ? () => context.read<OnboardingBloc>().add(
                                  NextStep(),
                                )
                              : null,
                          isEnabled: _canContinue(),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(
                  height: 40,
                ), // Bottom padding for scrollable content
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDaysPerWeekSection() {
    final options = [
      {'id': '1-2', 'label': '1-2', 'subtitle': 'days per week'},
      {'id': '3-4', 'label': '3-4', 'subtitle': 'days per week'},
      {'id': '5-6', 'label': '5-6', 'subtitle': 'days per week'},
      {'id': 'everyday', 'label': 'Every day', 'subtitle': ''},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How many days per week?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 20),

        // Responsive grid layout
        LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 400;
            final crossAxisCount = isSmallScreen ? 2 : 4;
            final childAspectRatio = isSmallScreen ? 1.2 : 1.5;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = _selectedDaysPerWeek == option['id'];

                return _buildSelectionButton(
                  option['label']!,
                  option['subtitle']!,
                  isSelected,
                  () => _onDaysPerWeekSelected(option['id']!),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSessionDurationSection() {
    final options = [
      {'id': '15m', 'label': '15m'},
      {'id': '30m', 'label': '30m'},
      {'id': '45m', 'label': '45m'},
      {'id': '60m', 'label': '60m'},
      {'id': '90m', 'label': '90m'},
      {'id': '90m+', 'label': '90m+'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How long per session?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 20),

        // Responsive grid layout
        LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 400;
            final crossAxisCount = isSmallScreen ? 3 : 6;
            final childAspectRatio = isSmallScreen ? 1.0 : 1.2;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = _selectedSessionDuration == option['id'];

                return _buildSelectionButton(
                  option['label']!,
                  '',
                  isSelected,
                  () => _onSessionDurationSelected(option['id']!),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildPreferredTimeSection() {
    final options = [
      {'id': 'morning', 'label': 'Morning'},
      {'id': 'midday', 'label': 'Midday'},
      {'id': 'evening', 'label': 'Evening'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferred time to train?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We will remind you 15 minutes before (you can turn this off in settings)',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 20),

        // Time preference buttons
        Row(
          children: options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = _selectedPreferredTime == option['id'];

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index < options.length - 1 ? 12 : 0,
                ),
                child: _buildSelectionButton(
                  option['label']!,
                  '',
                  isSelected,
                  () => _onPreferredTimeSelected(option['id']!),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        // Time picker
        GestureDetector(
          onTap: _selectTime,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.textSecondary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${_selectedTime.hour.toString().padLeft(2, '0')} : ${_selectedTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(
                  Icons.access_time,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionButton(
    String label,
    String subtitle,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.secondary : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppColors.secondary
              : AppColors.textSecondary.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppColors.secondary.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: isSelected ? 8 : 4,
            offset: Offset(0, isSelected ? 4 : 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          splashColor: AppColors.secondary.withValues(alpha: 0.2),
          highlightColor: AppColors.secondary.withValues(alpha: 0.1),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textLight,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: subtitle.isEmpty ? 16 : 18,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.8)
                          : AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _canContinue() {
    return _selectedDaysPerWeek != null &&
        _selectedSessionDuration != null &&
        _selectedPreferredTime != null;
  }
}
