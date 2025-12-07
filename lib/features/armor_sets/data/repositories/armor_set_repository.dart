import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/armor_set_model.dart';

class ArmorSetRepository {
  final http.Client client;

  ArmorSetRepository({http.Client? client}) 
      : client = client ?? http.Client();

  Future<List<ArmorSetModel>> getArmorSets({String? query}) async {
    try {
      final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.armorSetsEndpoint)
          .replace(queryParameters: {
        if (query != null) 'q': query,
      });

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is List) {
          return jsonData
              .map((item) => ArmorSetModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        return [];
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load armor sets: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching armor sets: $e');
    }
  }

  // Carica un singolo armor set tramite ID, includendo gli assets dei pezzi
  Future<ArmorSetModel> getArmorSetById(int setId) async {
    try {
      // Richiede anche gli assets dei pezzi per avere le immagini maschili e femminili
      final queryParams = <String, String>{
        'p': '{"id":true,"name":true,"rank":true,"pieces":{"id":true,"name":true,"type":true,"rank":true,"rarity":true,"assets":true},"bonus":true}',
      };
      
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getArmorSetById(setId),
      ).replace(queryParameters: queryParams);

      final response = await client.get(uri);

      // Se la richiesta è andata a buon fine
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ArmorSetModel.fromJson(jsonData as Map<String, dynamic>);
      } 
      // Se non trovato, lancia un errore
      else if (response.statusCode == 404) {
        throw Exception('Armor set not found');
      } 
      // Altrimenti lancia un errore
      else {
        throw Exception('Failed to load armor set: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching armor set: $e');
    }
  }
}

