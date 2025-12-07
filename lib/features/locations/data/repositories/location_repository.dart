import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/location_model.dart';

class LocationRepository {
  final http.Client client;

  LocationRepository({http.Client? client}) 
      : client = client ?? http.Client();

  Future<List<LocationModel>> getLocations({String? query}) async {
    try {
      final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.locationsEndpoint)
          .replace(queryParameters: {
        if (query != null) 'q': query,
      });

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is List) {
          return jsonData
              .map((item) => LocationModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        return [];
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load locations: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching locations: $e');
    }
  }

  Future<LocationModel> getLocationById(int locationId) async {
    try {
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getLocationById(locationId),
      );

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return LocationModel.fromJson(jsonData as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw Exception('Location not found');
      } else {
        throw Exception('Failed to load location: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching location: $e');
    }
  }
}

