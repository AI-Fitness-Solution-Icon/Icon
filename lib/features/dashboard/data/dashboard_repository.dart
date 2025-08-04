import 'package:flutter/material.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/utils/app_print.dart';
import '../models/goal.dart';
import '../models/progress.dart';
import '../models/muscle_group.dart';
import '../models/workout_challenge.dart';

/// Repository for dashboard data operations
class DashboardRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  /// Get goals for a specific date
  Future<List<Goal>> getGoals(DateTime date) async {
    try {
      AppPrint.printInfo('Fetching goals for date: $date');
      
      // For now, return mock data
      // In a real app, this would fetch from Supabase
      return [
        Goal(
          id: '1',
          title: 'Daily Steps',
          description: 'Walk 10,000 steps today',
          type: GoalType.steps,
          target: 10000,
          current: 8200,
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
        Goal(
          id: '2',
          title: 'Calories Burned',
          description: 'Burn 500 calories through exercise',
          type: GoalType.calories,
          target: 500,
          current: 425,
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
        Goal(
          id: '3',
          title: 'Protein Intake',
          description: 'Consume 150g of protein',
          type: GoalType.protein,
          target: 150,
          current: 120,
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
        Goal(
          id: '4',
          title: 'Recovery Score',
          description: 'Achieve 80% recovery score',
          type: GoalType.recovery,
          target: 80,
          current: 78,
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
        Goal(
          id: '5',
          title: 'Workout Session',
          description: 'Complete 1 workout session',
          type: GoalType.workout,
          target: 1,
          current: 1,
          isCompleted: true,
          createdAt: DateTime.now(),
        ),
      ];
    } catch (e) {
      AppPrint.printError('Failed to fetch goals: $e');
      rethrow;
    }
  }

  /// Get progress data for a specific date
  Future<Progress> getProgress(DateTime date) async {
    try {
      AppPrint.printInfo('Fetching progress for date: $date');
      
      // For now, return mock data
      // In a real app, this would fetch from Supabase
      return Progress(
        recoveryScore: 78,
        heartRate: 62,
        caloriesLeft: 1100,
        proteinLeft: 80,
        stepsLeft: 1800,
        caloriesBurned: 2425,
        date: DateTime.now(),
      );
    } catch (e) {
      AppPrint.printError('Failed to fetch progress: $e');
      rethrow;
    }
  }

  /// Get muscle groups for a specific date
  Future<List<MuscleGroup>> getMuscleGroups(DateTime date) async {
    try {
      AppPrint.printInfo('Fetching muscle groups for date: $date');
      
      // For now, return mock data
      // In a real app, this would fetch from Supabase
      return [
        const MuscleGroup(
          id: '1',
          name: 'Chest',
          view: BodyView.front,
          position: Offset(40, 30),
          size: Size(20, 20),
          color: Colors.red,
        ),
        const MuscleGroup(
          id: '2',
          name: 'Shoulders',
          view: BodyView.front,
          position: Offset(30, 20),
          size: Size(15, 15),
          color: Colors.red,
        ),
        const MuscleGroup(
          id: '3',
          name: 'Quads',
          view: BodyView.front,
          position: Offset(35, 60),
          size: Size(18, 25),
          color: Colors.blue,
        ),
        const MuscleGroup(
          id: '4',
          name: 'Back',
          view: BodyView.back,
          position: Offset(40, 30),
          size: Size(20, 20),
          color: Colors.red,
        ),
        const MuscleGroup(
          id: '5',
          name: 'Glutes',
          view: BodyView.back,
          position: Offset(35, 50),
          size: Size(18, 18),
          color: Colors.blue,
        ),
        const MuscleGroup(
          id: '6',
          name: 'Heart',
          view: BodyView.internal,
          position: Offset(40, 35),
          size: Size(12, 12),
          color: Colors.red,
        ),
      ];
    } catch (e) {
      AppPrint.printError('Failed to fetch muscle groups: $e');
      rethrow;
    }
  }

  /// Get workout challenges
  Future<List<WorkoutChallenge>> getWorkoutChallenges() async {
    try {
      AppPrint.printInfo('Fetching workout challenges');
      
      // For now, return mock data
      // In a real app, this would fetch from Supabase
      return [
        WorkoutChallenge(
          id: '1',
          senderId: 'user1',
          senderName: 'Ashley',
          challengeType: 'steps',
          description: 'Walk 15,000 steps today',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          expiresAt: DateTime.now().add(const Duration(days: 1)),
        ),
        WorkoutChallenge(
          id: '2',
          senderId: 'user2',
          senderName: 'Mike',
          challengeType: 'calories',
          description: 'Burn 600 calories',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          expiresAt: DateTime.now().add(const Duration(days: 1)),
        ),
      ];
    } catch (e) {
      AppPrint.printError('Failed to fetch workout challenges: $e');
      rethrow;
    }
  }

  /// Update a goal
  Future<void> updateGoal(String goalId, double progress) async {
    try {
      AppPrint.printInfo('Updating goal: $goalId with progress: $progress');
      
      // In a real app, this would update in Supabase
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call
    } catch (e) {
      AppPrint.printError('Failed to update goal: $e');
      rethrow;
    }
  }

  /// Accept a workout challenge
  Future<void> acceptWorkoutChallenge(String challengeId) async {
    try {
      AppPrint.printInfo('Accepting workout challenge: $challengeId');
      
      // In a real app, this would update in Supabase
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call
    } catch (e) {
      AppPrint.printError('Failed to accept workout challenge: $e');
      rethrow;
    }
  }

  /// Dismiss a workout challenge
  Future<void> dismissWorkoutChallenge(String challengeId) async {
    try {
      AppPrint.printInfo('Dismissing workout challenge: $challengeId');
      
      // In a real app, this would update in Supabase
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call
    } catch (e) {
      AppPrint.printError('Failed to dismiss workout challenge: $e');
      rethrow;
    }
  }
} 