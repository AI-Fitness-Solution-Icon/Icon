import 'package:equatable/equatable.dart';
import '../models/goal.dart';
import '../models/progress.dart';
import '../models/muscle_group.dart';
import '../models/workout_challenge.dart';

/// Base class for all dashboard states
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the dashboard starts
class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

/// State when dashboard data is loading
class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

/// State when dashboard data is loaded successfully
class DashboardLoaded extends DashboardState {
  final List<Goal> goals;
  final Progress progress;
  final List<MuscleGroup> muscleGroups;
  final List<WorkoutChallenge> workoutChallenges;
  final DateTime selectedDate;

  const DashboardLoaded({
    required this.goals,
    required this.progress,
    required this.muscleGroups,
    required this.workoutChallenges,
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [
    goals,
    progress,
    muscleGroups,
    workoutChallenges,
    selectedDate,
  ];

  /// Create a copy with updated values
  DashboardLoaded copyWith({
    List<Goal>? goals,
    Progress? progress,
    List<MuscleGroup>? muscleGroups,
    List<WorkoutChallenge>? workoutChallenges,
    DateTime? selectedDate,
  }) {
    return DashboardLoaded(
      goals: goals ?? this.goals,
      progress: progress ?? this.progress,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      workoutChallenges: workoutChallenges ?? this.workoutChallenges,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

/// State when dashboard loading fails
class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
} 