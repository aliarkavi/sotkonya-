import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  // Focus nodes for inputs to ensure keyboard focus works
  late FocusNode firstNameFocus;
  late FocusNode lastNameFocus;
  late FocusNode phoneFocus;
  late FocusNode ageFocus;
  late FocusNode universityFocus;
  late FocusNode facultyFocus;
  late FocusNode majorFocus;
  late FocusNode emailFocus;
  late FocusNode usernameFocus;
  late FocusNode passwordFocus;
  

  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController universityController = TextEditingController();
  final TextEditingController facultyController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedYear;
  final List<String> years = [
    'اختر السنة',
    'الأولى',
    'الثانية',
    'الثالثة',
    'الرابعة',
    'خامسة أو أكثر',
  ];

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    ageController.dispose();
    universityController.dispose();
    facultyController.dispose();
    majorController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
  // dispose focus nodes
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    phoneFocus.dispose();
    ageFocus.dispose();
    universityFocus.dispose();
    facultyFocus.dispose();
    majorFocus.dispose();
    emailFocus.dispose();
    usernameFocus.dispose();
    passwordFocus.dispose();
    
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    firstNameFocus = FocusNode();
    lastNameFocus = FocusNode();
    phoneFocus = FocusNode();
    ageFocus = FocusNode();
    universityFocus = FocusNode();
    facultyFocus = FocusNode();
    majorFocus = FocusNode();
    emailFocus = FocusNode();
    usernameFocus = FocusNode();
    passwordFocus = FocusNode();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151C26),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('الانضمام إلى التجمع'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'أهلاً بك في منصة التجمع! يرجى ملء الاستبيان التالي.',
                  style: TextStyle(color: Color(0xFFB0B8C1), fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(_error!, style: const TextStyle(color: Colors.red)),
                  ),
                _SectionTitle(title: 'المعلومات الشخصية'),
                Row(
                  children: [
                    Expanded(child: _buildTextField(firstNameController, 'الاسم الأول', focusNode: firstNameFocus, autofocus: true)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(lastNameController, 'الكنية', focusNode: lastNameFocus)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildTextField(phoneController, 'رقم الهاتف', keyboardType: TextInputType.phone, focusNode: phoneFocus)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(ageController, 'العمر', keyboardType: TextInputType.number, focusNode: ageFocus)),
                  ],
                ),
                const SizedBox(height: 24),
                _SectionTitle(title: 'المعلومات الجامعية'),
                Row(
                  children: [
                    Expanded(child: _buildTextField(universityController, 'الجامعة', focusNode: universityFocus)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(facultyController, 'الكلية', focusNode: facultyFocus)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildTextField(majorController, 'الفرع الجامعي', focusNode: majorFocus)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedYear ?? years[0],
                        items: years.map((y) => DropdownMenuItem(value: y, child: Text(y))).toList(),
                        onChanged: (val) => setState(() => selectedYear = val),
                        decoration: _inputDecoration('السنة الجامعية'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _SectionTitle(title: 'معلومات الحساب'),
                Row(
                  children: [
                    Expanded(child: _buildTextField(emailController, 'البريد الإلكتروني', keyboardType: TextInputType.emailAddress, focusNode: emailFocus)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(usernameController, 'اسم المستخدم (للدخول لاحقاً)', focusNode: usernameFocus)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildTextField(passwordController, 'كلمة المرور', keyboardType: TextInputType.visiblePassword, obscureText: true, focusNode: passwordFocus)),
                    const SizedBox(width: 16),
                    const Expanded(child: SizedBox.shrink()),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF039BE5),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _loading ? null : _register,
                    child: _loading
                        ? const SizedBox(
                            width: 24, height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('إرسال و الانضمام'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('← العودة إلى شاشة الدخول', style: TextStyle(color: Color(0xFFB0B8C1))),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate() || selectedYear == null || selectedYear == years[0]) {
      setState(() => _error = 'يرجى تعبئة جميع الحقول واختيار السنة الجامعية');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();
      if (password.length < 6) {
        setState(() { _loading = false; _error = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'; });
        return;
      }
        debugPrint('Attempting createUserWithEmail: $email');
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        final user = userCredential.user;
        if (user == null) throw Exception('فشل إنشاء الحساب');

      final appUser = AppUser(
        id: user.uid,
        name: '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
        email: email,
        role: 'user',
        major: majorController.text.trim(),
        gender: '',
        photoUrl: '',
      );
        try {
          await UserService().createUser(appUser);
        } catch (e, st) {
          debugPrint('createUser Firestore error: $e\n$st');
          setState(() { _loading = false; _error = 'فشل حفظ بيانات المستخدم في قاعدة البيانات'; });
          await showDialog<void>(context: context, builder: (_) => AlertDialog(title: const Text('خطأ'), content: Text(e.toString()), actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('حسناً'))]));
          return;
        }

      setState(() { _loading = false; });
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('تم التسجيل بنجاح'),
          content: const Text('تم إنشاء حسابك بنجاح! يمكنك الآن تسجيل الدخول.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('موافق'),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() { _loading = false; _error = e.message ?? 'حدث خطأ أثناء التسجيل'; });
    } catch (e) {
      setState(() { _loading = false; _error = 'حدث خطأ أثناء التسجيل'; });
    }
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text, bool obscureText = false, FocusNode? focusNode, bool autofocus = false}) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(label),
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      readOnly: false,
      enableInteractiveSelection: true,
      onTap: () {
        debugPrint('Tapped field: $label');
        focusNode?.requestFocus();
      },
      onChanged: (v) {
        debugPrint('Field updated: $label -> $v');
      },
      onEditingComplete: () {
        debugPrint('Editing complete for: $label');
      },
      validator: (value) {
        if (value == null || value.isEmpty) return 'هذا الحقل مطلوب';
        if (label == 'كلمة المرور' && value.length < 6) return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
        return null;
      },
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
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
