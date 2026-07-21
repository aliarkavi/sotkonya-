import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sotkonya/providers/riverpod_providers.dart';

import '../../widgets/layouts/base_page_layout.dart';
import 'widgets/administration_item_card.dart';
import 'add_administration_screen.dart';
import 'edit_administration_screen.dart';

class AdministrationScreen extends ConsumerStatefulWidget {
  const AdministrationScreen({super.key});

  @override
  ConsumerState<AdministrationScreen> createState() => _AdministrationScreenState();
}

class _AdministrationScreenState extends ConsumerState<AdministrationScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    _initialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final provider =
          ref.read(administrationProvider);
      if (provider.items.isEmpty && !provider.loading) {
        provider.fetchAdministration();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(administrationProvider);
    final isAdmin = ref.watch(authProvider).isAdmin;

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
