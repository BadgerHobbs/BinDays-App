// External Imports
import 'package:bindays_client/models/collector.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/pages/setup/enter_postcode_page.dart';
import 'package:bindays_app/widgets/secondary_button.dart';

class AddressesNotFoundPage extends StatelessWidget {
  final String postcode;
  final Collector collector;

  const AddressesNotFoundPage({
    super.key,
    required this.postcode,
    required this.collector,
  });

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
            Column(
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
                  "We couldn't find any addresses for postcode '${postcode.toUpperCase()}' associated with the collector '${collector.name}'. This might mean the postcode is incorrect, the collector doesn't cover this specific postcode, or there's an issue with the address data. Please try a different postcode or collector.",
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
                  text: "Retry",
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => EnterPostcodePage()),
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
