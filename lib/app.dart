import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/splash_screen.dart';



class SOTKonyaApp extends StatelessWidget {
  const SOTKonyaApp({super.key});

  @override
  Widget build(BuildContext context) {
        return MaterialApp(
          title: 'SOTKonya',
          debugShowCheckedModeBanner: false,
          locale: const Locale('ar'),
          supportedLocales: const [
            Locale('ar'),
            Locale('tr'),
            Locale('en'),
          ],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            fontFamily: 'Cairo',
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            fontFamily: 'Cairo',
            brightness: Brightness.dark,
          ),
          // Wrap the app with Directionality to force RTL across all screens
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: const SplashScreen(),
        );
  }
}
