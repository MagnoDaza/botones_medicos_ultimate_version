import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final List<String> options;
  final List<Widget> alwaysVisibleChildren;
  final Map<String, Widget> conditionallyVisibleChildren;
  final Function(String?) onChanged;
  final String? dropdownValue;
  final List<String> hiddenForOptions; // Nueva propiedad

  CustomDropdownButton({
    required this.options,
    required this.alwaysVisibleChildren,
    required this.conditionallyVisibleChildren,
    required this.onChanged,
    this.dropdownValue,
    this.hiddenForOptions = const [], // Valor por defecto
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DropdownButton<String>(
          value: dropdownValue,
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
        ...alwaysVisibleChildren,
        if (dropdownValue != null && !hiddenForOptions.contains(dropdownValue))
          conditionallyVisibleChildren[dropdownValue!] ?? SizedBox.shrink(),
      ],
    );
  }
}
