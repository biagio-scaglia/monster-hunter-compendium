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

  Future<void> loadLocations({String? query}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _locations = await repository.getLocations(query: query);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _locations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshLocations() async {
    await loadLocations();
  }
}

