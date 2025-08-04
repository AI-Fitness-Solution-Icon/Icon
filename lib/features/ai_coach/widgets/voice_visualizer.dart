import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/constants/app_colors.dart';

/// Voice visualizer widget that shows audio activity
class VoiceVisualizer extends StatefulWidget {
  final bool isListening;
  final bool isSpeaking;
  final double audioLevel; // 0.0 to 1.0
  final double confidence; // 0.0 to 1.0
  final String status;

  const VoiceVisualizer({
    super.key,
    this.isListening = false,
    this.isSpeaking = false,
    this.audioLevel = 0.0,
    this.confidence = 0.0,
    this.status = '',
  });

  @override
  State<VoiceVisualizer> createState() => _VoiceVisualizerState();
}

class _VoiceVisualizerState extends State<VoiceVisualizer>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(VoiceVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isListening != oldWidget.isListening) {
      if (widget.isListening) {
        _animationController.repeat();
        _pulseController.repeat(reverse: true);
      } else {
        _animationController.stop();
        _pulseController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main visualizer
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getBackgroundColor(),
            boxShadow: [
              BoxShadow(
                color: _getShadowColor(),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulse animation
              if (widget.isListening || widget.isSpeaking)
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _getPulseColor(),
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              
              // Audio level bars
              if (widget.isListening)
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(150, 150),
                      painter: AudioVisualizerPainter(
                        audioLevel: widget.audioLevel,
                        confidence: widget.confidence,
                        animationValue: _animationController.value,
                      ),
                    );
                  },
                ),
              
              // Center icon
              Icon(
                _getIcon(),
                size: 60,
                color: _getIconColor(),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Status text
        Text(
          widget.status.isNotEmpty ? widget.status : _getStatusText(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: _getStatusColor(),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 10),
        
        // Confidence indicator
        if (widget.isListening && widget.confidence > 0)
          Column(
            children: [
              Text(
                'Confidence: ${(widget.confidence * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 5),
              LinearProgressIndicator(
                value: widget.confidence,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getConfidenceColor(),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Color _getBackgroundColor() {
    if (widget.isListening) {
      return AppColors.primary.withValues(alpha: 0.1);
    } else if (widget.isSpeaking) {
      return AppColors.secondary.withValues(alpha: 0.1);
    } else {
      return Colors.grey[200]!;
    }
  }

  Color _getShadowColor() {
    if (widget.isListening) {
      return AppColors.primary.withValues(alpha: 0.3);
    } else if (widget.isSpeaking) {
      return AppColors.secondary.withValues(alpha: 0.3);
    } else {
      return Colors.grey.withValues(alpha: 0.2);
    }
  }

  Color _getPulseColor() {
    if (widget.isListening) {
      return AppColors.primary.withValues(alpha: 0.5);
    } else if (widget.isSpeaking) {
      return AppColors.secondary.withValues(alpha: 0.5);
    } else {
      return Colors.grey.withValues(alpha: 0.3);
    }
  }

  IconData _getIcon() {
    if (widget.isListening) {
      return Icons.mic;
    } else if (widget.isSpeaking) {
      return Icons.volume_up;
    } else {
      return Icons.mic_off;
    }
  }

  Color _getIconColor() {
    if (widget.isListening) {
      return AppColors.primary;
    } else if (widget.isSpeaking) {
      return AppColors.secondary;
    } else {
      return Colors.grey;
    }
  }

  String _getStatusText() {
    if (widget.isListening) {
      return 'Listening...';
    } else if (widget.isSpeaking) {
      return 'Speaking...';
    } else {
      return 'Ready to listen';
    }
  }

  Color _getStatusColor() {
    if (widget.isListening) {
      return AppColors.primary;
    } else if (widget.isSpeaking) {
      return AppColors.secondary;
    } else {
      return AppColors.textSecondary;
    }
  }

  Color _getConfidenceColor() {
    if (widget.confidence >= 0.8) {
      return Colors.green;
    } else if (widget.confidence >= 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

/// Custom painter for audio visualizer bars
class AudioVisualizerPainter extends CustomPainter {
  final double audioLevel;
  final double confidence;
  final double animationValue;

  AudioVisualizerPainter({
    required this.audioLevel,
    required this.confidence,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const barCount = 12;
    const barWidth = 4.0;
    
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    for (int i = 0; i < barCount; i++) {
      final angle = (2 * math.pi * i) / barCount;
      final barHeight = (audioLevel * 30 + confidence * 20) * 
                       (0.5 + 0.5 * math.sin(animationValue * 2 * math.pi + i * 0.5));
      
      final startPoint = Offset(
        center.dx + (radius - barHeight) * math.cos(angle),
        center.dy + (radius - barHeight) * math.sin(angle),
      );
      
      final endPoint = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      
      canvas.drawLine(startPoint, endPoint, paint..strokeWidth = barWidth);
    }
  }

  @override
  bool shouldRepaint(AudioVisualizerPainter oldDelegate) {
    return oldDelegate.audioLevel != audioLevel ||
           oldDelegate.confidence != confidence ||
           oldDelegate.animationValue != animationValue;
  }
} 