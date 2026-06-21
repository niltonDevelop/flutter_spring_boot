import 'package:flutter/material.dart';

import '../config/oauth_config.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.authService,
    required this.apiService,
    required this.onLogout,
  });

  final AuthService authService;
  final ApiService apiService;
  final VoidCallback onLogout;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthSession? _session;
  List<dynamic>? _users;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final session = await widget.authService.loadSession();
      if (session == null) {
        widget.onLogout();
        return;
      }

      final users = await widget.apiService.fetchUsers(session.accessToken);
      setState(() {
        _session = session;
        _users = users;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    await widget.authService.logout();
    widget.onLogout();
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
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
                          Text('OAuth: ${OAuthConfig.oauthBaseUrl}'),
                          Text('Gateway: ${OAuthConfig.gatewayBaseUrl}'),
                          const SizedBox(height: 8),
                          Text(
                            'Token: ${_session?.accessToken.substring(0, 24)}...',
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
                  if (_error != null)
                    Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  if (_users != null)
                    ..._users!.map(
                      (user) => ListTile(
                        title: Text(user['username']?.toString() ?? ''),
                        subtitle: Text(user['email']?.toString() ?? ''),
                        trailing: user['isAdmin'] == true
                            ? const Chip(label: Text('ADMIN'))
                            : null,
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
