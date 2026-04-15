// lib/features/sugestao/domain/use_cases/suggest_workout.dart
import '../../../../core/use_cases/use_case.dart';
import '../sugestao_engine.dart';
import '../sugestao_result.dart';

class SugestaoParams {
  final int energia;
  final int fadiga;
  final String? ultimoTreino;
  final int diasDescanso;

  const SugestaoParams({
    required this.energia,
    required this.fadiga,
    required this.ultimoTreino,
    required this.diasDescanso,
  });
}

class SuggestWorkout extends UseCase<SugestaoResult, SugestaoParams> {
  final SugestaoEngine engine;
  SuggestWorkout(this.engine);

  @override
  SugestaoResult call(SugestaoParams params) => engine.suggest(
        energia: params.energia,
        fadiga: params.fadiga,
        ultimoTreino: params.ultimoTreino,
        diasDescanso: params.diasDescanso,
      );
}
