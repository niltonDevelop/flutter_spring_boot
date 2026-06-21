import 'failures.dart';

/// Resultado funcional para propagar éxito o fallo sin excepciones en dominio/presentación.
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

final class Error<T> extends Result<T> {
  const Error(this.failure);

  final Failure failure;
}
