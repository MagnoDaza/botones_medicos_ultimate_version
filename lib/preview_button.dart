import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../botones/button_data.dart';
import '../controller/text_style_notifier.dart';
import '../botones/boton/button_factory.dart';

class PreviewButton extends StatelessWidget {
  final TextEditingController controller;
  final TextStyleNotifier textStyleNotifier;
  final ButtonData? buttonData;
  final QuillController? quillController;
  final ButtonFactory buttonFactory;

  const PreviewButton({
    Key? key,
    required this.controller,
    required this.textStyleNotifier,
    this.buttonData,
    this.quillController,
    required this.buttonFactory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (buttonData == null) {
      return Center(child: Text('Selecciona un tipo de botón'));
    }

    final updatedButton = buttonFactory.updateButton(
      buttonData!,
      {
        'text': controller.text,
        'isBold': textStyleNotifier.isBold,
        'isItalic': textStyleNotifier.isItalic,
        'isUnderline': textStyleNotifier.isUnderline,
      },
    );

    return Center(
      child: updatedButton.build(context),
    );
  }
}
