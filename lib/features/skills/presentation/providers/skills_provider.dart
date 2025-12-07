import 'package:flutter/foundation.dart';
import '../../data/models/skill_model.dart';
import '../../data/repositories/skill_repository.dart';

class SkillsProvider extends ChangeNotifier {
  final SkillRepository repository;

  List<SkillModel> _skills = [];
  List<SkillModel> _filteredSkills = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  SkillsProvider({SkillRepository? repository})
      : repository = repository ?? SkillRepository();

  List<SkillModel> get skills => _filteredSkills.isEmpty && _searchQuery.isEmpty
      ? _skills
      : _filteredSkills;
  List<SkillModel> get allSkills => _skills;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  String get searchQuery => _searchQuery;

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

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void _applyFilters() {
    _filteredSkills = _skills.where((skill) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final matchesSearch = skill.name.toLowerCase().contains(_searchQuery) ||
            skill.description.toLowerCase().contains(_searchQuery);
        if (!matchesSearch) return false;
      }

      return true;
    }).toList();

    notifyListeners();
  }
}

