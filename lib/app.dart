import 'package:flutter/material.dart';
import 'package:sotkonya/auth_gate.dart';
import 'package:sotkonya/l10n/app_localizations.dart';

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
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,

      // 🎨 تعريف الثيم الفاتح مع خطوط Tajawal
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Tajawal',   // ← الخط الجديد
        fontFamilyFallback: const [
           'Roboto',
            'Arial',
           'sans-serif',
],
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

      home: const AuthGate(),
    );
  }
}
