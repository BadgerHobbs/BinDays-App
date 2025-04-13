// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/pages/setup/collectors/select_collector_page.dart';
import 'package:bindays_app/widgets/secondary_button.dart';

class CollectorNotFoundPage extends StatelessWidget {
  final String postcode;

  const CollectorNotFoundPage({super.key, required this.postcode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(25),
        child: Column(
          children: [
            const Spacer(),
            Image.asset('assets/illustrations/Navigation_Two_Color.png'),
            const SizedBox(height: 50),
            const Column(
              children: [
                Text(
                  "Uh oh!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(68, 68, 68, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "We couldn't automatically detect your collector. This might be because your collector is not yet supported, or there was an issue with our service. Please select your collector manually, or try again later.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(68, 68, 68, 1),
                  ),
                ),
              ],
            ),
            const Spacer(),
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
                SecondaryButton(
                  text: "Select Collector Manually",
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SelectCollectorPage(postcode: postcode),
                      ),
                    );
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
