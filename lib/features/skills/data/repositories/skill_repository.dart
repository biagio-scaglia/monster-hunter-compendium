import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/skill_model.dart';

class SkillRepository {
  final http.Client client;

  SkillRepository({http.Client? client}) 
      : client = client ?? http.Client();

  Future<List<SkillModel>> getSkills({String? query}) async {
    try {
      final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.skillsEndpoint)
          .replace(queryParameters: {
        if (query != null) 'q': query,
      });

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is List) {
          return jsonData
              .map((item) => SkillModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        return [];
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load skills: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching skills: $e');
    }
  }

  Future<SkillModel> getSkillById(int skillId) async {
    try {
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getSkillById(skillId),
      );

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return SkillModel.fromJson(jsonData as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw Exception('Skill not found');
      } else {
        throw Exception('Failed to load skill: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching skill: $e');
    }
  }
}

