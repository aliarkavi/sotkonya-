// lib/screens/yurt/yurtlar_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/layouts/base_page_layout.dart';
import '../../providers/yurt_provider.dart';
import '../../providers/auth_provider.dart';
import '../../model/yurt_model.dart';
import 'widgets/yurtlar_item_card.dart';
import 'widgets/yurt_details_screen.dart';
import 'add_yurt_screen.dart';
import 'edit_yurt_screen.dart';

class YurtlarScreen extends StatefulWidget {
  const YurtlarScreen({super.key});

  @override
  State<YurtlarScreen> createState() => _YurtlarScreenState();
}

class _YurtlarScreenState extends State<YurtlarScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final provider = Provider.of<YurtProvider>(context, listen: false);
      if (provider.items.isEmpty && !provider.loading) {
        provider.fetchYurtlar();
      }
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<YurtProvider>(context);
    final isAdmin = Provider.of<AuthProvider>(context).isAdmin;

    return BasePageLayout(
      title: "السكنات الطلابية",
      child: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (isAdmin)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFeb5623),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddYurtScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "إضافة سكن جديد",
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
                        "لم يتم إضافة سكنات لقسم السكنات",
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
                      final YurtModel item = provider.items[index];
                      const cardColor = Color(0xFFeb5623);

                      return YurtlarItemCard(
                        obj: item,
                        iconData: Icons.article,
                        color: cardColor,
                        isAdmin: isAdmin,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => YurtDetailsScreen(
                                color: cardColor,
                                obj: item,
                              ),
                            ),
                          );
                        },
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditYurtScreen(item: item),
                            ),
                          );
                        },
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("حذف السكن"),
                              content: const Text(
                                "هل أنت متأكد من حذف هذا السكن؟ لا يمكن التراجع بعد الحذف.",
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
                            await provider.deleteYurt(item.id);
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
