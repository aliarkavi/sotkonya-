import 'package:flutter/material.dart';

import '../../../widgets/item_card.dart';

class EventItemCard extends StatelessWidget {
  const EventItemCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.iconData,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String date, time, location;
  final IconData iconData;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ItemCard(
      color: color,
      onTap: onTap,
      child: Padding(
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
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.date_range, color: color),
                          SizedBox(width: 4),
                          Text(date),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.timer_sharp, color: color),
                          SizedBox(width: 4),
                          Text(time),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on_outlined, color: color),
                          SizedBox(width: 4),
                          Text(location),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),

                Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/img/BG.png'),
                      fit: BoxFit.fill,
                    ),
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "",
                  ), // Icon(iconData, color: Colors.white, size: 20)
                ),
              ],
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: color,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  minimumSize: Size(50, 20),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  // alignment: Alignment.centerLeft,
                ),
                onPressed: () {},
                child: Text(
                  "عرض التفاصيل والتسجيل",
                  style: TextStyle(
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
    );
  }
}
