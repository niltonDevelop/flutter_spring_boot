import 'package:bloc/bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/usecases/get_users_usecase.dart';
import 'users_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc({required GetUsersUseCase getUsers})
      : _getUsers = getUsers,
        super(const UsersState()) {
    on<UsersLoadRequested>(_onLoadRequested);
  }

  final GetUsersUseCase _getUsers;

  Future<void> _onLoadRequested(
    UsersLoadRequested event,
    Emitter<UsersState> emit,
  ) async {
    emit(const UsersState(status: UsersStatus.loading));

    final result = await _getUsers();

    switch (result) {
      case Success(:final data):
        emit(UsersState(status: UsersStatus.success, users: data));
      case Error(:final failure):
        emit(
          UsersState(
            status: UsersStatus.failure,
            errorMessage: failure.message,
            isUnauthorized: failure is AuthFailure && failure.statusCode == 401,
          ),
        );
    }
  }
}
