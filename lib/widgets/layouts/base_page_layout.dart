import 'package:flutter/material.dart';

class BasePageLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const BasePageLayout({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
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
    );
  }
}
