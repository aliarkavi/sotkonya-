import 'package:flutter/material.dart';

import '../../../widgets/item_card.dart';

class YurtlarItemCard extends StatelessWidget {
  const YurtlarItemCard({
    super.key,
    required this.title,
    required this.durum,
    required this.personelData,
    required this.rentData,
    required this.location,
    required this.iconData,
    required this.color,
    required this.onTap,
  });

  final String title, durum;
  final String personelData, rentData, location;
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(iconData, color: Colors.white, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Container(
                          // margin: EdgeInsets.only(left: 6),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            durum,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
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
                        SizedBox(width: 4),
                        Text(location),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.person_outline_sharp, color: color),
                        SizedBox(width: 4),
                        Text(personelData),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.attach_money_rounded, color: color),
                        SizedBox(width: 4),
                        Text(rentData),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: color,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      minimumSize: Size(50, 20),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // alignment: Alignment.centerLeft,
                    ),
                    onPressed: () {},
                    child: Text(
                      "تفاصيل السكن",
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
                SizedBox(width: 8),
                OutlinedButton(
                  style: IconButton.styleFrom(
                    // backgroundColor: color,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    minimumSize: Size(50, 20),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),

                  onPressed: () {},
                  child: Icon(Icons.location_on, color: Colors.black, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
