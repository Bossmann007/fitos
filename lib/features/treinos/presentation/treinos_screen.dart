// lib/features/treinos/presentation/treinos_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../sugestao/domain/sugestao_result.dart';
import '../../sugestao/presentation/providers/sugestao_provider.dart';
import 'providers/workout_session_provider.dart';
import 'workout_session_screen.dart';

class TreinosScreen extends ConsumerWidget {
  const TreinosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sugestao = ref.watch(sugestaoProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('FitOS'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Como você está hoje?',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _SliderRow(
                      label: 'Energia',
                      value: sugestao.energia.toDouble(),
                      color: Colors.green,
                      onChanged: (v) => ref
                          .read(sugestaoProvider.notifier)
                          .setEnergia(v.round()),
                    ),
                    _SliderRow(
                      label: 'Fadiga',
                      value: sugestao.fadiga.toDouble(),
                      color: Colors.orange,
                      onChanged: (v) => ref
                          .read(sugestaoProvider.notifier)
                          .setFadiga(v.round()),
                    ),
                    FilledButton(
                      onPressed: () {
                        final history =
                            ref.read(workoutRepoProvider).getHistory();
                        final ultimoTipo = history.isNotEmpty
                            ? history.first.type
                            : null;
                        final diasDescanso = history.isNotEmpty
                            ? DateTime.now()
                                .difference(history.first.date)
                                .inDays
                            : 0;
                        ref
                            .read(sugestaoProvider.notifier)
                            .calcular(ultimoTipo, diasDescanso);
                      },
                      child: const Text('Ver Sugestão'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (sugestao.resultado != null) ...[
              _SugestaoCard(resultado: sugestao.resultado!),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  ref
                      .read(workoutSessionProvider.notifier)
                      .start(sugestao.resultado!.tipo.label);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const WorkoutSessionScreen()),
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Iniciar Treino Sugerido'),
              ),
              const SizedBox(height: 8),
            ],
            OutlinedButton.icon(
              onPressed: () => _showTipoSelector(context, ref),
              icon: const Icon(Icons.fitness_center),
              label: const Text('Escolher Manualmente'),
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ],
        ),
      ),
    );
  }

  void _showTipoSelector(BuildContext context, WidgetRef ref) {
    const tipos = [
      'Full Body A',
      'Full Body B',
      'Full Body C',
      'Calistenia',
      'Recuperação Ativa',
    ];
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Qual treino?',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...tipos.map((t) => ListTile(
                title: Text(t),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(workoutSessionProvider.notifier).start(t);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const WorkoutSessionScreen()),
                  );
                },
              )),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          SizedBox(
              width: 75,
              child: Text('$label ${value.round()}')),
          Expanded(
            child: Slider(
              value: value,
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: color,
              onChanged: onChanged,
            ),
          ),
        ],
      );
}

class _SugestaoCard extends StatelessWidget {
  final SugestaoResult resultado;
  const _SugestaoCard({required this.resultado});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(resultado.tipo.emoji,
                    style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sugestão de Hoje',
                        style: theme.textTheme.labelMedium),
                    Text(resultado.tipo.label,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(resultado.motivo, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
