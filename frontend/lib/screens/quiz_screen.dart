import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/dance.dart';
import '../models/question.dart';
import '../models/answer_response.dart';
import '../services/dance_service.dart';
import '../services/question_service.dart';
import 'add_question_screen.dart';

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

  bool get _isAdmin {
    final role = _extractRoleFromToken(widget.token);
    return role == 'ADMIN';
  }

  @override
  void initState() {
    super.initState();
    _loadDances();
  }

  String _extractRoleFromToken(String token) {
    try {
      final parts = token.split('.');

      if (parts.length != 3) return 'FREE';

      final payload = jsonDecode(
        utf8.decode(
          base64Url.decode(
            base64Url.normalize(parts[1]),
          ),
        ),
      );

      final rawRole = payload['scope'] ??
          payload['role'] ??
          payload['roles'] ??
          payload['authorities'] ??
          '';

      final roleText = rawRole.toString().toUpperCase();

      if (roleText.contains('ADMIN')) return 'ADMIN';
      if (roleText.contains('PREMIUM')) return 'PREMIUM';
      return 'FREE';
    } catch (_) {
      return 'FREE';
    }
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

      await _showAnswerDialog(response);

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

  Future<void> _showAnswerDialog(AnswerResponse response) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Row(
          children: [
            Icon(
              response.correct
                  ? Icons.check_circle_rounded
                  : Icons.cancel_rounded,
              color: response.correct
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                response.correct ? '¡Correcta!' : 'Incorrecta',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          response.correct
              ? 'Has ganado ${response.points} puntos.'
              : 'No has ganado puntos en esta pregunta.',
          style: const TextStyle(
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  Future<void> _goToAddQuestion() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddQuestionScreen(token: widget.token),
      ),
    );

    if (created == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pregunta creada correctamente.'),
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

  PreferredSizeWidget _buildAppBar(String title) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Color(0xFF111827),
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFFF8FAFC),
      elevation: 0,
      scrolledUnderElevation: 0,
      actions: [
        if (_isAdmin)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              tooltip: 'Añadir pregunta',
              onPressed: _goToAddQuestion,
              icon: const Icon(
                Icons.add_circle_outline_rounded,
                color: Color(0xFF7C3AED),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGradientBody({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF8FAFC),
            Color(0xFFEFF6FF),
            Color(0xFFF3E8FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }

  Widget _buildLoadingView(String text) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar('Modo test'),
      body: _buildGradientBody(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: Color(0xFF7C3AED),
                ),
                const SizedBox(height: 14),
                Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      appBar: _buildAppBar('Modo test'),
      body: _buildGradientBody(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Color(0xFFEF4444),
                    size: 54,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _errorMessage ?? 'Ha ocurrido un error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF111827),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: _loadDances,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Reintentar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectDanceScreen() {
    return Scaffold(
      appBar: _buildAppBar('Modo test'),
      body: _buildGradientBody(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            _buildQuizHeader(),
            const SizedBox(height: 22),
            _buildDanceSelectionCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7C3AED),
            Color(0xFF2563EB),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withOpacity(0.22),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.quiz_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Pon a prueba tus conocimientos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 29,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Selecciona un baile y responde preguntas para ganar puntos.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.94),
              fontSize: 14.5,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDanceSelectionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Selecciona un baile',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
                color: Color(0xFF111827),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Dance>(
            value: _selectedDance,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Baile',
              prefixIcon: const Icon(Icons.music_note_rounded),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E7EB),
                ),
              ),
            ),
            items: _dances.map((dance) {
              return DropdownMenuItem<Dance>(
                value: dance,
                child: Text(
                  '${dance.name} · ${dance.region}',
                  overflow: TextOverflow.ellipsis,
                ),
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
            child: ElevatedButton.icon(
              onPressed: _selectedDance == null ? null : _startQuiz,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Empezar test'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    const Color(0xFF7C3AED).withOpacity(0.45),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoQuestionsScreen() {
    return Scaffold(
      appBar: _buildAppBar('Modo test'),
      body: _buildGradientBody(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.quiz_outlined,
                    color: Color(0xFF9CA3AF),
                    size: 54,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Este baile no tiene preguntas todavía',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isAdmin
                        ? 'Puedes añadir preguntas desde el botón superior derecho.'
                        : 'Prueba con otro baile disponible.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: _resetQuiz,
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Volver a elegir baile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final totalQuestions = _questions.length;
    final percentage = totalQuestions == 0
        ? 0
        : ((_correctAnswers / totalQuestions) * 100).round();

    return Scaffold(
      appBar: _buildAppBar('Resultado'),
      body: _buildGradientBody(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 86,
                    width: 86,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFF59E0B),
                          Color(0xFFF97316),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.emoji_events_rounded,
                      color: Colors.white,
                      size: 46,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Test completado',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Has acertado $_correctAnswers de $totalQuestions preguntas.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: _buildResultStat(
                          title: 'Aciertos',
                          value: '$_correctAnswers/$totalQuestions',
                          icon: Icons.check_circle_rounded,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildResultStat(
                          title: 'Puntos',
                          value: '$_totalPoints',
                          icon: Icons.stars_rounded,
                          color: const Color(0xFF7C3AED),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildResultStat(
                    title: 'Porcentaje',
                    value: '$percentage%',
                    icon: Icons.percent_rounded,
                    color: const Color(0xFF2563EB),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _resetQuiz,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Volver a elegir baile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultStat({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.16),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 27,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionScreen() {
    final question = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      appBar: _buildAppBar(
        'Pregunta ${_currentQuestionIndex + 1}/${_questions.length}',
      ),
      body: _buildGradientBody(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            _buildProgressCard(progress),
            const SizedBox(height: 18),
            _buildQuestionCard(question),
            const SizedBox(height: 18),
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

  Widget _buildProgressCard(double progress) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.quiz_rounded,
                color: Color(0xFF7C3AED),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _selectedDance?.name ?? 'Test',
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                '$_totalPoints pts',
                style: const TextStyle(
                  color: Color(0xFF7C3AED),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: const Color(0xFFE5E7EB),
              color: const Color(0xFF7C3AED),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Question question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        question.question,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: Color(0xFF111827),
          height: 1.25,
        ),
      ),
    );
  }

  Widget _buildOptionButton(String optionLetter, String optionText) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _checkingAnswer ? null : () => _answerQuestion(optionLetter),
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.045),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    optionLetter,
                    style: const TextStyle(
                      color: Color(0xFF7C3AED),
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  optionText,
                  style: const TextStyle(
                    color: Color(0xFF374151),
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    height: 1.35,
                  ),
                ),
              ),
              if (_checkingAnswer)
                const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: Color(0xFF7C3AED),
                  ),
                )
              else
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF9CA3AF),
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingDances) {
      return _buildLoadingView('Cargando bailes...');
    }

    if (_errorMessage != null && _questions.isEmpty) {
      return _buildErrorScreen();
    }

    if (_questions.isEmpty && !_loadingQuestions) {
      return _buildSelectDanceScreen();
    }

    if (_loadingQuestions) {
      return _buildLoadingView('Cargando preguntas...');
    }

    if (_questions.isEmpty) {
      return _buildNoQuestionsScreen();
    }

    if (_quizFinished) {
      return _buildResultScreen();
    }

    return _buildQuestionScreen();
  }
}