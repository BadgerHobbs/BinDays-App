// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/setup_state.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/primary_button.dart';
import 'package:bindays_app/widgets/text_input.dart';

class EnterPostcodePage extends StatefulWidget {
  const EnterPostcodePage({super.key});

  @override
  State<EnterPostcodePage> createState() => _EnterPostcodePageState();
}

class _EnterPostcodePageState extends State<EnterPostcodePage> {
  final _postcodeController = TextEditingController();
  String _postcode = "";

  @override
  void initState() {
    super.initState();
    _postcodeController.addListener(() {
      setState(() {
        _postcode = _getPostcode();
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _postcodeController.dispose();
    super.dispose();
  }

  void _submitPostcode() async {
    if (_postcode.isNotEmpty) {
      setupState.postcode = _postcode;
      if (mounted) navigateToFindingCollectorPage(context);
    }
  }

  String _getPostcode() {
    return _postcodeController.text.trim().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeBasePage(
      child: Column(
        children: [
          const Spacer(flex: 1),
          Flexible(
            flex: 2,
            child: Image.asset('assets/illustrations/Map_Two_Color.png'),
          ),
          const SizedBox(height: 50),
          Text(
            "Help us find your collector",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            "Please provide your postcode so we can find your local bin collector.",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          TextInput(
            controller: _postcodeController,
            textCapitalization: TextCapitalization.characters,
            hintText: 'e.g. SW1A 0AA',
          ),
          const Spacer(flex: 1),
          if (_postcode.isNotEmpty)
            PrimaryButton(text: "Find Collector", onPressed: _submitPostcode),
        ],
      ),
    );
  }
}
