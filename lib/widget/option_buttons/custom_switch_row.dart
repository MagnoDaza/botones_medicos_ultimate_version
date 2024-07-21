import 'package:flutter/material.dart';

class CustomSwitchRow extends StatelessWidget {
  final bool initialValue;
  final Function(bool) updateButtonAttribute;
  final String label;

  const CustomSwitchRow({
    Key? key,
    required this.initialValue,
    required this.updateButtonAttribute,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Switch(
          
          value: initialValue,
          onChanged: (bool newValue) {
            updateButtonAttribute(newValue);
          },
        ),
      ],
    );
  }
}
