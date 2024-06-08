import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:uuid/uuid.dart';

import '../button_data.dart';

class AdaptiveButtonData extends ButtonData {
  AdaptiveButtonData({
    required ButtonType type, // Cambiado 'name' por 'type'
    required String text,
    required QuillController controller,
    required bool isBold,
    required bool isItalic,
    required bool isUnderline,
    required bool isBorder,
    required String id,
  }) : super(
          id: const Uuid().v4(),
          type: type, // Cambiado 'name' por 'type'
          text: text,
          controller: controller,
          isBold: isBold,
          isItalic: isItalic,
          isBorder: isBorder,
          isUnderline: isUnderline,
        );

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
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
  ButtonData cloneWithText(String newText, bool isBold, bool isItalic,
      bool isUnderline, bool isBorder) {
    return AdaptiveButtonData(
      id: id,
      type: type,
      text: newText,
      controller: controller,
      isBold: isBold,
      isItalic: isItalic,
      isBorder: isBorder,
      isUnderline: isUnderline,
    );
  }

  @override
  ButtonData copyWith(
      {String? text,
      QuillController? controller,
      bool? isBold,
      bool? isItalic,
      bool? isUnderline,
      bool? isBorder}) {
    return AdaptiveButtonData(
      id: id,
      type: type,
      text: text ?? this.text,
      controller: controller ?? this.controller,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      isBorder: isBorder ?? this.isBorder,
    );
  }
}
