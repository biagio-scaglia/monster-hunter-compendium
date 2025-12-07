import 'package:flutter/foundation.dart';
import '../../data/models/charm_model.dart';
import '../../data/repositories/charm_repository.dart';

class CharmsProvider extends ChangeNotifier {
  final CharmRepository repository;

  List<CharmModel> _charms = [];
  bool _isLoading = false;
  String? _error;

  CharmsProvider({CharmRepository? repository})
      : repository = repository ?? CharmRepository();

  List<CharmModel> get charms => _charms;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // Carica i charms dal repository
  Future<void> loadCharms({String? query}) async {
    // Inizia il caricamento
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Carica i charms
      _charms = await repository.getCharms(query: query);
      _error = null;
    } catch (e) {
      // Se c'è un errore, salvalo e svuota la lista
      _error = e.toString();
      _charms = [];
    } finally {
      // Ferma il caricamento
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshCharms() async {
    await loadCharms();
  }
}

