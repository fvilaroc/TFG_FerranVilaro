import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/app_config.dart';
import '../models/dance.dart';

class DanceService {
  Future<List<Dance>> getAllDances(String token) async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/api/dances/all'),
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
}