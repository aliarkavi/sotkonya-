import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sotkonya/model/yurt_item.dart';
import 'package:sotkonya/providers/yurt_provider.dart';

class EditYurtScreen extends StatefulWidget {
  final YurtItem item;
  const EditYurtScreen({super.key, required this.item});

  @override
  State<EditYurtScreen> createState() => _EditYurtScreenState();
}

class _EditYurtScreenState extends State<EditYurtScreen> {
  late TextEditingController titleController;
  late TextEditingController statusController;
  late TextEditingController personelController;
  late TextEditingController rentController;
  late TextEditingController locationController;
  late TextEditingController phoneController;
  late TextEditingController mapUrlController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.item.title);
    statusController = TextEditingController(text: widget.item.status);
    personelController =
        TextEditingController(text: widget.item.personelData);
    rentController = TextEditingController(text: widget.item.rentData);
    locationController = TextEditingController(text: widget.item.location);
    phoneController = TextEditingController(text: widget.item.phone);
    mapUrlController = TextEditingController(text: widget.item.mapUrl);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<YurtProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("تعديل سكن"),
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
                final updated = YurtItem(
                  id: widget.item.id,
                  title: titleController.text.trim(),
                  status: statusController.text.trim(),
                  personelData: personelController.text.trim(),
                  rentData: rentController.text.trim(),
                  location: locationController.text.trim(),
                  phone: phoneController.text.trim(),
                  mapUrl: mapUrlController.text.trim(),
                );

                await provider.updateYurt(updated);
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

