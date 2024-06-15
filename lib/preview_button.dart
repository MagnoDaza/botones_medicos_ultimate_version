import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
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
        // Establecer el estado inicial si se está editando un botón
        if (buttonData != null && quillController != null && buttonModel.factoryButtons.isNotEmpty) {
          // Actualizar el controlador de texto y el estado del estilo con los datos del botón a editar
          controller.text = buttonData!.text;
          textStyleNotifier.isBold = buttonData!.isBold;
          textStyleNotifier.isItalic = buttonData!.isItalic;
          textStyleNotifier.isUnderline = buttonData!.isUnderline;
          textStyleNotifier.isBorder = buttonData!.isBorder;
          quillController!.document = buttonData!.document;
        }

        return ScrollSnapList(
          dynamicItemOpacity: 0.5,
          onItemFocus: (index) {
            final selectedButton = buttonModel.factoryButtons[index];
            // Actualizar el controlador de texto y el estado del estilo
            controller.text = selectedButton.text;
            textStyleNotifier.isBold = selectedButton.isBold;
            textStyleNotifier.isItalic = selectedButton.isItalic;
            textStyleNotifier.isUnderline = selectedButton.isUnderline;
            textStyleNotifier.isBorder = selectedButton.isBorder;

            // Si se está editando, actualizar el documento Quill
            if (quillController != null) {
              quillController!.document = selectedButton.document;
            }

            buttonModel.selectButton(index);
          },
          itemSize: 150,
          dynamicItemSize: true,
          itemCount: buttonModel.factoryButtons.length,
          itemBuilder: (context, index) {
            ButtonData buttonData = buttonModel.factoryButtons[index];
            return SizedBox(
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buttonData.build(context),
                  const SizedBox(height: 20),
                  Text(
                    buttonData.type.toString().split('.').last,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
          initialIndex: buttonModel.selectedIndex.toDouble(),
        );
      },
    );
  }
}
