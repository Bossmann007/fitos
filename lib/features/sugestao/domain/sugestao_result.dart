// lib/features/sugestao/domain/sugestao_result.dart

enum TipoTreino {
  descanso,
  recuperacaoAtiva,
  fullBodyA,
  fullBodyB,
  fullBodyC,
  calistenia,
}

extension TipoTreinoLabel on TipoTreino {
  String get label => switch (this) {
    TipoTreino.descanso         => 'Descanso',
    TipoTreino.recuperacaoAtiva => 'Recuperação Ativa',
    TipoTreino.fullBodyA        => 'Full Body A',
    TipoTreino.fullBodyB        => 'Full Body B',
    TipoTreino.fullBodyC        => 'Full Body C',
    TipoTreino.calistenia       => 'Calistenia',
  };

  String get emoji => switch (this) {
    TipoTreino.descanso         => '😴',
    TipoTreino.recuperacaoAtiva => '🚶',
    TipoTreino.fullBodyA        => '💪',
    TipoTreino.fullBodyB        => '🏋️',
    TipoTreino.fullBodyC        => '🦵',
    TipoTreino.calistenia       => '🤸',
  };
}

class SugestaoResult {
  final TipoTreino tipo;
  final String motivo;

  const SugestaoResult({required this.tipo, required this.motivo});
}
