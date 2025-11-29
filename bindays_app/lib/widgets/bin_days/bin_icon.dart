// External Imports
import 'package:bindays_client/models/bin.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/notifiers/global_notifiers.dart';

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

  static const int _alpha75percent = 191; // 0.75 * 255
  static const String _baseAssetPath = "assets/bin_icons/";
  static const String _defaultBinAssetPath = "${_baseAssetPath}icon_bin.png";

  static const Map<String, String> _binTypeAssets = {
    "bin": _defaultBinAssetPath,
    "box": "${_baseAssetPath}icon_box.png",
    "bag": "${_baseAssetPath}icon_bag.png",
    "caddy": "${_baseAssetPath}icon_caddy.png",
    "sack": "${_baseAssetPath}icon_sack.png",
    "container": "${_baseAssetPath}icon_box.png",
  };

  const BinIcon({super.key, required this.bin});

  @override
  Widget build(BuildContext context) {
    final Color binColour = _binColours[bin.colour] ?? Colors.grey;
    final bool isWhite = binColour == Colors.white;
    final Brightness brightness = Theme.of(context).brightness;

    final String? typeKey =
        globalStateNotifier.showBinTypeIcons
            ? bin.type?.trim().toLowerCase()
            : null;

    final String assetPath = _binTypeAssets[typeKey] ?? _defaultBinAssetPath;

    // Determine the background color of the bin icon container.
    // If the bin is white, use solid white in dark mode, and a slightly transparent white in light mode.
    // Otherwise, use the bin's color with 75% opacity.
    final Color containerColor =
        isWhite
            ? (brightness == Brightness.dark
                ? Colors.white
                : Colors.white.withAlpha(_alpha75percent))
            : binColour.withAlpha(_alpha75percent);

    // Add a light grey border if the bin is white and in light mode, to make it visible against a white background.
    final Border? containerBorder =
        isWhite && brightness == Brightness.light
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
            fit: BoxFit.contain,
            color: isWhite ? Colors.black : null,
            colorBlendMode: isWhite ? BlendMode.srcIn : null,
          ),
        ),
      ),
    );
  }
}
