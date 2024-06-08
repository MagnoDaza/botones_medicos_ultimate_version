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
    required Document document,
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
          document: document,
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
    String? id,
    ButtonType? type,
    String? text,
    Document? document,
    Color? color,
    Color? textColor,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    bool? isBorder,
  }) {
    return ElevatedButtonData(
      id: id ?? this.id,
      type: type ?? this.type,
      text: text ?? this.text,
      document: document ?? this.document,
      color: color ?? this.color,
      textColor: textColor ?? this.textColor,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      isBorder: isBorder ?? this.isBorder,
    );
  }

  @override
  ElevatedButtonData cloneWithText({
    required String newText,
    required bool newIsBold,
    required bool newIsItalic,
    required bool newIsUnderline,
    required bool newIsBorder,
    required Document document,
  }) {
    return copyWith(
      text: newText,
      isBold: newIsBold,
      isItalic: newIsItalic,
      isUnderline: newIsUnderline,
      isBorder: newIsBorder,
      document:
          Document.fromJson(document.toDelta().toJson()), // Clonar el documento
    );
  }
}
