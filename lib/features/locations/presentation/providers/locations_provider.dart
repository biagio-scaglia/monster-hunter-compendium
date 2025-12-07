import 'package:flutter/foundation.dart';
import '../../data/models/location_model.dart';
import '../../data/repositories/location_repository.dart';

class LocationsProvider extends ChangeNotifier {
  final LocationRepository repository;

  List<LocationModel> _locations = [];
  bool _isLoading = false;
  String? _error;

  LocationsProvider({LocationRepository? repository})
      : repository = repository ?? LocationRepository();

  List<LocationModel> get locations => _locations;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // Carica le location dal repository
  Future<void> loadLocations({String? query}) async {
    // Inizia il caricamento
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Carica le location
      _locations = await repository.getLocations(query: query);
      _error = null;
    } catch (e) {
      // Se c'è un errore, salvalo e svuota la lista
      _error = e.toString();
      _locations = [];
    } finally {
      // Ferma il caricamento
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshLocations() async {
    await loadLocations();
  }
}

