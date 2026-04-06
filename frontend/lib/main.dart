import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  runApp(const TfgApp());
}

class TfgApp extends StatelessWidget {
  const TfgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider()..initAuth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TFG Bailes de España',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (authProvider.isAuthenticated &&
        authProvider.token != null &&
        authProvider.username != null) {
      return MainNavigationScreen(
        username: authProvider.username!,
        token: authProvider.token!,
      );
    }

    return const LoginScreen();
  }
}