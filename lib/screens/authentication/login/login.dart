import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sotkonya/navigation_menu.dart';

import '../../../providers/auth_provider.dart';
import '../../../widgets/gradient_button.dart';
import '../../../widgets/text_field.dart';
import '../signup/signup.dart';
import 'admin_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailOrUserController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

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

                  // ICON
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

                  // EMAIL / USERNAME
                  CustomTextField(
                    label: "اسم المستخدم او البريد الإلكتروني",
                    controller: emailOrUserController,
                  ),
                  const SizedBox(height: 15),

                  // PASSWORD
                  CustomTextField(
                    label: "كلمة المرور",
                    controller: passwordController,
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // FORGOT PASSWORD
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        final email = emailOrUserController.text.trim();

                        if (email.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("يرجى إدخال البريد الإلكتروني أولاً"),
                            ),
                          );
                          return;
                        }

                        final auth = Provider.of<AuthProvider>(
                            context,
                            listen: false);

                        await auth.resetPassword(email);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني"),
                          ),
                        );
                      },
                      child: const Text("هل نسيت كلمة المرور؟"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // LOGIN BUTTON
                  GradientButton(
                    text: authProvider.loading ? "جاري تسجيل الدخول..." : "تسجيل دخول",
                    icon: Icons.clear,
                    iconSize: 0,
                    onTap: () async {
                      await authProvider.login(
                        emailOrUserController.text.trim(),
                        passwordController.text.trim(),
                      );

                      if (authProvider.error == null &&
                          authProvider.user != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NavigationMenu()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(authProvider.error.toString()),
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  // SIGNUP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("ليس لديك حساب؟"),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()),
                        ),
                        child: const Text("إنشاء حساب"),
                      ),
                    ],
                  ),

                  const Divider(),

                  // ADMIN LOGIN
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminLoginScreen()),
                    ),
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
