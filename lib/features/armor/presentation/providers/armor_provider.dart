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

  // Mostra le armature filtrate se ci sono filtri attivi, altrimenti mostra tutte le armature
  List<ArmorModel> get armor {
    final hasNoFilters = _searchQuery.isEmpty && _selectedTypes.isEmpty && _selectedRanks.isEmpty && _selectedRarities.isEmpty;
    final hasNoFilteredResults = _filteredArmor.isEmpty;
    
    if (hasNoFilters && hasNoFilteredResults) {
      return _armor;
    } else {
      return _filteredArmor;
    }
  }
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
    final canLoadMore = !_isLoadingMore && _hasMore;
    final hasNoFilters = _searchQuery.isEmpty && _selectedTypes.isEmpty && _selectedRanks.isEmpty && _selectedRarities.isEmpty;
    
    if (canLoadMore && hasNoFilters) {
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
      // Controlla se corrisponde alla ricerca
      if (_searchQuery.isNotEmpty) {
        final armorName = armor.name.toLowerCase();
        final armorType = armor.type.toLowerCase();
        final armorRank = armor.rank.toLowerCase();
        final searchLower = _searchQuery.toLowerCase();
        
        final matchesName = armorName.contains(searchLower);
        final matchesType = armorType.contains(searchLower);
        final matchesRank = armorRank.contains(searchLower);
        
        if (!matchesName && !matchesType && !matchesRank) {
          return false;
        }
      }

      // Controlla se corrisponde al tipo selezionato
      if (_selectedTypes.isNotEmpty) {
        final armorType = armor.type;
        if (!_selectedTypes.contains(armorType)) {
          return false;
        }
      }

      // Controlla se corrisponde al rango selezionato
      if (_selectedRanks.isNotEmpty) {
        final armorRank = armor.rank;
        if (!_selectedRanks.contains(armorRank)) {
          return false;
        }
      }

      // Controlla se corrisponde alla rarità selezionata
      if (_selectedRarities.isNotEmpty) {
        final armorRarity = armor.rarity;
        if (!_selectedRarities.contains(armorRarity)) {
          return false;
        }
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

