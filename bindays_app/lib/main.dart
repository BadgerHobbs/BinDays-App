// External Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Internal Imports
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/pages/bin_days_page.dart';
import 'package:bindays_app/pages/setup/welcome_page.dart';

void main() {
  // Ensure app is initialised
  WidgetsFlutterBinding.ensureInitialized();

  // Transparent navigation bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
  );

  // Draw behind navigation bar for lists
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // TODO:
    // - Add logic to detect whether use already has collector/address configured
    final setupRequired = true;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BinDays',
      theme: ThemeData(
        colorScheme: ThemeData.light(
          useMaterial3: true,
        ).colorScheme.copyWith(primary: Color.fromRGBO(74, 149, 117, 1)),
      ),
      darkTheme: ThemeData(
        colorScheme: ThemeData.dark(
          useMaterial3: true,
        ).colorScheme.copyWith(primary: Color.fromRGBO(74, 149, 117, 1)),
      ),
      themeMode:
          globalStateNotifier.darkMode ? ThemeMode.dark : ThemeMode.light,
      home: setupRequired ? WelcomePage() : BinDaysPage(),
    );
  }
}
