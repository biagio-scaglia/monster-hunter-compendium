import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/motion_value_model.dart';

class MotionValueRepository {
  final http.Client client;

  MotionValueRepository({http.Client? client}) 
      : client = client ?? http.Client();

  // Carica tutti i motion values
  Future<List<MotionValueModel>> getMotionValues({String? weaponType}) async {
    try {
      // Costruisce l'URL
      String endpoint = ApiConstants.motionValuesEndpoint;
      if (weaponType != null) {
        endpoint = ApiConstants.getMotionValuesByWeaponType(weaponType);
      }
      
      final uri = Uri.parse(ApiConstants.baseUrl + endpoint);

      // Fa la richiesta HTTP
      final response = await client.get(uri);

      // Se la richiesta è andata a buon fine
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Se i dati sono una lista, li converte in modelli
        if (jsonData is List) {
          return jsonData
              .map((item) => MotionValueModel.fromJson(item as Map<String, dynamic>))
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
        throw Exception('Failed to load motion values: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching motion values: $e');
    }
  }

  // Carica un singolo motion value tramite ID
  Future<MotionValueModel> getMotionValueById(int motionValueId) async {
    try {
      // Costruisce l'URL per il motion value specifico
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getMotionValueById(motionValueId),
      );

      // Fa la richiesta HTTP
      final response = await client.get(uri);

      // Se la richiesta è andata a buon fine
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MotionValueModel.fromJson(jsonData as Map<String, dynamic>);
      } 
      // Se non trovato, lancia un errore
      else if (response.statusCode == 404) {
        throw Exception('Motion value not found');
      } 
      // Altrimenti lancia un errore
      else {
        throw Exception('Failed to load motion value: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching motion value: $e');
    }
  }
}

