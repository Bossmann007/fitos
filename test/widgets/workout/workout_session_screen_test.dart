// test/widgets/workout/workout_session_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitos/core/entities/workout.dart';
import 'package:fitos/features/treinos/presentation/workout_session_screen.dart';
import 'package:fitos/features/treinos/presentation/providers/workout_session_provider.dart';
import 'package:fitos/features/treinos/domain/repositories/workout_repository.dart';
import 'package:fitos/features/treinos/domain/use_cases/save_workout.dart';

class MockWorkoutRepository extends Mock implements WorkoutRepository {}

// Fake necessário para mocktail poder usar any() com tipo Workout
class _FakeWorkout extends Fake implements Workout {}

void main() {
  late MockWorkoutRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(_FakeWorkout());
  });

  setUp(() {
    mockRepo = MockWorkoutRepository();
    when(() => mockRepo.saveWorkout(any())).thenReturn(null);
    when(() => mockRepo.getHistory()).thenReturn([]);
    when(() => mockRepo.getExercises()).thenReturn([]);
  });

  testWidgets('WorkoutSessionScreen exibe mensagem inicial vazia',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workoutSessionProvider.overrideWith(
            (ref) => WorkoutSessionNotifier(SaveWorkout(mockRepo))
              ..start('Full Body A'),
          ),
        ],
        child: const MaterialApp(home: WorkoutSessionScreen()),
      ),
    );

    expect(find.text('Adicione exercícios para começar'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('WorkoutSessionScreen mostra nome do treino no AppBar',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workoutSessionProvider.overrideWith(
            (ref) => WorkoutSessionNotifier(SaveWorkout(mockRepo))
              ..start('Full Body B'),
          ),
        ],
        child: const MaterialApp(home: WorkoutSessionScreen()),
      ),
    );

    expect(find.text('Full Body B'), findsOneWidget);
  });
}
