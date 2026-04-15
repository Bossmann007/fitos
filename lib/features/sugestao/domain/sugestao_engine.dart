// lib/features/sugestao/domain/sugestao_engine.dart
import 'sugestao_result.dart';

/// Engine de sugestão de treino — lógica pura O(1).
/// Sem dependências externas: fácil de testar e de evoluir.
class SugestaoEngine {
  SugestaoResult suggest({
    required int energia,       // 1–10
    required int fadiga,        // 1–10
    required String? ultimoTreino,
    required int diasDescanso,
  }) {
    // Prioridade 1: descanso obrigatório
    if (energia <= 2 || fadiga >= 8) {
      return const SugestaoResult(
        tipo: TipoTreino.descanso,
        motivo: 'Seu corpo precisa descansar hoje.',
      );
    }

    // Prioridade 2: recuperação leve
    if (energia <= 4 || fadiga >= 6) {
      return const SugestaoResult(
        tipo: TipoTreino.recuperacaoAtiva,
        motivo: 'Energia baixa — sessão leve de recuperação.',
      );
    }

    // Prioridade 3: rotação Full Body A → B → C
    final proximo = _proximoFullBody(ultimoTreino);
    final motivo = diasDescanso >= 2
        ? '${diasDescanso}d sem treinar — hora de voltar!'
        : 'Rotação programada.';

    return SugestaoResult(tipo: proximo, motivo: motivo);
  }

  TipoTreino _proximoFullBody(String? ultimoTreino) {
    if (ultimoTreino == null) return TipoTreino.fullBodyA;

    final mapa = {
      'Full Body A': TipoTreino.fullBodyB,
      'Full Body B': TipoTreino.fullBodyC,
      'Full Body C': TipoTreino.fullBodyA,
    };

    return mapa[ultimoTreino] ?? TipoTreino.fullBodyA;
  }
}
