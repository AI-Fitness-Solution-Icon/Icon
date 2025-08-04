import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Voice control buttons for AI coach interaction
class VoiceControls extends StatelessWidget {
  final bool isListening;
  final bool isSpeaking;
  final bool isLoading;
  final VoidCallback? onStartListening;
  final VoidCallback? onStopListening;
  final VoidCallback? onStopSpeaking;
  final VoidCallback? onEmergencyStop;
  final VoidCallback? onSettings;

  const VoiceControls({
    super.key,
    this.isListening = false,
    this.isSpeaking = false,
    this.isLoading = false,
    this.onStartListening,
    this.onStopListening,
    this.onStopSpeaking,
    this.onEmergencyStop,
    this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main control button
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getMainButtonColor(),
            boxShadow: [
              BoxShadow(
                color: _getMainButtonColor().withValues(alpha: 0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(60),
              onTap: _handleMainButtonTap,
              child: Center(
                child: _buildMainButtonContent(),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Secondary controls
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Emergency stop button
            if (isListening || isSpeaking)
              _buildSecondaryButton(
                icon: Icons.stop,
                color: Colors.red,
                onTap: onEmergencyStop,
                tooltip: 'Emergency Stop',
              ),
            
            // Settings button
            _buildSecondaryButton(
              icon: Icons.settings,
              color: AppColors.textSecondary,
              onTap: onSettings,
              tooltip: 'Voice Settings',
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Instructions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                _getInstructions(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainButtonContent() {
    if (isLoading) {
      return const SizedBox(
        width: 40,
        height: 40,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    IconData icon;
    double size;

    if (isListening) {
      icon = Icons.mic;
      size = 50;
    } else if (isSpeaking) {
      icon = Icons.volume_up;
      size = 50;
    } else {
      icon = Icons.mic_none;
      size = 50;
    }

    return Icon(
      icon,
      size: size,
      color: Colors.white,
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.1),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: onTap,
            child: Center(
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getMainButtonColor() {
    if (isLoading) {
      return Colors.grey;
    } else if (isListening) {
      return AppColors.primary;
    } else if (isSpeaking) {
      return AppColors.secondary;
    } else {
      return AppColors.primary;
    }
  }

  void _handleMainButtonTap() {
    if (isLoading) return;

    if (isListening) {
      onStopListening?.call();
    } else if (isSpeaking) {
      onStopSpeaking?.call();
    } else {
      onStartListening?.call();
    }
  }

  String _getInstructions() {
    if (isLoading) {
      return 'Processing your request...';
    } else if (isListening) {
      return 'Tap to stop listening\nSpeak clearly into your microphone';
    } else if (isSpeaking) {
      return 'AI is responding\nTap to stop the response';
    } else {
      return 'Tap the microphone to start\nAsk me anything about your workout!';
    }
  }
} 