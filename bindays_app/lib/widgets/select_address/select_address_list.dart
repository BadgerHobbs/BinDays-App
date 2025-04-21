// External Imports
import 'package:bindays_client/models/address.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/extensions/address_extension.dart';

class SelectAddressList extends StatelessWidget {
  final List<Address>? addresses;
  final Address? selectedAddress;
  final Function(Address) onAddressSelected;

  const SelectAddressList({
    super.key,
    required this.addresses,
    required this.selectedAddress,
    required this.onAddressSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: ListView.builder(
            shrinkWrap: false,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: addresses?.length ?? 0,
            itemBuilder: (context, index) {
              final address = addresses![index];
              final isSelectedCollector = address == selectedAddress;

              return ListTile(
                onTap: () {
                  onAddressSelected(address);
                },
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.place,
                  size: 25,
                  color:
                      isSelectedCollector
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceContainerHigh,
                ),
                title: Text(
                  address.toFormattedString(),
                  style: TextStyle(
                    fontWeight:
                        isSelectedCollector
                            ? FontWeight.bold
                            : FontWeight.normal,
                    color:
                        isSelectedCollector
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
