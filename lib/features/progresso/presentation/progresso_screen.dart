// lib/features/progresso/presentation/progresso_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../historico/presentation/providers/historico_provider.dart';
import 'providers/progresso_provider.dart';

class ProgressoScreen extends ConsumerWidget {
  const ProgressoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volumeData = ref.watch(volumeChartDataProvider);
    final history = ref.watch(historicoProvider);
    final selectedEx = ref.watch(selectedExerciseProvider);
    final exData = ref.watch(exerciseProgressProvider);

    final exerciseNames = <String>{
      for (final w in history)
        for (final s in w.sets) s.exerciseName
    }.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Progresso'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Volume por Sessão (kg)',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: volumeData.length < 2
                  ? const Center(
                      child: Text('Faça mais treinos para ver o gráfico'))
                  : LineChart(LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: volumeData,
                          isCurved: true,
                          color: Theme.of(context).colorScheme.primary,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                    )),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text('Progresso por Exercício',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedEx,
              hint: const Text('Selecione um exercício'),
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: exerciseNames
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) =>
                  ref.read(selectedExerciseProvider.notifier).state = v,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: exData.length < 2
                  ? const Center(child: Text('Dados insuficientes'))
                  : LineChart(LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: exData,
                          isCurved: true,
                          color: Colors.green,
                          barWidth: 3,
                        ),
                      ],
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                    )),
            ),
          ],
        ),
      ),
    );
  }
}
