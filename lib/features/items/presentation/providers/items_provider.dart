import 'package:flutter/foundation.dart';
import '../../data/models/item_model.dart';
import '../../data/repositories/item_repository.dart';

class ItemsProvider extends ChangeNotifier {
  final ItemRepository repository;

  List<ItemModel> _items = [];
  bool _isLoading = false;
  String? _error;

  ItemsProvider({ItemRepository? repository})
      : repository = repository ?? ItemRepository();

  List<ItemModel> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

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
}

