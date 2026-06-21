import 'package:equatable/equatable.dart';

/// Entidad de dominio: sesión autenticada.
class AuthSession extends Equatable {
  const AuthSession({required this.accessToken});

  final String accessToken;

  @override
  List<Object?> get props => [accessToken];
}
