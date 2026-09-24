import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  // Topics
  static const String topicAll = 'sotkonya_all';
  static const String topicNews = 'news';
  static const String topicEvents = 'events';

  // Android notification channel
  static const String _channelId = 'sotkonya_default_channel';
  static const String _channelName = 'SotKonya Notifications';
  static const String _channelDesc = 'App notifications';

  bool _initialized = false;

  bool get _isSupportedPlatform =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Future<void> init() async {
    if (_initialized) return;
    if (!_isSupportedPlatform) return;

    _initialized = true;

    // 1) Permissions (Android 13+ / iOS)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2) Local notifications initialization
    const androidInit = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _local.initialize(
      settings: initSettings,
    );

    // 3) Android notification channel
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
    );

    final androidPlugin =
        _local.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);

    // 4) Foreground messages -> show local notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final n = message.notification;

      if (n == null) return;

      await _local.show(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: n.title,
        body: n.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDesc,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    });

    // 5) FCM token
    try {
      final token = await _messaging.getToken();

      debugPrint(
        'FCM TOKEN: ${token ?? "NULL"}',
      );

      _messaging.onTokenRefresh.listen((t) {
        debugPrint(
          'FCM TOKEN REFRESHED: $t',
        );
      });
    } catch (e) {
      debugPrint(
        'FCM TOKEN ERROR: $e',
      );
    }
  }

  Future<void> subscribeTo(String topic) async {
    if (!_isSupportedPlatform) return;

    await _messaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFrom(String topic) async {
    if (!_isSupportedPlatform) return;

    await _messaging.unsubscribeFromTopic(topic);
  }

  /// Apply user preferences (topics subscriptions)
  Future<void> applyPreferences({
    required bool notificationsEnabled,
    required bool newsEnabled,
    required bool eventsEnabled,
  }) async {
    if (!_isSupportedPlatform) return;

    // تنظيف أي اشتراك قديم
    await unsubscribeFrom(topicAll);

    // إذا الإشعارات مطفّية:
    // فك الاشتراك من جميع المواضيع
    if (!notificationsEnabled) {
      await unsubscribeFrom(topicNews);
      await unsubscribeFrom(topicEvents);
      return;
    }

    // News topic
    if (newsEnabled) {
      await subscribeTo(topicNews);
    } else {
      await unsubscribeFrom(topicNews);
    }

    // Events topic
    if (eventsEnabled) {
      await subscribeTo(topicEvents);
    } else {
      await unsubscribeFrom(topicEvents);
    }
  }
}