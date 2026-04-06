import 'package:flutter/material.dart';
import '../models/dance.dart';
import '../models/question.dart';
import '../models/answer_response.dart';
import '../services/dance_service.dart';
import '../services/question_service.dart';

class QuizScreen extends StatefulWidget {
  final String token;

  const QuizScreen({super.key, required this.token});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final DanceService _danceService = DanceService();
  final QuestionService _questionService = QuestionService();

  List<Dance> _dances = [];
  Dance? _selectedDance;
  List<Question> _questions = [];

  bool _loadingDances = true;
  bool _loadingQuestions = false;
  bool _checkingAnswer = false;

  String? _errorMessage;

  int _currentQuestionIndex = 0;
  int _totalPoints = 0;
  int _correctAnswers = 0;
  bool _quizFinished = false;

  @override
  void initState() {
    super.initState();
    _loadDances();
  }

  Future<void> _loadDances() async {
    try {
      final dances = await _danceService.getAllDances(widget.token);

      if (!mounted) return;
      setState(() {
        _dances = dances;
        _loadingDances = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingDances = false;
        _errorMessage = 'Error al cargar bailes';
      });
    }
  }

  Future<void> _startQuiz() async {
    if (_selectedDance == null) return;

    setState(() {
      _loadingQuestions = true;
      _errorMessage = null;
      _questions = [];
      _currentQuestionIndex = 0;
      _totalPoints = 0;
      _correctAnswers = 0;
      _quizFinished = false;
    });

    try {
      final questions = await _questionService.getQuestionsByDance(
        _selectedDance!.id,
        widget.token,
      );

      if (!mounted) return;
      setState(() {
        _questions = questions;
        _loadingQuestions = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingQuestions = false;
        _errorMessage = 'Error al cargar preguntas';
      });
    }
  }

  Future<void> _answerQuestion(String selectedOption) async {
    if (_checkingAnswer) return;

    final currentQuestion = _questions[_currentQuestionIndex];

    setState(() {
      _checkingAnswer = true;
    });

    try {
      final AnswerResponse response = await _questionService.checkAnswer(
        questionId: currentQuestion.id,
        answer: selectedOption,
        token: widget.token,
      );

      if (!mounted) return;

      if (response.correct) {
        _correctAnswers++;
      }

      _totalPoints += response.points;

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(response.correct ? '¡Correcta!' : 'Incorrecta'),
          content: Text(
            response.correct
                ? 'Has ganado ${response.points} puntos.'
                : 'No has ganado puntos en esta pregunta.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continuar'),
            ),
          ],
        ),
      );

      if (!mounted) return;

      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _checkingAnswer = false;
        });
      } else {
        setState(() {
          _quizFinished = true;
          _checkingAnswer = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _checkingAnswer = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al comprobar la respuesta'),
        ),
      );
    }
  }

  void _resetQuiz() {
    setState(() {
      _questions = [];
      _currentQuestionIndex = 0;
      _totalPoints = 0;
      _correctAnswers = 0;
      _quizFinished = false;
      _selectedDance = null;
      _errorMessage = null;
      _checkingAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingDances) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null && _questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Modo test')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              _errorMessage!,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    if (_questions.isEmpty && !_loadingQuestions) {
      return Scaffold(
        appBar: AppBar(title: const Text('Modo test')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Selecciona un baile para empezar el test',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<Dance>(
                value: _selectedDance,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Baile',
                ),
                items: _dances.map((dance) {
                  return DropdownMenuItem<Dance>(
                    value: dance,
                    child: Text(dance.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDance = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedDance == null ? null : _startQuiz,
                  child: const Text('Empezar test'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_loadingQuestions) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Modo test')),
        body: const Center(
          child: Text('Este baile no tiene preguntas todavía'),
        ),
      );
    }

    if (_quizFinished) {
      return Scaffold(
        appBar: AppBar(title: const Text('Resultado')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Test completado',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  'Respuestas correctas: $_correctAnswers / ${_questions.length}',
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Puntuación total: $_totalPoints',
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _resetQuiz,
                  child: const Text('Volver a elegir baile'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Pregunta ${_currentQuestionIndex + 1}/${_questions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildOptionButton('A', question.optionA),
            const SizedBox(height: 12),
            _buildOptionButton('B', question.optionB),
            const SizedBox(height: 12),
            _buildOptionButton('C', question.optionC),
            const SizedBox(height: 12),
            _buildOptionButton('D', question.optionD),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String optionLetter, String optionText) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _checkingAnswer ? null : () => _answerQuestion(optionLetter),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '$optionLetter. $optionText',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}