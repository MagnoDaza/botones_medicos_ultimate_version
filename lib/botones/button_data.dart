import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'boton/adaptive_button.dart';
import 'boton/elevated_button_data.dart';
import 'boton/outlined_button_data.dart';

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

  // Construir el widget del botón
  Widget build(BuildContext context);

  // Clonar el botón con nuevo texto y estilos
  ButtonData cloneWithText({
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

  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'text': text,
      'document': document.toDelta().toJson(),
      'isBold': isBold ? 1 : 0,
      'isItalic': isItalic ? 1 : 0,
      'isUnderline': isUnderline ? 1 : 0,
      'isBorder': isBorder ? 1 : 0,
    };
  }

  // Método para crear una instancia desde JSON
  static ButtonData fromJson(Map<String, dynamic> json) {
    ButtonType type =
        ButtonType.values.firstWhere((e) => e.toString() == json['type']);
    switch (type) {
      case ButtonType.elevated:
        return ElevatedButtonData.fromJson(json);
      case ButtonType.outlined:
        return OutlinedButtonData.fromJson(json);
      case ButtonType.adaptive:
        return AdaptiveButtonData.fromJson(json);
      default:
        throw Exception("Unknown button type");
    }
  }
}
