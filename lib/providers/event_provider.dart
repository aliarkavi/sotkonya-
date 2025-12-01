import 'package:flutter/material.dart';
import 'package:sotkonya/model/event_item.dart';
import 'package:sotkonya/services/event_service.dart';

class EventProvider extends ChangeNotifier {
  final EventService _service = EventService();

  List<EventItem> _events = [];
  List<EventItem> get events => _events;

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

  Future<void> addEvent(EventItem item) async {
    await _service.addEvent(item);
    await fetchEvents();
  }

  Future<void> updateEvent(EventItem item) async {
    await _service.updateEvent(item);
    await fetchEvents();
  }

  Future<void> deleteEvent(String id) async {
    await _service.deleteEvent(id);
    await fetchEvents();
  }
}
