// lib/features/progresso/presentation/providers/progresso_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../historico/presentation/providers/historico_provider.dart';

final volumeChartDataProvider = Provider<List<FlSpot>>((ref) {
  final history = ref.watch(historicoProvider);
  return history.reversed.toList().asMap().entries.map((e) {
    return FlSpot(e.key.toDouble(), e.value.totalVolume);
  }).toList();
});

final selectedExerciseProvider = StateProvider<String?>((ref) => null);

final exerciseProgressProvider = Provider<List<FlSpot>>((ref) {
  final history = ref.watch(historicoProvider);
  final selected = ref.watch(selectedExerciseProvider);
  if (selected == null) return [];

  final points = <FlSpot>[];
  int i = 0;
  for (final workout in history.reversed) {
    final maxWeight = workout.sets
        .where((s) => s.exerciseName == selected)
        .fold<double>(0, (max, s) => s.weight > max ? s.weight : max);
    if (maxWeight > 0) points.add(FlSpot(i.toDouble(), maxWeight));
    i++;
  }
  return points;
});
