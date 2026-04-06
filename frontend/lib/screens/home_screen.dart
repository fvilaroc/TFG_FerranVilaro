import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

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
                  'Esta es la primera versión funcional del TFG.\n\n'
                  'Desde aquí ya puedes navegar por la app, iniciar sesión, registrarte, ver el ranking y dejar preparada toda la estructura para cuando hagas la migración de datos.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              child: ListTile(
                leading: Icon(Icons.music_note),
                title: Text('Bailes típicos de España'),
                subtitle: Text('Pendiente de cargar desde base de datos'),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.quiz),
                title: Text('Modo test'),
                subtitle: Text('Se podrá activar cuando existan preguntas en la base de datos'),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.emoji_events),
                title: Text('Ranking'),
                subtitle: Text('Conectado al backend'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}