import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sotkonya/model/event_model.dart';
import 'package:sotkonya/widgets/item_card.dart';
import 'package:sotkonya/l10n/app_localizations.dart';

class EventItemCard extends ConsumerWidget {
  const EventItemCard({
    super.key,
    required this.obj,
    required this.color,
    required this.onTap,
  });

  final Color color;
  final VoidCallback onTap;
  final EventModel obj;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ImageProvider? imageProvider;

    if (obj.images.isNotEmpty) {
      final first = obj.images.first;
      if (first.startsWith('http')) {
        imageProvider = NetworkImage(first);
      } else {
        imageProvider = AssetImage(first);
      }
    } else if (obj.imageUrl != null && obj.imageUrl!.isNotEmpty) {
      final first = obj.imageUrl!;
      if (first.startsWith('http')) {
        imageProvider = NetworkImage(first);
      } else {
        imageProvider = AssetImage(first);
      }
    }

    return ItemCard(
      color: color,
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        
      child: Stack(
        children: [

          /// 🔹 محتوى الكارد
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            obj.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.date_range, color: color),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  obj.date,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.timer_sharp, color: color),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  obj.time,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on_outlined, color: color),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  obj.konum,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 100,
                      height: 100,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        image: imageProvider != null
                            ? DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              )
                            : null,
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: color,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      minimumSize: const Size(50, 20),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: onTap,
                    child: Text(
                      AppLocalizations.of(context)!.viewDetailsAndRegister,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// 🔹 شارة الحالة في أعلى يسار الكارد
        /*  Positioned(
            top: -3,
            left: 8,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                obj.durum,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),*/
        ],
      ),
    ));
  }
}





