// lib/features/sugestao/presentation/providers/sugestao_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/sugestao_engine.dart';
import '../../domain/sugestao_result.dart';
import '../../domain/use_cases/suggest_workout.dart';

final sugestaoEngineProvider = Provider((_) => SugestaoEngine());

final suggestWorkoutProvider = Provider(
  (ref) => SuggestWorkout(ref.read(sugestaoEngineProvider)),
);

class SugestaoState {
  final int energia;
  final int fadiga;
  final SugestaoResult? resultado;

  const SugestaoState({
    this.energia = 7,
    this.fadiga = 3,
    this.resultado,
  });

  SugestaoState copyWith({int? energia, int? fadiga, SugestaoResult? resultado}) =>
      SugestaoState(
        energia: energia ?? this.energia,
        fadiga: fadiga ?? this.fadiga,
        resultado: resultado ?? this.resultado,
      );
}

final sugestaoProvider =
    StateNotifierProvider<SugestaoNotifier, SugestaoState>(
  (ref) => SugestaoNotifier(ref.read(suggestWorkoutProvider)),
);

class SugestaoNotifier extends StateNotifier<SugestaoState> {
  final SuggestWorkout _suggest;

  SugestaoNotifier(this._suggest) : super(const SugestaoState());

  void setEnergia(int v) => state = state.copyWith(energia: v);
  void setFadiga(int v)  => state = state.copyWith(fadiga: v);

  void calcular(String? ultimoTreino, int diasDescanso) {
    final resultado = _suggest(SugestaoParams(
      energia: state.energia,
      fadiga: state.fadiga,
      ultimoTreino: ultimoTreino,
      diasDescanso: diasDescanso,
    ));
    state = state.copyWith(resultado: resultado);
  }
}
