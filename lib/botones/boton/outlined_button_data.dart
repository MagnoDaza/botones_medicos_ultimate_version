import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:uuid/uuid.dart';

import '../button_data.dart';

class OutlinedButtonData extends ButtonData {
  OutlinedButtonData({
    required ButtonType type,
    required String text,
    required QuillController controller,
    required bool isBold,
    required bool isItalic,
    required bool isUnderline,
    required bool isBorder,
    required String id,
  }) : super(
          id: Uuid().v4(),
          type: type,
          text: text,
          controller: controller,
          isBold: isBold,
          isItalic: isItalic,
          isBorder: isBorder,
          isUnderline: isUnderline,
        );

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        alignment: Alignment.center,
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
          color: Theme.of(context).textTheme.displayMedium!.color,
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
    return OutlinedButtonData(
      id: id,
      type: type,
      text: newText,
      controller: controller,
      isBold: isBold,
      isItalic: isItalic,
      isUnderline: isUnderline,
      isBorder: isBorder,
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
    return OutlinedButtonData(
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
