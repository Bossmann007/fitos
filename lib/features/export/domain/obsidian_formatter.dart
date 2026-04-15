// lib/features/export/domain/obsidian_formatter.dart
import 'package:intl/intl.dart';
import '../../../core/entities/workout.dart';

/// Formata um Workout como nota Markdown compatível com o vault Mafioso.
class ObsidianFormatter {
  final _dateFmt = DateFormat('yyyy-MM-dd');

  /// Nome do arquivo: "2026-04-15 — Treino Full Body A.md"
  String fileName(Workout w) =>
      '${_dateFmt.format(w.date)} — Treino ${w.type}.md';

  /// Conteúdo Markdown completo com frontmatter e links Obsidian
  String format(Workout w) {
    final date = _dateFmt.format(w.date);
    final tipoTag = w.type.toLowerCase().replaceAll(' ', '-');

    final exercicios = w.sets.isEmpty
        ? '_Nenhum exercício registrado_'
        : w.sets.map((s) {
            final pesoStr =
                s.weight == 0 ? 'Peso corporal' : '${s.weight}kg';
            return '- **${s.exerciseName}** — ${s.sets}x${s.reps} @ $pesoStr';
          }).join('\n');

    final logSection = w.dailyLog != null
        ? '- **Energia:** ${w.dailyLog!.energia}/10 · **Fadiga:** ${w.dailyLog!.fadiga}/10\n'
        : '';

    return '''# $date — Treino ${w.type}

Tags: #treino #fitos #$tipoTag
Data: $date

---

## Resumo

- **Duração:** ${w.durationMinutes} min
- **Volume total:** ${w.totalVolume.toStringAsFixed(1)} kg
${logSection}
## Exercícios

$exercicios

## Anotações

${w.notes ?? '_Sem anotações_'}

---

[[MOC - Saúde e Fitness]]
[[🏋️ FitOS — Central de Comando]]
''';
  }
}
