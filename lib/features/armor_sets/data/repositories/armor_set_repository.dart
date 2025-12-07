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

  Future<ArmorSetModel> getArmorSetById(int setId) async {
    try {
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getArmorSetById(setId),
      );

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ArmorSetModel.fromJson(jsonData as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw Exception('Armor set not found');
      } else {
        throw Exception('Failed to load armor set: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching armor set: $e');
    }
  }
}

