import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
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
