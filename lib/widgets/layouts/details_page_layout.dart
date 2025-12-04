import 'package:flutter/material.dart';

class DetailsPageLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const DetailsPageLayout({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(title), centerTitle: true),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 15.0,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
