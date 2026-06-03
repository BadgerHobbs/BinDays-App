// External Imports
import 'dart:io';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/setup_state.dart';
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/url_link.dart';

class NotFoundPage extends StatelessWidget {
  final String headline;
  final String message;
  final Widget button;
  final Widget? extraButton;

  const NotFoundPage({
    super.key,
    this.headline = "Uh oh!",
    required this.message,
    required this.button,
    this.extraButton,
  });

  String _getEmailUrl() {
    var subject = "BinDays Feedback";
    if (Platform.isIOS) {
      subject += " (iOS)";
    } else if (Platform.isAndroid) {
      subject += " (Android)";
    }
    final postcode = setupState.postcode ?? "Not set";
    final body =
        "[Please describe your issue or feedback here]\n\n---\n\nPostcode: $postcode";
    return "mailto:contact@bindays.app?subject=$subject&body=${Uri.encodeComponent(body)}";
  }

  @override
  Widget build(BuildContext context) {
    return SafeBasePage(
      child: Column(
        children: [
          const Spacer(flex: 1),
          Flexible(
            flex: 2,
            child: Image.asset('assets/illustrations/Navigation_Two_Color.png'),
          ),
          const SizedBox(height: 25),
          Text(
            headline,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              message,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const Spacer(flex: 1),
          Column(
            children: [
              UrlLink(
                text: "Send feedback to contact@bindays.app",
                url: _getEmailUrl(),
              ),
              const SizedBox(height: 10),
              button,
              if (extraButton != null) ...[
                const SizedBox(height: 10),
                extraButton!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}
