import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';

enum UsersStatus { initial, loading, success, failure }

final class UsersState extends Equatable {
  const UsersState({
    this.status = UsersStatus.initial,
    this.users = const [],
    this.errorMessage,
    this.isUnauthorized = false,
  });

  final UsersStatus status;
  final List<User> users;
  final String? errorMessage;
  final bool isUnauthorized;

  @override
  List<Object?> get props => [status, users, errorMessage, isUnauthorized];
}
