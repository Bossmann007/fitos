import 'package:hive/hive.dart';
import '../../../../core/entities/workout.dart';
import '../../../../core/entities/exercise.dart';
import '../../../../data/hive/hive_boxes.dart';
import '../../domain/repositories/workout_repository.dart';
import '../models/workout_hive_model.dart';
import '../models/exercise_hive_model.dart';

class WorkoutRepoImpl implements WorkoutRepository {
  Box<WorkoutHiveModel> get _workouts =>
      Hive.box<WorkoutHiveModel>(HiveBoxes.workouts);
  Box<ExerciseHiveModel> get _exercises =>
      Hive.box<ExerciseHiveModel>(HiveBoxes.exercises);

  @override
  void saveWorkout(Workout workout) {
    _workouts.put(workout.id, WorkoutHiveModel.fromEntity(workout));
  }

  /// Ordena por data descendente — O(n log n)
  @override
  List<Workout> getHistory() {
    final list = _workouts.values.map((m) => m.toEntity()).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  List<Exercise> getExercises() =>
      _exercises.values.map((m) => m.toEntity()).toList();
}
