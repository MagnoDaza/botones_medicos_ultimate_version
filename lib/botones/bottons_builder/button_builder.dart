import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:uuid/uuid.dart';

import '../buttons_types/adaptive_button.dart';
import '../buttons_types/elevated_button_data.dart';
import '../buttons_types/outlined_button_data.dart';
import '../button_data/button_data.dart';

class ButtonBuilder {
  String? id;
  ButtonType? type;
  String? text;
  Document? document;
  Color? color;
  Color? textColor;
  bool? isBold;
  bool? isItalic;
  bool? isUnderline;
  bool? isBorder;

  // Constructor privado
  ButtonBuilder._internal();

  // Instancia singleton
  static final ButtonBuilder _instance = ButtonBuilder._internal();

  // Método factory para obtener la instancia
  factory ButtonBuilder() {
    return _instance;
  }

  // Inicializa el builder a partir de ButtonData existente
  ButtonBuilder fromButtonData(ButtonData buttonData) {
    id = buttonData.id;
    type = buttonData.type;
    text = buttonData.text;
    document = buttonData.document;
    isBold = buttonData.isBold;
    isItalic = buttonData.isItalic;
    isUnderline = buttonData.isUnderline;
    isBorder = buttonData.isBorder;

    switch (buttonData.type) {
      case ButtonType.elevated:
        final elevatedButtonData = buttonData as ElevatedButtonData;
        color = elevatedButtonData.color;
        textColor = elevatedButtonData.textColor;
        break;
      case ButtonType.outlined:
        // No hay propiedades específicas adicionales en OutlinedButtonData
        break;
      case ButtonType.adaptive:
        // No hay propiedades específicas adicionales en AdaptiveButtonData
        break;
      default:
        throw Exception('Tipo de botón no soportado: ${buttonData.type}');
    }

    return this;
  }

  // Métodos setters
  ButtonBuilder setId(String id) {
    this.id = id;
    return this;
  }

  ButtonBuilder setType(ButtonType type) {
    this.type = type;
    return this;
  }

  ButtonBuilder setText(String text) {
    this.text = text;
    return this;
  }

  ButtonBuilder setDocument(Document document) {
    this.document = document;
    return this;
  }

  ButtonBuilder setColor(Color color) {
    this.color = color;
    return this;
  }

  ButtonBuilder setTextColor(Color textColor) {
    this.textColor = textColor;
    return this;
  }

  ButtonBuilder setBold(bool isBold) {
    this.isBold = isBold;
    return this;
  }

  ButtonBuilder setItalic(bool isItalic) {
    this.isItalic = isItalic;
    return this;
  }

  ButtonBuilder setUnderline(bool isUnderline) {
    this.isUnderline = isUnderline;
    return this;
  }

  ButtonBuilder setBorder(bool isBorder) {
    this.isBorder = isBorder;
    return this;
  }

  // Construye o actualiza el botón
  ButtonData build({ButtonData? buttonData}) {
    // Si se proporciona buttonData, usarlo como plantilla
    if (buttonData != null) {
      fromButtonData(buttonData);
    }

    String buttonId = id ?? const Uuid().v4();
    ButtonType buttonType = type!;
    String buttonText = text!;
    Document buttonDocument = document!;

    switch (buttonType) {
      case ButtonType.elevated:
        return ElevatedButtonData(
          id: buttonId,
          type: buttonType,
          text: buttonText,
          document: buttonDocument,
          color: color ?? Colors.blue, // Valores por defecto si son null
          textColor: textColor ?? Colors.white,
          isBold: isBold ?? false,
          isItalic: isItalic ?? false,
          isUnderline: isUnderline ?? false,
          isBorder: isBorder ?? false,
        );
      case ButtonType.outlined:
        return OutlinedButtonData(
          id: buttonId,
          type: buttonType,
          text: buttonText,
          document: buttonDocument,
          isBold: isBold ?? false,
          isItalic: isItalic ?? false,
          isUnderline: isUnderline ?? false,
          isBorder: isBorder ?? false,
        );
      case ButtonType.adaptive:
        return AdaptiveButtonData(
          id: buttonId,
          type: buttonType,
          text: buttonText,
          document: buttonDocument,
          isBold: isBold ?? false,
          isItalic: isItalic ?? false,
          isUnderline: isUnderline ?? false,
          isBorder: isBorder ?? false,
        );
      default:
        throw Exception('Tipo de botón no soportado: $buttonType');
    }
  }
}
