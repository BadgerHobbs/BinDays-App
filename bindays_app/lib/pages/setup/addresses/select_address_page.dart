// External Imports
import 'package:bindays_client/models/address.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/setup_state.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/widgets/primary_button.dart';
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

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _onConfirmSelection() {
    // Update global state with the user selected details from setup
    globalStateNotifier.setBinDays([]);
    globalStateNotifier.setCollector(setupState.collector!);
    globalStateNotifier.setAddress(selectedAddress!);

    navigateToBinDaysPage(context);
  }

  int _compareAddresses(Address a, Address b) {
    final aProperty = a.property ?? "";
    final bProperty = b.property ?? "";

    // Extract the first "word" from the property, removing any non-alphanumeric characters
    final aFirstWord = aProperty
        .split(" ")
        .first
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    final bFirstWord = bProperty
        .split(" ")
        .first
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

    // Try parsing the first words as integers
    final aNumber = int.tryParse(aFirstWord);
    final bNumber = int.tryParse(bFirstWord);

    // Both are numbers, compare them numerically
    if (aNumber != null && bNumber != null) {
      return aNumber.compareTo(bNumber);
    }
    // Only a is a number, it should come before words
    else if (aNumber != null) {
      return -1;
    }
    // Only b is a number, it should come before words
    else if (bNumber != null) {
      return 1;
    }
    // Both are words, compare them alphabetically
    else {
      return aFirstWord.compareTo(bFirstWord);
    }
  }

  @override
  Widget build(BuildContext context) {
    final addresses = setupState.addresses!;

    // Sort addresses by the first word of the property,
    // numerically if both are numbers, otherwise alphabetically.
    // Non-alphanumeric characters are ignored in the comparison.
    addresses.sort(_compareAddresses);

    return Scaffold(
      body: SafeArea(
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
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: PrimaryButton(
                  text: "Confirm Selection",
                  onPressed: _onConfirmSelection,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
