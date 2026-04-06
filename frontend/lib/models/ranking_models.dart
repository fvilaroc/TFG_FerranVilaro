class GlobalRankingEntry {
  final String username;
  final int points;

  GlobalRankingEntry({
    required this.username,
    required this.points,
  });

  factory GlobalRankingEntry.fromJson(Map<String, dynamic> json) {
    return GlobalRankingEntry(
      username: json['username'] ?? 'Usuario',
      points: json['points'] ?? 0,
    );
  }
}