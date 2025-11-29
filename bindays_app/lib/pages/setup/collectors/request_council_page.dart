// External Imports
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Internal Imports
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/primary_button.dart';
import 'package:bindays_app/widgets/secondary_button.dart';

class RequestCouncilPage extends StatelessWidget {
  const RequestCouncilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeBasePage(
      child: Column(
        children: [
          const Spacer(flex: 1),
          Flexible(
            flex: 2,
            child: Image.asset(
                'assets/illustrations/Construction_Worker_Two_Color.png'),
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
              "We are always working to add support for more councils. Please use the links below to request support for your council.\n\nPlease note that we can't guarantee a timeline for when your council will be supported, but we will do our best to add it as soon as possible.",
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
              PrimaryButton(
                text: "Request via GitHub",
                onPressed: () => launchUrlString(
                    "https://github.com/BadgerHobbs/BinDays-API/issues/new?template=council-request.md"),
              ),
              const SizedBox(height: 10),
              SecondaryButton(
                text: "Request via Google Form",
                onPressed: () =>
                    launchUrlString("https://forms.gle/vsr7rRadBDYDCRaT9"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
