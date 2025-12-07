import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/weapon_model.dart';

class WeaponRepository {
  final http.Client client;

  WeaponRepository({http.Client? client}) 
      : client = client ?? http.Client();

  // Carica tutte le armi, opzionalmente filtrate per query e limitate
  Future<List<WeaponModel>> getWeapons({String? query, int? limit}) async {
    try {
      // Costruisce i parametri di query
      final queryParams = <String, String>{};
      
      // Aggiunge la query di ricerca se presente
      if (query != null) {
        queryParams['q'] = query;
      }
      
      // Richiede sempre gli assets per avere le immagini
      queryParams['p'] = '{"id":true,"name":true,"type":true,"rarity":true,"attack":true,"assets":true}';
      
      // Aggiunge il limite se presente
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }

      // Costruisce l'URL
      final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.weaponsEndpoint)
          .replace(queryParameters: queryParams);

      // Fa la richiesta HTTP
      final response = await client.get(uri);

      // Se la richiesta è andata a buon fine
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Se i dati sono una lista, li converte in modelli
        if (jsonData is List) {
          final weapons = jsonData
              .map((item) => WeaponModel.fromJson(item as Map<String, dynamic>))
              .toList();
          
          return weapons;
        }

        return [];
      } 
      // Se non trovato, restituisce lista vuota
      else if (response.statusCode == 404) {
        return [];
      } 
      // Altrimenti lancia un errore
      else {
        throw Exception('Failed to load weapons: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      throw Exception('Error fetching weapons: $e');
    }
  }

  // Carica una singola arma tramite ID con tutte le informazioni complete
  Future<WeaponModel> getWeaponById(int weaponId) async {
    try {
      // Costruisce l'URL per l'arma specifica
      // L'API restituisce già tutte le informazioni per un singolo elemento
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getWeaponById(weaponId),
      );

      // Fa la richiesta HTTP
      final response = await client.get(uri);

      // Se la richiesta è andata a buon fine
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return WeaponModel.fromJson(jsonData as Map<String, dynamic>);
      } 
      // Se non trovato, lancia un errore
      else if (response.statusCode == 404) {
        throw Exception('Weapon not found');
      } 
      // Altrimenti lancia un errore
      else {
        throw Exception('Failed to load weapon: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weapon: $e');
    }
  }
}

