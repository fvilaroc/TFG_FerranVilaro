import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/config/app_config.dart';
import '../models/question.dart';
import '../models/answer_request.dart';
import '../models/answer_response.dart';

class QuestionService {
  Future<List<Question>> getQuestionsByDance(int danceId, String token) async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/questions/quiz/$danceId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Question.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar preguntas: ${response.body}');
    }
  }

  Future<AnswerResponse> checkAnswer({
    required int questionId,
    required String answer,
    required String token,
  }) async {
    final request = AnswerRequest(
      questionId: questionId,
      answer: answer,
    );

    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/questions/check'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return AnswerResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al comprobar respuesta: ${response.body}');
    }
  }

  Future<void> saveQuestion({
    required String token,
    required int danceId,
    required String question,
    required String optionA,
    required String optionB,
    required String optionC,
    required String optionD,
    required String correctAnswer,
    int points = 10,
    String difficulty = 'EASY',
  }) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/questions/save'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'question': question,
        'correctAnswer': correctAnswer,
        'optionA': optionA,
        'optionB': optionB,
        'optionC': optionC,
        'optionD': optionD,
        'points': points,
        'difficulty': difficulty,
        'dance': {
          'id': danceId,
        },
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error al añadir la pregunta: ${response.body}');
    }
  }
}