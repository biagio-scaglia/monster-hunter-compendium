import 'package:flutter/foundation.dart';
import '../../data/models/monster_model.dart';
import '../../data/repositories/monster_repository.dart';

class MonstersProvider extends ChangeNotifier {
  final MonsterRepository repository;

  List<MonsterModel> _monsters = [];
  bool _isLoading = false;
  String? _error;

  MonstersProvider({MonsterRepository? repository})
      : repository = repository ?? MonsterRepository();

  List<MonsterModel> get monsters => _monsters;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  Future<void> loadMonsters({String? query, int? limit}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _monsters = await repository.getMonsters(query: query, limit: limit);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _monsters = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshMonsters() async {
    await loadMonsters();
  }
}

