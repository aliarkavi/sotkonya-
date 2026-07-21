import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sotkonya/providers/riverpod_providers.dart';
import 'package:sotkonya/model/administration_item.dart';

class AddAdministrationScreen extends ConsumerStatefulWidget {
  const AddAdministrationScreen({super.key});

  @override
  ConsumerState<AddAdministrationScreen> createState() =>
      _AddAdministrationScreenState();
}

class _AddAdministrationScreenState extends ConsumerState<AddAdministrationScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider =
        ref.read(administrationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة عضو إدارة"),
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
                final item = AdministrationItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text.trim(),
                  job: jobController.text.trim(),
                  aboutHim: aboutController.text.trim(),
                  email: emailController.text.trim(),
                  phone: phoneController.text.trim(),
                );

                await provider.addAdministration(item);
                if (mounted) Navigator.pop(context);
              },
              child: const Text("حفظ"),
            ),
          ],
        ),
      ),
    );
  }
}

