import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/ailment_model.dart';

class AilmentRepository {
  final http.Client client;

  AilmentRepository({http.Client? client}) 
      : client = client ?? http.Client();

  // Carica tutti gli ailments
  Future<List<AilmentModel>> getAilments({String? query}) async {
    try {
      // Costruisce l'URL con i parametri di query
      final queryParams = <String, String>{};
      if (query != null) {
        queryParams['q'] = query;
      }
      
      final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.ailmentsEndpoint)
          .replace(queryParameters: queryParams);

      // Fa la richiesta HTTP
      final response = await client.get(uri);

      // Se la richiesta è andata a buon fine
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Se i dati sono una lista, li converte in modelli
        if (jsonData is List) {
          return jsonData
              .map((item) => AilmentModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        return [];
      } 
      // Se non trovato, restituisce lista vuota
      else if (response.statusCode == 404) {
        return [];
      } 
      // Altrimenti lancia un errore
      else {
        throw Exception('Failed to load ailments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching ailments: $e');
    }
  }

  // Carica un singolo ailment tramite ID
  Future<AilmentModel> getAilmentById(int ailmentId) async {
    try {
      // Costruisce l'URL per l'ailment specifico
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getAilmentById(ailmentId),
      );

      // Fa la richiesta HTTP
      final response = await client.get(uri);

      // Se la richiesta è andata a buon fine
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return AilmentModel.fromJson(jsonData as Map<String, dynamic>);
      } 
      // Se non trovato, lancia un errore
      else if (response.statusCode == 404) {
        throw Exception('Ailment not found');
      } 
      // Altrimenti lancia un errore
      else {
        throw Exception('Failed to load ailment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching ailment: $e');
    }
  }
}

