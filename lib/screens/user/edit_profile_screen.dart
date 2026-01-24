import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sotkonya/model/app_user.dart';
import 'package:sotkonya/providers/auth_provider.dart';

import 'info_card.dart';
import 'profile_header_card.dart';
import '../../../widgets/text_field.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/gradient_button.dart';

class EditProfileScreen extends StatefulWidget {
  final AppUser user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController ageController;
  late final TextEditingController phoneController;
  late final TextEditingController majorController;
  late final TextEditingController studentNumberController;
  late final TextEditingController facultyController;
  late final TextEditingController extraInfoController;

  String? gender;
  String? university;
  String? studyYear;

  final List<String> universities = const [
    "سلجوق",
    "نجم الدين أربكان",
    "قونيا التقنية",
    "كراتاي",
  ];

  final List<String> studyYears = const [
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
  void initState() {
    super.initState();
    final u = widget.user;

    nameController = TextEditingController(text: u.name);
    ageController = TextEditingController(text: u.age?.toString() ?? '');
    phoneController = TextEditingController(text: u.phone);
    majorController = TextEditingController(text: u.major);
    studentNumberController = TextEditingController(text: u.studentNumber);
    facultyController = TextEditingController(text: u.faculty);
    extraInfoController = TextEditingController(text: u.extraInfo);

    // حل مشكلة male/female القديمة
    if (u.gender == 'male') {
      gender = 'ذكر';
    } else if (u.gender == 'female') {
      gender = 'أنثى';
    } else if (u.gender.isNotEmpty) {
      gender = u.gender;
    } else {
      gender = null;
    }

    university = u.university.isNotEmpty ? u.university : null;
    studyYear = u.studyYear.isNotEmpty ? u.studyYear : null;
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    phoneController.dispose();
    majorController.dispose();
    studentNumberController.dispose();
    facultyController.dispose();
    extraInfoController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى إدخال الاسم")),
      );
      return;
    }

    if (gender == null || university == null || studyYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى اختيار الجنس والجامعة وسنة الدراسة")),
      );
      return;
    }

    final updatedUser = widget.user.copyWith(
      name: nameController.text.trim(),
      age: int.tryParse(ageController.text.trim()),
      phone: phoneController.text.trim(),
      major: majorController.text.trim(),
      studentNumber: studentNumberController.text.trim(),
      faculty: facultyController.text.trim(),
      extraInfo: extraInfoController.text.trim(),
      gender: gender!,
      university: university!,
      studyYear: studyYear!,
    );

    await auth.updateProfile(updatedUser);

    if (!mounted) return;

    if (auth.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم حفظ التعديلات بنجاح")),
      );
      Navigator.pop(context, updatedUser);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تعديل الملف الشخصي"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.check_circle_outline),
              onPressed: auth.loading ? null : _save,
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // ✅ نفس رأس البروفايل (عرض سريع)
                ProfileHeaderCard(
  name: widget.user.name,
  studentNumber: widget.user.studentNumber,
  major: widget.user.major,
  photoUrl: widget.user.photoUrl, // ✅
),


                  const SizedBox(height: 10),

                  // ===========================
                  // المعلومات الشخصية
                  // ===========================
                  InfoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "المعلومات الشخصية",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 16),

                        _EditRowTextField(
                          icon: Icons.person_outline,
                          label: "الاسم والكنية (بالتركية)",
                          controller: nameController,
                        ),
                        const SizedBox(height: 10),

                        _EditRowDropdown(
                          icon: Icons.wc_outlined,
                          label: "الجنس",
                          value: gender,
                          items: const ["ذكر", "أنثى"],
                          onChanged: (val) => setState(() => gender = val),
                        ),
                        const SizedBox(height: 10),

                        _EditRowTextField(
                          icon: Icons.cake_outlined,
                          label: "العمر",
                          controller: ageController,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 10),

                        // البريد عادة ما لا يُعدّل (FirebaseAuth)
                        _ReadOnlyRow(
                          icon: Icons.email_outlined,
                          label: "البريد الإلكتروني",
                          value: widget.user.email,
                        ),
                        const SizedBox(height: 10),

                        _EditRowTextField(
                          icon: Icons.phone_outlined,
                          label: "رقم الجوال",
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ===========================
                  // المعلومات الأكاديمية
                  // ===========================
                  InfoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "المعلومات الأكاديمية",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 16),

                        _EditRowDropdown(
                          icon: Icons.account_balance_outlined,
                          label: "الجامعة",
                          value: university,
                          items: universities,
                          onChanged: (val) => setState(() => university = val),
                        ),
                        const SizedBox(height: 10),

                        _EditRowTextField(
                          icon: Icons.school_outlined,
                          label: "الكلية",
                          controller: facultyController,
                        ),
                        const SizedBox(height: 10),

                        _EditRowDropdown(
                          icon: Icons.numbers_outlined,
                          label: "المستوى الدراسي",
                          value: studyYear,
                          items: studyYears,
                          onChanged: (val) => setState(() => studyYear = val),
                        ),
                        const SizedBox(height: 10),

                        _EditRowTextField(
                          icon: Icons.menu_book_outlined,
                          label: "التخصص",
                          controller: majorController,
                        ),
                        const SizedBox(height: 10),

                        _EditRowTextField(
                          icon: Icons.badge_outlined,
                          label: "رقم الطالب الجامعي",
                          controller: studentNumberController,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ===========================
                  // إضافي
                  // ===========================
                  InfoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "معلومات إضافية",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 16),

                        _EditRowTextField(
                          icon: Icons.info_outline,
                          label: "معلومات إضافية (اختياري)",
                          controller: extraInfoController,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  GradientButton(
                    onTap: auth.loading ? null : _save,
                    text: auth.loading ? "جاري الحفظ..." : "حفظ التعديلات",
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

// -----------------------------------------------------------------------------
// Widgets صغيرة لتخطيط مشابه لـ InfoRowItem (Icon + محتوى)
// -----------------------------------------------------------------------------

class _EditRowTextField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;

  const _EditRowTextField({
    required this.icon,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 10),
        Expanded(
          child: CustomTextField(
            label: label,
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
          ),
        ),
      ],
    );
  }
}

class _EditRowDropdown extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  const _EditRowDropdown({
    required this.icon,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // حماية إضافية: إذا value غير موجودة ضمن items نخليها null
    final safeValue = (value != null && items.contains(value)) ? value : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 10),
        Expanded(
          child: CustomDropdown(
            label: label,
            items: items,
            value: safeValue,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _ReadOnlyRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ReadOnlyRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
