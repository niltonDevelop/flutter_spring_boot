import 'package:equatable/equatable.dart';

/// Entidad de dominio: usuario del sistema.
class User extends Equatable {
  const User({
    required this.username,
    required this.email,
    required this.isAdmin,
  });

  final String username;
  final String email;
  final bool isAdmin;

  @override
  List<Object?> get props => [username, email, isAdmin];
}
