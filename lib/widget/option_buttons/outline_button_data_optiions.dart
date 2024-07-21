import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../botones/boton_types/outlined_button_data.dart';
import '../../botones/button_data/button_data.dart';
import '../../controller/button_model.dart';
import '../../controller/text_style_notifier.dart';
import 'buttondataoptions.dart';
import 'custom_switch_row.dart';

class OutlinedButtonDataOptions extends ButtonDataOptions {
  const OutlinedButtonDataOptions(
      {Key? key, required TextStyleNotifier textStyleNotifier})
      : super(key: key, textStyleNotifier: textStyleNotifier);

  @override
  Widget build(BuildContext context) {
    final buttonModel = Provider.of<ButtonModel>(context, listen: false);
    final ButtonData? buttonData = buttonModel.temporaryButton;

    if (buttonData == null || buttonData is! OutlinedButtonData) {
      // Mostrar un widget de error o una vista vacía si buttonData es nulo o no es del tipo correcto
      return Center(
          child:
              Text('Error: No hay datos disponibles para el botón delineado.'));
    }

    final OutlinedButtonData outlinedButtonData = buttonData;

    return Column(
      children: [
        CustomSwitchRow(
          initialValue: outlinedButtonData.isBold,
          updateButtonAttribute: (bool newValue) {
            buttonModel.updateButton(
              buttonData.copyWith(isBold: newValue),
            );
            textStyleNotifier.setBold(newValue);
          },
          label: 'Negrita',
          iconData: Icons.format_bold,
        ),
        CustomSwitchRow(
          initialValue: outlinedButtonData.isItalic,
          updateButtonAttribute: (bool newValue) {
            buttonModel.updateButton(
              buttonData.copyWith(isItalic: newValue),
            );
            textStyleNotifier.setItalic(newValue);
          },
          label: 'Itálica',
          iconData: Icons.format_italic,
        ),
        CustomSwitchRow(
          initialValue: outlinedButtonData.isUnderline,
          updateButtonAttribute: (bool newValue) {
            buttonModel.updateButton(
              buttonData.copyWith(isUnderline: newValue),
            );
            textStyleNotifier.setUnderline(newValue);
          },
          label: 'Subrayado',
          iconData: Icons.format_underline,
        ),
        CustomSwitchRow(
          initialValue: outlinedButtonData.isBorder,
          updateButtonAttribute: (bool newValue) {
            buttonModel.updateButton(
              buttonData.copyWith(isBorder: newValue),
            );
            textStyleNotifier.setBorder(newValue);
          },
          label: 'Borde',
          iconData: Icons.border_outer,
        ),
      ],
    );
  }
}
