import 'package:flutter/material.dart';
import '../../../core/widgets/back_button_widget.dart';

/// Voice interaction screen for voice-based AI coaching
class VoiceInteraction extends StatelessWidget {
  const VoiceInteraction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(fallbackRoute: '/ai-coach'),
        title: const Text('Voice Coach'),
      ),
      body: const Center(
        child: Text('Voice Interaction Screen - Coming Soon'),
      ),
    );
  }
} 