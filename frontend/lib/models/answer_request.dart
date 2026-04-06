class AnswerRequest {
  final int questionId;
  final String answer;

  AnswerRequest({
    required this.questionId,
    required this.answer,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'answer': answer,
    };
  }
}