import '../../../../core/entities/workout.dart';
import '../../../../core/use_cases/use_case.dart';
import '../repositories/workout_repository.dart';

class SaveWorkout extends UseCase<void, Workout> {
  final WorkoutRepository repository;
  SaveWorkout(this.repository);

  @override
  void call(Workout params) => repository.saveWorkout(params);
}
