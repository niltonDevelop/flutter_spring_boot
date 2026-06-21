import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  bool _checkingSession = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  @override
  void dispose() {
    _apiService.dispose();
    _authService.dispose();
    super.dispose();
  }

  Future<void> _restoreSession() async {
    final session = await _authService.loadSession();
    setState(() {
      _isAuthenticated = session != null;
      _checkingSession = false;
    });
  }

  void _onLoginSuccess() {
    setState(() {
      _isAuthenticated = true;
    });
  }

  void _onLogout() {
    setState(() {
      _isAuthenticated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spring Cloud',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: _checkingSession
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : _isAuthenticated
          ? HomeScreen(
              authService: _authService,
              apiService: _apiService,
              onLogout: _onLogout,
            )
          : LoginScreen(
              authService: _authService,
              onLoginSuccess: _onLoginSuccess,
            ),
    );
  }
}
