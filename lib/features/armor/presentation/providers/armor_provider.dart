import 'package:flutter/foundation.dart';
import '../../data/models/armor_model.dart';
import '../../data/repositories/armor_repository.dart';

class ArmorProvider extends ChangeNotifier {
  final ArmorRepository repository;

  List<ArmorModel> _armor = [];
  bool _isLoading = false;
  String? _error;

  ArmorProvider({ArmorRepository? repository})
      : repository = repository ?? ArmorRepository();

  List<ArmorModel> get armor => _armor;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  Future<void> loadArmor({String? query, int? limit}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _armor = await repository.getArmor(query: query, limit: limit);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _armor = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshArmor() async {
    await loadArmor();
  }
}

