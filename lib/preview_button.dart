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
        return ScrollSnapList(
          dynamicItemOpacity: 0.5,
          onItemFocus: (index) {
            final selectedButton = buttonModel.factoryButtons[index];
            // Clonar texto del botón y actualizar controlador de texto
            Provider.of<ButtonModel>(context, listen: false).cloneText(
              index,
              controller.text,
              isBold: textStyleNotifier.isBold,
              isItalic: textStyleNotifier.isItalic,
              isUnderline: textStyleNotifier.isUnderline,
              isBorder: textStyleNotifier.isBorder,
              document: Document.fromJson(selectedButton.document
                  .toDelta()
                  .toJson()), // Asegurar que cada botón tenga su propio documento
            );
            buttonModel.selectButton(index);
            controller.text = selectedButton.text;

            // Si se está editando, actualizar el documento Quill
            if (buttonData != null && quillController != null) {
              quillController!.document = selectedButton.document;
            }
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
