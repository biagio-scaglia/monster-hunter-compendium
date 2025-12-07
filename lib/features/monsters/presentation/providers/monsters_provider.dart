import 'package:flutter/foundation.dart';
import '../../data/models/monster_model.dart';
import '../../data/repositories/monster_repository.dart';

class MonstersProvider extends ChangeNotifier {
  final MonsterRepository repository;

  List<MonsterModel> _monsters = [];
  List<MonsterModel> _filteredMonsters = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  List<String> _selectedTypes = [];
  List<String> _selectedSpecies = [];

  MonstersProvider({MonsterRepository? repository})
      : repository = repository ?? MonsterRepository();

  List<MonsterModel> get monsters => _filteredMonsters.isEmpty && _searchQuery.isEmpty && _selectedTypes.isEmpty && _selectedSpecies.isEmpty
      ? _monsters
      : _filteredMonsters;
  List<MonsterModel> get allMonsters => _monsters;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  String get searchQuery => _searchQuery;
  List<String> get selectedTypes => _selectedTypes;
  List<String> get selectedSpecies => _selectedSpecies;

  Future<void> loadMonsters({String? query, int? limit}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _monsters = await repository.getMonsters(query: query, limit: limit);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _monsters = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshMonsters() async {
    await loadMonsters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void setSelectedTypes(List<String> types) {
    _selectedTypes = types;
    _applyFilters();
  }

  void setSelectedSpecies(List<String> species) {
    _selectedSpecies = species;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredMonsters = _monsters.where((monster) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final matchesSearch = monster.name.toLowerCase().contains(_searchQuery) ||
            (monster.description?.toLowerCase().contains(_searchQuery) ?? false) ||
            monster.type.toLowerCase().contains(_searchQuery) ||
            monster.species.toLowerCase().contains(_searchQuery);
        if (!matchesSearch) return false;
      }

      // Type filter
      if (_selectedTypes.isNotEmpty) {
        if (!_selectedTypes.contains(monster.type)) return false;
      }

      // Species filter
      if (_selectedSpecies.isNotEmpty) {
        if (!_selectedSpecies.contains(monster.species)) return false;
      }

      return true;
    }).toList();

    notifyListeners();
  }

  List<String> getAvailableTypes() {
    return _monsters.map((m) => m.type).where((type) => type.isNotEmpty).toSet().toList()..sort();
  }

  List<String> getAvailableSpecies() {
    return _monsters.map((m) => m.species).where((species) => species.isNotEmpty).toSet().toList()..sort();
  }
}

