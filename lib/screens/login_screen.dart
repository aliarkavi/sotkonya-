import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import 'admin_login_screen.dart';
import 'member_home_screen.dart';
import 'protected_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),

                /// ICON
                Container(
                  height: 85,
                  width: 85,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff006db7),
                        Color(0xff00b39f),
                        Color(0xffeb5623),
                        Color(0xfff2b200),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(Icons.login, size: 45, color: Colors.white),
                ),

                const SizedBox(height: 20),

                const Text(
                  "مرحباً بعودتك",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "سجل دخولك للمتابعة",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 35),

                if (_error != null)
                  Text(_error!, style: const TextStyle(color: Colors.red)),

                /// EMAIL FIELD
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                  decoration: _inputField("اسم المستخدم أو البريد الإلكتروني"),
                  validator: (value) =>
                      value == null || value.isEmpty ? "يرجى إدخال البريد" : null,
                ),

                const SizedBox(height: 18),

                /// PASSWORD FIELD
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                  decoration: _inputField("كلمة المرور"),
                  validator: (value) =>
                      value == null || value.isEmpty ? "يرجى إدخال كلمة المرور" : null,
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "نسيت كلمة المرور؟",
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// LOGIN BUTTON — gradient 4 colors
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff006db7),
                          Color(0xff00b39f),
                          Color(0xffeb5623),
                          Color(0xfff2b200),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: _loading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "تسجيل دخول",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                /// REGISTER
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("ليس لديك حساب؟"),
                    TextButton(
                      onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                      child: const Text(
                        "تسجيل جديد",
                        style: TextStyle(color: Colors.teal),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 15),

                TextButton(
                  onPressed:() {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
                      );
                    },
                  child: const Text(
                    "دخول الإداريين",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputField(String label) {
    return InputDecoration(
      hintText: label,
      hintTextDirection: TextDirection.rtl,
      filled: true,
      fillColor: const Color(0xfff5f5f5),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("تعذر تسجيل الدخول");

      final uid = user.uid;
      AppUser? appUser = await UserService().getUser(uid);

      if (appUser == null) {
        appUser = AppUser(
          id: uid,
          name: user.email!.split('@').first,
          email: user.email!,
          role: 'user',
          gender: '',
          major: '',
          photoUrl: '',
        );
        await UserService().createUser(appUser);
      }

      if (appUser.role == 'visitor') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ProtectedScreen(
              message: "هذه الصفحة تتطلب انتسابًا.",
            ),
          ),
        );
        return;
      }

    
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MemberHomeScreen()),
      );
    } catch (e) {
      setState(() {
        _error = "بيانات تسجيل الدخول غير صحيحة";
      });
    }

    setState(() {
      _loading = false;
    });
  }
}
