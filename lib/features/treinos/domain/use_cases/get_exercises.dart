import '../../../../core/entities/exercise.dart';
import '../../../../core/use_cases/use_case.dart';
import '../repositories/workout_repository.dart';

class GetExercises extends UseCase<List<Exercise>, NoParams> {
  final WorkoutRepository repository;
  GetExercises(this.repository);

  @override
  List<Exercise> call(NoParams params) => repository.getExercises();
}
