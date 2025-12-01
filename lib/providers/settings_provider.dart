import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _notificationsEnabled = true;
  bool _newsNotifications = true;
  bool _eventsNotifications = true;

  bool get notificationsEnabled => _notificationsEnabled;
  bool get newsNotifications => _newsNotifications;
  bool get eventsNotifications => _eventsNotifications;

  void setNotificationsEnabled(bool value) {
    _notificationsEnabled = value;
    if (!value) {
      _newsNotifications = false;
      _eventsNotifications = false;
    }
    notifyListeners();
  }

  void setNewsNotifications(bool value) {
    _newsNotifications = value;
    notifyListeners();
  }

  void setEventsNotifications(bool value) {
    _eventsNotifications = value;
    notifyListeners();
  }
}

