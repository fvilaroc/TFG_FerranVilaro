import 'package:flutter/material.dart';
import '../models/ranking_models.dart';
import '../services/ranking_service.dart';

class RankingScreen extends StatefulWidget {
  final String token;

  const RankingScreen({super.key, required this.token});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final RankingService _rankingService = RankingService();
  late Future<List<GlobalRankingEntry>> _rankingFuture;

  @override
  void initState() {
    super.initState();
    _rankingFuture = _rankingService.getGlobalRanking(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<GlobalRankingEntry>>(
        future: _rankingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Error al cargar el ranking:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final ranking = snapshot.data ?? [];

          if (ranking.isEmpty) {
            return const Center(
              child: Text('Todavía no hay datos en el ranking'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ranking.length,
            itemBuilder: (context, index) {
              final user = ranking[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(user.username),
                  subtitle: Text('Puntos: ${user.points}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}