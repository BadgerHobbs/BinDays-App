// External Imports
import 'package:flutter/material.dart';

/// A base page that provides a safe area for the child widget.
///
/// This widget is used to ensure that the child widget is not obscured by
/// system UI elements such as the status bar or the navigation bar.
class SafeBasePage extends StatelessWidget {
  final Widget child;

  const SafeBasePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(minimum: const EdgeInsets.all(16), child: child),
    );
  }
}
