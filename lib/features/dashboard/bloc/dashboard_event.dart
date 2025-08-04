import 'package:equatable/equatable.dart';

/// Base class for all dashboard events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load dashboard data for a specific date
class LoadDashboardData extends DashboardEvent {
  final DateTime date;

  const LoadDashboardData(this.date);

  @override
  List<Object?> get props => [date];
}

/// Event to refresh dashboard data
class RefreshDashboardData extends DashboardEvent {
  const RefreshDashboardData();
}

/// Event to update a goal
class UpdateGoal extends DashboardEvent {
  final String goalId;
  final double progress;

  const UpdateGoal({
    required this.goalId,
    required this.progress,
  });

  @override
  List<Object?> get props => [goalId, progress];
}

/// Event to accept a workout challenge
class AcceptWorkoutChallenge extends DashboardEvent {
  final String challengeId;

  const AcceptWorkoutChallenge(this.challengeId);

  @override
  List<Object?> get props => [challengeId];
}

/// Event to dismiss a workout challenge
class DismissWorkoutChallenge extends DashboardEvent {
  final String challengeId;

  const DismissWorkoutChallenge(this.challengeId);

  @override
  List<Object?> get props => [challengeId];
} 