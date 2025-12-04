import 'package:flutter/material.dart';

class ContactInformation extends StatelessWidget {
  const ContactInformation({
    super.key,
    required this.color,
    required this.icon,
    required this.data,
  });

  final Color color;
  final String data;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color),
          SizedBox(width: 20),

          Expanded(
            child: Text(
              data,
              maxLines: 1,
              style: TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
