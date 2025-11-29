// External Imports
import 'package:bindays_client/models/address.dart';

// Internal Imports
import 'package:bindays_app/extensions/string_extension.dart';

extension AddressExtension on Address {
  String toFormattedString() {
    final addressParts = [
      property?.capitaliseEveryWord(),
      street?.capitaliseEveryWord(),
      town?.capitaliseEveryWord(),
      postcode?.toUpperCase(),
    ];

    final filteredAddressParts = addressParts.where(
      (part) => part != null && part.trim().isNotEmpty,
    );

    return filteredAddressParts.join(", ");
  }

  String toFormattedStringNoPostcode() {
    final addressParts = [
      property?.capitaliseEveryWord(),
      street?.capitaliseEveryWord(),
      town?.capitaliseEveryWord(),
    ];

    final filteredAddressParts = addressParts.where(
      (part) => part != null && part.trim().isNotEmpty,
    );

    return filteredAddressParts.join(", ");
  }
}
