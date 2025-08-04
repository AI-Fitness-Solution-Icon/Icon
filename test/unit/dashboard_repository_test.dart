import 'package:flutter_test/flutter_test.dart';
import 'package:icon_app/features/dashboard/data/dashboard_repository.dart';
import 'package:icon_app/features/dashboard/models/goal.dart';
import 'package:icon_app/features/dashboard/models/progress.dart';
import 'package:icon_app/features/dashboard/models/muscle_group.dart';
import 'package:icon_app/features/dashboard/models/workout_challenge.dart';

import 'package:icon_app/core/services/supabase_service.dart';
import 'package:mockito/annotations.dart';

import 'dashboard_repository_test.mocks.dart';

@GenerateMocks([SupabaseService])
void main() {
  late DashboardRepository dashboardRepository;
  late MockSupabaseService mockSupabaseService;

  setUp(() {
    mockSupabaseService = MockSupabaseService();
    dashboardRepository = DashboardRepository(supabaseService: mockSupabaseService);
  });

  group('DashboardRepository', () {
    test('getGoals returns a list of goals', () async {
      final goals = await dashboardRepository.getGoals(DateTime.now());
      expect(goals, isA<List<Goal>>());
      expect(goals.isNotEmpty, isTrue);
    });

    test('getProgress returns a progress object', () async {
      final progress = await dashboardRepository.getProgress(DateTime.now());
      expect(progress, isA<Progress>());
    });

    test('getMuscleGroups returns a list of muscle groups', () async {
      final muscleGroups = await dashboardRepository.getMuscleGroups(DateTime.now());
      expect(muscleGroups, isA<List<MuscleGroup>>());
      expect(muscleGroups.isNotEmpty, isTrue);
    });

    test('getWorkoutChallenges returns a list of workout challenges', () async {
      final challenges = await dashboardRepository.getWorkoutChallenges();
      expect(challenges, isA<List<WorkoutChallenge>>());
      expect(challenges.isNotEmpty, isTrue);
    });

    test('updateGoal completes without errors', () async {
      await dashboardRepository.updateGoal('1', 100.0);
    });

    test('acceptWorkoutChallenge completes without errors', () async {
      await dashboardRepository.acceptWorkoutChallenge('1');
    });

    test('dismissWorkoutChallenge completes without errors', () async {
      await dashboardRepository.dismissWorkoutChallenge('1');
    });
  });
}