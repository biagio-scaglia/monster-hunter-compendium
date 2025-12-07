import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/monster_model.dart';

class MonsterRepository {
  final http.Client client;

  MonsterRepository({http.Client? client}) 
      : client = client ?? http.Client();

  Future<List<MonsterModel>> getMonsters({
    String? query,
    int? limit,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (query != null) queryParams['q'] = query;
      // Richiedi sempre gli assets per avere le immagini
      queryParams['p'] = '{"id":true,"name":true,"type":true,"species":true,"description":true,"assets":true}';
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }

      final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.monstersEndpoint)
          .replace(queryParameters: queryParams);

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is List) {
          final monsters = jsonData
              .map((item) {
                try {
                  return MonsterModel.fromJson(item as Map<String, dynamic>);
                } catch (e) {
                  if (kDebugMode) {
                    print('❌ [MonsterRepository] Error parsing monster: $e');
                  }
                  return null;
                }
              })
              .whereType<MonsterModel>()
              .toList();

          if (kDebugMode) {
            print('🐉 [MonsterRepository] Caricati ${monsters.length} mostri');
            if (monsters.isNotEmpty) {
              final firstMonster = monsters.first;
              print('🐉 [MonsterRepository] Primo mostro: ${firstMonster.name}');
              print('🐉 [MonsterRepository] Assets: ${firstMonster.assets}');
              print('🐉 [MonsterRepository] Icon URL: ${firstMonster.iconUrl}');
              print('🐉 [MonsterRepository] Image URL: ${firstMonster.imageUrl}');
            }
          }

          return monsters;
        }

        return [];
      } else if (response.statusCode == 404) {
        if (kDebugMode) {
          print('❌ [MonsterRepository] 404 - Nessun mostro trovato');
        }
        return [];
      } else {
        if (kDebugMode) {
          print('❌ [MonsterRepository] Errore ${response.statusCode}: ${response.body}');
        }
        throw Exception('Failed to load monsters: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ [MonsterRepository] Errore durante il fetch: $e');
        print('❌ [MonsterRepository] Stack trace: $stackTrace');
      }
      throw Exception('Error fetching monsters: $e');
    }
  }

  Future<MonsterModel> getMonsterById(int monsterId) async {
    try {
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getMonsterById(monsterId),
      );

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is Map<String, dynamic>) {
          return MonsterModel.fromJson(jsonData);
        }

        throw Exception('Invalid response format');
      } else if (response.statusCode == 404) {
        throw Exception('Monster not found');
      } else {
        throw Exception('Failed to load monster: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching monster: $e');
    }
  }
}

