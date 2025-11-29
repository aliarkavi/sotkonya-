// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/event_item.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventItem event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("تفاصيل الفعالية")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // صورة الفعالية
            if (event.imageUrl != null && event.imageUrl.isNotEmpty)
              Image.network(
                event.imageUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22)),

                  SizedBox(height: 10),
                  Text("التاريخ: ${event.dateString}"),
                  Text("الوقت: ${event.title}"),
                  Text("الموقع: ${event.location}"),

                  SizedBox(height: 25),

                  // زر التسجيل
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        launchUrl(Uri.parse(event.registerUrl));
                      },
                      child: Text("التسجيل الآن"),
                    ),
                  ),

                  SizedBox(height: 10),

                  // زر الموقع
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                      //  launchUrl(Uri.parse(event.mapUrl));
                      },
                      child: Text("عرض الموقع على الخريطة"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
