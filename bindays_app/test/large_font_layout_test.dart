// External Imports
import 'package:bindays_client/models/address.dart';
import 'package:bindays_client/models/bin.dart';
import 'package:bindays_client/models/bin_day.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Internal Imports
import 'package:bindays_app/pages/setup/enter_postcode_page.dart';
import 'package:bindays_app/pages/setup/how_it_works_page.dart';
import 'package:bindays_app/pages/setup/welcome_page.dart';
import 'package:bindays_app/pages/setup/generics/loading_page.dart';
import 'package:bindays_app/pages/setup/generics/not_found_page.dart';
import 'package:bindays_app/widgets/bin_days/bin_day_list_group.dart';
import 'package:bindays_app/widgets/primary_button.dart';
import 'package:bindays_app/widgets/scrollable_fill_column.dart';

/// Wraps [child] in a MaterialApp forcing a [scale] text scale to emulate a
/// user with large accessibility font sizes.
Widget _wrapWithTextScale(Widget child, double scale) {
  return MaterialApp(
    home: Builder(
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child,
        );
      },
    ),
  );
}

/// The maximum scroll extent of the page: 0 means it cannot be scrolled.
double _maxScrollExtent(WidgetTester tester) {
  final state = tester.state<ScrollableState>(find.byType(Scrollable));
  return state.position.maxScrollExtent;
}

/// A NotFoundPage with a representative message and two action buttons.
Widget _notFoundPage() {
  return NotFoundPage(
    headline: 'Collector Not Supported',
    message:
        'We identified a collector for your postcode, which we do not support '
        'yet. You can request support for it below, or select a collector '
        'manually to continue.',
    button: PrimaryButton(text: 'Request Support', onPressed: () {}),
    extraButton: PrimaryButton(text: 'Select Manually', onPressed: () {}),
  );
}

