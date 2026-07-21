import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sotkonya/providers/riverpod_providers.dart';

import 'package:sotkonya/l10n/app_localizations.dart';

import 'package:sotkonya/widgets/layouts/base_page_layout.dart';
import 'package:sotkonya/widgets/shimmer_widgets.dart';
import 'package:sotkonya/screens/event/widgets/event_item_card.dart';
import 'package:sotkonya/screens/event/widgets/event_details_screen.dart';
import 'package:sotkonya/screens/event/add_event_screen.dart';
import 'package:sotkonya/screens/event/edit_event_screen.dart';

class EventScreen extends ConsumerStatefulWidget {
  const EventScreen({super.key});

  @override
  ConsumerState<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends ConsumerState<EventScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = ref.read(eventProvider);
      if (state.events.isEmpty && !state.loading) {
        ref.read(eventProvider).fetchEvents();
      }
    });
  }

  void showEventActions(BuildContext context, dynamic item) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: Text(l10n.editEvent),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditEventScreen(event: item),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(l10n.deleteEvent, style: const TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l10n.deleteEvent),
                    content: Text(l10n.deleteConfirmMessage),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text(l10n.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await ref.read(eventProvider).deleteEvent(item.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(eventProvider);
    final auth = ref.watch(authProvider);
    final isAdmin = auth.isAdmin;

    final l10n = AppLocalizations.of(context)!;

    return BasePageLayout(
      title: l10n.events,
      child: state.loading
          ? const ShimmerEventList()
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
                          MaterialPageRoute(builder: (_) => const AddEventScreen()),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                       label: Text(
                        l10n.addEvent,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                if (state.events.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        l10n.noEventsYet,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    itemCount: state.events.length,
                    shrinkWrap: true,
                    separatorBuilder: (_, __) => const SizedBox(height: 15),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = state.events[index];
                      return GestureDetector(
                        onLongPress: isAdmin ? () => showEventActions(context, item) : null,
                        child: EventItemCard(
                          obj: item,
                          color: Colors.orange,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EventDetailsScreen(
                                  obj: item,
                                  color: Colors.orange,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
              ],
            ),
    );
  }
}





