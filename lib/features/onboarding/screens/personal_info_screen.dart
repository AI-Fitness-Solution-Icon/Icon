import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../navigation/route_names.dart';
import '../widgets/progress_header.dart';
import '../widgets/info_card.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/gender_selection.dart';
import '../widgets/primary_button.dart';
import '../../../core/repositories/user_repository.dart';
import '../../../core/utils/app_print.dart';
import '../../../core/services/supabase_service.dart';

/// Step 1 of 10: Personal Information Screen
/// Gathers user's name, date of birth, and gender
class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  Gender? _selectedGender;
  DateTime? _selectedDate;
  bool _shouldNavigate = false;

  @override
  void dispose() {
    _nameController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime.now().subtract(const Duration(days: 36500)), // 100 years ago
      lastDate: DateTime.now().subtract(const Duration(days: 3650)), // 10 years ago
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
        _dateOfBirthController.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _onContinue() {
    if (_formKey.currentState!.validate() && _selectedGender != null) {
      _savePersonalInfoAndNavigate();
    }
  }

  Future<void> _savePersonalInfoAndNavigate() async {
    try {
      // Save personal information using UserRepository
      final userRepository = UserRepository();
      
      // Get current user from Supabase
      final supabaseService = SupabaseService.instance;
      final currentUser = supabaseService.currentUser;
      
      if (currentUser != null) {
        // Parse the name to get first and last name
        final nameParts = _nameController.text.trim().split(' ');
        final firstName = nameParts.isNotEmpty ? nameParts.first : '';
        final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        
        // Update user profile with personal information
        await userRepository.updateUserProfile(
          firstName: firstName.isNotEmpty ? firstName : null,
          lastName: lastName.isNotEmpty ? lastName : null,
        );
        
        AppPrint.printInfo('Personal information saved successfully');
      }
      
      // Set flag to navigate
      if (mounted) {
        setState(() {
          _shouldNavigate = true;
        });
      }
    } catch (e) {
      AppPrint.printError('Failed to save personal information: $e');
      // Error handling can be added here if needed
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
    // Handle navigation when flag is set
    if (_shouldNavigate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go(RouteNames.fitnessGoalsPath);
        }
      });
    }
    
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Progress Header
                ProgressHeader(
                  currentStep: 1,
                  totalSteps: 10,
                  onBackPressed: () => context.pop(),
                ),
                
                const SizedBox(height: 32),
                
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
                  selectedGender: _selectedGender,
                  onGenderChanged: (gender) {
                    setState(() {
                      _selectedGender = gender;
                    });
                  },
                ),
                
                const Spacer(),
                
                // Continue Button
                PrimaryButton(
                  text: 'Continue',
                  onPressed: _onContinue,
                  isEnabled: _selectedGender != null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 