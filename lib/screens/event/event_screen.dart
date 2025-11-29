import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/event_provider.dart';
import '../../widgets/layouts/base_page_layout.dart';
import '../../model/EventsDetailsScreen.dart';
import 'widgets/event_item_card.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);

    return BasePageLayout(
      title: "الفعاليات",
      child: provider.loading
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailsScreen(event: event),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
