class DecorationModel {
  final int id;
  final String name;
  final int rarity;
  final int slot;
  final List<dynamic> skills;

  DecorationModel({
    required this.id,
    required this.name,
    required this.rarity,
    required this.slot,
    this.skills = const [],
  });

  factory DecorationModel.fromJson(Map<String, dynamic> json) {
    return DecorationModel(
      id: json['id'] is int ? json['id'] as int : (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      rarity: json['rarity'] is int ? json['rarity'] as int : (json['rarity'] as num?)?.toInt() ?? 0,
      slot: json['slot'] is int ? json['slot'] as int : (json['slot'] as num?)?.toInt() ?? 0,
      skills: json['skills'] is List ? json['skills'] as List<dynamic> : [],
    );
  }
}

