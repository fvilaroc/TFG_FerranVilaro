class GlobalRankingEntry {
  final String username;
  final int points;

  const GlobalRankingEntry({
    required this.username,
    required this.points,
  });

  factory GlobalRankingEntry.fromJson(Map<String, dynamic> json) {
    return GlobalRankingEntry(
      username: (json['username'] ?? json['userName'] ?? 'Usuario').toString(),
      points: _readInt(json['points'] ?? json['totalPoints']),
    );
  }
}

class DanceRankingEntry {
  final String username;
  final int points;

  const DanceRankingEntry({
    required this.username,
    required this.points,
  });

  factory DanceRankingEntry.fromJson(Map<String, dynamic> json) {
    return DanceRankingEntry(
      username: (json['username'] ?? json['userName'] ?? 'Usuario').toString(),
      points: _readInt(
        json['points'] ??
            json['dancePoints'] ??
            json['progressPoints'] ??
            json['totalPoints'],
      ),
    );
  }
}

class RankingDanceOption {
  final int id;
  final String name;
  final String? region;

  const RankingDanceOption({
    required this.id,
    required this.name,
    this.region,
  });

  factory RankingDanceOption.fromJson(Map<String, dynamic> json) {
    return RankingDanceOption(
      id: _readInt(json['id'] ?? json['danceId']),
      name: (json['name'] ?? json['danceName'] ?? 'Baile').toString(),
      region: json['region']?.toString(),
    );
  }
}

int _readInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}