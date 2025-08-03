import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_print.dart';
import '../../../core/models/subscription_plan.dart';
import '../../../core/models/subscription.dart';

/// Subscription screen for subscription management
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isLoading = false;
  List<SubscriptionPlan> _plans = [];
  UserSubscription? _currentSubscription;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionData();
  }

  Future<void> _loadSubscriptionData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load subscription plans
      _plans = await _getSubscriptionPlans();
      
      // Load current subscription
      _currentSubscription = await _getCurrentSubscription();
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      AppPrint.printError('Failed to load subscription data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<List<SubscriptionPlan>> _getSubscriptionPlans() async {
    // Mock data - in real app, this would come from API
    final now = DateTime.now();
    return [
      SubscriptionPlan(
        planId: 'basic',
        name: 'Basic Plan',
        description: 'Perfect for beginners',
        price: 9.99,
        billingCycle: 'monthly',
        features: {
          'workouts': 'Access to basic workouts',
          'tracking': 'Progress tracking',
          'coaching': 'Basic AI coaching',
        },
        createdAt: now,
        updatedAt: now,
      ),
      SubscriptionPlan(
        planId: 'premium',
        name: 'Premium Plan',
        description: 'For serious fitness enthusiasts',
        price: 19.99,
        billingCycle: 'monthly',
        features: {
          'workouts': 'All basic features',
          'advanced': 'Advanced workout plans',
          'coaching': 'Personalized AI coaching',
          'nutrition': 'Nutrition guidance',
          'videos': 'Video tutorials',
          'support': 'Priority support',
        },
        createdAt: now,
        updatedAt: now,
      ),
      SubscriptionPlan(
        planId: 'pro',
        name: 'Pro Plan',
        description: 'For professional athletes',
        price: 29.99,
        billingCycle: 'monthly',
        features: {
          'workouts': 'All premium features',
          'coaching': '1-on-1 coaching sessions',
          'custom': 'Custom workout programs',
          'analytics': 'Advanced analytics',
          'devices': 'Integration with fitness devices',
          'support': '24/7 support',
        },
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  Future<UserSubscription?> _getCurrentSubscription() async {
    // Mock data - in real app, this would come from API
    return null; // No current subscription
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadSubscriptionData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Subscription Status
                    if (_currentSubscription != null) ...[
                      _buildCurrentSubscriptionCard(),
                      const SizedBox(height: 24),
                    ],

                    // Subscription Plans
                    Text(
                      'Choose Your Plan',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select the plan that best fits your fitness goals',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Plans List
                    ..._plans.map((plan) => _buildPlanCard(plan)),

                    const SizedBox(height: 24),

                    // Additional Information
                    _buildInfoSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCurrentSubscriptionCard() {
    return Card(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Current Subscription',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _currentSubscription?.plan?.name ?? 'No active subscription',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (_currentSubscription != null) ...[
              const SizedBox(height: 4),
              Text(
                'Next billing: ${_currentSubscription!.endDate?.toString().split(' ')[0] ?? 'N/A'}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan) {
    final isPopular = plan.planId == 'premium'; // Mark premium as popular
    final isCurrentPlan = _currentSubscription?.planId == plan.planId;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: isPopular ? 4 : 2,
      child: Container(
        decoration: isPopular
            ? BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plan Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          plan.description ?? '',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isPopular)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'POPULAR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Price
              Row(
                children: [
                  Text(
                    '\$${plan.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '/${plan.billingCycle}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Features
              Text(
                'Features:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...plan.features.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.value.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 16),

              // Subscribe Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isCurrentPlan ? null : () => _subscribeToPlan(plan),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPopular ? AppColors.primary : null,
                    foregroundColor: isPopular ? Colors.white : null,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  child: Text(
                    isCurrentPlan ? 'Current Plan' : 'Subscribe',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subscription Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.cancel,
              title: 'Cancel Anytime',
              subtitle: 'You can cancel your subscription at any time',
            ),
            _buildInfoRow(
              icon: Icons.security,
              title: 'Secure Payment',
              subtitle: 'All payments are processed securely',
            ),
            _buildInfoRow(
              icon: Icons.support_agent,
              title: '24/7 Support',
              subtitle: 'Get help whenever you need it',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _subscribeToPlan(SubscriptionPlan plan) async {
    try {
      AppPrint.printInfo('Subscribing to plan: ${plan.name}');
      
      // Show loading dialog
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Processing subscription...'),
            ],
          ),
        ),
      );

      // Simulate subscription process
      await Future.delayed(const Duration(seconds: 2));

      // Close loading dialog
      if (!mounted) return;
      Navigator.of(context).pop();

      // Show success message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully subscribed to ${plan.name}!'),
          backgroundColor: Colors.green,
        ),
      );

      // Reload subscription data
      await _loadSubscriptionData();
    } catch (e) {
      // Close loading dialog if still open
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      AppPrint.printError('Failed to subscribe: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to subscribe: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
} 