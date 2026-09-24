// lib/screens/yurt/yurtlar_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sotkonya/providers/riverpod_providers.dart';
import 'package:sotkonya/widgets/shimmer_widgets.dart';

import 'package:sotkonya/widgets/layouts/base_page_layout.dart';
import 'package:sotkonya/screens/yurtlar/widgets/yurtlar_item_card.dart';
import 'package:sotkonya/screens/yurtlar/widgets/yurt_details_screen.dart';
import 'package:sotkonya/screens/yurtlar/add_yurt_screen.dart';
import 'package:sotkonya/screens/yurtlar/edit_yurt_screen.dart';
import 'package:sotkonya/l10n/app_localizations.dart';

class YurtlarScreen extends ConsumerStatefulWidget {
  const YurtlarScreen({super.key});

  @override
  ConsumerState<YurtlarScreen> createState() => _YurtlarScreenState();
}

class _YurtlarScreenState extends ConsumerState<YurtlarScreen> {
  static const Color primaryColor = Color(0xFFeb5623);

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    _initialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final yurtState = ref.read(yurtProvider);
      if (yurtState.items.isEmpty && !yurtState.loading) {
        ref.read(yurtProvider).fetchYurtlar();
      }
    });
  }

  // ================================
  // 🔥 BottomSheet الخاص بالإجراءات
  // ================================
  Future<String?> _showAdminActions() {
    final l10n = AppLocalizations.of(context)!;
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
                    children: [
                      const Icon(Icons.edit, color: primaryColor),
                      const SizedBox(width: 12),
                      Text(
                        l10n.editHousing,
                        style: const TextStyle(
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
                    children: [
                      const Icon(Icons.delete, color: Colors.red),
                      const SizedBox(width: 12),
                      Text(
                        l10n.deleteHousing,
                        style: const TextStyle(
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
                    children: [
                      const Icon(Icons.close, color: Colors.grey),
                      const SizedBox(width: 12),
                      Text(
                        l10n.cancel,
                        style: const TextStyle(
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
    final yurtState = ref.watch(yurtProvider);
    final isAdmin = ref.watch(authProvider).isAdmin;

    final l10n = AppLocalizations.of(context)!;

    return BasePageLayout(
      title: l10n.housing,
      child: yurtState.loading
          ? const ShimmerYurtList()
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
                      label: Text(
                        l10n.addHousing,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                if (yurtState.items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        l10n.noHousingYet,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    itemCount: yurtState.items.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, _) => const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      final item = yurtState.items[index];

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
                              if (!mounted) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditYurtScreen(item: item),
                                ),
                              );
                            } else if (action == "delete") {
                              if (!mounted) return;
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(l10n.deleteHousing),
                                  content: Text(l10n.deleteConfirmMessage),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: Text(l10n.cancel),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, true),
                                      child: Text(
                                        l10n.delete,
                                        style: const TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await ref
                                    .read(yurtProvider.notifier)
                                    .deleteYurt(item.id);
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





