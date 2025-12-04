import 'package:flutter/material.dart';

class DetailsItemCard extends StatelessWidget {
  const DetailsItemCard({
    super.key,
    required this.color,

    required this.child,
    this.padding = 16,
  });

  final Color color;

  final Widget child;
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

      child: Padding(padding: EdgeInsets.all(padding), child: child),
    );
  }
}
