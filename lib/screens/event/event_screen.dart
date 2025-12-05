import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sotkonya/model/event_model.dart';
import 'package:sotkonya/providers/event_provider.dart';
import 'package:sotkonya/providers/auth_provider.dart';

import 'package:sotkonya/widgets/layouts/base_page_layout.dart';
import 'package:sotkonya/screens/event/widgets/event_details_screen.dart';
import 'package:sotkonya/screens/event/widgets/event_item_card.dart';
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

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final isAdmin = Provider.of<AuthProvider>(context).isAdmin;

    const primaryColor = Color(0xFFf2b200);

    return BasePageLayout(
      title: "الفعاليات",
      child: eventProvider.loading
          ? const Center(child: CircularProgressIndicator())
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

                      if (isAdmin) {
                        card = GestureDetector(
                          onLongPress: () async {
                            final action = await showDialog<String>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("إدارة الفعالية"),
                                content: const Text(
                                  "ماذا تريد أن تفعل بهذه الفعالية؟",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop('edit'),
                                    child: const Text("تعديل"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop('delete'),
                                    child: const Text(
                                      "حذف",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(null),
                                    child: const Text("إلغاء"),
                                  ),
                                ],
                              ),
                            );

                            if (!mounted) return;

                            if (action == 'edit') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditEventScreen(event: event),
                                ),
                              );
                            } else if (action == 'delete') {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("حذف الفعالية"),
                                  content: const Text(
                                      "هل أنت متأكد من حذف هذه الفعالية؟"),
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
                                await Provider.of<EventProvider>(context,
                                        listen: false)
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

