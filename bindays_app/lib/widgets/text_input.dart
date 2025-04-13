// External Imports
import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onSubmitted;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;

  const TextInput({
    super.key,
    required this.controller,
    required this.hintText,
    this.onSubmitted,
    // Defaults match the postcode field, but can be overridden if necessary
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.characters,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadiusValue = 10.0;
    const contentPadding = EdgeInsets.symmetric(vertical: 15.0);
    const textStyle = TextStyle(fontSize: 18);
    const textAlign = TextAlign.center;

    final borderRadius = BorderRadius.circular(borderRadiusValue);
    final borderSide = BorderSide(
      color: Theme.of(context).primaryColor,
      width: 2.0,
    );
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: borderSide,
    );

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textAlign: textAlign,
      style: textStyle,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: contentPadding,
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
      ),
      onSubmitted: onSubmitted,
    );
  }
}
