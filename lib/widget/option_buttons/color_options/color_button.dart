import 'package:flutter/material.dart';

class ColorButton extends StatelessWidget {
  final Color buttonColor;
  final Function onPressed;
  final Widget? icon;

  const ColorButton({super.key, required this.buttonColor, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon ?? Icon(Icons.circle, color: buttonColor),
      onPressed: () => onPressed(),
    );
  }
}