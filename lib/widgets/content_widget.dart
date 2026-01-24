import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentWidget extends StatelessWidget {
  final String text;

  const ContentWidget({
    super.key,
    required this.text,
  });

  Future<void> _onOpen(LinkableElement link) async {
    final url = _normalizeUrl(link.url);
    final uri = Uri.parse(url);

    final ok = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // يفتح Instagram / YouTube
    );

    if (!ok) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  String _normalizeUrl(String url) {
    final u = url.trim();
    if (u.startsWith('http://') || u.startsWith('https://')) {
      return u;
    }
    return 'https://$u';
  }

  @override
  Widget build(BuildContext context) {
    return Linkify(
      text: text,
      onOpen: _onOpen,
      style: const TextStyle(
        fontSize: 15,
        height: 1.7,
        color: Colors.black87,
      ),
      linkStyle: const TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
