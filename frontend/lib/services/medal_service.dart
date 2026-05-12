import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/config/app_config.dart';
import '../models/user_medal.dart';

class MedalService {
  Future<List<UserMedal>> getMyMedals(String token) async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/medals/myMedals'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => UserMedal.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar las medallas: ${response.body}');
    }
  }
}