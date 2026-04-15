// lib/features/treinos/presentation/providers/workout_session_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/entities/workout.dart';
import '../../../../core/entities/workout_set.dart';
import '../../data/repositories/workout_repo_impl.dart';
import '../../domain/use_cases/save_workout.dart';

final workoutRepoProvider = Provider((_) => WorkoutRepoImpl());
final saveWorkoutProvider = Provider(
  (ref) => SaveWorkout(ref.read(workoutRepoProvider)),
);

enum SessionStatus { idle, active, finished }

class SessionState {
  final SessionStatus status;
  final String workoutType;
  final List<WorkoutSet> sets;
  final DateTime? startTime;
  final Workout? lastWorkout; // disponível após finish() para export

  const SessionState({
    this.status = SessionStatus.idle,
    this.workoutType = '',
    this.sets = const [],
    this.startTime,
    this.lastWorkout,
  });

  SessionState copyWith({
    SessionStatus? status,
    String? workoutType,
    List<WorkoutSet>? sets,
    DateTime? startTime,
    Workout? lastWorkout,
  }) =>
      SessionState(
        status: status ?? this.status,
        workoutType: workoutType ?? this.workoutType,
        sets: sets ?? this.sets,
        startTime: startTime ?? this.startTime,
        lastWorkout: lastWorkout ?? this.lastWorkout,
      );
}

final workoutSessionProvider =
    StateNotifierProvider<WorkoutSessionNotifier, SessionState>(
  (ref) => WorkoutSessionNotifier(ref.read(saveWorkoutProvider)),
);

class WorkoutSessionNotifier extends StateNotifier<SessionState> {
  final SaveWorkout _save;
  WorkoutSessionNotifier(this._save) : super(const SessionState());

  void start(String workoutType) {
    state = SessionState(
      status: SessionStatus.active,
      workoutType: workoutType,
      sets: const [],
      startTime: DateTime.now(),
    );
  }

  void addSet(WorkoutSet set) {
    state = state.copyWith(sets: [...state.sets, set]);
  }

  void removeSet(int index) {
    final updated = List<WorkoutSet>.from(state.sets)..removeAt(index);
    state = state.copyWith(sets: updated);
  }

  void finish({String? notes}) {
    final duration = state.startTime != null
        ? DateTime.now().difference(state.startTime!).inMinutes
        : 0;

    final workout = Workout(
      id: const Uuid().v4(),
      date: DateTime.now(),
      type: state.workoutType,
      sets: state.sets,
      notes: notes,
      durationMinutes: duration,
    );

    _save(workout);
    state = SessionState(status: SessionStatus.finished, lastWorkout: workout);
  }

  void reset() => state = const SessionState();
}
