import 'package:equatable/equatable.dart';
import 'workout.dart';
import 'exercise.dart';

/// WorkoutExercise model representing the relationship between workouts and exercises
class WorkoutExercise extends Equatable {
  static const String tableName = 'workout_exercises';

  final String workoutExerciseId;
  final String workoutId;
  final String exerciseId;
  final int orderNum;
  final int? sets;
  final int? reps;
  final int? restTime;
  
  // Related models (optional, populated when joined)
  final Workout? workout;
  final Exercise? exercise;

  const WorkoutExercise({
    required this.workoutExerciseId,
    required this.workoutId,
    required this.exerciseId,
    required this.orderNum,
    this.sets,
    this.reps,
    this.restTime,
    this.workout,
    this.exercise,
  });

  /// Creates a WorkoutExercise from JSON data
  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      workoutExerciseId: json['workout_exercise_id'] as String,
      workoutId: json['workout_id'] as String,
      exerciseId: json['exercise_id'] as String,
      orderNum: json['order_num'] as int,
      sets: json['sets'] as int?,
      reps: json['reps'] as int?,
      restTime: json['rest_time'] as int?,
      workout: json['workout'] != null 
          ? Workout.fromJson(json['workout'] as Map<String, dynamic>) 
          : null,
      exercise: json['exercise'] != null 
          ? Exercise.fromJson(json['exercise'] as Map<String, dynamic>) 
          : null,
    );
  }

  /// Converts WorkoutExercise to JSON data
  Map<String, dynamic> toJson() {
    return {
      'workout_exercise_id': workoutExerciseId,
      'workout_id': workoutId,
      'exercise_id': exerciseId,
      'order_num': orderNum,
      'sets': sets,
      'reps': reps,
      'rest_time': restTime,
      'workout': workout?.toJson(),
      'exercise': exercise?.toJson(),
    };
  }

  /// Creates a copy of WorkoutExercise with updated fields
  WorkoutExercise copyWith({
    String? workoutExerciseId,
    String? workoutId,
    String? exerciseId,
    int? orderNum,
    int? sets,
    int? reps,
    int? restTime,
    Workout? workout,
    Exercise? exercise,
  }) {
    return WorkoutExercise(
      workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderNum: orderNum ?? this.orderNum,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      restTime: restTime ?? this.restTime,
      workout: workout ?? this.workout,
      exercise: exercise ?? this.exercise,
    );
  }

  @override
  List<Object?> get props => [
    workoutExerciseId,
    workoutId,
    exerciseId,
    orderNum,
    sets,
    reps,
    restTime,
    workout,
    exercise,
  ];

  @override
  String toString() {
    return 'WorkoutExercise(workoutExerciseId: $workoutExerciseId, workoutId: $workoutId, exerciseId: $exerciseId, orderNum: $orderNum)';
  }
} 