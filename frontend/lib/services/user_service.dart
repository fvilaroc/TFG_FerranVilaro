import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/app_config.dart';
import '../models/user_profile.dart';
import '../models/update_profile_response.dart';

class UserService {
  Future<UserProfile> getMyProfile(String token) async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/users/currentUser'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar el perfil: ${response.body}');
    }
  }

  Future<UpdateProfileResponse> updateUsername({
    required String token,
    required String newUsername,
  }) async {
    final response = await http.patch(
      Uri.parse('${AppConfig.baseUrl}/users/updateUsername'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'newUsername': newUsername,
      }),
    );

    if (response.statusCode == 200) {
      return UpdateProfileResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al modificar username: ${response.body}');
    }
  }

  Future<void> updateEmail({
      required String token,
      required String newEmail,
    }) async {
      final response = await http.patch(
        Uri.parse('${AppConfig.baseUrl}/users/updateEmail'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'email': newEmail,
        }),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Error al modificar email: ${response.body}');
      }
    }

    Future<void> updatePassword({
      required String token,
      required String newPassword,
    }) async {
      final response = await http.patch(
        Uri.parse('${AppConfig.baseUrl}/users/updatePassword'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'password': newPassword,
        }),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Error al modificar contraseña: ${response.body}');
      }
    }
}