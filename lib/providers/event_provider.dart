import 'package:flutter/material.dart';
import 'package:sotkonya/model/event_model.dart';
import 'package:sotkonya/services/event_service.dart';

class EventProvider extends ChangeNotifier {
  final EventService _service = EventService();

  List<EventModel> _events = [];
  List<EventModel> get events => _events;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> fetchEvents() async {
    _loading = true;
    notifyListeners();

    try {
      _events = await _service.getEvents();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addEvent(EventModel item) async {
    await _service.addEvent(item);
    await fetchEvents();
  }

  Future<void> updateEvent(EventModel item) async {
    await _service.updateEvent(item);
    await fetchEvents();
  }

  Future<void> deleteEvent(String id) async {
    await _service.deleteEvent(id);
    await fetchEvents();
  }
}