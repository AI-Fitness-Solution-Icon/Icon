import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../navigation/route_names.dart';
import '../widgets/progress_header.dart';
import '../widgets/info_card.dart';
import '../widgets/primary_button.dart';
import '../../../core/services/settings_service.dart';

/// Step 2 of 5: Fitness Goals Screen
/// Gathers user's main fitness goal and experience level
class FitnessGoalsScreen extends StatefulWidget {
  const FitnessGoalsScreen({super.key});

  @override
  State<FitnessGoalsScreen> createState() => _FitnessGoalsScreenState();
}

class _FitnessGoalsScreenState extends State<FitnessGoalsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _goalDescriptionController = TextEditingController();
  final _experienceDescriptionController = TextEditingController();
  
  String? _selectedGoal;
  String? _selectedExperienceLevel;
  bool _shouldNavigate = false;
  late final SettingsService _settingsService;

  final List<String> _fitnessGoals = [
    'Build Muscle',
    'Lose Weight',
    'Improve Strength',
    'Increase Endurance',
    'General Fitness',
    'Sports Performance',
    'Rehabilitation',
  ];

  final List<String> _experienceLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
  ];

  @override
  void initState() {
    super.initState();
    _settingsService = SettingsService();
    _loadCurrentData();
  }

  @override
  void dispose() {
    _goalDescriptionController.dispose();
    _experienceDescriptionController.dispose();
    super.dispose();
  }

  void _loadCurrentData() {
    _selectedGoal = _settingsService.primaryGoal;
    _selectedExperienceLevel = _settingsService.fitnessLevel;
  }

  void _onContinue() {
    if (_formKey.currentState!.validate() && 
        _selectedGoal != null && 
        _selectedExperienceLevel != null) {
      _saveFitnessGoalsAndNavigate();
    }
  }

  Future<void> _saveFitnessGoalsAndNavigate() async {
    try {
      // Save fitness goals using SettingsService
      await _settingsService.setPrimaryGoal(_selectedGoal!);
      await _settingsService.setFitnessLevel(_selectedExperienceLevel!);
      
      // Set flag to navigate
      if (mounted) {
        setState(() {
          _shouldNavigate = true;
        });
      }
    } catch (e) {
      // Error handling can be added here if needed
      debugPrint('Failed to save fitness goals: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handle navigation when flag is set
    if (_shouldNavigate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go(RouteNames.trainingLocationPath);
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
                  currentStep: 2,
                  totalSteps: 5,
                  onBackPressed: () => context.pop(),
                ),
                
                const SizedBox(height: 32),
                
                // Info Card
                InfoCard(
                  title: "What's your main fitness goal?",
                  description: "This helps us create a personalized plan for you",
                  icon: Icons.fitness_center,
                ),
                
                const SizedBox(height: 40),
                
                // Fitness Goals Selection
                _buildSectionHeader('Main Fitness Goal'),
                _buildSelectionGrid(
                  items: _fitnessGoals,
                  selectedItem: _selectedGoal,
                  onItemSelected: (goal) {
                    setState(() {
                      _selectedGoal = goal;
                    });
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Optional Goal Description
                if (_selectedGoal != null) ...[
                  _buildSectionHeader('Tell us more about your goal (Optional)'),
                  _buildTextArea(
                    controller: _goalDescriptionController,
                    hintText: 'Describe your specific goals, timeline, or any other details...',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Experience Level Selection
                _buildSectionHeader('How experienced are you?'),
                _buildSelectionGrid(
                  items: _experienceLevels,
                  selectedItem: _selectedExperienceLevel,
                  onItemSelected: (level) {
                    setState(() {
                      _selectedExperienceLevel = level;
                    });
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Optional Experience Description
                if (_selectedExperienceLevel != null) ...[
                  _buildSectionHeader('Tell us about your experience (Optional)'),
                  _buildTextArea(
                    controller: _experienceDescriptionController,
                    hintText: 'Describe your fitness background, previous training, injuries, etc...',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                ],
                
                const Spacer(),
                
                // Continue Button
                PrimaryButton(
                  text: 'Continue',
                  onPressed: _onContinue,
                  isEnabled: _selectedGoal != null && _selectedExperienceLevel != null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.textLight,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildSelectionGrid({
    required List<String> items,
    required String? selectedItem,
    required Function(String) onItemSelected,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = selectedItem == item;
        
        return GestureDetector(
          onTap: () => onItemSelected(item),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                item,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected ? Colors.white : AppColors.textLight,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.3),
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: AppColors.textLight),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.textSecondary),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
        ),
      ),
    );
  }
} 