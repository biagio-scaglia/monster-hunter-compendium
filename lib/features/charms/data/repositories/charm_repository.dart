import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/charm_model.dart';

class CharmRepository {
  final http.Client client;

  CharmRepository({http.Client? client}) 
      : client = client ?? http.Client();

  Future<List<CharmModel>> getCharms({String? query}) async {
    try {
      final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.charmsEndpoint)
          .replace(queryParameters: {
        if (query != null) 'q': query,
      });

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is List) {
          return jsonData
              .map((item) => CharmModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        return [];
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load charms: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching charms: $e');
    }
  }

  Future<CharmModel> getCharmById(int charmId) async {
    try {
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getCharmById(charmId),
      );

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return CharmModel.fromJson(jsonData as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw Exception('Charm not found');
      } else {
        throw Exception('Failed to load charm: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching charm: $e');
    }
  }
}

