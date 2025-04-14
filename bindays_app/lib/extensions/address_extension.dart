// External Imports
import 'package:bindays_client/models/address.dart';

extension AddressExtension on Address {
  String toFormattedString() {
    final addressParts = [property, street, town, postcode?.toUpperCase()];

    final filteredAddressParts = addressParts.where(
      (part) => part != null && part.trim().isNotEmpty,
    );

    return filteredAddressParts.join(", ");
  }
}
