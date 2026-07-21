import 'package:flutter/material.dart';

class DetailsItemCard extends StatelessWidget {
  const DetailsItemCard({
    super.key,
    required this.color,
    this.child,
    this.icon,
    this.title,
    this.subtitle,
    this.onTap,
    this.padding = 16,
  });

  final Color color;
  final Widget? child;
  final IconData? icon;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(top: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: child ??
              Row(
                children: [
                   if (icon != null) ...[
                    Icon(icon, color: color, size: 28),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null)
                          Text(
                            title!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (onTap != null)
                    Icon(Icons.arrow_forward_ios,
                        size: 14, color: Colors.grey[400]),
                ],
              ),
        ),
      ),
    );
  }
}





