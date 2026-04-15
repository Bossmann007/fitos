import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitos/core/entities/workout.dart';
import 'package:fitos/features/treinos/domain/repositories/workout_repository.dart';
import 'package:fitos/features/treinos/domain/use_cases/save_workout.dart';

class MockWorkoutRepository extends Mock implements WorkoutRepository {}

void main() {
  late SaveWorkout saveWorkout;
  late MockWorkoutRepository mockRepo;

  setUp(() {
    mockRepo = MockWorkoutRepository();
    saveWorkout = SaveWorkout(mockRepo);
  });

  test('deve chamar repository.saveWorkout com workout correto', () {
    final workout = Workout(
      id: 'test-id',
      date: DateTime(2026, 4, 15),
      type: 'Full Body A',
      sets: const [],
      durationMinutes: 45,
    );
    when(() => mockRepo.saveWorkout(workout)).thenReturn(null);

    saveWorkout(workout);

    verify(() => mockRepo.saveWorkout(workout)).called(1);
  });
}
