// External Imports
import 'package:bindays_client/models/address.dart';
import 'package:flutter/material.dart';

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

  String _formatAddress(Address address) {
    final addressParts = [
      address.property,
      address.street,
      address.town,
      address.postcode,
    ];

    final filteredAddressParts = addressParts.where(
      (part) => part != null && part.trim().isNotEmpty,
    );

    return filteredAddressParts.join(", ");
  }

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

              return Opacity(
                opacity: isSelectedCollector ? 1 : 0.75,
                child: ListTile(
                  onTap: () {
                    onAddressSelected(address);
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    _formatAddress(address),
                    style: TextStyle(
                      fontWeight:
                          isSelectedCollector
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                  leading: Icon(
                    Icons.place,
                    size: 25,
                    color: Theme.of(context).primaryColor,
                  ),
                  trailing:
                      isSelectedCollector
                          ? Text(
                            "Selected",
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                          : null,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
