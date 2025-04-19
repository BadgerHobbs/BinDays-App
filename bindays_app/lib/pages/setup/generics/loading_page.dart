// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/animated_ellipsis.dart';

class LoadingPage extends StatelessWidget {
  final String titleText;
  final String descriptionText;

  const LoadingPage({
    super.key,
    required this.titleText,
    required this.descriptionText,
  });

  @override
  Widget build(BuildContext context) {
    return SafeBasePage(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 2,
            child: Image.asset('assets/illustrations/Navigation_Two_Color.png'),
          ),
          const SizedBox(height: 50),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                titleText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(68, 68, 68, 1),
                ),
              ),
              const AnimatedEllipsis(
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(68, 68, 68, 1),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                descriptionText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(68, 68, 68, 1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
