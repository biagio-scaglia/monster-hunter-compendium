import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/event_model.dart';

class EventRepository {
  final http.Client client;

  EventRepository({http.Client? client}) 
      : client = client ?? http.Client();

  Future<List<EventModel>> getEvents({String? query}) async {
    try {
      final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.eventsEndpoint)
          .replace(queryParameters: {
        if (query != null) 'q': query,
      });

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is List) {
          return jsonData
              .map((item) => EventModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        return [];
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }

  Future<EventModel> getEventById(int eventId) async {
    try {
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getEventById(eventId),
      );

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return EventModel.fromJson(jsonData as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw Exception('Event not found');
      } else {
        throw Exception('Failed to load event: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching event: $e');
    }
  }
}

