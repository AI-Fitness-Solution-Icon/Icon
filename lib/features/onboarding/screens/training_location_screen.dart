import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../navigation/route_names.dart';
import '../widgets/progress_header.dart';
import '../widgets/info_card.dart';
import '../widgets/primary_button.dart';
import '../../../core/services/settings_service.dart';

/// Step 3 of 5: Training Location Screen
/// Gathers user's training location and available equipment
class TrainingLocationScreen extends StatefulWidget {
  const TrainingLocationScreen({super.key});

  @override
  State<TrainingLocationScreen> createState() => _TrainingLocationScreenState();
}

class _TrainingLocationScreenState extends State<TrainingLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _equipmentDetailsController = TextEditingController();
  
  String? _selectedLocation;
  final Set<String> _selectedEquipment = {};
  bool _shouldNavigate = false;
  late final SettingsService _settingsService;

  final List<String> _trainingLocations = [
    'Gym',
    'Home',
    'Both',
  ];

  final List<String> _equipmentOptions = [
    'Dumbbells',
    'Barbell',
    'Kettlebell',
    'Resistance Band',
    'Pull-up Bar',
    'Bench',
    'Bodyweight Only',
    'Cardio Equipment',
    'Yoga Mat',
    'Foam Roller',
  ];

  @override
  void initState() {
    super.initState();
    _settingsService = SettingsService();
    _loadCurrentData();
  }

  @override
  void dispose() {
    _equipmentDetailsController.dispose();
    super.dispose();
  }

  void _loadCurrentData() {
    // Load any existing data if available
    // This can be expanded when we add more storage options
  }

  void _onContinue() {
    if (_formKey.currentState!.validate() && _selectedLocation != null) {
      _saveTrainingLocationAndNavigate();
    }
  }

  Future<void> _saveTrainingLocationAndNavigate() async {
    try {
      // Save training location and equipment preferences
      // This can be expanded when we add more storage options
      
      // Set flag to navigate
      if (mounted) {
        setState(() {
          _shouldNavigate = true;
        });
      }
    } catch (e) {
      debugPrint('Failed to save training location: $e');
    }
  }

  void _toggleEquipment(String equipment) {
    setState(() {
      if (_selectedEquipment.contains(equipment)) {
        _selectedEquipment.remove(equipment);
      } else {
        _selectedEquipment.add(equipment);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Handle navigation when flag is set
    if (_shouldNavigate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go(RouteNames.trainingRoutinePath);
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
                  currentStep: 3,
                  totalSteps: 5,
                  onBackPressed: () => context.pop(),
                ),
                
                const SizedBox(height: 32),
                
                // Info Card
                InfoCard(
                  title: "Where do you usually train?",
                  description: "We can tailor your plan to match your space and equipment",
                  icon: Icons.location_on,
                ),
                
                const SizedBox(height: 40),
                
                // Training Location Selection
                _buildSectionHeader('Training Location'),
                _buildSelectionGrid(
                  items: _trainingLocations,
                  selectedItem: _selectedLocation,
                  onItemSelected: (location) {
                    setState(() {
                      _selectedLocation = location;
                    });
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Equipment Selection
                _buildSectionHeader('What equipment do you have? (Select all that apply)'),
                _buildEquipmentGrid(),
                
                const SizedBox(height: 24),
                
                // Optional Equipment Details
                _buildSectionHeader('Any other equipment or details? (Optional)'),
                _buildTextArea(
                  controller: _equipmentDetailsController,
                  hintText: 'Describe any other equipment, space limitations, or training environment details...',
                  maxLines: 3,
                ),
                
                const Spacer(),
                
                // Continue Button
                PrimaryButton(
                  text: 'Continue',
                  onPressed: _onContinue,
                  isEnabled: _selectedLocation != null,
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
        crossAxisCount: 3,
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

  Widget _buildEquipmentGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: _equipmentOptions.length,
      itemBuilder: (context, index) {
        final equipment = _equipmentOptions[index];
        final isSelected = _selectedEquipment.contains(equipment);
        
        return GestureDetector(
          onTap: () => _toggleEquipment(equipment),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.secondary : AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.secondary : AppColors.textSecondary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                equipment,
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