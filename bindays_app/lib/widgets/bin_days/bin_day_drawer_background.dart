// External Imports
import 'package:flutter/material.dart';

class BinDayDrawerBackground extends StatelessWidget {
  final Widget child;

  const BinDayDrawerBackground({super.key, required this.child});

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
            'assets/illustrations/Recycling_Ladder_Monochromatic_Bg.png',
          ),
          fit: BoxFit.fitWidth,
          alignment: Alignment.bottomLeft,
        ),
      ),
      child: child,
    );
  }
}
