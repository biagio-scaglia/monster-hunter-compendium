class CharmModel {
  final int id;
  final String name;
  final List<dynamic> ranks;

  CharmModel({
    required this.id,
    required this.name,
    this.ranks = const [],
  });

  factory CharmModel.fromJson(Map<String, dynamic> json) {
    return CharmModel(
      id: json['id'] is int ? json['id'] as int : (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      ranks: json['ranks'] is List ? json['ranks'] as List<dynamic> : [],
    );
  }
  
  // I ranks contengono: level, rarity, skills, crafting
}

