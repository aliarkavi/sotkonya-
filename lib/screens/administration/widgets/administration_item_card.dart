import 'package:flutter/material.dart';

import '../../../widgets/item_card.dart';

class AdministrationItemCard extends StatelessWidget {
  const AdministrationItemCard({
    super.key,
    required this.title,
    required this.job,
    required this.aboutHim,
    required this.iconData,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String job, aboutHim;
  final IconData iconData;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ItemCard(
      color: color,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "م ح",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(job, style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 8),
                    Text(aboutHim, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Spacer(),
                Expanded(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: color,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      minimumSize: Size(50, 20),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // alignment: Alignment.centerLeft,
                    ),
                    onPressed: () {},
                    icon: Icon(
                      Icons.email_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: Text(
                      "تواصل عبر البريد",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 8),
                OutlinedButton(
                  style: IconButton.styleFrom(
                    // backgroundColor: color,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    minimumSize: Size(50, 20),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),

                  onPressed: () {},
                  child: Icon(
                    Icons.phone_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
