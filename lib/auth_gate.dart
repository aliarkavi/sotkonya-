import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sotkonya/navigation_menu.dart';
import 'package:sotkonya/screens/authentication/login/login.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 🔥 الأدمن/العضو مسجل دخول → يفتح NavigationMenu
        if (snapshot.hasData) {
          return const NavigationMenu(); // ← المهم!!!
        }

        // غير مسجل → تسجيل الدخول
        return const LoginScreen();
      },
    );
  }
}
