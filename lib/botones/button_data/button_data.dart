import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../buttons_types/adaptive_button.dart';
import '../buttons_types/colorful_button_data.dart';
import '../buttons_types/elevated_button_data.dart';
import '../buttons_types/outlined_button_data.dart';

// Enum para tipos de botones
enum ButtonType { elevated, outlined, adaptive, colorful, }

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
  final bool isHidden; // Nueva propiedad para manejar visibilidad

  ButtonData({
    required this.id,
    required this.type,
    required this.text,
    required this.document,
     this.isBold = false,
     this.isItalic  = false,
     this.isUnderline = false,
     this.isBorder  = false,
    this.isHidden = false, // Valor predeterminado es falso
  });

  // Construir el widget del botón
  Widget build(BuildContext context);


  // Método copyWith para actualizar propiedades
  ButtonData copyWith({
    String? text,
    Document? document,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    bool? isBorder,
    bool? isHidden,
    required String id,
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
      'isHidden': isHidden ? 1 : 0,
    };
  }

  // Método para crear una instancia desde JSON
  static ButtonData fromJson(Map<String, dynamic> json) {
    ButtonType type = ButtonType.values.firstWhere((e) => e.toString() == json['type']);
    switch (type) {
      case ButtonType.elevated:
        return ElevatedButtonData.fromJson(json);
      case ButtonType.outlined:
        return OutlinedButtonData.fromJson(json);
      case ButtonType.adaptive:
        return AdaptiveButtonData.fromJson(json);
      case ButtonType.colorful:
        return ColorfulButtonData.fromJson(json);
      default:
        throw Exception("Unknown button type");
    }
  }
}
