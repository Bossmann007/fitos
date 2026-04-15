// test/features/export/obsidian_formatter_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fitos/features/export/domain/obsidian_formatter.dart';
import 'package:fitos/core/entities/workout.dart';
import 'package:fitos/core/entities/workout_set.dart';
import 'package:fitos/core/entities/daily_log.dart';

void main() {
  late ObsidianFormatter formatter;

  setUp(() => formatter = ObsidianFormatter());

  final workout = Workout(
    id: 'test',
    date: DateTime(2026, 4, 15),
    type: 'Full Body A',
    sets: const [
      WorkoutSet(
        exerciseId: '1',
        exerciseName: 'Supino Reto',
        sets: 3,
        reps: 8,
        weight: 60.0,
      ),
    ],
    durationMinutes: 45,
    dailyLog: const DailyLog(date: '2026-04-15', energia: 8, fadiga: 3),
  );

  test('inclui data no formato yyyy-MM-dd no título', () {
    expect(formatter.format(workout), contains('2026-04-15'));
  });

  test('inclui tipo de treino no título', () {
    expect(formatter.format(workout), contains('Full Body A'));
  });

  test('inclui tag #fitos', () {
    expect(formatter.format(workout), contains('#fitos'));
  });

  test('lista exercício com séries e peso', () {
    final md = formatter.format(workout);
    expect(md, contains('Supino Reto'));
    expect(md, contains('3x8'));
    expect(md, contains('60.0kg'));
  });

  test('inclui link [[MOC - Saúde e Fitness]]', () {
    expect(formatter.format(workout), contains('[[MOC - Saúde e Fitness]]'));
  });

  test('inclui energia e fadiga quando dailyLog presente', () {
    final md = formatter.format(workout);
    expect(md, contains('8/10'));
    expect(md, contains('3/10'));
  });

  test('fileName segue padrão YYYY-MM-DD — Treino Tipo.md', () {
    expect(
      formatter.fileName(workout),
      equals('2026-04-15 — Treino Full Body A.md'),
    );
  });
}
