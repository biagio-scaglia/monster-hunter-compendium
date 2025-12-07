import 'package:flutter/foundation.dart';

class ArmorModel {
  final int id;
  final String name;
  final String type;
  final String rank;
  final int rarity;
  final Map<String, dynamic>? defense;
  final Map<String, dynamic>? resistances;
  final List<dynamic>? slots;
  final List<dynamic>? skills;
  final Map<String, dynamic>? armorSet;
  final Map<String, dynamic>? assets;

  ArmorModel({
    required this.id,
    required this.name,
    required this.type,
    required this.rank,
    required this.rarity,
    this.defense,
    this.resistances,
    this.slots,
    this.skills,
    this.armorSet,
    this.assets,
  });

  factory ArmorModel.fromJson(Map<String, dynamic> json) {
    return ArmorModel(
      id: json['id'] is int ? json['id'] as int : (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      type: (json['type'] as String?) ?? '',
      rank: (json['rank'] as String?) ?? '',
      rarity: json['rarity'] is int ? json['rarity'] as int : (json['rarity'] as num?)?.toInt() ?? 0,
      defense: json['defense'] as Map<String, dynamic>?,
      resistances: json['resistances'] as Map<String, dynamic>?,
      slots: json['slots'] is List ? json['slots'] as List<dynamic> : null,
      skills: json['skills'] is List ? json['skills'] as List<dynamic> : null,
      armorSet: json['armorSet'] as Map<String, dynamic>?,
      assets: json['assets'] as Map<String, dynamic>?,
    );
  }
  
  String? _getAbsoluteUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    // Se l'URL è relativo, convertilo in assoluto
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    return 'https://mhw-db.com' + (url.startsWith('/') ? url : '/$url');
  }

  String? get imageMaleUrl {
    if (assets == null) {
      return null;
    }
    return _getAbsoluteUrl(assets!['imageMale'] as String?);
  }
  
  String? get imageFemaleUrl {
    if (assets == null) return null;
    return _getAbsoluteUrl(assets!['imageFemale'] as String?);
  }
  
  String? get imageUrl {
    return imageMaleUrl ?? imageFemaleUrl;
  }
}

