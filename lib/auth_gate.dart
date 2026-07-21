import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sotkonya/providers/riverpod_providers.dart';

import 'package:sotkonya/navigation_menu.dart';
import 'screens/authentication/auth_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

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
