class AnswerResponse {
  final bool correct;
  final int points;

  AnswerResponse({
    required this.correct,
    required this.points,
  });

  factory AnswerResponse.fromJson(Map<String, dynamic> json) {
    return AnswerResponse(
      correct: json['correct'] ?? false,
      points: json['points'] ?? 0,
    );
  }
}