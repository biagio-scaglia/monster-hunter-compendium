import 'package:flutter/foundation.dart';
import '../../data/models/ailment_model.dart';
import '../../data/repositories/ailment_repository.dart';

class AilmentsProvider extends ChangeNotifier {
  final AilmentRepository repository;

  List<AilmentModel> _ailments = [];
  bool _isLoading = false;
  String? _error;

  AilmentsProvider({AilmentRepository? repository})
      : repository = repository ?? AilmentRepository();

  List<AilmentModel> get ailments => _ailments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // Carica gli ailments dal repository
  Future<void> loadAilments({String? query}) async {
    // Inizia il caricamento
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Carica gli ailments
      _ailments = await repository.getAilments(query: query);
      _error = null;
    } catch (e) {
      // Se c'è un errore, salvalo e svuota la lista
      _error = e.toString();
      _ailments = [];
    } finally {
      // Ferma il caricamento
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAilments() async {
    await loadAilments();
  }
}

