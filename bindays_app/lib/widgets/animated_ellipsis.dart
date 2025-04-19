// External Imports
import 'package:flutter/material.dart';

class AnimatedEllipsis extends StatefulWidget {
  final TextStyle? style;

  const AnimatedEllipsis({super.key, this.style});

  @override
  State<AnimatedEllipsis> createState() => _AnimatedEllipsisState();
}

class _AnimatedEllipsisState extends State<AnimatedEllipsis>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _dotCount = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _dotCount = (_dotCount % 3) + 1);
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String dots = '';
    for (int i = 0; i < _dotCount; i++) {
      dots += '.';
    }

    return Text(
      dots,
      style:
          widget.style ??
          TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
      textAlign: TextAlign.left,
      overflow: TextOverflow.clip,
    );
  }
}
