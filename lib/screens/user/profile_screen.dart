import 'package:flutter/material.dart';
import 'package:sotkonya/model/app_user.dart';
import 'package:sotkonya/screens/user/edit_profile_screen.dart';
import 'info_card.dart';
import 'profile_header_card.dart';

class ProfileScreen extends StatelessWidget {
  final String title;
  final AppUser obj;

  const ProfileScreen({super.key, required this.title, required this.obj});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          actions: [
            IconButton(icon: Icon(Icons.edit_outlined),   onPressed: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditProfileScreen(user: obj),
        ),
      );

      // إذا تريد تحديث الشاشة مباشرة بعد الرجوع:
      // هذا يعتمد على كيف تجيب obj (من Provider أو تمرير ثابت)
      // إن كان من Provider: اعمل refresh أو اقرأ auth.appUser
      // إن كان تمرير ثابت: تحتاج تعيد بناء الصفحة من الأب.
    },),
          ],
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
                  SizedBox(height: 10),
                ProfileHeaderCard(
  name: obj.name,
  studentNumber: obj.studentNumber,
  major: obj.major,
  photoUrl: obj.photoUrl, // ✅ أضف هذا
),

                  SizedBox(height: 10),

                  InfoCard(
                    child: Column(
                      // textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "المعلومات الشخصية",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),

                        InfoRowItem(
                          label: 'البريد الإلكتروني',
                          value: obj.email,
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 10),

                        InfoRowItem(
                          label: 'رقم الجوال',
                          value: obj.phone,
                          icon: Icons.phone_outlined,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  InfoCard(
                    child: Column(
                      // textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "المعلومات الأكاديمية",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),

                        InfoRowItem(
                          color: Colors.grey,
                          label: 'الكلية',
                          value: obj.faculty,
                          icon: Icons.school_outlined,
                        ),
                        const SizedBox(height: 10),

                        InfoRowItem(
                          color: Colors.grey,
                          label: "المستوى الدراسي",
                          value: obj.studyYear,
                          icon: Icons.numbers_outlined,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
