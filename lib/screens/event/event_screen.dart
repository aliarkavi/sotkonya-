import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/event_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/layouts/base_page_layout.dart';
import '../../model/EventsDetailsScreen.dart';
import 'widgets/event_item_card.dart';
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
      final provider = Provider.of<EventProvider>(context, listen: false);
      if (provider.events.isEmpty && !provider.loading) {
        provider.fetchEvents();
      }
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final isAdmin = Provider.of<AuthProvider>(context).isAdmin;

    return BasePageLayout(
      title: "الفعاليات",
      child: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (isAdmin)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
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
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.events.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 15),
                  itemBuilder: (_, index) {
                    final event = provider.events[index];
                    return EventItemCard(
                      title: event.title,
                      date: event.dateString,
                      time: event.formattedTime,
                      location: event.location,
                      iconData: Icons.event,
                      color: Colors.orange,
                      isAdmin: isAdmin,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventDetailsScreen(event: event),
                          ),
                        );
                      },
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditEventScreen(event: event),
                          ),
                        );
                      },
                      onDelete: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("حذف الفعالية"),
                            content: const Text(
                              "هل أنت متأكد من حذف هذه الفعالية؟ لا يمكن التراجع بعد الحذف.",
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
                          await provider.deleteEvent(event.id);
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

