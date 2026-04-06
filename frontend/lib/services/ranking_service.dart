import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/app_config.dart';
import '../models/ranking_models.dart';

class RankingService {
  Future<List<GlobalRankingEntry>> getGlobalRanking(String token) async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/api/ranking/global'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => GlobalRankingEntry.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar el ranking: ${response.body}');
    }
  }
}