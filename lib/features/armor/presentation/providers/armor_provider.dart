import 'package:flutter/foundation.dart';
import '../../data/models/armor_model.dart';
import '../../data/repositories/armor_repository.dart';

class ArmorProvider extends ChangeNotifier {
  final ArmorRepository repository;

  List<ArmorModel> _armor = [];
  List<ArmorModel> _filteredArmor = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 0;
  static const int _pageSize = 50;
  String? _error;
  String _searchQuery = '';
  List<String> _selectedTypes = [];
  List<String> _selectedRanks = [];
  List<int> _selectedRarities = [];

  ArmorProvider({ArmorRepository? repository})
      : repository = repository ?? ArmorRepository();

  List<ArmorModel> get armor => _filteredArmor.isEmpty && _searchQuery.isEmpty && _selectedTypes.isEmpty && _selectedRanks.isEmpty && _selectedRarities.isEmpty
      ? _armor
      : _filteredArmor;
  List<ArmorModel> get allArmor => _armor;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;
  bool get hasError => _error != null;
  String get searchQuery => _searchQuery;
  List<String> get selectedTypes => _selectedTypes;
  List<String> get selectedRanks => _selectedRanks;
  List<int> get selectedRarities => _selectedRarities;

  Future<void> loadArmor({String? query, int? limit, bool reset = true}) async {
    if (reset) {
      _isLoading = true;
      _currentPage = 0;
      _armor = [];
      _hasMore = true;
    } else {
      _isLoadingMore = true;
    }
    _error = null;
    notifyListeners();

    try {
      final limitToUse = limit ?? _pageSize;
      final newArmor = await repository.getArmor(query: query, limit: limitToUse);
      
      if (reset) {
        _armor = newArmor;
      } else {
        _armor.addAll(newArmor);
      }
      
      _hasMore = newArmor.length >= _pageSize;
      _currentPage++;
      _error = null;
      _applyFilters();
    } catch (e) {
      _error = e.toString();
      if (reset) {
        _armor = [];
      }
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreArmor() async {
    if (!_isLoadingMore && _hasMore && _searchQuery.isEmpty && _selectedTypes.isEmpty && _selectedRanks.isEmpty && _selectedRarities.isEmpty) {
      await loadArmor(reset: false);
    }
  }

  Future<void> refreshArmor() async {
    await loadArmor(reset: true);
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void setSelectedTypes(List<String> types) {
    _selectedTypes = types;
    _applyFilters();
  }

  void setSelectedRanks(List<String> ranks) {
    _selectedRanks = ranks;
    _applyFilters();
  }

  void setSelectedRarities(List<int> rarities) {
    _selectedRarities = rarities;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredArmor = _armor.where((armor) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final matchesSearch = armor.name.toLowerCase().contains(_searchQuery) ||
            armor.type.toLowerCase().contains(_searchQuery) ||
            armor.rank.toLowerCase().contains(_searchQuery);
        if (!matchesSearch) return false;
      }

      // Type filter
      if (_selectedTypes.isNotEmpty) {
        if (!_selectedTypes.contains(armor.type)) return false;
      }

      // Rank filter
      if (_selectedRanks.isNotEmpty) {
        if (!_selectedRanks.contains(armor.rank)) return false;
      }

      // Rarity filter
      if (_selectedRarities.isNotEmpty) {
        if (!_selectedRarities.contains(armor.rarity)) return false;
      }

      return true;
    }).toList();

    notifyListeners();
  }

  List<String> getAvailableTypes() {
    return _armor.map((a) => a.type).where((type) => type.isNotEmpty).toSet().toList()..sort();
  }

  List<String> getAvailableRanks() {
    return _armor.map((a) => a.rank).where((rank) => rank.isNotEmpty).toSet().toList()..sort();
  }

  List<int> getAvailableRarities() {
    return _armor.map((a) => a.rarity).toSet().toList()..sort();
  }
}

