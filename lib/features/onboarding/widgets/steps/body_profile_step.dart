import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_app/features/onboarding/widgets/info_card.dart';
import 'package:icon_app/features/onboarding/widgets/primary_button.dart';
import 'package:icon_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:icon_app/features/onboarding/bloc/onboarding_bloc_impl.dart';
import 'package:icon_app/features/onboarding/widgets/steps/components/body_metrics_input.dart';
import 'package:icon_app/features/onboarding/widgets/steps/components/body_type_selection.dart';
import 'package:icon_app/features/onboarding/widgets/steps/components/optional_note_field.dart';

/// Step 5: Body Profile Step Widget
/// Collects optional body metrics and profile information
class BodyProfileStep extends StatefulWidget {
  const BodyProfileStep({super.key});

  @override
  State<BodyProfileStep> createState() => _BodyProfileStepState();
}

class _BodyProfileStepState extends State<BodyProfileStep> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for body metrics
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  late final TextEditingController _bodyFatController;
  late final TextEditingController _notesController;

  // Selected values
  String? _selectedWeightUnit;
  String? _selectedHeightUnit;
  String? _selectedBodyType;
  String? _selectedBodyFatMethod;

  // Form validation state
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
        // Save body profile information
        _saveBodyProfileData();

        // Move to next step
        if (mounted) {
          context.read<OnboardingBloc>().add(NextStep());
        }
      } catch (e) {
        // Handle error - could show a snackbar or dialog
        debugPrint('Failed to save body profile data: $e');
      }
    }
  }

  void _saveBodyProfileData() {
    // TODO: Implement body profile data saving
    // This will be implemented when the data model is extended
  }

  void _onBodyTypeChanged(String? bodyType) {
    setState(() {
      _selectedBodyType = bodyType;
    });
  }

  void _onWeightUnitChanged(String? unit) {
    setState(() {
      _selectedWeightUnit = unit;
    });
  }

  void _onHeightUnitChanged(String? unit) {
    setState(() {
      _selectedHeightUnit = unit;
    });
  }

  void _onBodyFatMethodChanged(String? method) {
    setState(() {
      _selectedBodyFatMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    final isMediumScreen = screenSize.width >= 400 && screenSize.width < 600;

    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Info Card
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

                      SizedBox(height: isSmallScreen ? 24.0 : 40.0),

                      // Body Metrics Input Section
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 600),
                        opacity: 1.0,
                        child: BodyMetricsInput(
                          weightController: _weightController,
                          heightController: _heightController,
                          bodyFatController: _bodyFatController,
                          selectedWeightUnit: _selectedWeightUnit,
                          selectedHeightUnit: _selectedHeightUnit,
                          selectedBodyFatMethod: _selectedBodyFatMethod,
                          onWeightUnitChanged: _onWeightUnitChanged,
                          onHeightUnitChanged: _onHeightUnitChanged,
                          onBodyFatMethodChanged: _onBodyFatMethodChanged,
                          isSmallScreen: isSmallScreen,
                          isMediumScreen: isMediumScreen,
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 24.0 : 40.0),

                      // Body Type Selection Section
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 800),
                        opacity: 1.0,
                        child: BodyTypeSelection(
                          selectedBodyType: _selectedBodyType,
                          onBodyTypeChanged: _onBodyTypeChanged,
                          isSmallScreen: isSmallScreen,
                          isMediumScreen: isMediumScreen,
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 24.0 : 40.0),

                      // Optional Notes Section
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 1000),
                        opacity: 1.0,
                        child: OptionalNoteField(
                          controller: _notesController,
                          label: "Additional Notes",
                          hintText:
                              "Any other body-related information you'd like to share...",
                          icon: Icons.note_add_outlined,
                          isSmallScreen: isSmallScreen,
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 24.0 : 40.0),

                      // Continue Button
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 1200),
                        opacity: 1.0,
                        child: PrimaryButton(
                          text: 'Continue',
                          onPressed: _onContinue,
                          isEnabled: _isFormValid,
                        ),
                      ),

                      SizedBox(
                        height: isSmallScreen ? 24.0 : 40.0,
                      ), // Bottom padding for scrollable content
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
