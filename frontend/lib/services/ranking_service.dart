import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/config/app_config.dart';
import '../models/ranking_models.dart';

class RankingService {
  Map<String, String> _headers(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<GlobalRankingEntry>> getGlobalRanking(String token) async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/ranking/global'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => GlobalRankingEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception(_getErrorMessage(response, 'Error al cargar el ranking global'));
  }

  Future<List<DanceRankingEntry>> getDanceRanking(
    String token,
    int danceId,
  ) async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/ranking/dance/$danceId'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => DanceRankingEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception(_getErrorMessage(response, 'Error al cargar el ranking del baile'));
  }

  Future<List<RankingDanceOption>> getRankingDances(String token) async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/dances/all'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => RankingDanceOption.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception(_getErrorMessage(response, 'Error al cargar los bailes'));
  }

  String _getErrorMessage(http.Response response, String defaultMessage) {
    if (response.body.isEmpty) {
      return '$defaultMessage. Código: ${response.statusCode}';
    }

    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return decoded['message']?.toString() ??
            decoded['error']?.toString() ??
            '$defaultMessage. Código: ${response.statusCode}';
      }

      return response.body;
    } catch (_) {
      return response.body;
    }
  }
}