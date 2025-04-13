// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/pages/setup/how_it_works_page.dart';
import 'package:bindays_app/widgets/primary_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(25),
        child: Column(
          children: [
            Spacer(),
            Column(
              children: [
                Image.asset('assets/illustrations/Recycling_Monochromatic.png'),
                SizedBox(height: 50),
                Text(
                  "Welcome to BinDays",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(68, 68, 68, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Join our UK community in recieving the latest information on your local bin collection services.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromRGBO(68, 68, 68, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Spacer(),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // TODO: Add URL Link on click
                    Text(
                      "Privacy Policy",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(68, 68, 68, 0.75),
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // TODO: Add URL Link on click
                    Text(
                      "Terms & Conditions",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(68, 68, 68, 0.75),
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                PrimaryButton(
                  text: "Get Started",
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => HowItWorksPage()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
