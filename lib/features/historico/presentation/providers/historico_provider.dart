// lib/features/historico/presentation/providers/historico_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/entities/workout.dart';
import '../../../../core/use_cases/use_case.dart';
import '../../../treinos/domain/use_cases/get_workout_history.dart';
import '../../../treinos/presentation/providers/workout_session_provider.dart';

final getHistoryProvider = Provider(
  (ref) => GetWorkoutHistory(ref.read(workoutRepoProvider)),
);

/// Recarrega ao completar uma sessão
final historicoProvider = Provider<List<Workout>>((ref) {
  ref.watch(workoutSessionProvider);
  return ref.read(getHistoryProvider)(const NoParams());
});
