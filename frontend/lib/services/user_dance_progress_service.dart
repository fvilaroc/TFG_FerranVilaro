import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/config/app_config.dart';

class UserDanceProgressService {
  static const String _path = '/progress';

  Map<String, String> _headers(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<bool> isDocumentationRead({
    required String token,
    required int danceId,
  }) async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}$_path/$danceId/documentationRead'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      return _parseBooleanResponse(response.body);
    }

    throw Exception(
      'Error al comprobar si la documentación está leída: ${response.body}',
    );
  }

  Future<void> markDocumentationRead({
    required String token,
    required int danceId,
  }) async {
    final response = await http.patch(
      Uri.parse('${AppConfig.baseUrl}$_path/$danceId/markDocumentationRead'),
      headers: _headers(token),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Error al marcar la documentación como leída: ${response.body}',
      );
    }
  }

  bool _parseBooleanResponse(String body) {
    final cleanBody = body.trim().toLowerCase();

    if (cleanBody == 'true') return true;
    if (cleanBody == 'false') return false;

    try {
      final decoded = jsonDecode(body);

      if (decoded is bool) return decoded;

      if (decoded is Map<String, dynamic>) {
        return decoded['read'] == true ||
            decoded['documentationRead'] == true ||
            decoded['isDocumentationRead'] == true;
      }

      return false;
    } catch (_) {
      return false;
    }
  }
}