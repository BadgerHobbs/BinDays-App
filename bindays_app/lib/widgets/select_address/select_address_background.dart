// External Imports
import 'package:flutter/material.dart';

class SelectAddressBackground extends StatelessWidget {
  final Widget child;

  const SelectAddressBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
            BlendMode.dstATop,
          ),
          image: const AssetImage(
            'assets/illustrations/City_buildings_Monochromatic_Bg.png',
          ),
          fit: BoxFit.fitWidth,
          alignment: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
