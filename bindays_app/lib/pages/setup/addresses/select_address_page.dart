// External Imports
import 'package:bindays_client/models/address.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/setup_state.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/widgets/primary_button.dart';
import 'package:bindays_app/widgets/select_address/select_address_background.dart';
import 'package:bindays_app/widgets/select_address/select_address_header.dart';
import 'package:bindays_app/widgets/select_address/select_address_list.dart';

class SelectAddressPage extends StatefulWidget {
  const SelectAddressPage({super.key});

  @override
  State<SelectAddressPage> createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {
  Address? selectedAddress;

  void _onAddressSelected(Address address) {
    setState(() => selectedAddress = address);
  }

  void _onConfirmSelection() {
    // Update global state with the user selected details from setup
    globalStateNotifier.setBinDays([]);
    globalStateNotifier.setCollector(setupState.collector!);
    globalStateNotifier.setAddress(selectedAddress!);

    navigateToBinDaysPage(context);
  }

  @override
  Widget build(BuildContext context) {
    final addresses = setupState.addresses!;

    return Scaffold(
      body: SelectAddressBackground(
        child: SafeArea(
          minimum: const EdgeInsets.all(25),
          child: Column(
            children: [
              const SelectAddressHeader(),
              const SizedBox(height: 25),
              Expanded(
                child: SelectAddressList(
                  addresses: addresses,
                  selectedAddress: selectedAddress,
                  onAddressSelected: _onAddressSelected,
                ),
              ),
              if (selectedAddress != null)
                PrimaryButton(
                  text: "Confirm Selection",
                  onPressed: _onConfirmSelection,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
