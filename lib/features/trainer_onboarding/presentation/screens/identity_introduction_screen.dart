import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../bloc/trainer_onboarding_bloc.dart';
import '../../bloc/trainer_onboarding_event.dart';
import '../../bloc/trainer_onboarding_state.dart';
import '../../domain/entities/trainer_profile.dart';

/// Screen for collecting trainer's identity and introduction information
class IdentityIntroductionScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const IdentityIntroductionScreen({
    super.key,
    required this.onContinue,
  });

  @override
  State<IdentityIntroductionScreen> createState() => _IdentityIntroductionScreenState();
}

class _IdentityIntroductionScreenState extends State<IdentityIntroductionScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _customPronounsController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _motivationController = TextEditingController();

  final List<String> _pronounOptions = ['He/Him', 'She/Her', 'They/Them'];
  final List<String> _experienceLevels = ['< 1 year', '1-3 years', '3-5 years', '5+ years'];
  final List<String> _descriptiveWords = [
    'Motivator', 'Encourager', 'Supporter', 'Guide', 'Mentor',
    'Inspirer', 'Coach', 'Teacher', 'Leader', 'Helper',
    'Friend', 'Partner', 'Advisor', 'Trainer', 'Specialist'
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _customPronounsController.dispose();
    _nicknameController.dispose();
    _motivationController.dispose();
    super.dispose();
  }

  void _loadExistingData() {
    final bloc = context.read<TrainerOnboardingBloc>();
    final profile = _getProfileFromState(bloc.state);
    
    _fullNameController.text = profile.fullName ?? '';
    _customPronounsController.text = profile.customPronouns ?? '';
    _nicknameController.text = profile.nickname ?? '';
    _motivationController.text = profile.motivation ?? '';
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
                'Identity and Introduction',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              Text(
                'Let\'s start with some basics about you as a personal trainer.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Full Name
              _buildSectionTitle('What\'s your full name?'),
              _buildTextField(
                controller: _fullNameController,
                placeholder: 'Your full name',
                onChanged: (value) => context.read<TrainerOnboardingBloc>().add(
                  UpdateProfileFieldEvent(fullName: value),
                ),
              ),
              const SizedBox(height: 24),

              // Pronouns
              _buildSectionTitle('Your pronouns (Optional)'),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _pronounOptions.map((pronoun) {
                  final isSelected = profile.pronouns == pronoun;
                  return _buildSelectionButton(
                    text: pronoun,
                    isSelected: isSelected,
                    onTap: () => context.read<TrainerOnboardingBloc>().add(
                      UpdateProfileFieldEvent(pronouns: pronoun),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              
              _buildTextField(
                controller: _customPronounsController,
                placeholder: 'Or enter custom pronouns',
                onChanged: (value) => context.read<TrainerOnboardingBloc>().add(
                  UpdateProfileFieldEvent(customPronouns: value),
                ),
              ),
              const SizedBox(height: 24),

              // Nickname
              _buildSectionTitle('Do you use a nickname? (Optional)'),
              _buildTextField(
                controller: _nicknameController,
                placeholder: 'What your clients call you?',
                onChanged: (value) => context.read<TrainerOnboardingBloc>().add(
                  UpdateProfileFieldEvent(nickname: value),
                ),
              ),
              const SizedBox(height: 24),

              // Experience Level
              _buildSectionTitle('How long have you been in fitness or coaching?'),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _experienceLevels.map((level) {
                  final isSelected = profile.experienceLevel == level;
                  return _buildSelectionButton(
                    text: level,
                    isSelected: isSelected,
                    onTap: () => context.read<TrainerOnboardingBloc>().add(
                      UpdateProfileFieldEvent(experienceLevel: level),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Descriptive Words
              _buildSectionTitle('What three words your favourite client use to describe you?'),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _descriptiveWords.map((word) {
                  final isSelected = profile.descriptiveWords.contains(word);
                  return _buildSelectionButton(
                    text: word,
                    isSelected: isSelected,
                    onTap: () {
                      if (isSelected) {
                        context.read<TrainerOnboardingBloc>().add(
                          RemoveDescriptiveWordEvent(word),
                        );
                      } else {
                        context.read<TrainerOnboardingBloc>().add(
                          AddDescriptiveWordEvent(word),
                        );
                      }
                    },
                  );
                }).toList(),
              ),
              
              // Selected words display
              if (profile.descriptiveWords.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Selected:',
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
                  children: profile.descriptiveWords.map((word) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        word,
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

              // Motivation
              _buildSectionTitle('Why did you become a coach?'),
              _buildTextField(
                controller: _motivationController,
                placeholder: 'Share your motivation and passion...',
                maxLines: 4,
                onChanged: (value) => context.read<TrainerOnboardingBloc>().add(
                  UpdateProfileFieldEvent(motivation: value),
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
    return profile.fullName != null && 
           profile.fullName!.isNotEmpty && 
           profile.experienceLevel != null && 
           profile.experienceLevel!.isNotEmpty;
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

  Widget _buildSelectionButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.accentBlueLight,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppColors.textLight : AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
} 