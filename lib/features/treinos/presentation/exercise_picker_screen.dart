// lib/features/treinos/presentation/exercise_picker_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/entities/exercise.dart';
import '../../../core/entities/workout_set.dart';
import '../../../core/use_cases/use_case.dart';
import '../data/repositories/workout_repo_impl.dart';
import '../domain/use_cases/get_exercises.dart';

final exercisesProvider = Provider((ref) {
  final repo = WorkoutRepoImpl();
  return GetExercises(repo)(const NoParams());
});

class ExercisePickerScreen extends ConsumerStatefulWidget {
  const ExercisePickerScreen({super.key});

  @override
  ConsumerState<ExercisePickerScreen> createState() =>
      _ExercisePickerScreenState();
}

class _ExercisePickerScreenState extends ConsumerState<ExercisePickerScreen> {
  String _search = '';
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final all = ref.read(exercisesProvider);
    final categories = ['Todos', ...{...all.map((e) => e.category)}];
    final filtered = all.where((e) {
      final matchSearch =
          e.name.toLowerCase().contains(_search.toLowerCase());
      final matchCat = _selectedCategory == null ||
          _selectedCategory == 'Todos' ||
          e.category == _selectedCategory;
      return matchSearch && matchCat;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Escolher Exercício')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar exercício...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => FilterChip(
                label: Text(categories[i]),
                selected: _selectedCategory == categories[i],
                onSelected: (_) =>
                    setState(() => _selectedCategory = categories[i]),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(filtered[i].name),
                subtitle: Text(
                    '${filtered[i].category} · ${filtered[i].modality}'),
                trailing: const Icon(Icons.add_circle_outline),
                onTap: () => _showSetDialog(context, filtered[i]),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => _showCustomDialog(context),
        tooltip: 'Exercício personalizado',
        child: const Icon(Icons.edit),
      ),
    );
  }

  void _showSetDialog(BuildContext context, Exercise exercise) {
    int sets = 3, reps = 8;
    double weight = 0;
    int rest = 60;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: StatefulBuilder(
          builder: (ctx, setS) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(exercise.name,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Counter('Séries', sets, (v) => setS(() => sets = v)),
                  _Counter('Reps', reps, (v) => setS(() => reps = v)),
                ],
              ),
              if (exercise.modality != 'Peso Corporal')
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: TextFormField(
                    initialValue: '0',
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Peso (kg)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => weight = double.tryParse(v) ?? 0,
                  ),
                ),
              Row(
                children: [
                  const Text('Descanso: '),
                  Expanded(
                    child: Slider(
                      value: rest.toDouble(),
                      min: 30,
                      max: 180,
                      divisions: 5,
                      label: '${rest}s',
                      onChanged: (v) => setS(() => rest = v.round()),
                    ),
                  ),
                  Text('${rest}s'),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(
                    context,
                    WorkoutSet(
                      exerciseId: exercise.id,
                      exerciseName: exercise.name,
                      sets: sets,
                      reps: reps,
                      weight: weight,
                      restSeconds: rest,
                    ),
                  );
                },
                child: const Text('Adicionar'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exercício Personalizado'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(
            labelText: 'Nome do exercício',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty) return;
              Navigator.pop(ctx);
              Navigator.pop(
                context,
                WorkoutSet(
                  exerciseId: 'custom-${nameCtrl.text}',
                  exerciseName: nameCtrl.text,
                  sets: 3,
                  reps: 10,
                  weight: 0,
                ),
              );
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  const _Counter(this.label, this.value, this.onChanged);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => onChanged(value > 1 ? value - 1 : 1)),
              Text('$value',
                  style: Theme.of(context).textTheme.titleLarge),
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => onChanged(value + 1)),
            ],
          ),
        ],
      );
}
