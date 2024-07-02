import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import '../botones/button_data.dart';
import '../controller/button_model.dart';
import '../controller/text_style_notifier.dart';

class ButtonPreview extends StatelessWidget {
  final TextEditingController controller;
  final TextStyleNotifier textStyleNotifier;
  final ButtonData? buttonData; // Nuevo parámetro opcional
  final QuillController? quillController; // Nuevo parámetro opcional

  ButtonPreview({
    required this.controller,
    required this.textStyleNotifier,
    this.buttonData,
    this.quillController,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ButtonModel>(
      builder: (context, buttonModel, child) {
        final selectedButton = buttonModel.factoryButtons.isNotEmpty
            ? buttonModel.factoryButtons[buttonModel.selectedIndex]
            : null;

        if (selectedButton == null && buttonData == null) {
          return const Center(child: Text('No se ha seleccionado ningún botón.'));
        }

        // Determinar qué datos usar: los del botón existente o los nuevos
        final buttonToUse = selectedButton ?? buttonData!;

        // Actualizar el controlador de texto y Quill solo si buttonData está presente
        if (buttonData != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.text = buttonData!.text;
            if (quillController != null) {
              quillController!.document = buttonData!.document;
            }
            textStyleNotifier.isBold = buttonData!.isBold;
            textStyleNotifier.isItalic = buttonData!.isItalic;
            textStyleNotifier.isUnderline = buttonData!.isUnderline;
            textStyleNotifier.isBorder = buttonData!.isBorder;
          });
        }

        // Mostrar solo la previsualización del botón seleccionado o cargado
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buttonToUse.build(context),
            const SizedBox(height: 10),
            Text(
              buttonToUse.type.toString().split('.').last,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }
}
