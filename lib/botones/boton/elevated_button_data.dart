import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../button_data.dart';

class ElevatedButtonData extends ButtonData {
  final Color color;
  final Color textColor;

  ElevatedButtonData({
    required String id,
    required ButtonType type,
    required String text,
    required QuillController controller,
    required this.color,
    required this.textColor,
    required bool isBold,
    required bool isItalic,
    required bool isUnderline,
    required bool isBorder,
  }) : super(
          id: id,
          type: type,
          text: text,
          controller: controller,
          isBold: isBold,
          isItalic: isItalic,
          isUnderline: isUnderline,
          isBorder: isBorder,
        );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: color,
        shape: isBorder
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              )
            : null,
      ),
      onPressed: () => onPressed(context),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          decoration:
              isUnderline ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }

  @override
  ElevatedButtonData copyWith({
    String? text,
    QuillController? controller,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    bool? isBorder,
    Color? color,
    Color? textColor,
  }) {
    return ElevatedButtonData(
      id: id,
      type: type,
      text: text ?? this.text,
      controller: controller ?? this.controller,
      color: color ?? this.color,
      textColor: textColor ?? this.textColor,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      isBorder: isBorder ?? this.isBorder,
    );
  }

  @override
  ElevatedButtonData cloneWithText(String newText, bool newIsBold,
      bool newIsItalic, bool newIsUnderline, bool newIsBorder) {
    return copyWith(
        text: newText,
        isBold: newIsBold,
        isItalic: newIsItalic,
        isUnderline: newIsUnderline,
        isBorder: newIsBorder);
  }
}
