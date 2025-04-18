// External Imports
import 'package:flutter/material.dart';

// Internal Imports
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
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(25),
        child: Column(
          children: [
            const Spacer(flex: 1),
            Flexible(
              flex: 2,
              child: Image.asset(
                'assets/illustrations/Navigation_Two_Color.png',
              ),
            ),
            const SizedBox(height: 50),
            Column(
              children: [
                const Text(
                  "Uh oh!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(68, 68, 68, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(68, 68, 68, 1),
                  ),
                ),
              ],
            ),
            const Spacer(flex: 1),
            Column(
              children: [
                // TODO: Add URL Link on click
                TextButton(
                  onPressed: () => {},
                  child: const Text(
                    "Send feedback or report an issue.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(68, 68, 68, 0.75),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SecondaryButton(text: buttonText, onPressed: buttonOnPressed),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
