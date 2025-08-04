import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/url_service.dart';
import '../../../core/utils/app_print.dart';
import '../../../core/utils/toast_util.dart';

/// Help screen for user support and assistance
class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<FAQItem> _faqs = [
    FAQItem(
      question: 'How do I create a workout plan?',
      answer: 'Go to the Workouts tab and tap the "+" button to create a new workout plan. You can customize exercises, sets, and reps.',
    ),
    FAQItem(
      question: 'How do I track my progress?',
      answer: 'Your progress is automatically tracked in the Progress tab. You can view charts, statistics, and achievements.',
    ),
    FAQItem(
      question: 'Can I sync with other fitness apps?',
      answer: 'Currently, we support syncing with Apple Health and Google Fit. More integrations are coming soon.',
    ),
    FAQItem(
      question: 'How do I change my profile settings?',
      answer: 'Go to Settings > Profile to update your personal information, fitness goals, and preferences.',
    ),
    FAQItem(
      question: 'Is my data secure?',
      answer: 'Yes, we use industry-standard encryption and security measures to protect your personal data.',
    ),
    FAQItem(
      question: 'How do I contact support?',
      answer: 'You can contact us via email at hi@icon.com or use the live chat feature in this help section.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 24),

            // Quick Actions
            _buildQuickActions(),
            const SizedBox(height: 24),

            // FAQ Section
            _buildFAQSection(),
            const SizedBox(height: 24),

            // Contact Information
            _buildContactSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.help_outline,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          Text(
            'Need Help?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'re here to help you get the most out of your fitness journey',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.feedback,
                title: 'Send Feedback',
                subtitle: 'Share your thoughts',
                onTap: _sendFeedback,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.chat,
                title: 'Live Chat',
                subtitle: 'Get instant help',
                onTap: _startLiveChat,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Asked Questions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _faqs.length,
          itemBuilder: (context, index) {
            return _buildFAQItem(_faqs[index]);
          },
        ),
      ],
    );
  }

  Widget _buildFAQItem(FAQItem faq) {
    return ExpansionTile(
      title: Text(
        faq.question,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            faq.answer,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildContactInfo(
          icon: Icons.email,
          title: 'Email',
          subtitle: 'hi@icon.com',
          onTap: _emailSupport,
        ),
        _buildContactInfo(
          icon: Icons.phone,
          title: 'Phone',
          subtitle: '+1 (555) 123-4567',
          onTap: _callSupport,
        ),
        _buildContactInfo(
          icon: Icons.schedule,
          title: 'Support Hours',
          subtitle: 'Monday - Friday, 9 AM - 6 PM EST',
          onTap: null,
        ),
        const SizedBox(height: 16),
        Text(
          'We\'re here to help! Our support team is available to assist you with any questions or issues you may have.',
          style: TextStyle(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContactInfo({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

  void _sendFeedback() {
    // Navigate to feedback form - open email client
    AppPrint.printInfo('Opening feedback form...');
    ToastUtil.showProgress(context, 'Opening feedback form...');
    
    UrlService.openEmail(
      email: 'hi@icon.com',
      subject: 'ICON App Feedback',
      body: 'Please provide your feedback here:\n\n',
    ).then((success) {
      if (mounted) {
        if (success) {
          ToastUtil.showSuccess(context, 'Email client opened successfully');
        } else {
          ToastUtil.showError(context, 'Failed to open email client. Please check your email app.');
        }
      }
    });
  }

  void _emailSupport() {
    // Open email client
    AppPrint.printInfo('Opening email client...');
    ToastUtil.showProgress(context, 'Opening email client...');
    
    UrlService.openEmail(
      email: 'hi@icon.com',
      subject: 'ICON App Support',
      body: 'Hello,\n\nI need help with the following issue:\n\n',
    ).then((success) {
      if (mounted) {
        if (success) {
          ToastUtil.showSuccess(context, 'Email client opened successfully');
        } else {
          ToastUtil.showError(context, 'Failed to open email client. Please check your email app.');
        }
      }
    });
  }

  void _startLiveChat() {
    // Start live chat
    ToastUtil.showInfo(context, 'Live chat feature coming soon!');
  }

  void _callSupport() {
    // Make phone call
    ToastUtil.showInfo(context, 'Phone support feature coming soon!');
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
} 