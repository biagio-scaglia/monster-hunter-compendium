import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/item_model.dart';

class ItemRepository {
  final http.Client client;

  ItemRepository({http.Client? client}) 
      : client = client ?? http.Client();

  Future<List<ItemModel>> getItems({String? query}) async {
    try {
      final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.itemsEndpoint)
          .replace(queryParameters: {
        if (query != null) 'q': query,
      });

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is List) {
          return jsonData
              .map((item) => ItemModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        return [];
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching items: $e');
    }
  }

  Future<ItemModel> getItemById(int itemId) async {
    try {
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getItemById(itemId),
      );

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ItemModel.fromJson(jsonData as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw Exception('Item not found');
      } else {
        throw Exception('Failed to load item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching item: $e');
    }
  }
}

