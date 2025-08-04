import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/trainer_onboarding_bloc.dart';
import '../../bloc/trainer_onboarding_event.dart';
import '../../bloc/trainer_onboarding_state.dart';
import '../../domain/entities/trainer_profile.dart';
import '../../../../core/constants/app_colors.dart';

/// Screen for collecting trainer's credentials and experience
class CredentialsExperienceScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const CredentialsExperienceScreen({
    super.key,
    required this.onContinue,
  });

  @override
  State<CredentialsExperienceScreen> createState() => _CredentialsExperienceScreenState();
}

class _CredentialsExperienceScreenState extends State<CredentialsExperienceScreen> {
  final TextEditingController _coachingExperienceController = TextEditingController();
  final TextEditingController _equipmentDetailsController = TextEditingController();

  final List<String> _certificationOptions = [
    'NASM Certified Personal Trainer',
    'ACE Certified Personal Trainer',
    'ACSM Certified Personal Trainer',
    'ISSA Certified Personal Trainer',
    'NSCA Certified Personal Trainer',
    'AFAA Certified Personal Trainer',
    'NESTA Certified Personal Trainer',
    'NFPT Certified Personal Trainer',
    'NCSF Certified Personal Trainer',
    'Cooper Institute Certified Personal Trainer',
    'FMS Level 1',
    'FMS Level 2',
    'CrossFit Level 1',
    'CrossFit Level 2',
    'Yoga Alliance RYT-200',
    'Yoga Alliance RYT-500',
    'Pilates Certification',
    'Nutrition Coach Certification',
    'Sports Nutrition Certification',
    'Strength and Conditioning Specialist',
    'Corrective Exercise Specialist',
    'Performance Enhancement Specialist',
    'Senior Fitness Specialist',
    'Youth Fitness Specialist',
    'Pre/Post Natal Specialist',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _coachingExperienceController.dispose();
    _equipmentDetailsController.dispose();
    super.dispose();
  }

  void _loadExistingData() {
    final bloc = context.read<TrainerOnboardingBloc>();
    final profile = _getProfileFromState(bloc.state);
    
    _coachingExperienceController.text = profile.coachingExperience ?? '';
    _equipmentDetailsController.text = profile.equipmentDetails ?? '';
  }

  TrainerProfile _getProfileFromState(TrainerOnboardingState state) {
    if (state is TrainerOnboardingLoaded) {
      return state.profile;
    } else if (state is TrainerOnboardingError) {
      return state.profile;
    } else if (state is TrainerOnboardingLoading) {
      return state.profile;
    } else {
      return const TrainerProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainerOnboardingBloc, TrainerOnboardingState>(
      builder: (context, state) {
        final profile = _getProfileFromState(state);
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Credential and Experience',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              Text(
                'Tell us about your qualification and experience.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Certifications Section
              _buildSectionTitle('What certifications do you have?'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _certificationOptions.map((certification) {
                  final isSelected = profile.certifications.contains(certification);
                  return FilterChip(
                    label: Text(
                      certification,
                      style: TextStyle(
                        color: isSelected ? AppColors.surface : AppColors.textLight,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      final bloc = context.read<TrainerOnboardingBloc>();
                      if (selected) {
                        bloc.add(AddCertificationEvent(certification));
                      } else {
                        bloc.add(RemoveCertificationEvent(certification));
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
              
              // Selected certifications display
              if (profile.certifications.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Selected Certifications:',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.certifications.map((certification) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        certification,
                        style: const TextStyle(
                          color: AppColors.textLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 24),

              // Coaching Experience Section
              _buildSectionTitle('Tell us about your coaching experience'),
              _buildTextField(
                controller: _coachingExperienceController,
                placeholder: 'Describe your coaching experience and background...',
                maxLines: 4,
                onChanged: (value) => context.read<TrainerOnboardingBloc>().add(
                  UpdateProfileFieldEvent(coachingExperience: value),
                ),
              ),
              const SizedBox(height: 24),

              // Equipment Details Section
              _buildSectionTitle('What equipment do you have access to? (Optional)'),
              _buildTextField(
                controller: _equipmentDetailsController,
                placeholder: 'Describe your available equipment and facilities...',
                maxLines: 3,
                onChanged: (value) => context.read<TrainerOnboardingBloc>().add(
                  UpdateProfileFieldEvent(equipmentDetails: value),
                ),
              ),
              const SizedBox(height: 32),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canProceed(profile) ? widget.onContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: AppColors.textLight,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
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

  bool _canProceed(TrainerProfile profile) {
    return profile.certifications.isNotEmpty && 
           profile.coachingExperience != null && 
           profile.coachingExperience!.isNotEmpty;
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textLight,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    required ValueChanged<String> onChanged,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentBlueLight),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLines: maxLines,
        style: const TextStyle(color: AppColors.textLight),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
} 