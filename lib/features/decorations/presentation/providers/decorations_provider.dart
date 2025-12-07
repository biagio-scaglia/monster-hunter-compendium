import 'package:flutter/foundation.dart';
import '../../data/models/decoration_model.dart';
import '../../data/repositories/decoration_repository.dart';

class DecorationsProvider extends ChangeNotifier {
  final DecorationRepository repository;

  List<DecorationModel> _decorations = [];
  bool _isLoading = false;
  String? _error;

  DecorationsProvider({DecorationRepository? repository})
      : repository = repository ?? DecorationRepository();

  List<DecorationModel> get decorations => _decorations;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // Carica le decorazioni dal repository
  Future<void> loadDecorations({String? query}) async {
    // Inizia il caricamento
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Carica le decorazioni
      _decorations = await repository.getDecorations(query: query);
      _error = null;
    } catch (e) {
      // Se c'è un errore, salvalo e svuota la lista
      _error = e.toString();
      _decorations = [];
    } finally {
      // Ferma il caricamento
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshDecorations() async {
    await loadDecorations();
  }
}

