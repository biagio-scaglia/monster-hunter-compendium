import 'package:flutter/foundation.dart';

class MonsterModel {
  final int id;
  final String name;
  final String type;
  final String species;
  final String? description;
  final List<String> elements;
  final List<dynamic> ailments;
  final List<dynamic> locations;
  final List<dynamic> resistances;
  final List<dynamic> weaknesses;
  final List<dynamic> rewards;
  final Map<String, dynamic>? assets;

  MonsterModel({
    required this.id,
    required this.name,
    required this.type,
    required this.species,
    this.description,
    this.elements = const [],
    this.ailments = const [],
    this.locations = const [],
    this.resistances = const [],
    this.weaknesses = const [],
    this.rewards = const [],
    this.assets,
  });

  factory MonsterModel.fromJson(Map<String, dynamic> json) {
    return MonsterModel(
      id: json['id'] is int ? json['id'] as int : (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      type: (json['type'] as String?) ?? 'unknown',
      species: (json['species'] as String?) ?? 'unknown',
      description: json['description'] as String?,
      elements: json['elements'] != null && json['elements'] is List
          ? (json['elements'] as List).map((e) => e.toString()).toList()
          : [],
      ailments: json['ailments'] is List ? json['ailments'] as List<dynamic> : [],
      locations: json['locations'] is List ? json['locations'] as List<dynamic> : [],
      resistances: json['resistances'] is List ? json['resistances'] as List<dynamic> : [],
      weaknesses: json['weaknesses'] is List ? json['weaknesses'] as List<dynamic> : [],
      rewards: json['rewards'] is List ? json['rewards'] as List<dynamic> : [],
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
    final finalUrl = url.startsWith('http://') || url.startsWith('https://')
        ? url
        : 'https://mhw-db.com' + (url.startsWith('/') ? url : '/$url');
    
    return finalUrl;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'species': species,
      'description': description,
      'elements': elements,
      'ailments': ailments,
      'locations': locations,
      'resistances': resistances,
      'weaknesses': weaknesses,
      'rewards': rewards,
    };
  }
}

