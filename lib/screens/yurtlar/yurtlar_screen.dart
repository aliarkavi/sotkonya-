// lib/screens/yurt/yurtlar_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sotkonya/widgets/shimmer_widgets.dart';

import '../../widgets/layouts/base_page_layout.dart';
import '../../providers/yurt_provider.dart';
import '../../providers/auth_provider.dart';
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
  static const Color primaryColor = Color(0xFFeb5623);

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

  // ================================
  // 🔥 BottomSheet الخاص بالإجراءات
  // ================================
  Future<String?> _showAdminActions() {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              const SizedBox(height: 20),

              // تعديل
              GestureDetector(
                onTap: () => Navigator.pop(ctx, "edit"),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEFE8),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.edit, color: primaryColor),
                      SizedBox(width: 12),
                      Text(
                        "تعديل السكن",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // حذف
              GestureDetector(
                onTap: () => Navigator.pop(ctx, "delete"),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE5E5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 12),
                      Text(
                        "حذف السكن",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // إلغاء
              GestureDetector(
                onTap: () => Navigator.pop(ctx, null),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.close, color: Colors.grey),
                      SizedBox(width: 12),
                      Text(
                        "إلغاء",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<YurtProvider>(context);
    final isAdmin = Provider.of<AuthProvider>(context).isAdmin;

    return BasePageLayout(
      title: "السكنات الطلابية",
      child: provider.loading
          ? Column(
  children: List.generate(4, (_) => shimmerYurtCard()),
)

          : Column(
              children: [
                if (isAdmin)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
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
                        "لم يتم إضافة سكنات حتى الآن",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    itemCount: provider.items.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      final item = provider.items[index];

                      Widget card = YurtlarItemCard(
                        obj: item,
                        color: primaryColor,
                        iconData: Icons.home_work_rounded,
                        isAdmin: isAdmin,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => YurtDetailsScreen(
                                color: primaryColor,
                                obj: item,
                              ),
                            ),
                          );
                        },
                      );

                      // ===========================
                      // 🔥 الضغط المطوّل للمدير
                      // ===========================
                      if (isAdmin) {
                        card = GestureDetector(
                          onLongPress: () async {
                            final action = await _showAdminActions();

                            if (action == "edit") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditYurtScreen(item: item),
                                ),
                              );
                            } else if (action == "delete") {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("حذف السكن"),
                                  content: const Text(
                                      "هل أنت متأكد من حذف هذا السكن؟"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: const Text("إلغاء"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, true),
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
                            }
                          },
                          child: card,
                        );
                      }

                      return card;
                    },
                  ),
              ],
            ),
    );
  }
}
