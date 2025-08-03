import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Fitness goals screen for setting and tracking fitness objectives
class FitnessGoalsScreen extends StatefulWidget {
  const FitnessGoalsScreen({super.key});

  @override
  State<FitnessGoalsScreen> createState() => _FitnessGoalsScreenState();
}

class _FitnessGoalsScreenState extends State<FitnessGoalsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightGoalController = TextEditingController();
  final _workoutDaysController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _stepsController = TextEditingController();
  
  String _selectedGoal = 'Weight Loss';
  String _selectedFitnessLevel = 'Beginner';

  final List<String> _goalTypes = [
    'Weight Loss',
    'Muscle Gain',
    'Endurance',
    'Strength',
    'General Fitness',
  ];

  final List<String> _fitnessLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentGoals();
  }

  @override
  void dispose() {
    _weightGoalController.dispose();
    _workoutDaysController.dispose();
    _caloriesController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  void _loadCurrentGoals() {
    // TODO: Load from local storage or API
    _weightGoalController.text = '70';
    _workoutDaysController.text = '4';
    _caloriesController.text = '2000';
    _stepsController.text = '10000';
  }

  void _saveGoals() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save to local storage or API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fitness goals saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Goals'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveGoals,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.fitness_center,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Set Your Fitness Goals',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Define your objectives to track your progress effectively',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Goal Type
              _buildSectionHeader('Primary Goal'),
              _buildDropdownField(
                value: _selectedGoal,
                items: _goalTypes,
                onChanged: (value) {
                  setState(() {
                    _selectedGoal = value!;
                  });
                },
                label: 'What is your main fitness goal?',
              ),
              const SizedBox(height: 16),

              // Fitness Level
              _buildSectionHeader('Fitness Level'),
              _buildDropdownField(
                value: _selectedFitnessLevel,
                items: _fitnessLevels,
                onChanged: (value) {
                  setState(() {
                    _selectedFitnessLevel = value!;
                  });
                },
                label: 'What is your current fitness level?',
              ),
              const SizedBox(height: 24),

              // Numeric Goals
              _buildSectionHeader('Target Goals'),
              
              // Weight Goal
              _buildNumericField(
                controller: _weightGoalController,
                label: 'Target Weight (kg)',
                icon: Icons.monitor_weight,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter target weight';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null || weight <= 0) {
                    return 'Please enter a valid weight';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Workout Days
              _buildNumericField(
                controller: _workoutDaysController,
                label: 'Workout Days per Week',
                icon: Icons.calendar_today,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter workout days';
                  }
                  final days = int.tryParse(value);
                  if (days == null || days < 1 || days > 7) {
                    return 'Please enter 1-7 days';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Daily Calories
              _buildNumericField(
                controller: _caloriesController,
                label: 'Daily Calorie Goal',
                icon: Icons.local_fire_department,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter calorie goal';
                  }
                  final calories = int.tryParse(value);
                  if (calories == null || calories <= 0) {
                    return 'Please enter a valid calorie goal';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Daily Steps
              _buildNumericField(
                controller: _stepsController,
                label: 'Daily Steps Goal',
                icon: Icons.directions_walk,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter steps goal';
                  }
                  final steps = int.tryParse(value);
                  if (steps == null || steps <= 0) {
                    return 'Please enter a valid steps goal';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Progress Tips
              _buildProgressTips(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required String label,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.arrow_drop_down),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a value';
        }
        return null;
      },
    );
  }

  Widget _buildNumericField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: validator,
    );
  }

  Widget _buildProgressTips() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  'Progress Tips',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTip('Set realistic goals that you can achieve'),
            _buildTip('Track your progress regularly'),
            _buildTip('Stay consistent with your workout routine'),
            _buildTip('Listen to your body and rest when needed'),
            _buildTip('Celebrate small victories along the way'),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.blue[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.blue[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 