// lib/features/treinos/presentation/workout_session_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/entities/workout_set.dart';
import '../../export/presentation/providers/export_provider.dart';
import 'providers/workout_session_provider.dart';
import 'providers/rest_timer_provider.dart';
import 'exercise_picker_screen.dart';

class WorkoutSessionScreen extends ConsumerStatefulWidget {
  const WorkoutSessionScreen({super.key});

  @override
  ConsumerState<WorkoutSessionScreen> createState() =>
      _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState
    extends ConsumerState<WorkoutSessionScreen> {
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(workoutSessionProvider);
    final timer = ref.watch(restTimerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(session.workoutType),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Finalizar treino',
            onPressed: () => _confirmFinish(context),
          ),
        ],
      ),
      body: Column(
        children: [
          if (timer.isRunning || timer.remaining > 0)
            _RestTimerBanner(timer: timer),
          Expanded(
            child: session.sets.isEmpty
                ? const Center(
                    child: Text('Adicione exercícios para começar'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: session.sets.length,
                    itemBuilder: (_, i) =>
                        _SetCard(set: session.sets[i], index: i),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addExercise(context),
        icon: const Icon(Icons.add),
        label: const Text('Exercício'),
      ),
    );
  }

  Future<void> _addExercise(BuildContext context) async {
    final result = await Navigator.push<WorkoutSet>(
      context,
      MaterialPageRoute(builder: (_) => const ExercisePickerScreen()),
    );
    if (result != null && mounted) {
      ref.read(workoutSessionProvider.notifier).addSet(result);
      ref.read(restTimerProvider.notifier).start(result.restSeconds);
    }
  }

  void _confirmFinish(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Finalizar Treino?'),
        content: TextField(
          controller: _notesController,
          decoration: const InputDecoration(
            hintText: 'Anotações (opcional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _finish(context);
            },
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
  }

  void _finish(BuildContext context) {
    ref.read(workoutSessionProvider.notifier).finish(
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exportar para Obsidian?'),
        content: const Text(
            'Gera uma nota .md e abre o share sheet para salvar no vault.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Pular'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              final workout =
                  ref.read(workoutSessionProvider).lastWorkout;
              Navigator.pop(context);
              if (workout != null) {
                ref.read(exportProvider).exportWorkout(workout);
              }
            },
            child: const Text('Exportar'),
          ),
        ],
      ),
    );
  }
}

class _RestTimerBanner extends StatelessWidget {
  final RestTimerState timer;
  const _RestTimerBanner({required this.timer});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.timer),
          const SizedBox(width: 8),
          Text('Descanso: ${timer.remaining}s',
              style: Theme.of(context).textTheme.titleSmall),
          const Spacer(),
          SizedBox(
            width: 100,
            child: LinearProgressIndicator(value: timer.progress, minHeight: 6),
          ),
        ],
      ),
    );
  }
}

class _SetCard extends ConsumerWidget {
  final WorkoutSet set;
  final int index;
  const _SetCard({required this.set, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Card(
        child: ListTile(
          title: Text(set.exerciseName),
          subtitle: Text(
              '${set.sets}x${set.reps} @ ${set.weight == 0 ? 'Peso corporal' : '${set.weight}kg'}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => ref
                .read(workoutSessionProvider.notifier)
                .removeSet(index),
          ),
        ),
      );
}
