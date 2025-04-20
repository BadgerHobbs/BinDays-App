// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/secondary_button.dart';

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
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(flex: 1),
          Column(
            children: [
              // TODO: Add URL Link on click
              Text(
                "Send feedback or report an issue.",
                style: TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
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
