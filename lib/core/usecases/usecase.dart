/// Contrato base para casos de uso con parámetros.
abstract interface class UseCase<T, Params> {
  Future<T> call(Params params);
}

/// Contrato base para casos de uso sin parámetros.
abstract interface class UseCaseNoParams<T> {
  Future<T> call();
}
