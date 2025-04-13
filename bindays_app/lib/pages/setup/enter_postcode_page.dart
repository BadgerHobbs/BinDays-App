// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/pages/setup/collectors/finding_collector_page.dart';
import 'package:bindays_app/widgets/primary_button.dart';
import 'package:bindays_app/widgets/text_input.dart';

class EnterPostcodePage extends StatefulWidget {
  const EnterPostcodePage({super.key});

  @override
  State<EnterPostcodePage> createState() => _EnterPostcodePageState();
}

class _EnterPostcodePageState extends State<EnterPostcodePage> {
  final _postcodeController = TextEditingController();

  @override
  void dispose() {
    _postcodeController.dispose();
    super.dispose();
  }

  void _submitPostcode() async {
    final postcode = _postcodeController.text.trim().toUpperCase();
    if (postcode.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FindingCollectorPage(postcode: postcode),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/illustrations/Map_Two_Color.png'),
              const SizedBox(height: 50),
              const Text(
                "Help us find your collector",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(68, 68, 68, 1),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Please provide your postcode to identify your local bin collector.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(68, 68, 68, 1),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              TextInput(
                controller: _postcodeController,
                hintText: 'e.g. SW1A 0AA',
              ),
              const SizedBox(height: 30),
              PrimaryButton(text: "Find Schedule", onPressed: _submitPostcode),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
