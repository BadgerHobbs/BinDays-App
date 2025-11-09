// External Imports
import 'package:bindays_client/models/bin.dart';
import 'package:flutter/material.dart';

class BinIcon extends StatelessWidget {
  final Bin bin;

  static const Map<String, Color> _binColours = {
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
    "White": Colors.white,
  };

  static const Map<String, String> _binTypeAssets = {
    "bin": "assets/bin_icons/icon_bin.png",
    "box": "assets/bin_icons/icon_box.png",
    "bag": "assets/bin_icons/icon_bag.png",
    "caddy": "assets/bin_icons/icon_caddy.png",
    "sack": "assets/bin_icons/icon_sack.png",
    "container": "assets/bin_icons/icon_box.png",
  };

  const BinIcon({super.key, required this.bin});

  @override
  Widget build(BuildContext context) {
    final Color binColour = _binColours[bin.colour] ?? Colors.grey;
    final bool isWhite = binColour == Colors.white;
    final Brightness brightness = Theme.of(context).brightness;

    final String? typeKey = bin.type?.trim().toLowerCase();
    final String assetPath = _binTypeAssets[typeKey] ?? _binTypeAssets["bin"]!;

    // Determine the background color of the bin icon container.
    // If the bin is white, use solid white in dark mode, and a slightly transparent white in light mode.
    // Otherwise, use the bin's color with 75% opacity.
    final Color containerColor = isWhite
        ? (brightness == Brightness.dark
            ? Colors.white
            : Colors.white.withAlpha(191))
        : binColour.withAlpha(191);

    // Add a light grey border if the bin is white and in light mode, to make it visible against a white background.
    final Border? containerBorder = isWhite && brightness == Brightness.light
        ? Border.all(color: Colors.grey.shade300)
        : null;

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: containerColor,
        border: containerBorder,
      ),
      child: SizedBox(
        width: 35,
        height: 35,
        child: Center(
          child: Image.asset(
            assetPath,
            width: 35,
            height: 35,
            fit: BoxFit.contain,
            color: isWhite ? Colors.black : null,
            colorBlendMode: isWhite ? BlendMode.srcIn : null,
          ),
        ),
      ),
    );
  }
}
