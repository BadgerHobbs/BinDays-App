// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/pages/setup/enter_postcode_page.dart';
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
            const Text(
              "How it works",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(68, 68, 68, 1),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "BinDays provides free bin collection information from your local council's website. We strive for accuracy, but data reliability depends on the council's website content.\n\nThis app is maintained at cost. We cannot guarantee continued availability of all council data.\n\nBy proceeding, you acknowledge this disclaimer.",
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(68, 68, 68, 1),
              ),
              textAlign: TextAlign.left,
            ),
            const Spacer(flex: 1),
            PrimaryButton(
              text: "Continue",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EnterPostcodePage()),
                );
              },
            ),
          ],
        ),
    );
  }
}
