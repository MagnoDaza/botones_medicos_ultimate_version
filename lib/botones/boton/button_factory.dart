import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:uuid/uuid.dart';
import '../../controller/color_notifier.dart';
import '../../controller/text_style_notifier.dart';
import '../button_data.dart';
import 'adaptive_button.dart';
import 'elevated_button_data.dart';
import 'outlined_button_data.dart';

class ButtonFactory {
  final ColorNotifier colorNotifier;
  final TextStyleNotifier textStyleNotifier;

  ButtonFactory(this.colorNotifier, this.textStyleNotifier);

  ButtonData createButton(
    ButtonType type,
    String text,
    Document document,
  ) {
    String buttonId = const Uuid().v4();
    Color backgroundColor = colorNotifier.getBackgroundColor(buttonId);
    Color textColor = colorNotifier.getTextColor(buttonId);
    bool isBold = textStyleNotifier.isBold;
    bool isItalic = textStyleNotifier.isItalic;
    bool isUnderline = textStyleNotifier.isUnderline;
    bool isBorder = textStyleNotifier.isBorder;

    switch (type) {
      case ButtonType.elevated:
        return ElevatedButtonData(
          id: buttonId,
          type: type,
          text: text,
          document: document,
          color: backgroundColor,
          textColor: textColor,
          isBold: isBold,
          isItalic: isItalic,
          isUnderline: isUnderline,
          isBorder: isBorder,
        );
      case ButtonType.outlined:
        return OutlinedButtonData(
          id: buttonId,
          type: type,
          text: text,
          document: document,
          isBold: isBold,
          isItalic: isItalic,
          isUnderline: isUnderline,
          isBorder: isBorder,
        );
      case ButtonType.adaptive:
        return AdaptiveButtonData(
          id: buttonId,
          type: type,
          text: text,
          document: document,
          isBold: isBold,
          isItalic: isItalic,
          isUnderline: isUnderline,
          isBorder: isBorder,
        );
      default:
        throw Exception('Tipo de botón no soportado: $type');
    }
  }

ButtonData updateButton(
  ButtonData originalButton,
  Map<String, dynamic> newValues,
) {
  switch (originalButton.type) {
    case ButtonType.elevated:
      return (originalButton as ElevatedButtonData).copyWith(
        text: newValues['text'] ?? originalButton.text,
        document: newValues['document'] ?? originalButton.document,
        color: newValues['color'] ?? originalButton.color,
        textColor: newValues['textColor'] ?? originalButton.textColor,
        isBold: newValues['isBold'] ?? originalButton.isBold,
        isItalic: newValues['isItalic'] ?? originalButton.isItalic,
        isUnderline: newValues['isUnderline'] ?? originalButton.isUnderline,
        isBorder: newValues['isBorder'] ?? originalButton.isBorder,
        // Otros parámetros específicos
      );
    case ButtonType.outlined:
      return (originalButton as OutlinedButtonData).copyWith(
        text: newValues['text'] ?? originalButton.text,
        document: newValues['document'] ?? originalButton.document,
        isBold: newValues['isBold'] ?? originalButton.isBold,
        isItalic: newValues['isItalic'] ?? originalButton.isItalic,
        isUnderline: newValues['isUnderline'] ?? originalButton.isUnderline,
        isBorder: newValues['isBorder'] ?? originalButton.isBorder,
        // Otros parámetros específicos
      );
    case ButtonType.adaptive:
      return (originalButton as AdaptiveButtonData).copyWith(
        text: newValues['text'] ?? originalButton.text,
        document: newValues['document'] ?? originalButton.document,
        isBold: newValues['isBold'] ?? originalButton.isBold,
        isItalic: newValues['isItalic'] ?? originalButton.isItalic,
        isUnderline: newValues['isUnderline'] ?? originalButton.isUnderline,
        isBorder: newValues['isBorder'] ?? originalButton.isBorder,
        // Otros parámetros específicos
      );
    default:
      throw Exception('Tipo de botón no soportado: ${originalButton.type}');
  }
}

}
