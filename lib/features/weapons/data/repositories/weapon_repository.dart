import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/weapon_model.dart';

class WeaponRepository {
  final http.Client client;

  WeaponRepository({http.Client? client}) 
      : client = client ?? http.Client();

  Future<List<WeaponModel>> getWeapons({String? query, int? limit}) async {
    try {
      final queryParams = <String, String>{};
      if (query != null) queryParams['q'] = query;
      if (limit != null) {
        queryParams['p'] = '{"id":true,"name":true,"type":true,"rarity":true,"attack":true,"assets":true}';
      }

      final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.weaponsEndpoint)
          .replace(queryParameters: queryParams);

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is List) {
          return jsonData
              .map((item) => WeaponModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        return [];
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load weapons: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weapons: $e');
    }
  }

  Future<WeaponModel> getWeaponById(int weaponId) async {
    try {
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getWeaponById(weaponId),
      );

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return WeaponModel.fromJson(jsonData as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw Exception('Weapon not found');
      } else {
        throw Exception('Failed to load weapon: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weapon: $e');
    }
  }
}

