import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/trainer_onboarding_bloc.dart';
import '../../bloc/trainer_onboarding_event.dart';
import '../../bloc/trainer_onboarding_state.dart';
import '../../../../core/constants/app_colors.dart';

/// Screen for collecting trainer's training philosophy
class TrainingPhilosophyScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const TrainingPhilosophyScreen({
    super.key,
    required this.onContinue,
  });

  @override
  State<TrainingPhilosophyScreen> createState() => _TrainingPhilosophyScreenState();
}

class _TrainingPhilosophyScreenState extends State<TrainingPhilosophyScreen> {
  final TextEditingController _coreBeliefsController = TextEditingController();
  final TextEditingController _movementBeliefsController = TextEditingController();

  final List<String> _philosophyOptions = [
    'Progressive Overload',
    'Functional Movement',
    'Mind-Body Connection',
    'Individualized Approach',
    'Evidence-Based Training',
    'Holistic Wellness',
    'Strength Foundation',
    'Mobility First',
    'Recovery Focused',
    'Consistency Over Intensity',
    'Form Before Weight',
    'Sustainable Habits',
    'Goal-Oriented Training',
    'Adaptive Programming',
    'Client Education',
    'Long-term Health',
    'Performance Enhancement',
    'Injury Prevention',
    'Balanced Development',
    'Quality Over Quantity'
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _coreBeliefsController.dispose();
    _movementBeliefsController.dispose();
    super.dispose();
  }

  void _loadExistingData() {
    final bloc = context.read<TrainerOnboardingBloc>();
    final state = bloc.state;
    
    if (state is TrainerOnboardingLoaded) {
      final profile = state.profile;
      // Load existing philosophy data if available
      if (profile.trainingPhilosophy.isNotEmpty) {
        // This is a simplified approach - in a real app, you might want to
        // store core beliefs and movement beliefs separately
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrainerOnboardingBloc, TrainerOnboardingState>(
      listener: (context, state) {
        if (state is TrainerOnboardingAccountCreated) {
          widget.onContinue();
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Training Philosophy',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              Text(
                'Share your core beliefs about your fitness and coaching.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Core Beliefs Section
              Text(
                'Core Beliefs',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              
              TextField(
                controller: _coreBeliefsController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'What are your core beliefs about fitness and coaching?',
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.accentBlueLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.accentBlueLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
                style: TextStyle(color: AppColors.textLight),
              ),
              const SizedBox(height: 24),

              // Movement Beliefs Section
              Text(
                'Movement Philosophy',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              
              TextField(
                controller: _movementBeliefsController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'What are your beliefs about movement and exercise?',
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.accentBlueLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.accentBlueLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
                style: TextStyle(color: AppColors.textLight),
              ),
              const SizedBox(height: 32),

              // Training Principles Section
              Text(
                'Training Principles',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              
              Text(
                'Select the principles that guide your training approach:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),

              // Philosophy Options Grid
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _philosophyOptions.map((option) {
                  final isSelected = state is TrainerOnboardingLoaded && 
                      state.profile.trainingPhilosophy.contains(option);
                  
                  return FilterChip(
                    label: Text(
                      option,
                      style: TextStyle(
                        color: isSelected ? AppColors.surface : AppColors.textLight,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      final bloc = context.read<TrainerOnboardingBloc>();
                      if (selected) {
                        bloc.add(AddTrainingPhilosophyEvent(option));
                      } else {
                        bloc.add(RemoveTrainingPhilosophyEvent(option));
                      }
                    },
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.primary,
                    checkmarkColor: AppColors.surface,
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.accentBlueLight,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Selected Principles Display
              if (state is TrainerOnboardingLoaded && state.profile.trainingPhilosophy.isNotEmpty) ...[
                Text(
                  'Selected Principles:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.profile.trainingPhilosophy.map((principle) {
                    return Chip(
                      label: Text(
                        principle,
                        style: TextStyle(
                          color: AppColors.surface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: AppColors.primary,
                      deleteIcon: Icon(
                        Icons.close,
                        color: AppColors.surface,
                        size: 18,
                      ),
                      onDeleted: () {
                        final bloc = context.read<TrainerOnboardingBloc>();
                        bloc.add(RemoveTrainingPhilosophyEvent(principle));
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
              ],

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canContinue(state) ? () {
                    _saveData();
                    widget.onContinue();
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _canContinue(TrainerOnboardingState state) {
    if (state is TrainerOnboardingLoaded) {
      return state.profile.trainingPhilosophy.isNotEmpty;
    }
    return false;
  }

  void _saveData() {
    final bloc = context.read<TrainerOnboardingBloc>();
    final currentState = bloc.state;
    
    if (currentState is TrainerOnboardingLoaded) {
      final currentProfile = currentState.profile;
      
      // Update profile with new data
      final updatedProfile = currentProfile.copyWith(
        // Note: In a real implementation, you might want to store
        // core beliefs and movement beliefs separately in the entity
        trainingPhilosophy: currentProfile.trainingPhilosophy,
      );
      
      bloc.add(UpdateProfileEvent(updatedProfile));
    }
  }
} 