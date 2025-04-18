// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/client/bindays_client.dart';
import 'package:bindays_app/pages/setup/collectors/confirm_collector_page.dart';
import 'package:bindays_app/pages/setup/collectors/collector_not_found_page.dart';
import 'package:bindays_app/pages/setup/loading_page.dart';

class FindingCollectorPage extends StatefulWidget {
  final String postcode;

  const FindingCollectorPage({super.key, required this.postcode});

  @override
  State<FindingCollectorPage> createState() => _FindingCollectorPage();
}

class _FindingCollectorPage extends State<FindingCollectorPage> {
  @override
  void initState() {
    super.initState();
    _getCollector(widget.postcode);
  }

  Future<void> _getCollector(String postcode) async {
    try {
      // Fake processing time so that users can see the loading animation
      await Future.delayed(const Duration(seconds: 2));
      final collector = await binDaysClient.getCollector(postcode);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder:
                (context, animation1, animation2) => ConfirmCollectorPage(
                  collector: collector,
                  postcode: postcode,
                ),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder:
                (context, animation1, animation2) =>
                    CollectorNotFoundPage(postcode: postcode),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const LoadingPage(
      titleText: "Finding Your Collector",
      descriptionText:
          "Please wait while we check which bin collector serves your area. This may take a few seconds.",
    );
  }
}
