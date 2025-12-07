class AilmentModel {
  final int id;
  final String name;
  final String description;
  final Map<String, dynamic>? recovery;
  final Map<String, dynamic>? protection;

  AilmentModel({
    required this.id,
    required this.name,
    required this.description,
    this.recovery,
    this.protection,
  });

  factory AilmentModel.fromJson(Map<String, dynamic> json) {
    return AilmentModel(
      id: json['id'] is int ? json['id'] as int : (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      recovery: json['recovery'] as Map<String, dynamic>?,
      protection: json['protection'] as Map<String, dynamic>?,
    );
  }
}

