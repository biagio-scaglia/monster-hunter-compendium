import 'package:flutter/foundation.dart';

class WeaponModel {
  final int id;
  final String name;
  final String type;
  final int rarity;
  final Map<String, dynamic>? attack;
  final String? damageType;
  final String? elderseal;
  final Map<String, dynamic>? attributes;
  final List<dynamic>? slots;
  final List<dynamic>? elements;
  final List<dynamic>? durability;
  final Map<String, dynamic>? crafting;
  final Map<String, dynamic>? assets;

  WeaponModel({
    required this.id,
    required this.name,
    required this.type,
    required this.rarity,
    this.attack,
    this.damageType,
    this.elderseal,
    this.attributes,
    this.slots,
    this.elements,
    this.durability,
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
      damageType: json['damageType'] as String? ?? (json['attributes']?['damageType'] as String?),
      elderseal: json['elderseal'] as String?,
      attributes: json['attributes'] as Map<String, dynamic>?,
      slots: json['slots'] is List ? json['slots'] as List<dynamic> : null,
      elements: json['elements'] is List ? json['elements'] as List<dynamic> : null,
      durability: json['durability'] is List ? json['durability'] as List<dynamic> : null,
      crafting: json['crafting'] as Map<String, dynamic>?,
      assets: json['assets'] as Map<String, dynamic>?,
    );
  }
  
  String? get imageUrl {
    if (assets == null) {
      return null;
    }
    final url = assets!['image'] as String?;
    if (url == null || url.isEmpty) {
      return null;
    }
    // Gli URL dall'API sono già assoluti (https://assets.mhw-db.com/...)
    // Se per qualche motivo fossero relativi, li convertiamo
    final finalUrl = url.startsWith('http://') || url.startsWith('https://')
        ? url
        : 'https://mhw-db.com' + (url.startsWith('/') ? url : '/$url');
    
    return finalUrl;
  }
  
  String? get iconUrl {
    if (assets == null) {
      return null;
    }
    final url = assets!['icon'] as String?;
    if (url == null || url.isEmpty) {
      return null;
    }
    // Gli URL dall'API sono già assoluti (https://assets.mhw-db.com/...)
    // Se per qualche motivo fossero relativi, li convertiamo
    final finalUrl = url.startsWith('http://') || url.startsWith('https://')
        ? url
        : 'https://mhw-db.com' + (url.startsWith('/') ? url : '/$url');
    
    return finalUrl;
  }
}

