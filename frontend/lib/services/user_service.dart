import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/app_config.dart';
import '../models/user_profile.dart';

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
}