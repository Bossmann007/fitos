// test/features/sugestao/sugestao_engine_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fitos/features/sugestao/domain/sugestao_engine.dart';
import 'package:fitos/features/sugestao/domain/sugestao_result.dart';

void main() {
  late SugestaoEngine engine;
  setUp(() => engine = SugestaoEngine());

  test('energia <= 2 → descanso', () {
    final r = engine.suggest(energia: 2, fadiga: 5, ultimoTreino: null, diasDescanso: 0);
    expect(r.tipo, TipoTreino.descanso);
  });

  test('fadiga >= 8 → descanso', () {
    final r = engine.suggest(energia: 8, fadiga: 8, ultimoTreino: null, diasDescanso: 0);
    expect(r.tipo, TipoTreino.descanso);
  });

  test('energia 3-4 com fadiga 6-7 → recuperação ativa', () {
    final r = engine.suggest(energia: 4, fadiga: 6, ultimoTreino: null, diasDescanso: 1);
    expect(r.tipo, TipoTreino.recuperacaoAtiva);
  });

  test('sem último treino → Full Body A', () {
    final r = engine.suggest(energia: 8, fadiga: 2, ultimoTreino: null, diasDescanso: 1);
    expect(r.tipo, TipoTreino.fullBodyA);
  });

  test('após Full Body A → Full Body B', () {
    final r = engine.suggest(energia: 8, fadiga: 2, ultimoTreino: 'Full Body A', diasDescanso: 1);
    expect(r.tipo, TipoTreino.fullBodyB);
  });

  test('após Full Body B → Full Body C', () {
    final r = engine.suggest(energia: 8, fadiga: 2, ultimoTreino: 'Full Body B', diasDescanso: 1);
    expect(r.tipo, TipoTreino.fullBodyC);
  });

  test('após Full Body C → Full Body A (rotação completa)', () {
    final r = engine.suggest(energia: 8, fadiga: 2, ultimoTreino: 'Full Body C', diasDescanso: 1);
    expect(r.tipo, TipoTreino.fullBodyA);
  });

  test('tipo não nulo para qualquer combinação válida', () {
    final r = engine.suggest(energia: 9, fadiga: 1, ultimoTreino: 'Full Body A', diasDescanso: 1);
    expect(r.tipo, isNotNull);
  });
}
