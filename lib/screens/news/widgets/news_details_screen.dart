// lib/screens/news/widgets/news_details_screen.dart
import 'package:flutter/material.dart';

import '../../../model/news_model.dart';
import '../../../widgets/details_container.dart';
import '../../../widgets/details_item_card.dart';
import '../../../widgets/layouts/details_page_layout.dart';
import '../../../widgets/promo_slider.dart';
import '../../../widgets/sub_title_container.dart';

// ✅ NEW: clickable links widget
import '../../../widgets/content_widget.dart';

class NewsDetailsScreen extends StatelessWidget {
  const NewsDetailsScreen({
    super.key,
    required this.color,
    required this.obj,
  });

  final Color color;
  final NewsModel obj;

  @override
  Widget build(BuildContext context) {
    final dateString =
        "${obj.createdAt.day}/${obj.createdAt.month}/${obj.createdAt.year}";

    // لو ما في images نستخدم imageUrl كرابط واحد
    final images = obj.images.isNotEmpty
        ? obj.images
        : (obj.imageUrl.isNotEmpty ? [obj.imageUrl] : <String>[]);

    return DetailsPageLayout(
      title: "تفاصيل الخبر",
      child: Column(
        children: [
          DetailsItemCard(
            padding: 0,
            color: color,
            child: Column(
              children: [
                if (images.isNotEmpty) PromoSlider(images: images, color: color),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        obj.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.date_range_outlined,
                            color: color,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            dateString,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SubTitleContainer(color: color, subtitle: obj.subtitle),
          const SizedBox(height: 15),

          // ✅ هنا التعديل: بدل Text(obj.details) استخدم NewsContentWidget
          DetailsContainer(
            child: ContentWidget(
              text: obj.details,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
