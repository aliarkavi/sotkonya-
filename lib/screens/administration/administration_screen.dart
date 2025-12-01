import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/layouts/base_page_layout.dart';
import '../../providers/administration_provider.dart';
import '../../providers/auth_provider.dart';
import 'widgets/administration_item_card.dart';
import 'add_administration_screen.dart';
import 'edit_administration_screen.dart';

class AdministrationScreen extends StatefulWidget {
  const AdministrationScreen({super.key});

  @override
  State<AdministrationScreen> createState() => _AdministrationScreenState();
}

class _AdministrationScreenState extends State<AdministrationScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final provider =
          Provider.of<AdministrationProvider>(context, listen: false);
      if (provider.items.isEmpty && !provider.loading) {
        provider.fetchAdministration();
      }
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdministrationProvider>(context);
    final isAdmin = Provider.of<AuthProvider>(context).isAdmin;

    return BasePageLayout(
      title: "إدارة الجامعة",
      child: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (isAdmin)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00a5a5),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddAdministrationScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "إضافة عضو إدارة",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                if (provider.items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "لم يتم اختيار الإداريين بعد لقسم الإدارة",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    itemCount: provider.items.length,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 15),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = provider.items[index];
                      return AdministrationItemCard(
                        title: item.title,
                        job: item.job,
                        aboutHim: item.aboutHim,
                        iconData: Icons.article,
                        color: const Color(0xFF00a5a5),
                        onTap: () {},
                        isAdmin: isAdmin,
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditAdministrationScreen(item: item),
                            ),
                          );
                        },
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("حذف عضو الإدارة"),
                              content: const Text(
                                "هل أنت متأكد من حذف هذا العضو؟ لا يمكن التراجع بعد الحذف.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(ctx).pop(false),
                                  child: const Text("إلغاء"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(ctx).pop(true),
                                  child: const Text(
                                    "حذف",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await provider.deleteAdministration(item.id);
                          }
                        },
                      );
                    },
                  ),
              ],
            ),
    );
  }
}

