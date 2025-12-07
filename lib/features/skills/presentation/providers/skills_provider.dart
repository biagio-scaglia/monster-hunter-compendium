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

  // Mostra le skill filtrate se c'è una ricerca attiva, altrimenti mostra tutte le skill
  List<SkillModel> get skills {
    final hasNoSearch = _searchQuery.isEmpty;
    final hasNoFilteredResults = _filteredSkills.isEmpty;
    
    if (hasNoSearch && hasNoFilteredResults) {
      return _skills;
    } else {
      return _filteredSkills;
    }
  }
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
      // Controlla se corrisponde alla ricerca
      if (_searchQuery.isNotEmpty) {
        final skillName = skill.name.toLowerCase();
        final skillDescription = skill.description.toLowerCase();
        final searchLower = _searchQuery.toLowerCase();
        
        final matchesName = skillName.contains(searchLower);
        final matchesDescription = skillDescription.contains(searchLower);
        
        if (!matchesName && !matchesDescription) {
          return false;
        }
      }

      return true;
    }).toList();

    notifyListeners();
  }
}

