import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icon_app/core/constants/app_colors.dart';
import 'package:icon_app/features/onboarding/widgets/progress_header.dart';
import 'package:icon_app/features/onboarding/widgets/info_card.dart';
import 'package:icon_app/features/onboarding/widgets/custom_input_field.dart';
import 'package:icon_app/features/onboarding/widgets/gender_selection.dart';
import 'package:icon_app/features/onboarding/widgets/primary_button.dart';
import 'package:icon_app/core/repositories/user_repository.dart';
import 'package:icon_app/core/repositories/fitness_goals_repository.dart';
import 'package:icon_app/core/models/fitness_main_goal.dart';
import 'package:icon_app/core/utils/app_print.dart';
import 'package:icon_app/core/services/supabase_service.dart';

/// Step 1 of 10: Personal Information Screen
/// Gathers user's name, date of birth, and gender
class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _dateOfBirthController;
  Gender? _selectedGender;
  DateTime? _selectedDate;

  // PageView controller for onboarding steps
  late final PageController _pageController;
  int _currentStep = 0;

  // Fitness goals state
  final FitnessGoalsRepository _fitnessGoalsRepository =
      FitnessGoalsRepository();
  List<FitnessMainGoal> _availableGoals = [];
  Set<String> _selectedGoalIds = {};
  bool _isLoadingGoals = false;
  String? _goalsError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _pageController = PageController();

    // Load fitness goals when the screen initializes
    _loadFitnessGoals();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateOfBirthController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  /// Load fitness goals from the database
  Future<void> _loadFitnessGoals() async {
    if (_isLoadingGoals) return;

    setState(() {
      _isLoadingGoals = true;
      _goalsError = null;
    });

    try {
      final goals = await _fitnessGoalsRepository.getAllMainGoals();
      print("The goals are : $goals");
      setState(() {
        _availableGoals = goals;
        _isLoadingGoals = false;
      });
      AppPrint.printInfo('Loaded ${goals.length} fitness goals');
    } catch (e) {
      setState(() {
        _goalsError = 'Failed to load fitness goals: $e';
        _isLoadingGoals = false;
      });
      AppPrint.printError('Error loading fitness goals: $e');
    }
  }

  /// Toggle goal selection
  void _toggleGoalSelection(String goalId) {
    setState(() {
      if (_selectedGoalIds.contains(goalId)) {
        _selectedGoalIds.remove(goalId);
      } else {
        _selectedGoalIds.add(goalId);
      }
    });
    AppPrint.printInfo('Selected goals: ${_selectedGoalIds.length}');
  }

  /// Check if a goal is selected
  bool _isGoalSelected(String goalId) {
    return _selectedGoalIds.contains(goalId);
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentStep = page;
    });
  }

  void _nextPage() {
    if (_currentStep < 9) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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
        _dateOfBirthController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
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
      final UserRepository userRepository = UserRepository();

      // Get current user from Supabase
      final SupabaseService supabaseService = SupabaseService.instance;
      final currentUser = supabaseService.currentUser;

      if (currentUser != null) {
        // Parse the name to get first and last name
        final nameParts = _nameController.text.trim().split(' ');
        final firstName = nameParts.isNotEmpty ? nameParts.first : '';
        final lastName = nameParts.length > 1
            ? nameParts.sublist(1).join(' ')
            : '';

        // Update user profile with personal information including date of birth and gender
        await userRepository.updateUserProfile(
          firstName: firstName.isNotEmpty ? firstName : null,
          lastName: lastName.isNotEmpty ? lastName : null,
          dateOfBirth: _selectedDate,
          gender: _selectedGender?.name,
        );

        _nextPage();

        AppPrint.printInfo('Personal information saved successfully');
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
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Header - stays at top and updates with current step
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ProgressHeader(
                currentStep: _currentStep + 1,
                totalSteps: 10,
                onBackPressed: _currentStep == 0
                    ? () => context.pop()
                    : _previousPage,
              ),
            ),

            // PageView for onboarding steps
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  // Step 1: Personal Information
                  SingleChildScrollView(child: _buildPersonalInfoStep()),

                  // Step 2: Fitness Goals
                  SingleChildScrollView(child: _buildFitnessGoalsStep()),

                  // Step 3: Training Location
                  SingleChildScrollView(child: _buildTrainingLocationStep()),

                  // Step 4: Training Routine
                  SingleChildScrollView(child: _buildTrainingRoutineStep()),

                  // Step 5: Nutrition Goals
                  SingleChildScrollView(child: _buildNutritionGoalsStep()),

                  // Step 6: Experience Level
                  SingleChildScrollView(child: _buildExperienceLevelStep()),

                  // Step 7: Available Time
                  SingleChildScrollView(child: _buildAvailableTimeStep()),

                  // Step 8: Equipment Access
                  SingleChildScrollView(child: _buildEquipmentAccessStep()),

                  // Step 9: Health Information
                  SingleChildScrollView(child: _buildHealthInformationStep()),

                  // Step 10: Review & Complete
                  SingleChildScrollView(child: _buildReviewCompleteStep()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 1: Personal Information
  Widget _buildPersonalInfoStep() {
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

            const SizedBox(height: 40),

            // Continue Button
            PrimaryButton(
              text: 'Continue',
              onPressed: _onContinue,
              isEnabled:
                  _selectedGender != null &&
                  _nameController.text.isNotEmpty &&
                  _dateOfBirthController.text.isNotEmpty,
            ),

            const SizedBox(height: 40), // Bottom padding for scrollable content
          ],
        ),
      ),
    );
  }

  // Step 2: Fitness Goals
  Widget _buildFitnessGoalsStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Animated Info Card
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: InfoCard(
                    title: "Nice to meet you!",
                    description:
                        "What's your main fitness goal right now, and how experienced are you? Remember - there are no wrong answers!",
                    icon: Icons.fitness_center,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          // Main Goal Section with staggered animation
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 600),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "What's your main goal?",
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),
                      _buildGoalSelectionArea(),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          // Experience Level Section with staggered animation
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "How experienced are you?",
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),
                      _buildExperienceButtons(),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          // Optional Details Section with staggered animation
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Want to tell us more about your goal? (Optional)",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 16),
                      _buildOptionalDetailsField(),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          // Animated Continue Button
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1200),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Opacity(
                  opacity: value,
                  child: PrimaryButton(
                    text: 'Continue',
                    onPressed: _selectedGoalIds.isNotEmpty ? _nextPage : null,
                    isEnabled: _selectedGoalIds.isNotEmpty,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 40), // Bottom padding for scrollable content
        ],
      ),
    );
  }

  /// Build the goal selection area with loading state and error handling
  Widget _buildGoalSelectionArea() {
    if (_isLoadingGoals) {
      return _buildGoalsLoadingState();
    }

    if (_goalsError != null) {
      return _buildGoalsErrorState();
    }

    if (_availableGoals.isEmpty) {
      return _buildNoGoalsState();
    }

    return _buildGoalsGrid();
  }

  /// Build loading state for goals
  Widget _buildGoalsLoadingState() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
            ),
            SizedBox(height: 16),
            Text(
              'Loading fitness goals...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  /// Build error state for goals
  Widget _buildGoalsErrorState() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red, width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 32),
            const SizedBox(height: 8),
            Text(
              'Failed to load goals',
              style: TextStyle(color: Colors.red[300], fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loadFitnessGoals,
              child: const Text(
                'Retry',
                style: TextStyle(color: AppColors.secondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build no goals state
  Widget _buildNoGoalsState() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!, width: 1),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center_outlined, color: Colors.grey, size: 32),
            SizedBox(height: 8),
            Text(
              'No fitness goals available',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the goals grid
  Widget _buildGoalsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: _availableGoals.length,
      itemBuilder: (context, index) {
        final goal = _availableGoals[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 400 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: _buildAnimatedGoalButton(goal, index),
            );
          },
        );
      },
    );
  }

  Widget _buildAnimatedGoalButton(FitnessMainGoal goal, int index) {
    final isSelected = _isGoalSelected(goal.id);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.secondary : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.secondary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _toggleGoalSelection(goal.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Center(
              child: Text(
                goal.name,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Experience level buttons with staggered animations
  Widget _buildExperienceButtons() {
    final experiences = [
      {
        'level': 'Beginner',
        'description': 'New to fitness or getting back into it',
        'icon': Icons.trending_up,
      },
      {
        'level': 'Intermediate',
        'description': 'Some experience with regular workouts',
        'icon': Icons.fitness_center,
      },
      {
        'level': 'Advanced',
        'description': 'Experienced with consistent training',
        'icon': Icons.emoji_events,
      },
    ];

    return Row(
      children: experiences.asMap().entries.map((entry) {
        final index = entry.key;
        final experience = entry.value;

        return Expanded(
          child: TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 600 + (index * 200)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Padding(
                    padding: EdgeInsets.only(right: index < 2 ? 12 : 0),
                    child: _buildAnimatedExperienceButton(experience, index),
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAnimatedExperienceButton(
    Map<String, dynamic> experience,
    int index,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Handle experience selection
            AppPrint.printInfo('Selected experience: ${experience['level']}');
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(
                  experience['icon'] as IconData,
                  color: AppColors.secondary,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  experience['level'] as String,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  experience['description'] as String,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Optional details text field with animation
  Widget _buildOptionalDetailsField() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[700]!, width: 1),
              ),
              child: TextField(
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText:
                      'Add any specific details about your fitness goals...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Step 3: Training Location
  Widget _buildTrainingLocationStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoCard(
            title: "Where will you train?",
            description: "Choose your preferred training environment",
            icon: Icons.location_on,
          ),
          const SizedBox(height: 40),
          PrimaryButton(text: 'Continue', onPressed: _nextPage),
          const SizedBox(height: 40), // Bottom padding for scrollable content
        ],
      ),
    );
  }

  // Step 4: Training Routine
  Widget _buildTrainingRoutineStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoCard(
            title: "What's your training routine?",
            description: "How often do you want to work out?",
            icon: Icons.schedule,
          ),
          const SizedBox(height: 40),
          PrimaryButton(text: 'Continue', onPressed: _nextPage),
          const SizedBox(height: 40), // Bottom padding for scrollable content
        ],
      ),
    );
  }

  // Step 5: Nutrition Goals
  Widget _buildNutritionGoalsStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoCard(
            title: "What are your nutrition goals?",
            description: "Tell us about your dietary preferences",
            icon: Icons.restaurant,
          ),
          const SizedBox(height: 40),
          PrimaryButton(text: 'Continue', onPressed: _nextPage),
          const SizedBox(height: 40), // Bottom padding for scrollable content
        ],
      ),
    );
  }

  // Step 6: Experience Level
  Widget _buildExperienceLevelStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoCard(
            title: "What's your experience level?",
            description: "Are you a beginner or experienced?",
            icon: Icons.trending_up,
          ),
          const SizedBox(height: 40),
          PrimaryButton(text: 'Continue', onPressed: _nextPage),
          const SizedBox(height: 40), // Bottom padding for scrollable content
        ],
      ),
    );
  }

  // Step 7: Available Time
  Widget _buildAvailableTimeStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoCard(
            title: "How much time do you have?",
            description: "What's your daily workout time availability?",
            icon: Icons.access_time,
          ),
          const SizedBox(height: 40),
          PrimaryButton(text: 'Continue', onPressed: _nextPage),
          const SizedBox(height: 40), // Bottom padding for scrollable content
        ],
      ),
    );
  }

  // Step 8: Equipment Access
  Widget _buildEquipmentAccessStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoCard(
            title: "What equipment do you have access to?",
            description: "Tell us about your available resources",
            icon: Icons.fitness_center,
          ),
          const SizedBox(height: 40),
          PrimaryButton(text: 'Continue', onPressed: _nextPage),
          const SizedBox(height: 40), // Bottom padding for scrollable content
        ],
      ),
    );
  }

  // Step 9: Health Information
  Widget _buildHealthInformationStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoCard(
            title: "Any health considerations?",
            description: "Let us know about any medical conditions",
            icon: Icons.health_and_safety,
          ),
          const SizedBox(height: 40),
          PrimaryButton(text: 'Continue', onPressed: _nextPage),
          const SizedBox(height: 40), // Bottom padding for scrollable content
        ],
      ),
    );
  }

  // Step 10: Review & Complete
  Widget _buildReviewCompleteStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoCard(
            title: "Review your information",
            description: "Let's make sure everything is correct",
            icon: Icons.check_circle,
          ),
          const SizedBox(height: 40),
          PrimaryButton(
            text: 'Complete Setup',
            onPressed: () {
              // Handle completion
              AppPrint.printInfo('Onboarding completed!');
            },
          ),
          const SizedBox(height: 40), // Bottom padding for scrollable content
        ],
      ),
    );
  }
}
