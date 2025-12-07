import 'package:flutter/foundation.dart';
import '../../data/models/motion_value_model.dart';
import '../../data/repositories/motion_value_repository.dart';

class MotionValuesProvider extends ChangeNotifier {
  final MotionValueRepository repository;

  List<MotionValueModel> _motionValues = [];
  bool _isLoading = false;
  String? _error;

  MotionValuesProvider({MotionValueRepository? repository})
      : repository = repository ?? MotionValueRepository();

  List<MotionValueModel> get motionValues => _motionValues;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // Carica i motion values dal repository
  Future<void> loadMotionValues({String? weaponType}) async {
    // Inizia il caricamento
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Carica i motion values
      _motionValues = await repository.getMotionValues(weaponType: weaponType);
      _error = null;
    } catch (e) {
      // Se c'è un errore, salvalo e svuota la lista
      _error = e.toString();
      _motionValues = [];
    } finally {
      // Ferma il caricamento
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshMotionValues({String? weaponType}) async {
    await loadMotionValues(weaponType: weaponType);
  }
}

