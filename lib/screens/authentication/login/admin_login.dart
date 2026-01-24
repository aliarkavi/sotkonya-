import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sotkonya/navigation_menu.dart';

import '../../../providers/auth_provider.dart';
import '../../../widgets/gradient_button.dart';
import '../../../widgets/text_field.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _adminLogin(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    await auth.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("بريد المشرف أو كلمة المرور غير صحيحة.")),
      );
      return;
    }

    if (!auth.isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "هذا الحساب ليس حساب مشرف، لا يمكنك الدخول إلى لوحة المشرف.",
          ),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const NavigationMenu()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("تسجيل دخول المشرف"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),

                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF006db7),
                          Color(0xFF006db7),
                          Color(0xFF00b39f),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.shield_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'تسجيل دخول المشرف',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF00b39f),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'يرجى إدخال بريد المشرف وكلمة المرور.',
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 25),

                  CustomTextField(
                    label: "البريد الإلكتروني للمشرف",
                    controller: emailController,
                  ),
                  const SizedBox(height: 15),

                  CustomTextField(
                    label: "كلمة المرور",
                    controller: passwordController,
                    obscureText: true,
                  ),

                  const SizedBox(height: 20),

                  GradientButton(
                    onTap: auth.loading ? null : () => _adminLogin(context),
                    text: auth.loading
                        ? "جارٍ تسجيل دخول المشرف..."
                        : "تسجيل دخول المشرف",
                    icon: Icons.admin_panel_settings,
                    iconSize: 0,
                    colors: const [
                      Color(0xFF006db7),
                      Color(0xFF006db7),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "رجوع إلى تسجيل الدخول العادي",
                    ),
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

