import '../../../../core/entities/workout.dart';
import '../../../../core/use_cases/use_case.dart';
import '../repositories/workout_repository.dart';

class GetWorkoutHistory extends UseCase<List<Workout>, NoParams> {
  final WorkoutRepository repository;
  GetWorkoutHistory(this.repository);

  @override
  List<Workout> call(NoParams params) => repository.getHistory();
}
