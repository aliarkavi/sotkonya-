import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sotkonya/screens/settings/privacy_policy_screen.dart';

import '../../../widgets/gradient_button.dart';
import '../../../widgets/text_field.dart';
import '../../../widgets/custom_dropdown.dart';

import '../../../model/app_user.dart';
import '../../../providers/auth_provider.dart';
import '../login/login.dart';
 // تأكد من استيراد ملف السياسة

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController extraInfoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Dropdown values
  String? gender;
  String? university;
  String? studyYear;

  // ✅ حالة الموافقة على الخصوصية
  bool _isPrivacyAccepted = false;

  final List<String> universities = [
    "سلجوق",
    "نجم الدين أربكان",
    "قونيا التقنية",
    "كراتاي",
  ];

  final List<String> studyYears = [
    "تحضيري (HAZIRLIK)",
    "سنة أولى",
    "سنة ثانية",
    "سنة ثالثة",
    "سنة رابعة",
    "سنة خامسة",
    "سنة سادسة",
    "ماجستير",
    "دكتوراه",
    "آخر",
  ];

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    ageController.dispose();
    majorController.dispose();
    studentIdController.dispose();
    phoneController.dispose();
    extraInfoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text("إنشاء حساب"), centerTitle: true),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF006db7), Color(0xFF00b39f)],
                      ),
                      borderRadius: BorderRadius.circular(55),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_add_alt_1_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'تسجيل جديد',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF00b39f),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'انضم إلى مجتمع الطلاب',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ===========================
                  // المعلومات الشخصية
                  // ===========================
                  CustomTextField(
                    label: "الاسم والكنية (بالتركية)",
                    controller: nameController,
                  ),
                  const SizedBox(height: 15),

                  CustomDropdown(
                    label: "الجنس",
                    items: const ["ذكر", "أنثى"],
                    value: gender,
                    onChanged: (val) => setState(() => gender = val),
                  ),
                  const SizedBox(height: 15),

                  CustomTextField(
                    label: "العمر",
                    controller: ageController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 25),

                  // ===========================
                  // معلومات الجامعة
                  // ===========================
                  CustomDropdown(
                    label: "الجامعة",
                    items: universities,
                    value: university,
                    onChanged: (val) => setState(() => university = val),
                  ),
                  const SizedBox(height: 15),

                  CustomDropdown(
                    label: "سنة الدراسة",
                    items: studyYears,
                    value: studyYear,
                    onChanged: (val) => setState(() => studyYear = val),
                  ),
                  const SizedBox(height: 15),

                  CustomTextField(
                    label: "التخصص",
                    controller: majorController,
                  ),
                  const SizedBox(height: 15),

                  CustomTextField(
                    label: "رقم الطالب الجامعي",
                    controller: studentIdController,
                  ),
                  const SizedBox(height: 25),

                  // ===========================
                  // التواصل
                  // ===========================
                  CustomTextField(
                    label: "البريد الإلكتروني",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),

                  CustomTextField(
                    label: "رقم الهاتف",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 25),

                
                  // ===========================
                  // كلمة المرور
                  // ===========================
                  CustomTextField(
                    label: "كلمة المرور",
                    controller: passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  // ===========================

                    // ===========================
                  // إضافي
                  // ===========================
                  CustomTextField(
                    label: "معلومات إضافية (اختياري)",
                    controller: extraInfoController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 25),
                  // ===========================

                  // ✅ Checkbox الخاص بسياسة الخصوصية
                  Row(
                    children: [
                      Checkbox(
                        value: _isPrivacyAccepted,
                        activeColor: const Color(0xFF00b39f),
                        onChanged: (val) {
                          setState(() {
                            _isPrivacyAccepted = val ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                            );
                          },
                          child: const Text.rich(
                            TextSpan(
                              text: "لقد قرأت وأوافق على ",
                              style: TextStyle(fontSize: 13),
                              children: [
                                TextSpan(
                                  text: "سياسة الخصوصية",
                                  style: TextStyle(
                                    color: Color(0xFF006db7),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // زر التسجيل
                  GradientButton(
                    onTap: (auth.loading || !_isPrivacyAccepted)
                        ? null
                        : () async {
                            if (gender == null ||
                                university == null ||
                                studyYear == null ||
                                nameController.text.trim().isEmpty ||
                                emailController.text.trim().isEmpty ||
                                passwordController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("يرجى تعبئة جميع الحقول المطلوبة"),
                                ),
                              );
                              return;
                            }

                            final user = AppUser(
                              id: "",
                              name: nameController.text.trim(),
                              email: emailController.text.trim(),
                              role: "user",
                              major: majorController.text.trim(),
                              gender: gender!,
                              photoUrl: "",
                              phone: phoneController.text.trim(),
                              university: university!,
                              faculty: "",
                              username: "",
                              age: int.tryParse(ageController.text),
                              studentNumber: studentIdController.text.trim(),
                              studyYear: studyYear!,
                              extraInfo: extraInfoController.text.trim(),
                            );

                            await auth.register(user, passwordController.text.trim());

                            if (!mounted) return;

                            if (auth.error == null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(auth.error!)),
                              );
                            }
                          },
                    text: auth.loading ? "جاري التسجيل..." : "تسجيل",
                    icon: Icons.check,
                    iconSize: 20,
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("هل لديك حساب؟"),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        ),
                        child: const Text("تسجيل دخول"),
                      ),
                    ],
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