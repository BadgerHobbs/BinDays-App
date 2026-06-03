// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/misc/navigators.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Spacer(flex: 1),
            Flexible(
              flex: 2,
              child: Image.asset(
                'assets/illustrations/Navigation_Two_Color.png',
              ),
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
                GestureDetector(
                  onTap: () => navigateToTroubleshootingPage(context),
                  child: Text(
                    "Having trouble? Visit our Troubleshooting page.",
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize,
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
      ),
    );
  }
}
