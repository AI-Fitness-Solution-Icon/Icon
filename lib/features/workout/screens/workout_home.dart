import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/workout.dart';
import '../widgets/workout_card.dart';
import '../widgets/workout_category_card.dart';

/// Home screen for workout management
class WorkoutHomeScreen extends StatelessWidget {
  const WorkoutHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.go('/workout-history'),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/create-workout'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Start Section
            _buildQuickStartSection(context),
            const SizedBox(height: 32),

            // Workout Categories
            _buildCategoriesSection(context),
            const SizedBox(height: 32),

            // Recent Workouts
            _buildRecentWorkoutsSection(context),
            const SizedBox(height: 32),

            // Recommended Workouts
            _buildRecommendedWorkoutsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStartSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Start',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/workout-session'),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Workout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/ai-coach'),
                    icon: const Icon(Icons.psychology),
                    label: const Text('AI Coach'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Workout Categories',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            WorkoutCategoryCard(
              title: 'Strength',
              icon: Icons.fitness_center,
              color: Colors.blue,
              onTap: () => context.go('/workouts/strength'),
            ),
            WorkoutCategoryCard(
              title: 'Cardio',
              icon: Icons.directions_run,
              color: Colors.red,
              onTap: () => context.go('/workouts/cardio'),
            ),
            WorkoutCategoryCard(
              title: 'Flexibility',
              icon: Icons.accessibility_new,
              color: Colors.green,
              onTap: () => context.go('/workouts/flexibility'),
            ),
            WorkoutCategoryCard(
              title: 'Yoga',
              icon: Icons.self_improvement,
              color: Colors.purple,
              onTap: () => context.go('/workouts/yoga'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentWorkoutsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Workouts',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/workout-history'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _getRecentWorkouts().length,
            itemBuilder: (context, index) {
              final workout = _getRecentWorkouts()[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < _getRecentWorkouts().length - 1 ? 12 : 0,
                ),
                child: SizedBox(
                  width: 280,
                  child: WorkoutCard(
                    workout: workout,
                    onTap: () => context.go('/workout-details/${workout.workoutId}'),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedWorkoutsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended for You',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _getRecommendedWorkouts().length,
          itemBuilder: (context, index) {
            final workout = _getRecommendedWorkouts()[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: WorkoutCard(
                workout: workout,
                onTap: () => context.go('/workout-details/${workout.workoutId}'),
              ),
            );
          },
        ),
      ],
    );
  }

  List<Workout> _getRecentWorkouts() {
    return [
      Workout(
        workoutId: '1',
        creatorId: 'coach1',
        name: 'Morning Strength',
        description: 'Full body strength workout',
        duration: 45,
        difficultyLevel: 'Intermediate',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Workout(
        workoutId: '2',
        creatorId: 'coach1',
        name: 'Cardio Blast',
        description: 'High intensity cardio session',
        duration: 30,
        difficultyLevel: 'Advanced',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Workout(
        workoutId: '3',
        creatorId: 'coach1',
        name: 'Yoga Flow',
        description: 'Relaxing yoga session',
        duration: 60,
        difficultyLevel: 'Beginner',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  List<Workout> _getRecommendedWorkouts() {
    return [
      Workout(
        workoutId: '4',
        creatorId: 'coach1',
        name: 'Upper Body Focus',
        description: 'Target your chest, arms, and shoulders',
        duration: 40,
        difficultyLevel: 'Intermediate',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Workout(
        workoutId: '5',
        creatorId: 'coach1',
        name: 'HIIT Training',
        description: 'High intensity interval training',
        duration: 25,
        difficultyLevel: 'Advanced',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
} 