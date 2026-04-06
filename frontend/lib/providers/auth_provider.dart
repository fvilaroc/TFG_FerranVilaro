import 'package:flutter/material.dart';
import '../core/services/storage_service.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _token;
  String? _username;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  String? get username => _username;

  Future<void> initAuth() async {
    _isLoading = true;
    notifyListeners();

    _token = await _storageService.getToken();
    _username = await _storageService.getUsername();

    _isAuthenticated = _token != null && _token!.isNotEmpty;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.login(
        username: username,
        password: password,
      );

      _token = response.accessToken;
      _username = username;
      _isAuthenticated = true;

      await _storageService.saveToken(_token!);
      await _storageService.saveUsername(username);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String email,
    required String username,
    required String password,
    required String name,
    required String dateOfBirth,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.register(
        email: email,
        username: username,
        password: password,
        name: name,
        dateOfBirth: dateOfBirth,
      );

      _token = response.accessToken;
      _username = username;
      _isAuthenticated = true;

      await _storageService.saveToken(_token!);
      await _storageService.saveUsername(username);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _storageService.clearAll();
    _token = null;
    _username = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}