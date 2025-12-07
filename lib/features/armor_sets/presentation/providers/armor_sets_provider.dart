import 'package:flutter/foundation.dart';
import '../../data/models/armor_set_model.dart';
import '../../data/repositories/armor_set_repository.dart';

class ArmorSetsProvider extends ChangeNotifier {
  final ArmorSetRepository repository;

  List<ArmorSetModel> _armorSets = [];
  bool _isLoading = false;
  String? _error;

  ArmorSetsProvider({ArmorSetRepository? repository})
      : repository = repository ?? ArmorSetRepository();

  List<ArmorSetModel> get armorSets => _armorSets;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // Carica gli armor sets dal repository
  Future<void> loadArmorSets({String? query}) async {
    // Inizia il caricamento
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Carica gli armor sets
      _armorSets = await repository.getArmorSets(query: query);
      _error = null;
    } catch (e) {
      // Se c'è un errore, salvalo e svuota la lista
      _error = e.toString();
      _armorSets = [];
    } finally {
      // Ferma il caricamento
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshArmorSets() async {
    await loadArmorSets();
  }
}

