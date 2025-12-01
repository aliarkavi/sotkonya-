import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sotkonya/model/yurt_item.dart';
import 'package:sotkonya/providers/yurt_provider.dart';

class AddYurtScreen extends StatefulWidget {
  const AddYurtScreen({super.key});

  @override
  State<AddYurtScreen> createState() => _AddYurtScreenState();
}

class _AddYurtScreenState extends State<AddYurtScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController personelController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController mapUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<YurtProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة سكن"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "اسم السكن"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: statusController,
              decoration: const InputDecoration(labelText: "الحالة"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: personelController,
              decoration: const InputDecoration(labelText: "معلومات التواصل"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: rentController,
              decoration: const InputDecoration(labelText: "الإيجار"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: "الموقع"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "رقم الهاتف"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: mapUrlController,
              decoration:
                  const InputDecoration(labelText: "رابط الموقع على الخريطة"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final item = YurtItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text.trim(),
                  status: statusController.text.trim(),
                  personelData: personelController.text.trim(),
                  rentData: rentController.text.trim(),
                  location: locationController.text.trim(),
                  phone: phoneController.text.trim(),
                  mapUrl: mapUrlController.text.trim(),
                );

                await provider.addYurt(item);
                if (mounted) Navigator.pop(context);
              },
              child: const Text("حفظ السكن"),
            ),
          ],
        ),
      ),
    );
  }
}

