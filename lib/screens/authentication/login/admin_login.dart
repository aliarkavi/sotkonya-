import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sotkonya/navigation_menu.dart';

import '../../../providers/auth_provider.dart';
import '../../../widgets/gradient_button.dart';
import '../../../widgets/text_field.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("دخول الإداريين"), centerTitle: true),
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
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF006db7),
                          Color(0xFF006db7),
                          Color(0xFF00b39f),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Icon(Icons.shield_outlined,
                          color: Colors.white, size: 30),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'دخول الإداريين',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF00b39f),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'لوحة التحكم الإدارية',
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 25),

                  CustomTextField(label: "معرّف المدير"),
                  const SizedBox(height: 15),

                  CustomTextField(label: "كلمة المرور", obscureText: true),
                  const SizedBox(height: 20),

                  GradientButton(
                    onTap: () async {
                      /// هنا نفعل وضع الأدمن
                      Provider.of<AuthProvider>(context, listen: false)
                          .setAdmin(true);

                      /// ثم ندخل لوحة الإدارة
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavigationMenu(),
                        ),
                      );
                    },
                    text: "تسجيل دخول",
                    icon: Icons.admin_panel_settings,
                    iconSize: 0,
                    colors: [
                      Color(0xFF006db7),
                      Color(0xFF006db7),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("← العودة لتسجيل دخول الطلاب"),
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
