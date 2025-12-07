class WeaponModel {
  final int id;
  final String name;
  final String type;
  final int rarity;
  final Map<String, dynamic>? attack;
  final String? damageType;
  final List<dynamic>? slots;
  final List<dynamic>? elements;
  final Map<String, dynamic>? crafting;
  final Map<String, dynamic>? assets;

  WeaponModel({
    required this.id,
    required this.name,
    required this.type,
    required this.rarity,
    this.attack,
    this.damageType,
    this.slots,
    this.elements,
    this.crafting,
    this.assets,
  });

  factory WeaponModel.fromJson(Map<String, dynamic> json) {
    return WeaponModel(
      id: json['id'] is int ? json['id'] as int : (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      type: (json['type'] as String?) ?? '',
      rarity: json['rarity'] is int ? json['rarity'] as int : (json['rarity'] as num?)?.toInt() ?? 0,
      attack: json['attack'] as Map<String, dynamic>?,
      damageType: json['damageType'] as String?,
      slots: json['slots'] is List ? json['slots'] as List<dynamic> : null,
      elements: json['elements'] is List ? json['elements'] as List<dynamic> : null,
      crafting: json['crafting'] as Map<String, dynamic>?,
      assets: json['assets'] as Map<String, dynamic>?,
    );
  }
  
  String? get imageUrl {
    if (assets == null) return null;
    return assets!['image'] as String?;
  }
  
  String? get iconUrl {
    if (assets == null) return null;
    return assets!['icon'] as String?;
  }
}

