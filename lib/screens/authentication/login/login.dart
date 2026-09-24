import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sotkonya/providers/riverpod_providers.dart';
import 'package:sotkonya/navigation_menu.dart';
import 'package:sotkonya/screens/authentication/login/admin_login.dart';

import '../../../widgets/gradient_button.dart';
import '../../../widgets/text_field.dart';
import '../signup/signup.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailOrUserController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProviderNotifier = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("تسجيل دخول"), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  /// ICON
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF006db7),
                          Color(0xFF00b39f),
                          Color(0xFF00b39f),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(55),
                    ),
                    child: const Center(
                      child: Icon(Icons.login, color: Colors.white, size: 30),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'مرحبًا بعودتك',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF00b39f),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'سجل دخولك للمتابعة',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// EMAIL OR USERNAME
                  CustomTextField(
                    label: " البريدالإلكتروني",
                    controller: emailOrUserController,
                  ),
                  const SizedBox(height: 15),

                  /// PASSWORD
                  CustomTextField(
                    label: "كلمة المرور",
                    controller: passwordController,
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  /// FORGOT PASSWORD
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        final email = emailOrUserController.text.trim();

                        if (email.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("يرجى إدخال البريد الإلكتروني أولاً"),
                            ),
                          );
                          return;
                        }

                        await authProviderNotifier.resetPassword(email);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني"),
                          ),
                        );
                      },
                      child: const Text("هل نسيت كلمة المرور؟"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// LOGIN BUTTON
                  GradientButton(
                    text: authProviderNotifier.loading
                        ? "جاري تسجيل الدخول..."
                        : "تسجيل دخول",
                    icon: Icons.clear,
                    iconSize: 0,
                    onTap: () async {
                      final email = emailOrUserController.text.trim();
                      final password = passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("يرجى ملء جميع الحقول"),
                          ),
                        );
                        return;
                      }

                      await authProviderNotifier.login(email, password);

                      if (authProviderNotifier.error != null) {
                        debugPrint("LOGIN ERROR: ${authProviderNotifier.error}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(authProviderNotifier.error!)),
                        );
                        return;
                      }

                      if (authProviderNotifier.user != null) {
                        /// 🔥 إذا كان المستخدم أدمن → لوحة الإدارة
                        /// 🔥 إذا كان مستخدم عادي → الصفحة الرئيسية
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavigationMenu(),
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  /// SIGNUP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("ليس لديك حساب؟"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SignupScreen()),
                          );
                        },
                        child: const Text("إنشاء حساب"),
                      ),
                    ],
                  ),

                  const Divider(),

                  /// ADMIN LOGIN BUTTON
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
                      );
                    },
                    child: const Text("دخول الإداريين"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
