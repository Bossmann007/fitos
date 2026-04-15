// lib/core/entities/workout.dart
import 'workout_set.dart';
import 'daily_log.dart';

class Workout {
  final String id;
  final DateTime date;
  final String type; // "Full Body A", "Calistenia", etc.
  final List<WorkoutSet> sets;
  final String? notes;
  final int durationMinutes;
  final DailyLog? dailyLog;

  const Workout({
    required this.id,
    required this.date,
    required this.type,
    required this.sets,
    this.notes,
    required this.durationMinutes,
    this.dailyLog,
  });

  /// Volume total da sessão — O(n) onde n = número de exercícios
  double get totalVolume =>
      sets.fold(0.0, (sum, s) => sum + s.volume);
}
