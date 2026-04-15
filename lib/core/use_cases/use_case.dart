// lib/core/use_cases/use_case.dart

/// Base abstrata para todos os use cases.
/// T = tipo de retorno, P = tipo dos parâmetros.
/// Padrão Command com tipagem forte.
abstract class UseCase<T, P> {
  T call(P params);
}

/// Usar quando o use case não precisa de parâmetros.
class NoParams {
  const NoParams();
}
