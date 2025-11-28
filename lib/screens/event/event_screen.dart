import 'package:flutter/material.dart';

import '../../widgets/layouts/base_page_layout.dart';
import 'widgets/event_item_card.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePageLayout(
      title: "الفعاليات",
      child: Column(
        children: [
          ListView.separated(
            itemCount: 6,
            shrinkWrap: true,
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return EventItemCard(
                title: "عنوان الفعالية رقم ${index + 1}",
                date: "12 يونيو 2024",
                time: "10:00 صباحاً",
                location: "الموقع هنا",
                iconData: Icons.article,
                color: Color(0xFFf2b200),

                onTap: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}
