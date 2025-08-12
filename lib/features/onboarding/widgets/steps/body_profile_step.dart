import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_app/features/onboarding/widgets/info_card.dart';
import 'package:icon_app/features/onboarding/widgets/primary_button.dart';
import 'package:icon_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:icon_app/features/onboarding/bloc/onboarding_bloc_impl.dart';
import 'package:icon_app/features/onboarding/widgets/steps/components/body_metrics_input.dart';
import 'package:icon_app/features/onboarding/widgets/steps/components/body_type_selection.dart';
import 'package:icon_app/features/onboarding/widgets/steps/components/optional_note_field.dart';

class BodyProfileStep extends StatefulWidget {
  const BodyProfileStep({super.key});

  @override
  State<BodyProfileStep> createState() => _BodyProfileStepState();
}

class _BodyProfileStepState extends State<BodyProfileStep> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  late final TextEditingController _bodyFatController;
  late final TextEditingController _notesController;

  String? _selectedBodyType;

  final bool _isFormValid = true;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
    _heightController = TextEditingController();
    _bodyFatController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _bodyFatController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onContinue() async {
    if (_formKey.currentState!.validate()) {
      try {
        _saveBodyProfileData();

        if (mounted) {
          context.read<OnboardingBloc>().add(NextStep());
        }
      } catch (e) {
        debugPrint('Failed to save body profile data: $e');
      }
    }
  }

  void _saveBodyProfileData() {}

  void _onBodyTypeChanged(String? bodyType) {
    setState(() {
      _selectedBodyType = bodyType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(), // Add proper scroll physics
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: 1.0,
                    child: InfoCard(
                      title: "Let's get to know your body",
                      description:
                          "Share your body metrics and profile to help us personalize your fitness journey. All fields are optional!",
                      icon: Icons.monitor_weight_outlined,
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 600),
                    opacity: 1.0,
                    child: BodyMetricsInput(
                      weightController: _weightController,
                      heightController: _heightController,
                      bodyFatController: _bodyFatController,
                      selectedWeightUnit: null,
                      selectedHeightUnit: null,
                      selectedBodyFatMethod: null,
                      onWeightUnitChanged: (_) {},
                      onHeightUnitChanged: (_) {},
                      onBodyFatMethodChanged: (_) {},
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: 1.0,
                    child: BodyTypeSelection(
                      selectedBodyType: _selectedBodyType,
                      onBodyTypeChanged: _onBodyTypeChanged,
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 1000),
                    opacity: 1.0,
                    child: OptionalNoteField(
                      controller: _notesController,
                      label: "Additional Notes",
                      hintText:
                          "Any other body-related information you'd like to share...",
                      icon: Icons.note_add_outlined,
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 1200),
                    opacity: 1.0,
                    child: PrimaryButton(
                      text: 'Continue',
                      onPressed: _onContinue,
                      isEnabled: _isFormValid,
                    ),
                  ),

                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
