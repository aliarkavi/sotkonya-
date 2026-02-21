import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'services/notification_service.dart';

import 'providers/auth_provider.dart';
import 'providers/news_provider.dart';
import 'providers/event_provider.dart';
import 'providers/administration_provider.dart';
import 'providers/yurt_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/users_provider.dart';
import 'providers/notification_provider.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.instance.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => AdministrationProvider()),
        ChangeNotifierProvider(create: (_) => YurtProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()..load()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProxyProvider<AuthProvider, NotificationProvider>(
          create: (_) => NotificationProvider(),
          update: (_, auth, notif) => notif!..init(auth),
        ),
      ],
      child: const SOTKonyaApp(),
    ),
  );
}
