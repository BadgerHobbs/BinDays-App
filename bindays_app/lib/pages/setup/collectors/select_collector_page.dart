// External Imports
import 'package:bindays_client/models/collector.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/client/bindays_client.dart';
import 'package:bindays_app/data/setup_state.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/widgets/primary_button.dart';
import 'package:bindays_app/widgets/select_collector/select_collector_header.dart';
import 'package:bindays_app/widgets/select_collector/select_collector_list.dart';

class SelectCollectorPage extends StatefulWidget {
  const SelectCollectorPage({super.key});

  @override
  State<SelectCollectorPage> createState() => _SelectCollectorPageState();
}

class _SelectCollectorPageState extends State<SelectCollectorPage> {
  List<Collector>? collectors;
  Collector? selectedCollector;

  @override
  void initState() {
    super.initState();
    _getCollectors();
  }

  Future<void> _getCollectors() async {
    try {
      final fetchedCollectors = await binDaysClient.getCollectors();
      setState(() => collectors = fetchedCollectors);
    } catch (e) {
      setState(() => collectors = []);
    }
  }

  void _onCollectorSelected(Collector collector) {
    setState(() => selectedCollector = collector);
  }

  void _onConfirmSelection() {
    setupState.collector = selectedCollector;
    navigateToFindingAddressesPage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          minimum: const EdgeInsets.all(25),
          child: Column(
            children: [
              const SelectCollectorHeader(),
              const SizedBox(height: 25),
              Expanded(
                child: SelectCollectorList(
                  collectors: collectors,
                  selectedCollector: selectedCollector,
                  onCollectorSelected: _onCollectorSelected,
                ),
              ),
              if (selectedCollector != null)
                PrimaryButton(
                  text: "Confirm Selection",
                  onPressed: _onConfirmSelection,
                ),
            ],
          ),
      ),
    );
  }
}
