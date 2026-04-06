import 'package:flutter/material.dart';
import '../models/dance.dart';
import '../services/dance_service.dart';

class DancesScreen extends StatefulWidget {
  final String token;

  const DancesScreen({super.key, required this.token});

  @override
  State<DancesScreen> createState() => _DancesScreenState();
}

class _DancesScreenState extends State<DancesScreen> {
  final DanceService _danceService = DanceService();
  late Future<List<Dance>> _dancesFuture;

  @override
  void initState() {
    super.initState();
    _dancesFuture = _danceService.getAllDances(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Dance>>(
        future: _dancesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Error al cargar los bailes:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final dances = snapshot.data ?? [];

          if (dances.isEmpty) {
            return const Center(
              child: Text(
                'Todavía no hay bailes cargados en la base de datos',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dances.length,
            itemBuilder: (context, index) {
              final dance = dances[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.music_note),
                  title: Text(dance.name),
                  subtitle: Text(
                    'Región: ${dance.region}\n${dance.description}',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}