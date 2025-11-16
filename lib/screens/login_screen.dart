import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import 'admin_home_screen.dart';
import 'member_home_screen.dart';
import 'protected_screen.dart';

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
        title: const Text('تسجيل الدخول'),
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
                      backgroundColor: const Color(0xFF039BE5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _loading ? null : _login,
                    child: _loading
                        ? const SizedBox(
                            width: 24, height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('تسجيل الدخول'),
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
    debugPrint('Attempting sign in: ${emailController.text.trim()}');
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;
      if (uid == null) throw Exception('فشل استرجاع المستخدم');

      AppUser? appUser;
      try {
        debugPrint('Fetching user doc for uid=$uid');
        appUser = await UserService().getUser(uid);
      } catch (e, st) {
        debugPrint('getUser error: $e\n$st');
        setState(() { _loading = false; _error = 'فشل استرجاع بيانات المستخدم من الخادم'; });
        await showDialog<void>(context: context, builder: (_) => AlertDialog(title: const Text('خطأ'), content: Text(e.toString()), actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('حسناً'))]));
        return;
      }

      if (appUser == null) {
        // Create a minimal AppUser record for this authenticated user
        final displayName = user?.displayName;
        final defaultName = (displayName != null && displayName.isNotEmpty)
            ? displayName
            : (user?.email?.split('@').first ?? 'مستخدم');
        final newUser = AppUser(
          id: uid,
          name: defaultName,
          email: user?.email ?? '',
          role: 'user',
          major: '',
          gender: '',
          photoUrl: user?.photoURL ?? '',
        );
        try {
          debugPrint('Creating user doc for $uid');
          await UserService().createUser(newUser);
          appUser = newUser;
        } catch (e, st) {
          debugPrint('createUser error: $e\n$st');
          setState(() { _loading = false; _error = 'فشل إنشاء سجل المستخدم'; });
          await showDialog<void>(context: context, builder: (_) => AlertDialog(title: const Text('خطأ إنشاء المستخدم'), content: Text(e.toString()), actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('حسناً'))]));
          return;
        }
      }

      // At this point appUser is non-null
      if (appUser.role == 'visitor') {
        setState(() { _loading = false; });
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ProtectedScreen(message: 'هذه الصفحة تتطلب انتسابًا. الرجاء الانتساب للوصول الكامل.')));
        return;
      }

      if (appUser.role == 'admin') {
        setState(() { _loading = false; });
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const AdminHomeScreen()));
        return;
      }

      // default: member
      setState(() { _loading = false; });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MemberHomeScreen()));
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during signIn: ${e.message}');
      setState(() { _loading = false; _error = e.message ?? 'فشل تسجيل الدخول'; });
      await showDialog<void>(context: context, builder: (_) => AlertDialog(title: const Text('خطأ تسجيل الدخول'), content: Text(e.message ?? e.toString()), actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('حسناً'))]));
    } catch (e, st) {
      debugPrint('General login error: $e\n$st');
      setState(() { _loading = false; _error = 'فشل تسجيل الدخول'; });
      await showDialog<void>(context: context, builder: (_) => AlertDialog(title: const Text('خطأ'), content: Text(e.toString()), actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('حسناً'))]));
    }
  }
}
