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
                  return null;
                }
              })
              .whereType<MonsterModel>()
              .toList();

          return monsters;
        }

        return [];
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load monsters: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      throw Exception('Error fetching monsters: $e');
    }
  }

  // Carica un singolo mostro tramite ID con tutte le informazioni complete
  Future<MonsterModel> getMonsterById(int monsterId) async {
    try {
      // Richiede tutte le informazioni: ailments, locations, resistances, weaknesses, rewards, assets
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getMonsterById(monsterId),
      );

      final response = await client.get(uri);

      // Se la richiesta è andata a buon fine
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is Map<String, dynamic>) {
          return MonsterModel.fromJson(jsonData);
        }

        throw Exception('Invalid response format');
      } 
      // Se non trovato, lancia un errore
      else if (response.statusCode == 404) {
        throw Exception('Monster not found');
      } 
      // Altrimenti lancia un errore
      else {
        throw Exception('Failed to load monster: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching monster: $e');
    }
  }
}

