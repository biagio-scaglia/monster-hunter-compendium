import 'package:flutter/foundation.dart';
import '../../data/models/skill_model.dart';
import '../../data/repositories/skill_repository.dart';

class SkillsProvider extends ChangeNotifier {
  final SkillRepository repository;

  List<SkillModel> _skills = [];
  bool _isLoading = false;
  String? _error;

  SkillsProvider({SkillRepository? repository})
      : repository = repository ?? SkillRepository();

  List<SkillModel> get skills => _skills;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  Future<void> loadSkills({String? query}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _skills = await repository.getSkills(query: query);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _skills = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshSkills() async {
    await loadSkills();
  }
}

