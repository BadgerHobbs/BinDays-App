// External Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that listens for keyboard events and triggers back navigation
/// when the Escape key is pressed, specifically intended for desktop debug builds.
class DesktopNavigationListener extends StatelessWidget {
  const DesktopNavigationListener({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      canRequestFocus: true,
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event is KeyUpEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          final navigatorState = navigatorKey.currentState;

          if (navigatorState != null && navigatorState.canPop()) {
            navigatorState.pop();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: child,
    );
  }
}
