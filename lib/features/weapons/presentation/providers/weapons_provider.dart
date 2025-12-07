import 'package:flutter/foundation.dart';
import '../../data/models/weapon_model.dart';
import '../../data/repositories/weapon_repository.dart';

class WeaponsProvider extends ChangeNotifier {
  final WeaponRepository repository;

  List<WeaponModel> _weapons = [];
  List<WeaponModel> _filteredWeapons = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 0;
  static const int _pageSize = 50;
  String? _error;
  String _searchQuery = '';
  List<String> _selectedTypes = [];
  List<int> _selectedRarities = [];

  WeaponsProvider({WeaponRepository? repository})
      : repository = repository ?? WeaponRepository();

  // Mostra le armi filtrate se ci sono filtri attivi, altrimenti mostra tutte le armi
  List<WeaponModel> get weapons {
    final hasNoFilters = _searchQuery.isEmpty && _selectedTypes.isEmpty && _selectedRarities.isEmpty;
    final hasNoFilteredResults = _filteredWeapons.isEmpty;
    
    if (hasNoFilters && hasNoFilteredResults) {
      return _weapons;
    } else {
      return _filteredWeapons;
    }
  }
  List<WeaponModel> get allWeapons => _weapons;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;
  bool get hasError => _error != null;
  String get searchQuery => _searchQuery;
  List<String> get selectedTypes => _selectedTypes;
  List<int> get selectedRarities => _selectedRarities;

  Future<void> loadWeapons({String? query, int? limit, bool reset = true}) async {
    if (reset) {
      _isLoading = true;
      _currentPage = 0;
      _weapons = [];
      _hasMore = true;
    } else {
      _isLoadingMore = true;
    }
    _error = null;
    notifyListeners();

    try {
      final limitToUse = limit ?? _pageSize;
      final offset = reset ? 0 : _currentPage * _pageSize;
      final newWeapons = await repository.getWeapons(query: query, limit: limitToUse);
      
      if (reset) {
        _weapons = newWeapons;
      } else {
        _weapons.addAll(newWeapons);
      }
      
      _hasMore = newWeapons.length >= _pageSize;
      _currentPage++;
      _error = null;
      _applyFilters();
    } catch (e) {
      _error = e.toString();
      if (reset) {
        _weapons = [];
      }
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreWeapons() async {
    final canLoadMore = !_isLoadingMore && _hasMore;
    final hasNoFilters = _searchQuery.isEmpty && _selectedTypes.isEmpty && _selectedRarities.isEmpty;
    
    if (canLoadMore && hasNoFilters) {
      await loadWeapons(reset: false);
    }
  }

  Future<void> refreshWeapons() async {
    await loadWeapons(reset: true);
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void setSelectedTypes(List<String> types) {
    _selectedTypes = types;
    _applyFilters();
  }

  void setSelectedRarities(List<int> rarities) {
    _selectedRarities = rarities;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredWeapons = _weapons.where((weapon) {
      // Controlla se corrisponde alla ricerca
      if (_searchQuery.isNotEmpty) {
        final weaponName = weapon.name.toLowerCase();
        final weaponType = weapon.type.toLowerCase();
        final searchLower = _searchQuery.toLowerCase();
        
        final matchesName = weaponName.contains(searchLower);
        final matchesType = weaponType.contains(searchLower);
        
        if (!matchesName && !matchesType) {
          return false;
        }
      }

      // Controlla se corrisponde al tipo selezionato
      if (_selectedTypes.isNotEmpty) {
        final weaponType = weapon.type;
        if (!_selectedTypes.contains(weaponType)) {
          return false;
        }
      }

      // Controlla se corrisponde alla rarità selezionata
      if (_selectedRarities.isNotEmpty) {
        final weaponRarity = weapon.rarity;
        if (!_selectedRarities.contains(weaponRarity)) {
          return false;
        }
      }

      return true;
    }).toList();

    notifyListeners();
  }

  List<String> getAvailableTypes() {
    return _weapons.map((w) => w.type).where((type) => type.isNotEmpty).toSet().toList()..sort();
  }

  List<int> getAvailableRarities() {
    return _weapons.map((w) => w.rarity).toSet().toList()..sort();
  }
}

