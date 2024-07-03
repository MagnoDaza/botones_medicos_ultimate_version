import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:uuid/uuid.dart';

import '../boton/adaptive_button.dart';
import '../boton/elevated_button_data.dart';
import '../boton/outlined_button_data.dart';
import '../button_data.dart';

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

  ButtonData build() {
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
          color: color!,
          textColor: textColor!,
          isBold: isBold!,
          isItalic: isItalic!,
          isUnderline: isUnderline!,
          isBorder: isBorder!,
        );
      case ButtonType.outlined:
        return OutlinedButtonData(
          id: buttonId,
          type: buttonType,
          text: buttonText,
          document: buttonDocument,
          isBold: isBold!,
          isItalic: isItalic!,
          isUnderline: isUnderline!,
          isBorder: isBorder!,
        );
      case ButtonType.adaptive:
        return AdaptiveButtonData(
          id: buttonId,
          type: buttonType,
          text: buttonText,
          document: buttonDocument,
          isBold: isBold!,
          isItalic: isItalic!,
          isUnderline: isUnderline!,
          isBorder: isBorder!,
        );
      default:
        throw Exception('Tipo de botón no soportado: $buttonType');
    }
  }
}
