import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sotkonya/providers/riverpod_providers.dart';
import 'package:sotkonya/model/administration_item.dart';

class EditAdministrationScreen extends ConsumerStatefulWidget {
  final AdministrationItem item;
  const EditAdministrationScreen({super.key, required this.item});

  @override
  ConsumerState<EditAdministrationScreen> createState() =>
      _EditAdministrationScreenState();
}

class _EditAdministrationScreenState extends ConsumerState<EditAdministrationScreen> {
  late TextEditingController titleController;
  late TextEditingController jobController;
  late TextEditingController aboutController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.item.title);
    jobController = TextEditingController(text: widget.item.job);
    aboutController = TextEditingController(text: widget.item.aboutHim);
    emailController = TextEditingController(text: widget.item.email);
    phoneController = TextEditingController(text: widget.item.phone);
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        ref.read(administrationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("تعديل عضو إدارة"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "الاسم / المنصب"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: jobController,
              decoration: const InputDecoration(labelText: "الوظيفة"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: aboutController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "نبذة عنه"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration:
                  const InputDecoration(labelText: "البريد الإلكتروني"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "رقم الهاتف"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final updated = AdministrationItem(
                  id: widget.item.id,
                  title: titleController.text.trim(),
                  job: jobController.text.trim(),
                  aboutHim: aboutController.text.trim(),
                  email: emailController.text.trim(),
                  phone: phoneController.text.trim(),
                );

                await provider.updateAdministration(updated);
                if (mounted) Navigator.pop(context);
              },
              child: const Text("حفظ التغييرات"),
            ),
          ],
        ),
      ),
    );
  }
}

