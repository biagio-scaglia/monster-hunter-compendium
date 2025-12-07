import 'package:flutter/foundation.dart';
import '../../data/models/weapon_model.dart';
import '../../data/repositories/weapon_repository.dart';

class WeaponsProvider extends ChangeNotifier {
  final WeaponRepository repository;

  List<WeaponModel> _weapons = [];
  bool _isLoading = false;
  String? _error;

  WeaponsProvider({WeaponRepository? repository})
      : repository = repository ?? WeaponRepository();

  List<WeaponModel> get weapons => _weapons;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

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
}

