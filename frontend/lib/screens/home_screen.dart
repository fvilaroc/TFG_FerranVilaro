import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  final String token;
  final VoidCallback onGoToDances;
  final VoidCallback onGoToRanking;

  const HomeScreen({
    super.key,
    required this.username,
    required this.token,
    required this.onGoToDances,
    required this.onGoToRanking,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Text(
              'Bienvenido, $username',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Esta es la primera versión\n\n',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: ListTile(
                leading: const Icon(Icons.music_note),
                title: const Text('Bailes típicos de España'),
                subtitle: const Text('Ver el listado de bailes'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: onGoToDances,
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.quiz),
                title: const Text('Modo test'),
                subtitle: const Text('Responder preguntas de un baile'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(token: token),
                    ),
                  );
                },
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.emoji_events),
                title: const Text('Ranking'),
                subtitle: const Text('Consultar clasificación global'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: onGoToRanking,
              ),
            ),
          ],
        ),
      ),
    );
  }
}