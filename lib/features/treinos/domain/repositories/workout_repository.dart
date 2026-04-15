import '../../../../core/entities/workout.dart';
import '../../../../core/entities/exercise.dart';

abstract class WorkoutRepository {
  void saveWorkout(Workout workout);
  /// Retorna treinos ordenados por data desc — O(n log n)
  List<Workout> getHistory();
  List<Exercise> getExercises();
}
