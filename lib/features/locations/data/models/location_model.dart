class LocationModel {
  final int id;
  final String name;
  final int zoneCount;
  final List<dynamic> camps;

  LocationModel({
    required this.id,
    required this.name,
    required this.zoneCount,
    this.camps = const [],
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] is int ? json['id'] as int : (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      zoneCount: json['zoneCount'] is int ? json['zoneCount'] as int : (json['zoneCount'] as num?)?.toInt() ?? 0,
      camps: json['camps'] is List ? json['camps'] as List<dynamic> : [],
    );
  }
}