void main() {
  setUp(() {
    final view =
        TestWidgetsFlutterBinding.ensureInitialized().platformDispatcher.views
            .first;
    view.physicalSize = const Size(400, 820);
    view.devicePixelRatio = 1.0;
  });

  tearDown(() {
    final view =
        TestWidgetsFlutterBinding.ensureInitialized().platformDispatcher.views
            .first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  testWidgets(
    'a flexible child with a real intrinsic height does not make a fitting '
    'page scrollable (regression: scrolling at normal font sizes)',
    (tester) async {
      // Image.asset reports a zero intrinsic size until it loads, so it cannot
      // reproduce the real-device bug in a test. A sized box stands in for the
      // loaded illustration, which has a real natural height. ScrollableFillColumn
      // must neutralise it automatically, without any special wrapper at the
      // call site.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScrollableFillColumn(
              children: [
                Spacer(flex: 1),
                Flexible(flex: 2, child: SizedBox(width: 200, height: 600)),
                SizedBox(height: 50),
                Text('A short heading'),
                SizedBox(height: 10),
                Text('A short body that easily fits the viewport.'),
                Spacer(flex: 1),
                SizedBox(width: 200, height: 50),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // The illustration shrinks to fill the leftover space; nothing scrolls.
      expect(_maxScrollExtent(tester), 0.0);
    },
  );

  testWidgets(
    'HowItWorksPage is not scrollable when its content fits the viewport',
    (tester) async {
      // A tall viewport so the content fits even with the wide test font.
      final view = tester.view;
      view.physicalSize = const Size(500, 1600);
      view.devicePixelRatio = 1.0;

      await tester.pumpWidget(_wrapWithTextScale(const HowItWorksPage(), 1.0));

      expect(tester.takeException(), isNull);
      // Nothing to scroll: the page stays fixed.
      expect(_maxScrollExtent(tester), 0.0);
    },
  );

  testWidgets(
    'HowItWorksPage does not overflow and becomes scrollable so the Continue '
    'button stays reachable at an extreme font scale',
    (tester) async {
      final view = tester.view;
      view.physicalSize = const Size(360, 480);
      view.devicePixelRatio = 1.0;

      await tester.pumpWidget(_wrapWithTextScale(const HowItWorksPage(), 4.0));

      // No RenderFlex overflow: the page scrolls as a last resort instead.
      expect(tester.takeException(), isNull);
      expect(_maxScrollExtent(tester), greaterThan(0.0));

      final button = find.byType(PrimaryButton);
      expect(button, findsOneWidget);
      await tester.ensureVisible(button);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'WelcomePage does not overflow and keeps the Get Started button reachable '
    'at an extreme font scale',
    (tester) async {
      final view = tester.view;
      view.physicalSize = const Size(360, 480);
      view.devicePixelRatio = 1.0;

      await tester.pumpWidget(_wrapWithTextScale(const WelcomePage(), 4.0));

      expect(tester.takeException(), isNull);

      final button = find.byType(PrimaryButton);
      expect(button, findsOneWidget);
      await tester.ensureVisible(button);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'EnterPostcodePage (a TextField inside the fill column) does not overflow '
    'and keeps the button reachable at an extreme font scale',
    (tester) async {
      final view = tester.view;
      view.physicalSize = const Size(360, 480);
      view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        _wrapWithTextScale(const EnterPostcodePage(), 4.0),
      );
      expect(tester.takeException(), isNull);

      // Entering a postcode reveals the "Find Collector" button.
      await tester.enterText(find.byType(TextField), 'EX20 1ZF');
      await tester.pump();
      expect(tester.takeException(), isNull);

      final button = find.byType(PrimaryButton);
      expect(button, findsOneWidget);
      await tester.ensureVisible(button);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('LoadingPage does not overflow at an extreme font scale', (
    tester,
  ) async {
    final view = tester.view;
    view.physicalSize = const Size(360, 480);
    view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      _wrapWithTextScale(
        const LoadingPage(
          titleText: 'Finding your collector',
          descriptionText:
              'This can take a little while, please be patient while we search.',
        ),
        4.0,
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(ScrollableFillColumn), findsOneWidget);
  });

  testWidgets(
    'NotFoundPage does not overflow and keeps both buttons reachable at an '
    'extreme font scale',
    (tester) async {
      final view = tester.view;
      view.physicalSize = const Size(360, 480);
      view.devicePixelRatio = 1.0;

      await tester.pumpWidget(_wrapWithTextScale(_notFoundPage(), 4.0));

      expect(tester.takeException(), isNull);

      final buttons = find.byType(PrimaryButton);
      expect(buttons, findsNWidgets(2));
      await tester.ensureVisible(buttons.first);
      await tester.ensureVisible(buttons.last);
      expect(tester.takeException(), isNull);
    },
  );

  BinDay binDayGroup() {
    return BinDay(
      date: DateTime.now().add(const Duration(days: 5)),
      address: const Address(
        property: '12',
        street: 'Oak Street',
        town: 'Okehampton',
        postcode: 'EX20 1ZF',
        uid: 'uid-1',
      ),
      bins: const [
        Bin(name: 'Recycling', colour: 'green', keys: ['recycling']),
      ],
    );
  }

  Future<void> pumpBinDayGroup(
    WidgetTester tester,
    double scale, {
    Size size = const Size(400, 820),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      _wrapWithTextScale(
        Scaffold(
          // As used in the app: inside a vertically scrollable list.
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: BinDayListGroup(binDay: binDayGroup()),
          ),
        ),
        scale,
      ),
    );
  }

  testWidgets(
    'BinDayListGroup header does not overflow horizontally at a large font '
    'scale (the date wraps instead of pushing the countdown off screen)',
    (tester) async {
      await pumpBinDayGroup(tester, 2.5);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'BinDayListGroup header does not overflow horizontally at an extreme font '
    'scale on a small device (both the date and countdown wrap)',
    (tester) async {
      await pumpBinDayGroup(tester, 4.0, size: const Size(320, 640));
      expect(tester.takeException(), isNull);
    },
  );
}
