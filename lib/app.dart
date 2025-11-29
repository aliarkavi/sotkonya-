import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sotkonya/screens/authentication/auth_screen.dart';

class SOTKonyaApp extends StatelessWidget {
  const SOTKonyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOTKonya',
      debugShowCheckedModeBanner: false,

      // 🔥 تعطيل الوضع الداكن نهائياً
      themeMode: ThemeMode.light,

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

      // 🎨 تعريف الثيم الفاتح مع خطوط Tajawal
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Tajawal',   // ← الخط الجديد
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),

      // 🔥 لن نستخدم darkTheme لأنه معطّل أصلاً
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },

      home: const AuthScreen(),
    );
  }
}
