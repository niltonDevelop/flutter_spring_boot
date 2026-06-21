import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/injection/injection_container.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/users/presentation/bloc/users_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final InjectionContainer _container;

  @override
  void initState() {
    super.initState();
    _container = InjectionContainer.create();
  }

  @override
  void dispose() {
    _container.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _container.authBloc),
        BlocProvider<UsersBloc>.value(value: _container.usersBloc),
      ],
      child: MaterialApp.router(
        title: 'Spring Cloud',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        routerConfig: _container.router,
      ),
    );
  }
}
