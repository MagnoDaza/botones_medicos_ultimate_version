import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../botones/buttons_types/adaptive_button.dart';
import '../../../botones/button_data/button_data.dart';
import '../../../controller/button_model.dart';
import '../../../controller/text_style_notifier.dart';
import '../buttondataoptions.dart';
import '../custom_switch_row.dart';

class AdaptiveButtonDataOptions extends ButtonDataOptions {
  const AdaptiveButtonDataOptions({Key? key, required TextStyleNotifier textStyleNotifier})
      : super(key: key, textStyleNotifier: textStyleNotifier);

  @override
  Widget build(BuildContext context) {
    final buttonModel = Provider.of<ButtonModel>(context, listen: false);
    final ButtonData? buttonData = buttonModel.temporaryButton;

    if (buttonData == null || buttonData is! AdaptiveButtonData) {
      // Mostrar un widget de error o una vista vacía si buttonData es nulo o no es del tipo correcto
      return const Center(child: Text('Error: No hay datos disponibles para el botón adaptativo.'));
    }

    final AdaptiveButtonData adaptiveButtonData = buttonData;

    return Column(
      children: [
        CustomSwitchRow(
          initialValue: adaptiveButtonData.isBold,
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
          initialValue: adaptiveButtonData.isItalic,
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
          initialValue: adaptiveButtonData.isUnderline,
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
          initialValue: adaptiveButtonData.isBorder,
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
