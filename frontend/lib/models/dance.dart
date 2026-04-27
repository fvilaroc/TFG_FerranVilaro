class Dance {
  final int id;
  final String name;
  final String region;
  final String description;
  final String videoUrl;
  final String history;
  final String origin;
  final String clothing;
  final String musicCharacteristics;

  Dance({
    required this.id,
    required this.name,
    required this.region,
    required this.description,
    required this.videoUrl,
    required this.history,
    required this.origin,
    required this.clothing,
    required this.musicCharacteristics
  });

  factory Dance.fromJson(Map<String, dynamic> json) {
    return Dance(
      id: json['id'],
      name: json['name'] ?? '',
      region: json['region'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      history: json['history'] ?? '',
      origin: json['origin'] ?? '',
      clothing: json['clothing'] ?? '',
      musicCharacteristics: json['musicCharacteristics'] ?? ''
    );
  }
}