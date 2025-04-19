// External Imports
import 'package:bindays_client/models/collector.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/pages/setup/addresses/finding_addresses_page.dart';
import 'package:bindays_app/pages/setup/collectors/select_collector_page.dart';
import 'package:bindays_app/widgets/primary_button.dart';
import 'package:bindays_app/widgets/secondary_button.dart';

class ConfirmCollectorPage extends StatelessWidget {
  final Collector collector;
  final String postcode;

  const ConfirmCollectorPage({
    super.key,
    required this.collector,
    required this.postcode,
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
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => FindingAddressesPage(
                            postcode: postcode,
                            collector: collector,
                          ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              SecondaryButton(
                text: "Select Another Collector",
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
    );
  }
}
