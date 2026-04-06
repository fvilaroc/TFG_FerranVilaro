import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/app_config.dart';
import '../models/auth_response.dart';

class AuthService {
  Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al iniciar sesión: ${response.body}');
    }
  }

  Future<AuthResponse> register({
    required String email,
    required String username,
    required String password,
    required String name,
    required String dateOfBirth,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/api/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'username': username,
        'password': password,
        'name': name,
        'dateOfBirth': dateOfBirth,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al registrarse: ${response.body}');
    }
  }
}