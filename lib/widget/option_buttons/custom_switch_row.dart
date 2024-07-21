import 'package:flutter/material.dart';

class CustomSwitchRow extends StatelessWidget {
  final bool initialValue;
  final ValueChanged<bool> updateButtonAttribute;
  final String label;
  final IconData iconData;

  const CustomSwitchRow({
    Key? key,
    required this.initialValue,
    required this.updateButtonAttribute,
    required this.label,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: initialValue,
      onChanged: updateButtonAttribute,
      title: Text(label),
      secondary: Icon(iconData),
    );
  }
}
