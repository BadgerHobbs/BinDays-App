// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/client/bindays_client.dart';
import 'package:bindays_app/pages/setup/collectors/confirm_collector_page.dart';
import 'package:bindays_app/pages/setup/collectors/collector_not_found_page.dart';
import 'package:bindays_app/widgets/animated_ellipsis.dart';

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
      await Future.delayed(const Duration(seconds: 3));
      final collector = await binDaysClient.getCollector(postcode);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder:
                (context, animation1, animation2) =>
                    ConfirmCollectorPage(collector: collector),
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
                (context, animation1, animation2) => CollectorNotFoundPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/illustrations/Navigation_Two_Color.png'),
            const SizedBox(height: 50),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Finding Your Collector",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(68, 68, 68, 1),
                      ),
                    ),
                  ],
                ),
                AnimatedEllipsis(
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(68, 68, 68, 1),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Please wait while we check which bin collector serves your area. This may take a few seconds.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(68, 68, 68, 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
