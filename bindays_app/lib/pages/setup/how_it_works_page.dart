// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/primary_button.dart';

class HowItWorksPage extends StatelessWidget {
  const HowItWorksPage({super.key});

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
          const SizedBox(height: 50),
          Text(
            "How it works",
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
              "BinDays finds your bin collection dates by checking your council's website.\n\nWe keep the app up to date, but the information comes directly from the council and can change without warning.\n\nBinDays is run at cost as a community project, so we can't promise every council will always be supported.\n\nSelect Continue if you're happy to proceed.",
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const Spacer(flex: 1),
          PrimaryButton(
            text: "Continue",
            onPressed: () => navigateToEnterPostcodePage(context),
          ),
        ],
      ),
    );
  }
}
