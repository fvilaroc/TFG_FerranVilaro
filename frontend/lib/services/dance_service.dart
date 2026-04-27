import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/config/app_config.dart';
import '../models/dance.dart';

class DanceService {
  Future<List<Dance>> getAllDances(String token) async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/dances/all'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Dance.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar los bailes: ${response.body}');
    }
  }

  Future<Dance> saveDance({
    required String token,
    required String name,
    required String region,
    required String description,
    required String videoUrl,
    required String history,
    required String origin,
    required String clothing,
    required String music,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/dances/save'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'region': region,
        'description': description,
        'videoUrl': videoUrl,
        'history': history,
        'origin': origin,
        'clothing': clothing,
        'music': music,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Dance.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al añadir el baile: ${response.body}');
    }
  }
}