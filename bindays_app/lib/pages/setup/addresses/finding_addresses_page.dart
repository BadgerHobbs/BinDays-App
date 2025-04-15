// External Imports
import 'package:bindays_client/models/collector.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/client/bindays_client.dart';
import 'package:bindays_app/pages/setup/addresses/addresses_not_found_page.dart';
import 'package:bindays_app/pages/setup/addresses/select_address_page.dart';
import 'package:bindays_app/widgets/animated_ellipsis.dart';

class FindingAddressesPage extends StatefulWidget {
  final String postcode;
  final Collector collector;

  const FindingAddressesPage({
    super.key,
    required this.postcode,
    required this.collector,
  });

  @override
  State<FindingAddressesPage> createState() => _FindingAddressesPage();
}

class _FindingAddressesPage extends State<FindingAddressesPage> {
  @override
  void initState() {
    super.initState();
    _getAddresses(widget.postcode, widget.collector);
  }

  Future<void> _getAddresses(String postcode, Collector collector) async {
    try {
      final addresses = await binDaysClient.getAddresses(collector, postcode);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder:
                (context, animation1, animation2) => SelectAddressPage(
                  collector: collector,
                  postcode: postcode,
                  addresses: addresses,
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
                (context, animation1, animation2) => AddressesNotFoundPage(
                  postcode: postcode,
                  collector: collector,
                ),
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
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Finding Addresss",
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
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(68, 68, 68, 1),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Please wait while we check for addresses under your collector and postcode. This may take a few seconds.",
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
