import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/api_config.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_event.dart';
import '../bloc/users_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<UsersBloc>().add(const UsersLoadRequested());
  }

  Future<void> _refresh() async {
    context.read<UsersBloc>().add(const UsersLoadRequested());
  }

  void _logout() {
    context.read<AuthBloc>().add(const AuthLogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: BlocConsumer<UsersBloc, UsersState>(
        listenWhen: (previous, current) =>
            current.status == UsersStatus.failure &&
            (current.errorMessage != null || current.isUnauthorized),
        listener: (context, state) {
          if (state.isUnauthorized) {
            context.read<AuthBloc>().add(const AuthSessionExpired());
            return;
          }

          final message = state.errorMessage;
          if (message == null) return;

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
        builder: (context, state) {
          if (state.status == UsersStatus.loading ||
              state.status == UsersStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sesión activa',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text('API: ${ApiConfig.baseUrl}'),
                        const SizedBox(height: 8),
                        Text(
                          'Autenticado correctamente',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Usuarios (GET /api/users/v1)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (state.status == UsersStatus.failure &&
                    state.errorMessage != null)
                  Text(
                    state.errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                if (state.status == UsersStatus.success)
                  ...state.users.map(
                    (user) => ListTile(
                      title: Text(user.username),
                      subtitle: Text(user.email),
                      trailing: user.isAdmin
                          ? const Chip(label: Text('ADMIN'))
                          : null,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
