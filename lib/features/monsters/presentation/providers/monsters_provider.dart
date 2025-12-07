import 'package:flutter/foundation.dart';
import '../../data/models/monster_model.dart';
import '../../data/repositories/monster_repository.dart';

class MonstersProvider extends ChangeNotifier {
  final MonsterRepository repository;

  List<MonsterModel> _monsters = [];
  List<MonsterModel> _filteredMonsters = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 0;
  static const int _pageSize = 50;
  String? _error;
  String _searchQuery = '';
  List<String> _selectedTypes = [];
  List<String> _selectedSpecies = [];

  MonstersProvider({MonsterRepository? repository})
      : repository = repository ?? MonsterRepository();

  // Mostra i mostri filtrati se ci sono filtri attivi, altrimenti mostra tutti i mostri
  List<MonsterModel> get monsters {
    final hasNoFilters = _searchQuery.isEmpty && _selectedTypes.isEmpty && _selectedSpecies.isEmpty;
    final hasNoFilteredResults = _filteredMonsters.isEmpty;
    
    if (hasNoFilters && hasNoFilteredResults) {
      return _monsters;
    } else {
      return _filteredMonsters;
    }
  }
  List<MonsterModel> get allMonsters => _monsters;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;
  bool get hasError => _error != null;
  String get searchQuery => _searchQuery;
  List<String> get selectedTypes => _selectedTypes;
  List<String> get selectedSpecies => _selectedSpecies;

  Future<void> loadMonsters({String? query, int? limit, bool reset = true}) async {
    if (reset) {
      _isLoading = true;
      _currentPage = 0;
      _monsters = [];
      _hasMore = true;
    } else {
      _isLoadingMore = true;
    }
    _error = null;
    notifyListeners();

    try {
      final limitToUse = limit ?? _pageSize;
      final newMonsters = await repository.getMonsters(query: query, limit: limitToUse);
      
      if (reset) {
        _monsters = newMonsters;
      } else {
        _monsters.addAll(newMonsters);
      }
      
      _hasMore = newMonsters.length >= _pageSize;
      _currentPage++;
      _error = null;
      _applyFilters();
    } catch (e) {
      _error = e.toString();
      if (reset) {
        _monsters = [];
      }
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreMonsters() async {
    final canLoadMore = !_isLoadingMore && _hasMore;
    final hasNoFilters = _searchQuery.isEmpty && _selectedTypes.isEmpty && _selectedSpecies.isEmpty;
    
    if (canLoadMore && hasNoFilters) {
      await loadMonsters(reset: false);
    }
  }

  Future<void> refreshMonsters() async {
    await loadMonsters(reset: true);
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
      // Controlla se corrisponde alla ricerca
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final monsterName = monster.name.toLowerCase();
        final monsterDescription = monster.description?.toLowerCase() ?? '';
        final monsterType = monster.type.toLowerCase();
        final monsterSpecies = monster.species.toLowerCase();
        
        final matchesName = monsterName.contains(searchLower);
        final matchesDescription = monsterDescription.contains(searchLower);
        final matchesType = monsterType.contains(searchLower);
        final matchesSpecies = monsterSpecies.contains(searchLower);
        
        if (!matchesName && !matchesDescription && !matchesType && !matchesSpecies) {
          return false;
        }
      }

      // Controlla se corrisponde al tipo selezionato
      if (_selectedTypes.isNotEmpty) {
        final monsterType = monster.type;
        if (!_selectedTypes.contains(monsterType)) {
          return false;
        }
      }

      // Controlla se corrisponde alla specie selezionata
      if (_selectedSpecies.isNotEmpty) {
        final monsterSpecies = monster.species;
        if (!_selectedSpecies.contains(monsterSpecies)) {
          return false;
        }
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

