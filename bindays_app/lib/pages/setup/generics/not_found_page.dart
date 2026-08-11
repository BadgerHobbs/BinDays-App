// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/pages/safe_base_page.dart';

class NotFoundPage extends StatelessWidget {
  final String headline;
  final String message;
  final Widget button;
  final Widget? extraButton;
  final bool showTroubleshootingLink;

  /// Widget shown above [button] in place of the troubleshooting link, e.g.
  /// a feedback link. When set, [showTroubleshootingLink] is ignored.
  final Widget? topLink;

  const NotFoundPage({
    super.key,
    this.headline = "Uh oh!",
    required this.message,
    required this.button,
    this.extraButton,
    this.showTroubleshootingLink = true,
    this.topLink,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeBasePage(
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
                if (topLink != null) ...[
                  topLink!,
                  const SizedBox(height: 10),
                ] else if (showTroubleshootingLink) ...[
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
                ],
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
