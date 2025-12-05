import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sotkonya/model/event_model.dart';
import 'package:sotkonya/providers/event_provider.dart';
import 'package:sotkonya/providers/auth_provider.dart';

import 'package:sotkonya/widgets/layouts/base_page_layout.dart';
import 'package:sotkonya/screens/event/widgets/event_details_screen.dart';
import 'package:sotkonya/screens/event/widgets/event_item_card.dart';
import 'package:sotkonya/widgets/shimmer_widgets.dart';
import 'add_event_screen.dart';
import 'edit_event_screen.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      if (eventProvider.events.isEmpty && !eventProvider.loading) {
        eventProvider.fetchEvents();
      }
      _initialized = true;
    }
  }

  // ============================
  //   UI جديد لقائمة الإدارة
  // ============================
  Future<String?> showEventActions(BuildContext context) {
    const primaryColor = Color(0xFFf2b200);

    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
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
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.edit, color: primaryColor),
                      SizedBox(width: 12),
                      Text(
                        "تعديل الفعالية",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE5E5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 12),
                      Text(
                        "حذف الفعالية",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
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
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.close, color: Colors.grey),
                      SizedBox(width: 12),
                      Text(
                        "إلغاء",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
    final eventProvider = Provider.of<EventProvider>(context);
    final isAdmin = Provider.of<AuthProvider>(context).isAdmin;

    const primaryColor = Color(0xFFf2b200);

    return BasePageLayout(
      title: "الفعاليات",
      child: eventProvider.loading
          ? Column(
  children: List.generate(4, (_) => shimmerEventCard()),
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
                            builder: (_) => const AddEventScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "إضافة فعالية جديدة",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                if (eventProvider.events.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "لا توجد فعاليات حالياً.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: eventProvider.events.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      final EventModel event = eventProvider.events[index];

                      Widget card = EventItemCard(
                        obj: event,
                        color: primaryColor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EventDetailsScreen(
                                color: primaryColor,
                                obj: event,
                              ),
                            ),
                          );
                        },
                      );

                      // ============ UI الضغط المطول ============
                      if (isAdmin) {
                        card = GestureDetector(
                          onLongPress: () async {
                            final action = await showEventActions(context);

                            if (!mounted) return;

                            if (action == 'edit') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditEventScreen(event: event),
                                ),
                              );
                            } else if (action == 'delete') {

                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("حذف الفعالية"),
                                  content: const Text("هل أنت متأكد من حذف هذه الفعالية؟"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(false),
                                      child: const Text("إلغاء"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(true),
                                      child: const Text(
                                        "حذف",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await Provider.of<EventProvider>(context, listen: false)
                                    .deleteEvent(event.id);
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
