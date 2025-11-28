import 'package:flutter/material.dart';
import 'package:sotkonya/navigation_menu.dart';

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF006db7),
                          Color(0xFF006db7),

                          Color(0xFF00b39f),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(55),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.shield_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(
                    'دخول الإداريين',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF00b39f),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'لوحة التحكم الإدارية',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),
                  //
                  SizedBox(height: 20),
                  CustomTextField(label: "معرّف المدير"),
                  SizedBox(height: 15),
                  CustomTextField(label: "كلمة المرور"),

                  //
                  SizedBox(height: 15),
                  GradientButton(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NavigationMenu()),
                    ),
                    text: "تسجيل دخول",
                    icon: Icons.clear,
                    iconSize: 0,
                    colors: [
                      Color(0xFF006db7),
                      Color(0xFF006db7),
                      // Color(0xFF00b39f),
                    ],
                  ),

                  SizedBox(height: 20),

                  Divider(),
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
