class Dance {
  final int id;
  final String name;
  final String region;
  final String description;
  final String videoUrl;

  Dance({
    required this.id,
    required this.name,
    required this.region,
    required this.description,
    required this.videoUrl,
  });

  factory Dance.fromJson(Map<String, dynamic> json) {
    return Dance(
      id: json['id'],
      name: json['name'] ?? '',
      region: json['region'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
    );
  }
}