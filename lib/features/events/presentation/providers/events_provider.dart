import 'package:flutter/foundation.dart';
import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository.dart';

class EventsProvider extends ChangeNotifier {
  final EventRepository repository;

  List<EventModel> _events = [];
  bool _isLoading = false;
  String? _error;

  EventsProvider({EventRepository? repository})
      : repository = repository ?? EventRepository();

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // Carica gli eventi dal repository
  Future<void> loadEvents({String? query}) async {
    // Inizia il caricamento
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Carica gli eventi
      _events = await repository.getEvents(query: query);
      _error = null;
    } catch (e) {
      // Se c'è un errore, salvalo e svuota la lista
      _error = e.toString();
      _events = [];
    } finally {
      // Ferma il caricamento
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshEvents() async {
    await loadEvents();
  }
}

