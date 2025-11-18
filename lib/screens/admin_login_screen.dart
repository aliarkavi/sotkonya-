import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';
import 'admin_home_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController adminIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    adminIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ---------------- Icon circle ----------------
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xff006db7), Color(0xff00b39f)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.security, color: Colors.white, size: 42),
              ),
              const SizedBox(height: 20),

              // ---------------- Title ----------------
              const Text(
                'دخول الإداريين',
                style: TextStyle( color: Color(0xFF151C26),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 6),

              const Text(
                'لوحة التحكم الإدارية',
                style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 0, 0, 0)),
              ),

              const SizedBox(height: 40),

              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _field(
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                      label: "معرّف المدير",
                      controller: adminIdController,
                      isPassword: false,
                    ),
                    const SizedBox(height: 16),
                    _field( style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                      label: "كلمة المرور",
                      controller: passwordController,
                      isPassword: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ---------------- Login button ----------------
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff006db7), Color(0xff00b39f)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'دخول لوحة التحكم',
                            style: TextStyle(color: Colors.white,
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ---------------- Back link ----------------
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  '← العودة لتسجيل دخول الطلاب',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required bool isPassword, required TextStyle style,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: label,
        hintTextDirection: TextDirection.rtl,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? "يرجى إدخال $label" : null,
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
        email: adminIdController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception();

      final user = await UserService().getUser(uid);
      if (user == null || user.role != 'admin') {
        await FirebaseAuth.instance.signOut();
        setState(() {
          _loading = false;
          _error = "ليس لديك صلاحيات الدخول كمسؤول.";
        });
        return;
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
      );
    } catch (e) {
      setState(() {
        _loading = false;
        _error = "فشل تسجيل الدخول";
      });
    }
  }
}
      