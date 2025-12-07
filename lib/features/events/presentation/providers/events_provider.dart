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

  Future<void> loadEvents({String? query}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await repository.getEvents(query: query);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _events = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshEvents() async {
    await loadEvents();
  }
}

