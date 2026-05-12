class UserMedal {
  final int id;
  final String medal;

  UserMedal({
    required this.id,
    required this.medal,
  });

  factory UserMedal.fromJson(Map<String, dynamic> json) {
    return UserMedal(
      id: json['id'] ?? 0,
      medal: json['medal'] ?? '',
    );
  }
}