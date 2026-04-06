class UserProfile {
  final String username;
  final int points;
  final int streak;

  UserProfile({
    required this.username,
    required this.points,
    required this.streak,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'] ?? '',
      points: json['points'] ?? 0,
      streak: json['streak'] ?? 0,
    );
  }
}