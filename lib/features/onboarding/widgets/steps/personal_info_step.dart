import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_app/core/constants/app_colors.dart';
import 'package:icon_app/features/onboarding/widgets/info_card.dart';
import 'package:icon_app/features/onboarding/widgets/custom_input_field.dart';
import 'package:icon_app/features/onboarding/widgets/gender_selection.dart';
import 'package:icon_app/features/onboarding/widgets/primary_button.dart';
import 'package:icon_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:icon_app/features/onboarding/bloc/onboarding_bloc_impl.dart';
import 'package:icon_app/core/repositories/user_repository.dart';
import 'package:icon_app/core/utils/app_print.dart';
import 'package:icon_app/core/services/supabase_service.dart';

/// Step 1: Personal Information Step Widget
class PersonalInfoStep extends StatefulWidget {
  const PersonalInfoStep({super.key});

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _dateOfBirthController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dateOfBirthController = TextEditingController();

    // Initialize with existing data if available
    final bloc = context.read<OnboardingBloc>();
    final currentData = bloc.getCurrentData();
    if (currentData != null) {
      if (currentData.firstName != null && currentData.lastName != null) {
        _nameController.text =
            '${currentData.firstName} ${currentData.lastName}';
      }
      if (currentData.dateOfBirth != null) {
        _selectedDate = currentData.dateOfBirth;
        _dateOfBirthController.text = _formatDate(currentData.dateOfBirth!);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        const Duration(days: 6570),
      ), // 18 years ago
      firstDate: DateTime.now().subtract(
        const Duration(days: 36500),
      ), // 100 years ago
      lastDate: DateTime.now().subtract(
        const Duration(days: 3650),
      ), // 10 years ago
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

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text = _formatDate(picked);
      });

      // Update BLoC with the new date
      _updatePersonalInfo();
    }
  }

  void _updatePersonalInfo() {
    final nameParts = _nameController.text.trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    context.read<OnboardingBloc>().add(
      UpdatePersonalInfo(
        firstName: firstName.isNotEmpty ? firstName : null,
        lastName: lastName.isNotEmpty ? lastName : null,
        dateOfBirth: _selectedDate,
        gender: null, // Will be updated when gender is selected
      ),
    );
  }

  void _onGenderChanged(Gender? gender) {
    if (gender != null) {
      context.read<OnboardingBloc>().add(
        UpdatePersonalInfo(
          firstName: null, // Keep existing
          lastName: null, // Keep existing
          dateOfBirth: null, // Keep existing
          gender: gender.name,
        ),
      );
    }
  }

  void _onContinue() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      try {
        // Save personal information using UserRepository
        final userRepository = UserRepository();
        final supabaseService = SupabaseService.instance;
        final currentUser = supabaseService.currentUser;

        if (currentUser != null) {
          final nameParts = _nameController.text.trim().split(' ');
          final firstName = nameParts.isNotEmpty ? nameParts.first : '';
          final lastName = nameParts.length > 1
              ? nameParts.sublist(1).join(' ')
              : '';

          await userRepository.updateUserProfile(
            firstName: firstName.isNotEmpty ? firstName : null,
            lastName: lastName.isNotEmpty ? lastName : null,
            dateOfBirth: _selectedDate,
            gender: null, // Will be updated when gender is selected
          );

          // Check if widget is still mounted before using BuildContext
          if (mounted) {
          context.read<OnboardingBloc>().add(NextStep());
          AppPrint.printInfo('Personal information saved successfully');
          }
        }
      } catch (e) {
        AppPrint.printError('Failed to save personal information: $e');
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateDateOfBirth(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select your date of birth';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final currentData = state is OnboardingLoaded ? state.data : null;
        final selectedGender = currentData?.gender != null
            ? Gender.values.firstWhere(
                (g) => g.name == currentData!.gender,
                orElse: () => Gender.male,
              )
            : null;

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info Card
                InfoCard(
                  title: "Let's make this personal",
                  description: "What would you like to be called?",
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 40),

                // Name Input
                CustomInputField(
                  label: 'Name',
                  hintText: 'Your name',
                  controller: _nameController,
                  validator: _validateName,
                  onChanged: (value) => _updatePersonalInfo(),
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 24),

                // Date of Birth Input
                CustomInputField(
                  label: 'Date of Birth',
                  hintText: 'dd/mm/yy',
                  controller: _dateOfBirthController,
                  validator: _validateDateOfBirth,
                  readOnly: true,
                  onTap: _selectDate,
                  prefixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 24),

                // Gender Selection
                GenderSelection(
                  selectedGender: selectedGender,
                  onGenderChanged: _onGenderChanged,
                ),

                const SizedBox(height: 40),

                // Continue Button
                PrimaryButton(
                  text: 'Continue',
                  onPressed: _onContinue,
                  isEnabled:
                      _selectedDate != null &&
                      _nameController.text.isNotEmpty &&
                      selectedGender != null,
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
}
