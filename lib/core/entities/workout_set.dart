// lib/core/entities/workout_set.dart
class WorkoutSet {
  final String exerciseId;
  final String exerciseName; // desnormalizado para exibição rápida
  final int sets;
  final int reps;
  final double weight; // kg; 0.0 para peso corporal
  final int restSeconds;

  const WorkoutSet({
    required this.exerciseId,
    required this.exerciseName,
    required this.sets,
    required this.reps,
    required this.weight,
    this.restSeconds = 60,
  });

  /// Volume total = sets × reps × peso — O(1)
  double get volume => sets * reps * weight;
}
