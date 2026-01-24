import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sotkonya/navigation_menu.dart';
import 'screens/authentication/auth_screen.dart';
import '../providers/auth_provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // Loading عام (خصوصًا أثناء جلب Firestore)
    if (auth.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // مسجل دخول
    if (auth.user != null) {
      return const NavigationMenu();
    }

    // غير مسجل
    return const AuthScreen();
  }
}
