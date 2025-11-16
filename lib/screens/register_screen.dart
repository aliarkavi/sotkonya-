import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Focus Nodes
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'الانضمام إلى مجتمع الطلاب',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 12),

                const Text(
                  "تسجيل جديد",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                ),

                const SizedBox(height: 4),
                const Text(
                  "انضم إلى مجتمع الطلاب",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),

                const SizedBox(height: 24),

                if (_error != null)
                  Text(_error!, style: const TextStyle(color: Colors.red)),

                _SectionTitle(title: "المعلومات الشخصية"),

                Row(
                  children: [
                    Expanded(child: _buildTextField(firstNameController, "الاسم الأول")),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField(lastNameController, "الكنية")),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(child: _buildTextField(phoneController, "رقم الهاتف", keyboardType: TextInputType.phone)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField(ageController, "العمر", keyboardType: TextInputType.number)),
                  ],
                ),

                const SizedBox(height: 24),

                _SectionTitle(title: "المعلومات الجامعية"),

                Row(
                  children: [
                    Expanded(child: _buildTextField(universityController, "الجامعة")),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField(facultyController, "الكلية")),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(child: _buildTextField(majorController, "الفرع الجامعي")),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: _inputDecoration("السنة الجامعية"),
                        initialValue: selectedYear ?? years[0],
                        items: years
                            .map((y) => DropdownMenuItem(
                                  value: y,
                                  child: Text(y),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => selectedYear = v),
                        validator: (v) => v == years[0] ? "يرجى اختيار السنة" : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _SectionTitle(title: "معلومات الحساب"),

                Row(
                  children: [
                    Expanded(child: _buildTextField(emailController, "البريد الإلكتروني", keyboardType: TextInputType.emailAddress)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField(usernameController, "اسم المستخدم")),
                  ],
                ),

                const SizedBox(height: 12),

                _buildTextField(passwordController, "كلمة المرور", obscureText: true),

                const SizedBox(height: 32),

                // زر التسجيل بتدرج الألوان
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff006db7), Color(0xff00b39f),Color(0xffeb5623),Color(0xfff2b200)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ElevatedButton(
                    onPressed: _loading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("تسجيل", style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF))),
                  ),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                  child: const Text(
                    "لديك حساب بالفعل؟ تسجيل دخول",
                    style: TextStyle(color: Colors.blue),
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
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF0097A7), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      decoration: _inputDecoration(label),
      validator: (v) => (v == null || v.isEmpty) ? "هذا الحقل مطلوب" : null,
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedYear == years[0]) {
      setState(() => _error = "يرجى اختيار السنة الجامعية");
      return;
    }

    setState(() => _loading = true);

    try {
      final email = emailController.text.trim();
      final pass = passwordController.text.trim();

      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      final user = cred.user!;
      final appUser = AppUser(
        id: user.uid,
        name: "${firstNameController.text.trim()} ${lastNameController.text.trim()}",
        email: email,
        role: "user",
        major: majorController.text.trim(),
        gender: "",
        photoUrl: "",
      );

      await UserService().createUser(appUser);

      setState(() => _loading = false);

      showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(title: const Text("نجاح"), content: const Text("تم إنشاء حسابك بنجاح!")),
      );
    } catch (e) {
      setState(() {
        _loading = false;
        _error = "حدث خطأ أثناء التسجيل";
      });
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}
