import 'package:flutter/foundation.dart';
import '../../data/models/weapon_model.dart';
import '../../data/repositories/weapon_repository.dart';

class WeaponsProvider extends ChangeNotifier {
  final WeaponRepository repository;

  List<WeaponModel> _weapons = [];
  List<WeaponModel> _filteredWeapons = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  List<String> _selectedTypes = [];
  List<int> _selectedRarities = [];

  WeaponsProvider({WeaponRepository? repository})
      : repository = repository ?? WeaponRepository();

  List<WeaponModel> get weapons => _filteredWeapons.isEmpty && _searchQuery.isEmpty && _selectedTypes.isEmpty && _selectedRarities.isEmpty
      ? _weapons
      : _filteredWeapons;
  List<WeaponModel> get allWeapons => _weapons;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  String get searchQuery => _searchQuery;
  List<String> get selectedTypes => _selectedTypes;
  List<int> get selectedRarities => _selectedRarities;

  Future<void> loadWeapons({String? query, int? limit}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weapons = await repository.getWeapons(query: query, limit: limit);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _weapons = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshWeapons() async {
    await loadWeapons();
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
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final matchesSearch = weapon.name.toLowerCase().contains(_searchQuery) ||
            weapon.type.toLowerCase().contains(_searchQuery);
        if (!matchesSearch) return false;
      }

      // Type filter
      if (_selectedTypes.isNotEmpty) {
        if (!_selectedTypes.contains(weapon.type)) return false;
      }

      // Rarity filter
      if (_selectedRarities.isNotEmpty) {
        if (!_selectedRarities.contains(weapon.rarity)) return false;
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

