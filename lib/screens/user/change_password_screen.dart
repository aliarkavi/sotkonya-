import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'info_card.dart';
import 'profile_header_card.dart';
import '../../model/app_user.dart';

import '../../widgets/gradient_button.dart';
import '../../widgets/text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  final AppUser obj; // نفس نمط ProfileScreen: نمرر المستخدم

  const ChangePasswordScreen({super.key, required this.obj});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController currentController = TextEditingController();
  final TextEditingController newController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool _loading = false;

  bool showCurrent = false;
  bool showNew = false;
  bool showConfirm = false;

  @override
  void dispose() {
    currentController.dispose();
    newController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  // ✅ تحقق محلي من سياسة كلمة المرور (عدّلها حسب شروط Firebase عندك)
  String? _validatePasswordPolicy(String p) {
    if (p.length < 8) return "كلمة المرور يجب أن تكون 8 أحرف على الأقل";
    if (!RegExp(r'[A-Z]').hasMatch(p)) return "يجب أن تحتوي حرفًا كبيرًا (A-Z)";
    if (!RegExp(r'[a-z]').hasMatch(p)) return "يجب أن تحتوي حرفًا صغيرًا (a-z)";
    if (!RegExp(r'\d').hasMatch(p)) return "يجب أن تحتوي رقمًا (0-9)";
    return null;
  }

  Future<void> _changePassword() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    final currentPass = currentController.text.trim();
    final newPass = newController.text.trim();
    final confirmPass = confirmController.text.trim();

    if (firebaseUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("لا يوجد مستخدم مسجل دخول")),
      );
      return;
    }

    if (currentPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى تعبئة جميع الحقول")),
      );
      return;
    }

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تأكيد كلمة المرور غير مطابق")),
      );
      return;
    }

    if (currentPass == newPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("كلمة المرور الجديدة يجب أن تختلف عن القديمة")),
      );
      return;
    }

    // ✅ تطبيق سياسة الـ 8 أحرف + Upper/Lower/Number محليًا
    final policyError = _validatePasswordPolicy(newPass);
    if (policyError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(policyError)),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final email = firebaseUser.email;
      if (email == null || email.isEmpty) {
        throw Exception("لا يمكن تغيير كلمة المرور لأن البريد غير متوفر لهذا الحساب");
      }

      // ✅ 1) إعادة توثيق بكلمة المرور الحالية
      final cred = EmailAuthProvider.credential(
        email: email,
        password: currentPass,
      );
      await firebaseUser.reauthenticateWithCredential(cred);

      // ✅ 2) تغيير كلمة المرور
      await firebaseUser.updatePassword(newPass);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم تغيير كلمة المرور بنجاح")),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // ✅ عرض رسالة عربية بدل الإنكليزي
      final msg = _firebaseAuthErrorToArabic(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } catch (_) {
      // ✅ لا نعرض Exception الخام للمستخدم
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("حدث خطأ، حاول مرة أخرى")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ✅ ترجمة أخطاء Firebase للعربي (مُوسع + يغطي invalid-credential + رسائل policy)
  String _firebaseAuthErrorToArabic(FirebaseAuthException e) {
    final msg = (e.message ?? '').toLowerCase();

    // ✅ في بعض الحالات يرجع Firebase قائمة متطلبات كلمة المرور بالإنجليزي داخل message
    if (msg.contains('password must contain') ||
        msg.contains('at least 8 characters') ||
        msg.contains('upper case') ||
        msg.contains('numeric')) {
      return "كلمة المرور لا تطابق الشروط.\n"
          "يجب أن تكون 8 أحرف على الأقل، وتحتوي حرفًا كبيرًا (A-Z)، وحرفًا صغيرًا (a-z)، ورقمًا (0-9).";
    }

    switch (e.code) {
      case 'wrong-password':
        return "كلمة المرور الحالية غير صحيحة";

      case 'invalid-credential':
      case 'invalid-login-credentials':
        return "كلمة المرور الحالية غير صحيحة";

      case 'user-mismatch':
        return "حصل عدم تطابق في بيانات المستخدم";

      case 'user-not-found':
        return "هذا الحساب غير موجود";

      case 'invalid-email':
        return "البريد الإلكتروني غير صالح";

      case 'weak-password':
        return "كلمة المرور الجديدة ضعيفة أو لا تطابق الشروط المطلوبة";

      case 'requires-recent-login':
        return "للأمان: سجّل خروج ثم سجّل دخول وحاول مجددًا";

      case 'too-many-requests':
        return "محاولات كثيرة. حاول لاحقًا";

      case 'operation-not-allowed':
        return "هذه العملية غير مسموحة";

      case 'network-request-failed':
        return "لا يوجد اتصال إنترنت. تحقق من الشبكة";

      default:
        return "تعذر تغيير كلمة المرور. تأكد من كلمة المرور الحالية ثم حاول مجددًا";
    }
  }

  @override
  Widget build(BuildContext context) {
    final obj = widget.obj;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تغيير كلمة المرور"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 15.0,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // ✅ نفس هيدر البروفايل تمامًا
                  ProfileHeaderCard(
                    name: obj.name,
                    studentNumber: obj.studentNumber,
                    major: obj.major,
                    photoUrl: obj.photoUrl,
                  ),

                  const SizedBox(height: 10),

                  // ✅ نفس InfoCard + عنوان
                  InfoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "معلومات كلمة المرور",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _PasswordRowItem(
                          label: "كلمة المرور الحالية",
                          icon: Icons.lock_outline,
                          controller: currentController,
                          obscureText: !showCurrent,
                          onToggle: () => setState(() => showCurrent = !showCurrent),
                        ),
                        const SizedBox(height: 10),

                        _PasswordRowItem(
                          label: "كلمة المرور الجديدة",
                          icon: Icons.lock_reset_outlined,
                          controller: newController,
                          obscureText: !showNew,
                          onToggle: () => setState(() => showNew = !showNew),
                        ),
                        const SizedBox(height: 10),

                        _PasswordRowItem(
                          label: "تأكيد كلمة المرور الجديدة",
                          icon: Icons.verified_outlined,
                          controller: confirmController,
                          obscureText: !showConfirm,
                          onToggle: () => setState(() => showConfirm = !showConfirm),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  GradientButton(
                    onTap: _loading ? null : _changePassword,
                    text: _loading ? "جاري التغيير..." : "تأكيد تغيير كلمة المرور",
                    icon: Icons.clear,
                    iconSize: 0,
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ✅ بنفس شكل InfoRowItem تقريبًا (خلفية فاتحة + أيقونة + محتوى)
class _PasswordRowItem extends StatelessWidget {
  const _PasswordRowItem({
    required this.label,
    required this.icon,
    required this.controller,
    required this.obscureText,
    required this.onToggle,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: const Color(0xFF0F87FF)),
          const SizedBox(width: 10),

          Expanded(
            child: CustomTextField(
              label: label,
              controller: controller,
              obscureText: obscureText,
            ),
          ),

          const SizedBox(width: 6),

          IconButton(
            onPressed: onToggle,
            icon: Icon(
              obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
