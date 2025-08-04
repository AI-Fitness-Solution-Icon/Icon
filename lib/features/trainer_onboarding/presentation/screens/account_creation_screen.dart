import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/trainer_onboarding_bloc.dart';
import '../../bloc/trainer_onboarding_event.dart';
import '../../bloc/trainer_onboarding_state.dart';
import '../../domain/entities/trainer_profile.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:go_router/go_router.dart';

/// Screen for creating the final trainer account
class AccountCreationScreen extends StatefulWidget {
  final VoidCallback onAccountCreated;

  const AccountCreationScreen({
    super.key,
    required this.onAccountCreated,
  });

  @override
  State<AccountCreationScreen> createState() => _AccountCreationScreenState();
}

class _AccountCreationScreenState extends State<AccountCreationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _loadExistingData() {
    final bloc = context.read<TrainerOnboardingBloc>();
    final profile = _getProfileFromState(bloc.state);
    
    _emailController.text = profile.email ?? '';
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
    return BlocConsumer<TrainerOnboardingBloc, TrainerOnboardingState>(
      listener: (context, state) {
        if (state is TrainerOnboardingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
        if (state is TrainerOnboardingAccountCreated) {
          widget.onAccountCreated();
        }
      },
      builder: (context, state) {
        final isLoading = state is TrainerOnboardingCreatingAccount;
        final error = state is TrainerOnboardingError ? state.message : null;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Create your account',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                Text(
                  'Set up your account to start your journey as a trainer.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // Error message
                if (error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.error),
                    ),
                    child: Text(
                      error,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Email Address
                _buildSectionTitle('Email Address'),
                _buildEmailField(),
                const SizedBox(height: 24),

                // Password
                _buildSectionTitle('Password'),
                _buildPasswordField(),
                const SizedBox(height: 24),

                // Confirm Password
                _buildSectionTitle('Confirm Password'),
                _buildConfirmPasswordField(),
                const SizedBox(height: 24),

                // Terms and Conditions
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                        });
                      },
                      activeColor: AppColors.secondary,
                      checkColor: AppColors.textLight,
                    ),
                    Expanded(
                      child: Text(
                        'I agree to the Terms & Conditions and Privacy Policy.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Create Account Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading || !_agreeToTerms 
                         ? null 
                         : () => _handleCreateAccount(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.textLight,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                         ? const SizedBox(
                             height: 20,
                             width: 20,
                             child: CircularProgressIndicator(
                               strokeWidth: 2,
                               valueColor: AlwaysStoppedAnimation<Color>(AppColors.textLight),
                             ),
                           )
                         : const Text(
                             'Create Account',
                             style: TextStyle(
                               fontSize: 16,
                               fontWeight: FontWeight.w600,
                             ),
                           ),
                  ),
                ),
                const SizedBox(height: 16),

                // Login link
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to login screen
                      context.go('/login');
                    },
                    child: const Text(
                      'Already have an account? Log in',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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

  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentBlueLight),
      ),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: AppColors.textLight),
        decoration: const InputDecoration(
          hintText: 'Enter your email address',
          hintStyle: TextStyle(color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email is required';
          }
          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
            return 'Please enter a valid email address';
          }
          return null;
        },
        onChanged: (value) {
          final bloc = context.read<TrainerOnboardingBloc>();
          bloc.add(UpdateProfileFieldEvent(email: value));
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentBlueLight),
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        style: const TextStyle(color: AppColors.textLight),
        decoration: InputDecoration(
          hintText: 'Enter your password',
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password is required';
          }
          if (value.length < 8) {
            return 'Password must be at least 8 characters long';
          }
          return null;
        },
        onChanged: (value) {
          final bloc = context.read<TrainerOnboardingBloc>();
          bloc.add(UpdateProfileFieldEvent(password: value));
        },
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentBlueLight),
      ),
      child: TextFormField(
        controller: _confirmPasswordController,
        obscureText: _obscureConfirmPassword,
        style: const TextStyle(color: AppColors.textLight),
        decoration: InputDecoration(
          hintText: 'Confirm your password',
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
              color: AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          }
          if (value != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }

  void _handleCreateAccount(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms & Conditions'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final bloc = context.read<TrainerOnboardingBloc>();
    bloc.add(CreateAccountEvent());
  }
} 