// External Imports
import 'package:bindays_app/pages/bin_days_page.dart';
import 'package:bindays_app/widgets/primary_button.dart';
import 'package:bindays_app/widgets/select_address/select_address_background.dart';
import 'package:bindays_app/widgets/select_address/select_address_header.dart';
import 'package:bindays_app/widgets/select_address/select_address_list.dart';
import 'package:bindays_client/models/address.dart';
import 'package:bindays_client/models/collector.dart';
import 'package:flutter/material.dart';

class SelectAddressPage extends StatefulWidget {
  final String postcode;
  final Collector collector;
  final List<Address> addresses;

  const SelectAddressPage({
    super.key,
    required this.postcode,
    required this.collector,
    required this.addresses,
  });

  @override
  State<SelectAddressPage> createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {
  Address? selectedAddress;

  void _onAddressSelected(Address address) {
    setState(() {
      selectedAddress = address;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  addresses: widget.addresses,
                  selectedAddress: selectedAddress,
                  onAddressSelected: _onAddressSelected,
                ),
              ),
              Visibility(
                visible: selectedAddress != null,
                child: PrimaryButton(
                  text: "Confirm Selection",
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (_) => BinDaysPage(
                              postcode: widget.postcode,
                              collector: widget.collector,
                              address: selectedAddress!,
                            ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
