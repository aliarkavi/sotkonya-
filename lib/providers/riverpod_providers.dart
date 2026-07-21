import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';
import 'news_provider.dart';
import 'event_provider.dart';
import 'administration_provider.dart';
import 'yurt_provider.dart';
import 'settings_provider.dart';
import 'users_provider.dart';
import 'notification_provider.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider());
final newsProvider = ChangeNotifierProvider<NewsProvider>((ref) => NewsProvider());
final eventProvider = ChangeNotifierProvider<EventProvider>((ref) => EventProvider());
final administrationProvider = ChangeNotifierProvider<AdministrationProvider>((ref) => AdministrationProvider());
final yurtProvider = ChangeNotifierProvider<YurtProvider>((ref) => YurtProvider());
final settingsProvider = ChangeNotifierProvider<SettingsProvider>((ref) => SettingsProvider()..load());
final usersProvider = ChangeNotifierProvider<UsersProvider>((ref) => UsersProvider());

final notificationProvider = ChangeNotifierProvider<NotificationProvider>((ref) {
  final notif = NotificationProvider();
  final authNotifier = ref.watch(authProvider);
  notif.init(authNotifier);
  return notif;
});
