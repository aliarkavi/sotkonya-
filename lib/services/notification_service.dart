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
  static const String topicAll = 'sotkonya_all'; // تنظيف قديم فقط
  static const String topicNews = 'news';
  static const String topicEvents = 'events';

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

    // 2) Local notifications init
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _local.initialize(initSettings);

    // 3) Android channel
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
    );

    final androidPlugin = _local.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(channel);

    // 4) Foreground messages -> show local notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final n = message.notification;
      if (n == null) return;

      await _local.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        n.title,
        n.body,
        const NotificationDetails(
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

    // (اختياري) اطبع التوكن للتجربة
    try {
      final token = await _messaging.getToken();
      debugPrint('FCM TOKEN: ${token ?? "NULL"}');

      _messaging.onTokenRefresh.listen((t) {
        debugPrint('FCM TOKEN REFRESHED: $t');
      });
    } catch (e) {
      debugPrint('FCM TOKEN ERROR: $e');
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

    // ✅ تنظيف أي اشتراك قديم كان سبب وصول الإشعارات رغم الإطفاء
    await unsubscribeFrom(topicAll);

    // إذا الإشعارات مطفّية: فك الاشتراك من كل المواضيع
    if (!notificationsEnabled) {
      await unsubscribeFrom(topicNews);
      await unsubscribeFrom(topicEvents);
      return;
    }

    // news topic
    if (newsEnabled) {
      await subscribeTo(topicNews);
    } else {
      await unsubscribeFrom(topicNews);
    }

    // events topic
    if (eventsEnabled) {
      await subscribeTo(topicEvents);
    } else {
      await unsubscribeFrom(topicEvents);
    }
  }
}
