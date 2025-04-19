// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/setup_manager.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/primary_button.dart';
import 'package:bindays_app/widgets/secondary_button.dart';

class ConfirmCollectorPage extends StatelessWidget {
  const ConfirmCollectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final collector = setupManager.collector!;

    return SafeBasePage(
      child: Column(
        children: [
          const Spacer(flex: 1),
          Flexible(
            flex: 2,
            child: Image.asset('assets/illustrations/Navigation_Two_Color.png'),
          ),
          const SizedBox(height: 50),
          Column(
            children: [
              Text(
                collector.name,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(68, 68, 68, 1),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Your collector was identified as ${collector.name}. If incorrect, please select another supported collector.",
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(68, 68, 68, 1),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const Spacer(flex: 1),
          Column(
            children: [
              PrimaryButton(
                text: "Continue",
                onPressed: () => navigateToFindingAddressesPage(context),
              ),
              const SizedBox(height: 10),
              SecondaryButton(
                text: "Select Another Collector",
                onPressed: () => navigateToSelectCollectorPage(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
