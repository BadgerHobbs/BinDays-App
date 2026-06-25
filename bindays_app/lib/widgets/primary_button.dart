// External Imports
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool enabled;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: enabled
            ? const Color.fromRGBO(58, 119, 93, 1)
            : const Color.fromRGBO(58, 119, 93, 0.4),
      ),
      padding: const EdgeInsets.only(bottom: 7),
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          backgroundColor: const Color.fromRGBO(74, 149, 117, 1),
          disabledBackgroundColor: const Color.fromRGBO(74, 149, 117, 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(15),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: enabled ? Colors.white : Colors.white70,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
