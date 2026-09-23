// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/setup_state.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/bin_days/location_bin_days_view.dart';
import 'package:bindays_app/widgets/primary_button.dart';
import 'package:bindays_app/widgets/scrollable_fill_column.dart';

class BinDaysPage extends StatefulWidget {
  const BinDaysPage({super.key});

  @override
  State<BinDaysPage> createState() => _BinDaysPageState();
}

class _BinDaysPageState extends State<BinDaysPage> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = _selectedIndex();
    _pageController = PageController(initialPage: _currentIndex);
    globalStateNotifier.addListener(_onStateChanged);

    // Guarantee the page lands on the selected location once laid out, so that
    // after adding an address (which selects it) or tapping a notification the
    // screen opens on the associated address even if the freshly-pushed route
    // didn't honour initialPage.
    WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToSelected());
  }

  /// Ensure the page view shows the selected location, retrying until the
  /// PageView has attached (it may not be laid out on the first frame of a
  /// freshly-pushed route).
  void _jumpToSelected() {
    if (!mounted) return;
    final index = _selectedIndex();
    if (!_pageController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToSelected());
      return;
    }
    if (_pageController.page?.round() != index) {
      _pageController.jumpToPage(index);
    }
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  void dispose() {
    globalStateNotifier.removeListener(_onStateChanged);
    _pageController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  /// Index of the selected location in the list (0 if none/unknown).
  int _selectedIndex() {
    final selectedId = globalStateNotifier.selectedLocation?.id;
    final index = globalStateNotifier.locations.indexWhere(
      (location) => location.id == selectedId,
    );
    return index < 0 ? 0 : index;
  }

  /// Keep the page in sync when the selection changes elsewhere (e.g. from the
  /// manage addresses page, or after adding/removing an address).
  void _onStateChanged() {
    final selectedIndex = _selectedIndex();
    if (selectedIndex != _currentIndex && _pageController.hasClients) {
      _currentIndex = selectedIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(selectedIndex);
        }
      });
    }
    setState(() {});
  }

  void _onPageChanged(int index) {
    final locations = globalStateNotifier.locations;
    if (index < 0 || index >= locations.length) return;
    _currentIndex = index;
    globalStateNotifier.setSelectedLocation(locations[index].id);
  }

  void _startAddAddress() {
    setupState.reset();
    navigateToEnterPostcodePage(context);
  }

  /// Shown when the user has removed all of their saved addresses.
  Widget _buildEmptyState(BuildContext context) {
    return SafeBasePage(
      child: ScrollableFillColumn(
        children: [
          const Spacer(flex: 1),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Image.asset(
              'assets/illustrations/Recycling_Two_Color.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            'No addresses',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Add an address to start seeing its bin collections.',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 1),
          PrimaryButton(text: 'Add Address', onPressed: _startAddAddress),
        ],
      ),
    );
  }

  /// Row of page dots shown when more than one address is saved.
  Widget _buildPageDots(BuildContext context, int count, int current) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color:
                isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.35),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locations = globalStateNotifier.locations;
    final title = globalStateNotifier.selectedLocation?.shortName ?? 'BinDays';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () => navigateToTroubleshootingPage(context),
        ),
        title: InkWell(
          onTap: () => navigateToManageAddressesPage(context),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(title, overflow: TextOverflow.ellipsis),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => navigateToSettingsPage(context),
          ),
        ],
        bottom:
            locations.length > 1
                ? PreferredSize(
                  preferredSize: const Size.fromHeight(16),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildPageDots(
                      context,
                      locations.length,
                      _currentIndex,
                    ),
                  ),
                )
                : null,
      ),
      body:
          locations.isEmpty
              ? _buildEmptyState(context)
              : PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  return LocationBinDaysView(
                    key: ValueKey(locations[index].id),
                    locationId: locations[index].id,
                  );
                },
              ),
    );
  }
}
