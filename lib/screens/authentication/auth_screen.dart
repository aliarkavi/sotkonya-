import 'package:flutter/material.dart';

import '../../widgets/gradient_button.dart';
import '../../widgets/outline_button.dart';
import 'login/login.dart';
import 'signup/signup.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blueGrey, Colors.orange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'تطبيق تجمع الطلبة السوريين',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const Text(
                  "منصة طلابية شاملة",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 40),
                GradientButton(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupScreen()),
                  ),
                  text: "إنتساب جديد",
                  icon: Icons.person_add_alt_1_outlined,
                ),
                const SizedBox(height: 10),
                OutlineButtonCustom(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  ),
                  text: "تسجيل دخول",
                  icon: Icons.login,
                ),
                const SizedBox(height: 40),
                const Text(
                  "جميع الحقوق محفوظة © 2026",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 127, 127, 127),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
