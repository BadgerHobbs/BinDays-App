// External Imports
import 'dart:io';
import 'package:bindays_app/widgets/url_link.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Internal Imports
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/primary_button.dart';
import 'package:bindays_app/widgets/secondary_button.dart';

class RequestCouncilPage extends StatelessWidget {
  const RequestCouncilPage({super.key});

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
            child: Image.asset(
              'assets/illustrations/Construction_Worker_Two_Color.png',
            ),
          ),
          const SizedBox(height: 25),
          Text(
            "Request Council Support",
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
              "Thank you for your interest in adding your council to BinDays.\n\nYou can provide your council details using either the GitHub issue or Google Form below.\n\nPlease note, as a free, open-source project, new councils are added on a voluntary basis, so there are no guaranteed timelines.\n\nCode contributions are also always welcome!",
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
              PrimaryButton(
                text: "Request via GitHub",
                onPressed:
                    () => launchUrlString(
                      "https://github.com/BadgerHobbs/BinDays-API/issues/new?template=council-request.md",
                    ),
              ),
              const SizedBox(height: 10),
              SecondaryButton(
                text: "Request via Google Form",
                onPressed:
                    () =>
                        launchUrlString("https://forms.gle/vsr7rRadBDYDCRaT9"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
