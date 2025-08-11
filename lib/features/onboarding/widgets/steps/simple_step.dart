import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_app/features/onboarding/widgets/info_card.dart';
import 'package:icon_app/features/onboarding/widgets/primary_button.dart';
import 'package:icon_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:icon_app/features/onboarding/bloc/onboarding_bloc_impl.dart';

/// Reusable simple step widget for basic onboarding steps
class SimpleStep extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final bool isButtonEnabled;

  const SimpleStep({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.buttonText = 'Continue',
    this.onButtonPressed,
    this.isButtonEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InfoCard(title: title, description: description, icon: icon),
              const SizedBox(height: 40),
              PrimaryButton(
                text: buttonText,
                onPressed:
                    onButtonPressed ??
                    () {
                      context.read<OnboardingBloc>().add(NextStep());
                    },
                isEnabled: isButtonEnabled,
              ),
              const SizedBox(
                height: 40,
              ), // Bottom padding for scrollable content
            ],
          ),
        );
      },
    );
  }
}
