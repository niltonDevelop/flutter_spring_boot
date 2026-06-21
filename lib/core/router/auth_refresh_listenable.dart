import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';

/// Puente reactivo entre [AuthBloc] y GoRouter: re-evalúa redirects al cambiar auth.
class AuthRefreshListenable extends ChangeNotifier {
  AuthRefreshListenable(AuthBloc authBloc) {
    _subscription = authBloc.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
