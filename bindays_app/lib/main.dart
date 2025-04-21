// External Imports
import 'dart:io';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Internal Imports
import 'package:bindays_app/data/background_task_manager.dart';
import 'package:bindays_app/data/notifications_manager.dart';
import 'package:bindays_app/data/shared_preferences_manager.dart';
import 'package:bindays_app/pages/bin_days_page.dart';
import 'package:bindays_app/widgets/debug/desktop_navigation_listener.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/pages/setup/welcome_page.dart';

void main() async {
  // Ensure app is initialised
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise notifications manager
  await NotificationsManager.init();

  // Load shared preferences
  await SharedPreferencesManager.loadSharedPreferences();

  // Initialise background task manager
  BackgroundTaskManager.init();

  // Transparent navigation bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
  );

  // Draw behind navigation bar for lists
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Use the helper method for DevicePreview enabled flag
  runApp(
    DevicePreview(
      enabled: _isDebugAndDesktop(),
      builder: (context) => const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    globalStateNotifier.reload();
    globalStateNotifier.addListener(() {
      setState(() {});
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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final setupRequired =
        globalStateNotifier.collector == null &&
        globalStateNotifier.address == null;

    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'BinDays',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(74, 149, 117, 1),
          brightness: Brightness.light,
          dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
          primary: const Color.fromRGBO(74, 149, 117, 1),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(74, 149, 117, 1),
          brightness: Brightness.dark,
          dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
          primary: const Color.fromRGBO(74, 149, 117, 1),
        ),
      ),
      themeMode:
          globalStateNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      builder: (BuildContext innerContext, Widget? child) {
        if (_isDebugAndDesktop()) {
          return DesktopNavigationListener(
            navigatorKey: _navigatorKey,
            child: child!,
          );
        } else {
          return child!;
        }
      },
      home: setupRequired ? const WelcomePage() : const BinDaysPage(),
    );
  }
}

// Helper method to determine the platform and debug mode state
bool _isDebugAndDesktop() {
  final isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  return kDebugMode && isDesktop;
}
