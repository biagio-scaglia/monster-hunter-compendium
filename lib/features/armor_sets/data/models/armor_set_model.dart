class ArmorSetModel {
  final int id;
  final String name;
  final String rank;
  final List<dynamic> pieces;
  final Map<String, dynamic>? bonus;

  ArmorSetModel({
    required this.id,
    required this.name,
    required this.rank,
    this.pieces = const [],
    this.bonus,
  });

  factory ArmorSetModel.fromJson(Map<String, dynamic> json) {
    return ArmorSetModel(
      id: json['id'] is int ? json['id'] as int : (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      rank: (json['rank'] as String?) ?? '',
      pieces: json['pieces'] is List ? json['pieces'] as List<dynamic> : [],
      bonus: json['bonus'] as Map<String, dynamic>?,
    );
  }
}

