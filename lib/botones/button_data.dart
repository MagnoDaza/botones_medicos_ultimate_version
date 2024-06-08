import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:uuid/uuid.dart';

import '../controller/color_notifier.dart';
import '../controller/text_style_notifier.dart';
import 'boton/adaptive_button.dart';
import 'boton/elevated_button_data.dart';
import 'boton/outlined_button_data.dart';
import 'button_sheet.dart';

//--Clase genérica de botones
enum ButtonType { elevated, outlined, adaptive }

abstract class ButtonData {
  final String id;
  final ButtonType type;
  final String text;
  final QuillController controller;

  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final bool isBorder;

  ButtonData({
    required this.id,
    required this.type,
    required this.text,
    required this.controller,
    required this.isBold,
    required this.isItalic,
    required this.isBorder,
    required this.isUnderline,
  });

  void onPressed(BuildContext context) {
    showCustomBottomSheet(
      context: context,
      controller: controller,
      builder: (BuildContext context) {},
    );
  }

  Widget build(BuildContext context);

  //-- Método para clonar el botón con un nuevo texto y nuevo  isBold, isItalic, isUnderline, isBorder
  ButtonData cloneWithText(String newText, bool newIsBold, bool newIsItalic,
      bool newIsUnderline, bool newIsBorder) {
    return copyWith(
      text: newText,
      isBold: newIsBold,
      isItalic: newIsItalic,
      isUnderline: newIsUnderline,
      isBorder: newIsBorder,
    );
  }

  ButtonData copyWith({
    String? text,
    QuillController? controller,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    bool? isBorder,
  });
}

// Fábrica de botones que también maneja la actualización
class ButtonFactory {
  final ColorNotifier colorNotifier;
  final TextStyleNotifier textStyleNotifier;

  ButtonFactory(this.colorNotifier, this.textStyleNotifier);

  ButtonData createButton(
      ButtonType type, String text, QuillController controller) {
    String buttonId = const Uuid().v4();
    Color backgroundColor = colorNotifier.getBackgroundColor(buttonId);
    Color textColor = colorNotifier.getTextColor(buttonId);
    bool isBold = textStyleNotifier.isBold;
    bool isItalic = textStyleNotifier.isItalic;
    bool isUnderline = textStyleNotifier.isUnderline;
    bool isBorder = textStyleNotifier.isBorder;

    // Creación de botones según el tipo
    switch (type) {
      case ButtonType.elevated:
        return ElevatedButtonData(
          id: buttonId,
          type: type,
          text: text,
          controller: controller,
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
          controller: controller,
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
          controller: controller,
          isBold: isBold,
          isItalic: isItalic,
          isUnderline: isUnderline,
          isBorder: isBorder,
        );
      default:
        throw Exception('Tipo de botón no soportado: $type');
    }
  }

  // Método unificado para actualizar botones
  ButtonData updateButton(ButtonData button, Map<String, dynamic> newValues) {
    // Actualización de botones según el tipo
    return button.copyWith(
      text: newValues['text'],
      controller: newValues['controller'],
      isBold: newValues['isBold'],
      isItalic: newValues['isItalic'],
      isUnderline: newValues['isUnderline'],
      isBorder: newValues['isBorder'],
    );
  }
}
