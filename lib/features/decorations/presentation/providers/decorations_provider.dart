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

  Future<void> loadDecorations({String? query}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _decorations = await repository.getDecorations(query: query);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _decorations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshDecorations() async {
    await loadDecorations();
  }
}

