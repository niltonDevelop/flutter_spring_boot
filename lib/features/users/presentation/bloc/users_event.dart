import 'package:equatable/equatable.dart';

sealed class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

final class UsersLoadRequested extends UsersEvent {
  const UsersLoadRequested();
}
