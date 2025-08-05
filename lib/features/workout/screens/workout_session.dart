import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_print.dart';
import '../../../core/widgets/back_button_widget.dart';

/// Workout session screen for active workout tracking
class WorkoutSession extends StatefulWidget {
  final String workoutId;

  const WorkoutSession({
    super.key,
    required this.workoutId,
  });

  @override
  State<WorkoutSession> createState() => _WorkoutSessionState();
}

class _WorkoutSessionState extends State<WorkoutSession> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  int _currentExerciseIndex = 0;
  bool _isPaused = false;
  bool _isCompleted = false;

  // Mock workout data
  final List<Map<String, dynamic>> _exercises = [
    {
      'name': 'Push-ups',
      'sets': 3,
      'reps': 10,
      'restTime': 60, // seconds
      'completed': false,
    },
    {
      'name': 'Squats',
      'sets': 3,
      'reps': 15,
      'restTime': 60,
      'completed': false,
    },
    {
      'name': 'Plank',
      'sets': 3,
      'duration': 30, // seconds
      'restTime': 45,
      'completed': false,
    },
    {
      'name': 'Jumping Jacks',
      'sets': 3,
      'reps': 20,
      'restTime': 60,
      'completed': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && !_isCompleted) {
        setState(() {
          _elapsedSeconds++;
        });
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _completeExercise() {
    if (_currentExerciseIndex < _exercises.length) {
      setState(() {
        _exercises[_currentExerciseIndex]['completed'] = true;
      });
    }
  }

  void _nextExercise() {
    if (_currentExerciseIndex < _exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
      });
    } else {
      _completeWorkout();
    }
  }

  void _previousExercise() {
    if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
      });
    }
  }

  void _completeWorkout() {
    setState(() {
      _isCompleted = true;
    });
    _timer?.cancel();
    
    AppPrint.printInfo('Workout completed! Duration: ${_formatTime(_elapsedSeconds)}');
    
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Workout Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text('Great job! You completed your workout in ${_formatTime(_elapsedSeconds)}.'),
            const SizedBox(height: 8),
            Text('Exercises completed: ${_exercises.where((e) => e['completed']).length}/${_exercises.length}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
              context.pop(); // Go back to workout home
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCompleted) {
      return Scaffold(
        appBar: AppBar(
          leading: const BackButtonWidget(fallbackRoute: '/workout'),
          title: const Text('Workout Complete'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Workout completed!'),
        ),
      );
    }

    final currentExercise = _exercises[_currentExerciseIndex];
    final progress = (_currentExerciseIndex + 1) / _exercises.length;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(fallbackRoute: '/workout'),
        title: const Text('Workout Session'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: _togglePause,
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          
          // Timer and Stats
          Container(
            padding: const EdgeInsets.all(16.0),
            color: AppColors.primary.withValues(alpha: 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  'Time',
                  _formatTime(_elapsedSeconds),
                  Icons.timer,
                ),
                _buildStatCard(
                  'Exercise',
                  '${_currentExerciseIndex + 1}/${_exercises.length}',
                  Icons.fitness_center,
                ),
                _buildStatCard(
                  'Completed',
                  '${_exercises.where((e) => e['completed']).length}',
                  Icons.check_circle,
                ),
              ],
            ),
          ),

          // Current Exercise
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Exercise Header
                  Text(
                    'Current Exercise',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Exercise Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.fitness_center,
                            size: 64,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            currentExercise['name'],
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          
                          // Exercise Details
                          if (currentExercise['reps'] != null) ...[
                            Text(
                              '${currentExercise['sets']} sets × ${currentExercise['reps']} reps',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ] else if (currentExercise['duration'] != null) ...[
                            Text(
                              '${currentExercise['sets']} sets × ${currentExercise['duration']} seconds',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                          
                          const SizedBox(height: 8),
                          Text(
                            'Rest: ${currentExercise['restTime']} seconds',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _currentExerciseIndex > 0 ? _previousExercise : null,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black87,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _completeExercise(),
                        icon: const Icon(Icons.check),
                        label: const Text('Complete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _currentExerciseIndex < _exercises.length - 1 ? _nextExercise : null,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Exercise List
          Container(
            height: 120,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Workout Plan',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = _exercises[index];
                      final isCurrent = index == _currentExerciseIndex;
                      final isCompleted = exercise['completed'] == true;
                      
                      return Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 8.0),
                        child: Card(
                                                     color: isCurrent 
                               ? AppColors.primary.withValues(alpha: 0.1)
                               : isCompleted 
                                   ? Colors.green.withValues(alpha: 0.1)
                                   : null,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isCompleted ? Icons.check_circle : Icons.fitness_center,
                                  color: isCompleted ? Colors.green : AppColors.primary,
                                  size: 24,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  exercise['name'],
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
} 