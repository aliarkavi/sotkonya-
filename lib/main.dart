import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// أين ملفاتك:
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/news_provider.dart';
import 'providers/event_provider.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: const SOTKonyaApp(),
    ),
  );
}
