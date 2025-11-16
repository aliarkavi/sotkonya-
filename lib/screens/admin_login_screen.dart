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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151C26),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('دخول الإدارة'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(_error!, style: const TextStyle(color: Colors.red)),
                  ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('البريد الإلكتروني'),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  validator: (value) => (value == null || value.isEmpty) ? 'يرجى إدخال البريد الإلكتروني' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('كلمة المرور'),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  validator: (value) => (value == null || value.isEmpty) ? 'يرجى إدخال كلمة المرور' : null,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B2B1B),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _loading ? null : _login,
                    child: _loading
                        ? const SizedBox(
                            width: 24, height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('دخول الإدارة'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFFB0B8C1)),
      filled: true,
      fillColor: const Color(0xFF232B39),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF232B39)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF232B39)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF039BE5)),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // تحقق من الدور (admin) بعد تسجيل الدخول
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('فشل الحصول على معلومات المستخدم');
      final appUser = await UserService().getUser(uid);
      if (appUser == null || appUser.role != 'admin') {
        // not an admin: sign out and show error
        await FirebaseAuth.instance.signOut();
        setState(() { _loading = false; _error = 'ليس لديك صلاحيات الدخول كمسؤول.'; });
        return;
      }
      // authorized admin -> navigate to admin home
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const AdminHomeScreen()), (r) => false);
    } on FirebaseAuthException catch (e) {
      setState(() { _loading = false; _error = e.message ?? 'فشل تسجيل الدخول'; });
    } catch (e) {
      setState(() { _loading = false; _error = 'فشل تسجيل الدخول'; });
    }
  }
}
