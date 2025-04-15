// External Imports
import 'package:bindays_client/models/bin.dart';
import 'package:flutter/material.dart';

class BinDayListItem extends StatelessWidget {
  final Bin bin;

  static Map<String, Color> binColours = {
    "Red": Colors.red,
    "Green": Colors.green,
    "Light Green": Colors.lightGreen,
    "Blue": Colors.blue,
    "Light Blue": Colors.lightBlue,
    "Black": Colors.black,
    "Grey": Colors.grey,
    "Yellow": Colors.yellow,
    "Orange": Colors.orange,
    "Purple": Colors.purple,
    "Pink": Colors.pink,
    "Brown": Colors.brown,
  };

  const BinDayListItem({super.key, required this.bin});

  String _getBinType() {
    return "${bin.colour.trim()} ${bin.type ?? "Bin".trim()}";
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: binColours[bin.colour]?.withValues(alpha: 0.75) ?? Colors.grey,
        ),
        child: Image.asset(
          "assets/illustrations/Icon-Just-White-Splash.png",
          width: 35,
          height: 35,
        ),
      ),
      title: Text(bin.name, style: const TextStyle(fontSize: 16)),
      subtitle: Text(
        _getBinType(),
        style: const TextStyle(fontSize: 15, color: Colors.grey),
      ),
    );
  }
}
