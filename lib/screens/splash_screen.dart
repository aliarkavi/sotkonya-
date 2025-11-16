import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'login_screen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

//import 'visitor_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Gradient buttonGradient = const LinearGradient(
      colors: [Color(0xff006db7), Color(0xff00b39f),Color(0xffeb5623),Color(0xfff2b200)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ---------------------------
                // اللوجو (من الكود الثاني)
                // ---------------------------
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
      'assets/logo.png', // ضع اسم الصورة هنا
      fit: BoxFit.cover,
    ),
  ),
),

                const SizedBox(height: 20),

                const Text(
                  "تطبيق تجمّع الطلبة السوريين",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  "منصة طلابية شاملة",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 40),

              
                
                const SizedBox(height: 15),

                // ---------------------------
                // زر "انتساب جديد" (بتدرج مثل الكود الثاني)
                // ---------------------------
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: buttonGradient,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(PhosphorIcons.userPlus, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "انتساب جديد",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // ---------------------------
                // زر "دخول الأعضاء"
                // ---------------------------
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.login, color: Colors.black),
                        SizedBox(width: 10),
                        Text(
                          "تسجيل دخول",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),


                  // ---------------------------
                // زر "تصفح كزائر"
                // ---------------------------

          /*       SizedBox(  
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const VisitorScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.remove_red_eye_outlined, color: Colors.black),
                        SizedBox(width: 10),
                        Text(
                            "تصفح كزائر",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
*/
                const SizedBox(height: 25),

                Text(
                  "جميع الحقوق محفوظة © 2025",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
