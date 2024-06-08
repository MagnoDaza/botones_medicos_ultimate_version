import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:uuid/uuid.dart';

import '../controller/color_notifier.dart';
import '../controller/text_style_notifier.dart';
import 'boton/adaptive_button.dart';
import 'boton/elevated_button_data.dart';
import 'boton/outlined_button_data.dart';
import 'button_sheet.dart';

// Enum para tipos de botones
enum ButtonType { elevated, outlined, adaptive }

// Clase abstracta para datos de botones
abstract class ButtonData {
  final String id;
  final ButtonType type;
  final String text;
  final Document document;
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final bool isBorder;

  ButtonData({
    required this.id,
    required this.type,
    required this.text,
    required this.document,
    required this.isBold,
    required this.isItalic,
    required this.isUnderline,
    required this.isBorder,
  });

  // Mostrar una hoja inferior personalizada
  void onPressed(BuildContext context) {
    QuillController controller = QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
    );
    showCustomBottomSheet(
      context: context,
      controller: controller,
      builder: (BuildContext context) {},
    );
  }

  // Construir el widget del botón
  Widget build(BuildContext context);

  // Clonar el botón con nuevo texto y estilos
  ButtonData cloneWithText({
    required String newText,
    required bool newIsBold,
    required bool newIsItalic,
    required bool newIsUnderline,
    required bool newIsBorder,
  }) {
    return copyWith(
      text: newText,
      isBold: newIsBold,
      isItalic: newIsItalic,
      isUnderline: newIsUnderline,
      isBorder: newIsBorder,
      document: Document.fromJson(document.toDelta().toJson()),
    );
  }

  // Método copyWith para actualizar propiedades
  ButtonData copyWith({
    String? text,
    Document? document,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    bool? isBorder,
  });
}

// Fábrica de botones
class ButtonFactory {
  final ColorNotifier colorNotifier;
  final TextStyleNotifier textStyleNotifier;

  ButtonFactory(this.colorNotifier, this.textStyleNotifier);

  // Crear un botón con los valores iniciales
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

    // Crear botón según el tipo
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

  // Actualizar propiedades del botón
  ButtonData updateButton(ButtonData button, Map<String, dynamic> newValues) {
    return button.copyWith(
      text: newValues['text'],
      document: newValues['document'],
      isBold: newValues['isBold'],
      isItalic: newValues['isItalic'],
      isUnderline: newValues['isUnderline'],
      isBorder: newValues['isBorder'],
    );
  }
}
