class ItemModel {
  final int id;
  final String name;
  final String description;
  final int rarity;
  final int carryLimit;
  final int value;

  ItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.rarity,
    required this.carryLimit,
    required this.value,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      rarity: json['rarity'] as int? ?? 0,
      carryLimit: json['carryLimit'] as int? ?? 0,
      value: json['value'] as int? ?? 0,
    );
  }
}

