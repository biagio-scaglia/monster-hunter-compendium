import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/decoration_model.dart';

class DecorationRepository {
  final http.Client client;

  DecorationRepository({http.Client? client}) 
      : client = client ?? http.Client();

  Future<List<DecorationModel>> getDecorations({String? query}) async {
    try {
      final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.decorationsEndpoint)
          .replace(queryParameters: {
        if (query != null) 'q': query,
      });

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is List) {
          return jsonData
              .map((item) => DecorationModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        return [];
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load decorations: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching decorations: $e');
    }
  }

  Future<DecorationModel> getDecorationById(int decorationId) async {
    try {
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getDecorationById(decorationId),
      );

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return DecorationModel.fromJson(jsonData as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw Exception('Decoration not found');
      } else {
        throw Exception('Failed to load decoration: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching decoration: $e');
    }
  }
}

