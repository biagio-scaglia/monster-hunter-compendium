import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/armor_model.dart';

class ArmorRepository {
  final http.Client client;

  ArmorRepository({http.Client? client}) 
      : client = client ?? http.Client();

  Future<List<ArmorModel>> getArmor({String? query, int? limit}) async {
    try {
      final queryParams = <String, String>{};
      if (query != null) queryParams['q'] = query;
      if (limit != null) {
        queryParams['p'] = '{"id":true,"name":true,"type":true,"rank":true,"rarity":true,"defense":true,"assets":true}';
      }

      final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.armorEndpoint)
          .replace(queryParameters: queryParams);

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is List) {
          return jsonData
              .map((item) => ArmorModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        return [];
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load armor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching armor: $e');
    }
  }

  Future<ArmorModel> getArmorById(int armorId) async {
    try {
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getArmorById(armorId),
      );

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ArmorModel.fromJson(jsonData as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw Exception('Armor not found');
      } else {
        throw Exception('Failed to load armor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching armor: $e');
    }
  }
}

