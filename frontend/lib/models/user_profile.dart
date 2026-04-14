class UserProfile {
  final String username;
  final int points;
  final int streak;
  final String role;

  UserProfile({
    required this.username,
    required this.points,
    required this.streak,
    required this.role,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'] ?? '',
      points: json['points'] ?? 0,
      streak: json['streak'] ?? 0,
      role: json['role'] ?? 'user',
    );
  }
}