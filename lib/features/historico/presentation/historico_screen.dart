// lib/features/historico/presentation/historico_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'providers/historico_provider.dart';

class HistoricoScreen extends ConsumerStatefulWidget {
  const HistoricoScreen({super.key});

  @override
  ConsumerState<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends ConsumerState<HistoricoScreen> {
  String? _filterType;
  static const _tipos = [
    'Todos', 'Full Body A', 'Full Body B', 'Full Body C',
    'Calistenia', 'Recuperação Ativa',
  ];

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(historicoProvider);
    final filtered = _filterType == null || _filterType == 'Todos'
        ? all
        : all.where((w) => w.type == _filterType).toList();
    final fmt = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico'), centerTitle: true),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              scrollDirection: Axis.horizontal,
              itemCount: _tipos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => FilterChip(
                label: Text(_tipos[i]),
                selected: _filterType == _tipos[i],
                onSelected: (_) =>
                    setState(() => _filterType = _tipos[i]),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('Nenhum treino registrado'))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final w = filtered[i];
                      return ListTile(
                        leading: CircleAvatar(child: Text(w.type[0])),
                        title: Text(w.type),
                        subtitle: Text(fmt.format(w.date)),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${w.durationMinutes} min'),
                            Text(
                              '${w.totalVolume.toStringAsFixed(0)} kg',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
