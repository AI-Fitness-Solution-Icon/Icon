import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/app_print.dart';
import '../data/dashboard_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

/// BLoC for managing dashboard state
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _dashboardRepository;

  DashboardBloc({required DashboardRepository dashboardRepository})
      : _dashboardRepository = dashboardRepository,
        super(const DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<RefreshDashboardData>(_onRefreshDashboardData);
    on<UpdateGoal>(_onUpdateGoal);
    on<AcceptWorkoutChallenge>(_onAcceptWorkoutChallenge);
    on<DismissWorkoutChallenge>(_onDismissWorkoutChallenge);
  }

  /// Handle load dashboard data request
  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    try {
      AppPrint.printInfo('Loading dashboard data for date: ${event.date}');
      
      final goals = await _dashboardRepository.getGoals(event.date);
      final progress = await _dashboardRepository.getProgress(event.date);
      final muscleGroups = await _dashboardRepository.getMuscleGroups(event.date);
      final workoutChallenges = await _dashboardRepository.getWorkoutChallenges();

      emit(DashboardLoaded(
        goals: goals,
        progress: progress,
        muscleGroups: muscleGroups,
        workoutChallenges: workoutChallenges,
        selectedDate: event.date,
      ));
    } catch (e) {
      AppPrint.printError('Failed to load dashboard data: $e');
      emit(DashboardError(message: e.toString()));
    }
  }

  /// Handle refresh dashboard data request
  Future<void> _onRefreshDashboardData(
    RefreshDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      add(LoadDashboardData(currentState.selectedDate));
    }
  }

  /// Handle update goal request
  Future<void> _onUpdateGoal(
    UpdateGoal event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      AppPrint.printInfo('Updating goal: ${event.goalId} with progress: ${event.progress}');
      
      await _dashboardRepository.updateGoal(event.goalId, event.progress);
      
      // Refresh the dashboard data
      add(const RefreshDashboardData());
    } catch (e) {
      AppPrint.printError('Failed to update goal: $e');
      emit(DashboardError(message: e.toString()));
    }
  }

  /// Handle accept workout challenge request
  Future<void> _onAcceptWorkoutChallenge(
    AcceptWorkoutChallenge event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      AppPrint.printInfo('Accepting workout challenge: ${event.challengeId}');
      
      await _dashboardRepository.acceptWorkoutChallenge(event.challengeId);
      
      // Refresh the dashboard data
      add(const RefreshDashboardData());
    } catch (e) {
      AppPrint.printError('Failed to accept workout challenge: $e');
      emit(DashboardError(message: e.toString()));
    }
  }

  /// Handle dismiss workout challenge request
  Future<void> _onDismissWorkoutChallenge(
    DismissWorkoutChallenge event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      AppPrint.printInfo('Dismissing workout challenge: ${event.challengeId}');
      
      await _dashboardRepository.dismissWorkoutChallenge(event.challengeId);
      
      // Refresh the dashboard data
      add(const RefreshDashboardData());
    } catch (e) {
      AppPrint.printError('Failed to dismiss workout challenge: $e');
      emit(DashboardError(message: e.toString()));
    }
  }
} 