// External Imports
import 'dart:io';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/secondary_button.dart';
import 'package:bindays_app/widgets/url_link.dart';

class NotFoundPage extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback buttonOnPressed;

  const NotFoundPage({
    super.key,
    required this.message,
    required this.buttonText,
    required this.buttonOnPressed,
  });

  String _getEmailUrl() {
    var emailUrl = "mailto:contact@bindays.app?subject=BinDays Feedback";
    if (Platform.isIOS) {
      emailUrl += " (iOS)";
    } else if (Platform.isAndroid) {
      emailUrl += " (Android)";
    }
    return emailUrl;
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
            "Uh oh!",
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
              textAlign: TextAlign.center,
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
              SecondaryButton(text: buttonText, onPressed: buttonOnPressed),
            ],
          ),
        ],
      ),
    );
  }
}
