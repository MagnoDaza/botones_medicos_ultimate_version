import 'package:flutter/material.dart';

class UniversalButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final bool isBorder;
  const UniversalButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.isBold,
      required this.isItalic,
      required this.isUnderline,
      required this.isBorder});

  @override
  State<UniversalButton> createState() => _UniversalButtonState();
}

class _UniversalButtonState extends State<UniversalButton> {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkTheme ? Colors.white : Colors.black;
    final borderColor = isDarkTheme ? Colors.white : Colors.black;

    return Center(
      child: IntrinsicWidth(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: widget.isBorder ? BorderRadius.circular(8) : BorderRadius.circular(24),
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: borderColor.withOpacity(0.5),
                offset: const Offset(-4, 4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: TextButton(
            onPressed: widget.onPressed,
            style: TextButton.styleFrom(
              minimumSize: const Size(0, 40), // Altura fija
              padding: const EdgeInsets.symmetric(horizontal: 24), // Espaciado horizontal
              shape: RoundedRectangleBorder(
                borderRadius: widget.isBorder ? BorderRadius.circular(8) : BorderRadius.circular(24),
              ),
            ),
            child: Text(
             widget.text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: widget.isBold ? FontWeight.bold : FontWeight.w300,
                fontStyle: widget.isItalic ? FontStyle.italic : FontStyle.normal,
                decoration: widget.isUnderline ? TextDecoration.underline : TextDecoration.none,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}