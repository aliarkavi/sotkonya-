// lib/screens/news/widgets/news_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sotkonya/model/news_model.dart';
import 'package:sotkonya/widgets/details_container.dart';
import 'package:sotkonya/widgets/details_item_card.dart';
import 'package:sotkonya/widgets/layouts/details_page_layout.dart';
import 'package:sotkonya/widgets/promo_slider.dart';
import 'package:sotkonya/widgets/sub_title_container.dart';
import 'package:sotkonya/l10n/app_localizations.dart';

// ✅ NEW: clickable links widget
import 'package:sotkonya/widgets/content_widget.dart';

class NewsDetailsScreen extends ConsumerWidget {
  const NewsDetailsScreen({
    super.key,
    required this.color,
    required this.obj,
  });

  final Color color;
  final NewsModel obj;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final dateString =
    "${obj.newsDate.day}/${obj.newsDate.month}/${obj.newsDate.year}";


    // لو ما في images نستخدم imageUrl كرابط واحد
    final images = obj.images.isNotEmpty
        ? obj.images
        : (obj.imageUrl.isNotEmpty ? [obj.imageUrl] : <String>[]);

    return DetailsPageLayout(
      title: l10n.eventDetails,
      child: Column(
        children: [
          DetailsItemCard(
            padding: 0,
            color: color,
            child: Column(
              children: [
                if (images.isNotEmpty) PromoSlider(items: images, color: color),
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





