import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:uuid/uuid.dart';

import '../../controller/color_notifier.dart';
import '../../controller/text_style_notifier.dart';
import '../button_data.dart';
import 'button_builder.dart';

class ButtonFactory {
  final ColorNotifier colorNotifier;
  final TextStyleNotifier textStyleNotifier;

  ButtonFactory(this.colorNotifier, this.textStyleNotifier);

  ButtonData createButton(ButtonType type, String text, Document document, {Color? color, Color? textColor,
   bool? isBold, bool? isItalic, bool? isUnderline, bool? isBorder}) {
    String buttonId = const Uuid().v4();
    return ButtonBuilder()
      .setId(buttonId)
      .setType(type)
      .setText(text)
      .setDocument(document)
      .setColor(color ?? colorNotifier.getBackgroundColor(buttonId))
      .setTextColor(textColor ?? colorNotifier.getTextColor(buttonId))
      .setBold(isBold ?? textStyleNotifier.isBold)
      .setItalic(isItalic ?? textStyleNotifier.isItalic)
      .setUnderline(isUnderline ?? textStyleNotifier.isUnderline)
      .setBorder(isBorder ?? textStyleNotifier.isBorder)
      .build();
  }

  ButtonData updateButton(ButtonData originalButton, Map<String, dynamic> newValues) {
    return ButtonBuilder()
      .setId(originalButton.id)
      .setType(originalButton.type)
      .setText(newValues['text'] ?? originalButton.text)
      .setDocument(newValues['document'] ?? originalButton.document)
      .setColor(newValues['color'] ?? (originalButton as dynamic).color)
      .setTextColor(newValues['textColor'] ?? (originalButton as dynamic).textColor)
      .setBold(newValues['isBold'] ?? originalButton.isBold)
      .setItalic(newValues['isItalic'] ?? originalButton.isItalic)
      .setUnderline(newValues['isUnderline'] ?? originalButton.isUnderline)
      .setBorder(newValues['isBorder'] ?? originalButton.isBorder)
      .build();
  }
}
