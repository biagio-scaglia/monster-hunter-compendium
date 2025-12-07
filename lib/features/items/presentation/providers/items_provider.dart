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

  List<ItemModel> get items => _filteredItems.isEmpty && _searchQuery.isEmpty && _selectedRarities.isEmpty
      ? _items
      : _filteredItems;
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
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final matchesSearch = item.name.toLowerCase().contains(_searchQuery) ||
            item.description.toLowerCase().contains(_searchQuery);
        if (!matchesSearch) return false;
      }

      // Rarity filter
      if (_selectedRarities.isNotEmpty) {
        if (!_selectedRarities.contains(item.rarity)) return false;
      }

      return true;
    }).toList();

    notifyListeners();
  }

  List<int> getAvailableRarities() {
    return _items.map((i) => i.rarity).toSet().toList()..sort();
  }
}

