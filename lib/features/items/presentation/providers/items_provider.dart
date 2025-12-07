import 'package:flutter/foundation.dart';
import '../../data/models/item_model.dart';
import '../../data/repositories/item_repository.dart';

class ItemsProvider extends ChangeNotifier {
  final ItemRepository repository;

  List<ItemModel> _items = [];
  List<ItemModel> _filteredItems = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  List<int> _selectedRarities = [];

  ItemsProvider({ItemRepository? repository})
      : repository = repository ?? ItemRepository();

  // Mostra gli oggetti filtrati se ci sono filtri attivi, altrimenti mostra tutti gli oggetti
  List<ItemModel> get items {
    final hasNoFilters = _searchQuery.isEmpty && _selectedRarities.isEmpty;
    final hasNoFilteredResults = _filteredItems.isEmpty;
    
    if (hasNoFilters && hasNoFilteredResults) {
      return _items;
    } else {
      return _filteredItems;
    }
  }
  List<ItemModel> get allItems => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  String get searchQuery => _searchQuery;
  List<int> get selectedRarities => _selectedRarities;

  Future<void> loadItems({String? query}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await repository.getItems(query: query);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _items = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshItems() async {
    await loadItems();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void setSelectedRarities(List<int> rarities) {
    _selectedRarities = rarities;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredItems = _items.where((item) {
      // Controlla se corrisponde alla ricerca
      if (_searchQuery.isNotEmpty) {
        final itemName = item.name.toLowerCase();
        final itemDescription = item.description.toLowerCase();
        final searchLower = _searchQuery.toLowerCase();
        
        final matchesName = itemName.contains(searchLower);
        final matchesDescription = itemDescription.contains(searchLower);
        
        if (!matchesName && !matchesDescription) {
          return false;
        }
      }

      // Controlla se corrisponde alla rarità selezionata
      if (_selectedRarities.isNotEmpty) {
        final itemRarity = item.rarity;
        if (!_selectedRarities.contains(itemRarity)) {
          return false;
        }
      }

      return true;
    }).toList();

    notifyListeners();
  }

  List<int> getAvailableRarities() {
    return _items.map((i) => i.rarity).toSet().toList()..sort();
  }
}

