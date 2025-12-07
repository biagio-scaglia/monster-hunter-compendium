class MotionValueModel {
  final int id;
  final String name;
  final String weaponType;
  final String damageType;
  final int? stun;
  final int? exhaust;
  final List<int> hits;

  MotionValueModel({
    required this.id,
    required this.name,
    required this.weaponType,
    required this.damageType,
    this.stun,
    this.exhaust,
    this.hits = const [],
  });

  factory MotionValueModel.fromJson(Map<String, dynamic> json) {
    return MotionValueModel(
      id: json['id'] is int ? json['id'] as int : (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      weaponType: (json['weaponType'] as String?) ?? '',
      damageType: (json['damageType'] as String?) ?? '',
      stun: json['stun'] is int ? json['stun'] as int : (json['stun'] as num?)?.toInt(),
      exhaust: json['exhaust'] is int ? json['exhaust'] as int : (json['exhaust'] as num?)?.toInt(),
      hits: json['hits'] is List ? (json['hits'] as List).map((e) => e is int ? e : (e as num?)?.toInt() ?? 0).toList() : [],
    );
  }
}

