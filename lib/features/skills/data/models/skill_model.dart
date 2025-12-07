class SkillModel {
  final int id;
  final String name;
  final String description;
  final List<dynamic> ranks;

  SkillModel({
    required this.id,
    required this.name,
    required this.description,
    this.ranks = const [],
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      ranks: json['ranks'] as List<dynamic>? ?? [],
    );
  }
}

