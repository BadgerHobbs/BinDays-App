// External Imports
import 'dart:io';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/primary_button.dart';
import 'package:bindays_app/widgets/url_link.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeBasePage(
      child: Column(
        children: [
          const Spacer(flex: 1),
          Flexible(
            flex: 2,
            child: Image.asset(
              'assets/illustrations/Recycling_Monochromatic.png',
            ),
          ),
          const SizedBox(height: 50),
          Text(
            "Welcome to BinDays",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            "Join our UK community in recieving the latest information on your local bin collection services.",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 1),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Flexible(
                    child: UrlLink(
                      text: "Privacy Policy",
                      url: "https://bindays.app/privacy-policy.html",
                    ),
                  ),
                  Flexible(
                    child: UrlLink(
                      text: "Terms & Conditions",
                      url:
                          Platform.isIOS
                              ? "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
                              : "https://bindays.app/terms-and-conditions.html",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              PrimaryButton(
                text: "Get Started",
                onPressed: () => navigateToHowItWorksPage(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
