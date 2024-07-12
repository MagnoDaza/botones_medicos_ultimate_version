import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../botones/button_data.dart';
import '../controller/text_style_notifier.dart';
import '../botones/patron_builder/button_builder.dart';

class PreviewButton extends StatelessWidget {
  final TextEditingController controller;
  final TextStyleNotifier textStyleNotifier;
  final ButtonData? buttonData;
  final QuillController? quillController;

  const PreviewButton({
    Key? key,
    required this.controller,
    required this.textStyleNotifier,
    this.buttonData,
    this.quillController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ButtonBuilder builder = ButtonBuilder();
    // Si se proporciona un ButtonData existente, inicializa el builder con él
    if (buttonData != null) {
      builder.fromButtonData(buttonData!);
    }
    // Actualiza el builder con los nuevos valores
    builder
        .setText(controller.text)
        .setBold(textStyleNotifier.isBold)
        .setItalic(textStyleNotifier.isItalic)
        .setUnderline(textStyleNotifier.isUnderline)
        .setBorder(textStyleNotifier.isBorder)
        .setDocument(quillController?.document ?? buttonData?.document ?? Document());
    // Construye el botón actualizado
    ButtonData updatedButton = builder.build();
    return Center(
      child: updatedButton.build(context),
    );
  }
}
