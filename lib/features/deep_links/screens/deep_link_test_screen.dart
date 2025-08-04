import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/services/deep_link_service.dart';
import '../../../core/services/url_service.dart';

/// Screen for testing deep link functionality
class DeepLinkTestScreen extends StatefulWidget {
  const DeepLinkTestScreen({super.key});

  @override
  State<DeepLinkTestScreen> createState() => _DeepLinkTestScreenState();
}

class _DeepLinkTestScreenState extends State<DeepLinkTestScreen> {
  final List<String> _testLinks = DeepLinkService.getTestDeepLinks();
  final TextEditingController _customLinkController = TextEditingController();

  @override
  void dispose() {
    _customLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep Link Testing'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection(),
            const SizedBox(height: 24),
            _buildCustomLinkSection(),
            const SizedBox(height: 24),
            _buildTestLinksSection(),
            const SizedBox(height: 24),
            _buildGeneratedLinksSection(),
          ],
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
            const Text(
              'Deep Link Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This screen allows you to test deep link functionality for the Icon App.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              'Supported Schemes:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Text('• icon:// - Custom scheme'),
            const Text('• https://icon.com - Universal links'),
            const SizedBox(height: 8),
            const Text(
              'Supported Paths:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Text('• /profile - User profile'),
            const Text('• /settings - App settings'),
            const Text('• /badge - Badge details'),
            const Text('• /feedback - Feedback form'),
            const Text('• /help - Help center'),
            const Text('• /privacy - Privacy policy'),
            const Text('• /terms - Terms of service'),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomLinkSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test Custom Link',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _customLinkController,
              decoration: const InputDecoration(
                labelText: 'Enter deep link URL',
                hintText: 'e.g., icon://profile?userId=123',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _testCustomLink,
                    child: const Text('Test Link'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearCustomLink,
                    child: const Text('Clear'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestLinksSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Predefined Test Links',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...(_testLinks.map((link) => _buildTestLinkItem(link))),
          ],
        ),
      ),
    );
  }

  Widget _buildTestLinkItem(String link) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                link,
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _testLink(link),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Text('Test'),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratedLinksSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Generate Deep Links',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildGeneratedLinkButton(
              'Profile Link',
              DeepLinkService.generateDeepLink(
                path: '/profile',
                queryParameters: {'userId': '123', 'section': 'badges'},
              ),
            ),
            _buildGeneratedLinkButton(
              'Settings Link',
              DeepLinkService.generateDeepLink(
                path: '/settings',
                queryParameters: {'section': 'notifications'},
              ),
            ),
            _buildGeneratedLinkButton(
              'Badge Link',
              DeepLinkService.generateDeepLink(
                path: '/badge',
                queryParameters: {'badgeId': '456', 'action': 'view'},
              ),
            ),
            _buildGeneratedLinkButton(
              'Feedback Link',
              DeepLinkService.generateDeepLink(
                path: '/feedback',
                queryParameters: {'type': 'bug', 'subject': 'app_crash'},
              ),
            ),
            _buildGeneratedLinkButton(
              'Help Link',
              DeepLinkService.generateDeepLink(
                path: '/help',
                queryParameters: {'topic': 'getting_started'},
              ),
            ),
            _buildGeneratedLinkButton(
              'HTTPS Profile Link',
              DeepLinkService.generateDeepLink(
                path: '/profile',
                queryParameters: {'userId': '123', 'section': 'badges'},
                useHttps: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratedLinkButton(String label, String link) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _testLink(link),
              child: Text(label),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _copyToClipboard(link),
            icon: const Icon(Icons.copy),
            tooltip: 'Copy to clipboard',
          ),
        ],
      ),
    );
  }

  void _testCustomLink() {
    final link = _customLinkController.text.trim();
    if (link.isNotEmpty) {
      _testLink(link);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a link to test'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _clearCustomLink() {
    _customLinkController.clear();
  }

  void _testLink(String link) async {
    try {
      final uri = Uri.parse(link);
      final success = await launchUrl(uri);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully opened: $link'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open: $link'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error testing link: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _copyToClipboard(String text) {
    // Note: In a real app, you'd use a clipboard plugin
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard: $text'),
        backgroundColor: Colors.blue,
      ),
    );
  }
} 