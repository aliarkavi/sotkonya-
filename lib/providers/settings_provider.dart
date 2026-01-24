import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/notification_service.dart';

class SettingsProvider extends ChangeNotifier {
  static const _kNotificationsEnabled = 'notifications_enabled';
  static const _kNewsNotifications = 'news_notifications';
  static const _kEventsNotifications = 'events_notifications';

  bool _notificationsEnabled = true;
  bool _newsNotifications = true;
  bool _eventsNotifications = true;

  bool get notificationsEnabled => _notificationsEnabled;
  bool get newsNotifications => _newsNotifications;
  bool get eventsNotifications => _eventsNotifications;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    _notificationsEnabled = prefs.getBool(_kNotificationsEnabled) ?? true;
    _newsNotifications = prefs.getBool(_kNewsNotifications) ?? true;
    _eventsNotifications = prefs.getBool(_kEventsNotifications) ?? true;

    if (!_notificationsEnabled) {
      _newsNotifications = false;
      _eventsNotifications = false;
    }

    notifyListeners(); // ✅ يظهر مباشرة في UI

    await NotificationService.instance.applyPreferences(
      notificationsEnabled: _notificationsEnabled,
      newsEnabled: _newsNotifications,
      eventsEnabled: _eventsNotifications,
    );
  }

  Future<void> setNotificationsEnabled(bool value) async {
    // ✅ 1) تحديث الحالة فورًا
    _notificationsEnabled = value;
    if (!value) {
      _newsNotifications = false;
      _eventsNotifications = false;
    } else {
      // خليهم true افتراضيًا عند التشغيل (غيّرها إذا بدك)
      _newsNotifications = true;
      _eventsNotifications = true;
    }
    notifyListeners();

    // ✅ 2) حفظ + تطبيق بالخلفية
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotificationsEnabled, _notificationsEnabled);
    await prefs.setBool(_kNewsNotifications, _newsNotifications);
    await prefs.setBool(_kEventsNotifications, _eventsNotifications);

    await NotificationService.instance.applyPreferences(
      notificationsEnabled: _notificationsEnabled,
      newsEnabled: _newsNotifications,
      eventsEnabled: _eventsNotifications,
    );
  }

  Future<void> setNewsNotifications(bool value) async {
    _newsNotifications = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNewsNotifications, _newsNotifications);

    await NotificationService.instance.applyPreferences(
      notificationsEnabled: _notificationsEnabled,
      newsEnabled: _newsNotifications,
      eventsEnabled: _eventsNotifications,
    );
  }

  Future<void> setEventsNotifications(bool value) async {
    _eventsNotifications = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kEventsNotifications, _eventsNotifications);

    await NotificationService.instance.applyPreferences(
      notificationsEnabled: _notificationsEnabled,
      newsEnabled: _newsNotifications,
      eventsEnabled: _eventsNotifications,
    );
  }
}
