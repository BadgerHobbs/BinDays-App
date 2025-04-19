// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/pages/setup/how_it_works_page.dart';
import 'package:bindays_app/widgets/primary_button.dart';

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
          const Text(
            "Welcome to BinDays",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(68, 68, 68, 1),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            "Join our UK community in recieving the latest information on your local bin collection services.",
            style: TextStyle(
              fontSize: 15,
              color: Color.fromRGBO(68, 68, 68, 1),
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 1),
          Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // TODO: Add URL Link on click
                  Flexible(
                    child: Text(
                      "Privacy Policy",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(68, 68, 68, 0.75),
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // TODO: Add URL Link on click
                  Flexible(
                    child: Text(
                      "Terms & Conditions",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(68, 68, 68, 0.75),
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              PrimaryButton(
                text: "Get Started",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HowItWorksPage()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
