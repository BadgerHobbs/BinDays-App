// External Imports
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UrlLink extends StatelessWidget {
  final String text;
  final String url;

  const UrlLink({super.key, required this.text, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrlString(url),
      child: Text(
        text,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
          decoration: TextDecoration.underline,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
