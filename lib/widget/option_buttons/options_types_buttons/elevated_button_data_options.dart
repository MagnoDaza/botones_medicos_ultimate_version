import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../botones/buttons_types/elevated_button_data.dart';
import '../../../botones/button_data/button_data.dart';
import '../../../common/color_icon/rainbow_icon.dart';
import '../../../controller/button_model.dart';
import '../../../controller/color_notifier.dart';
import '../../../controller/text_style_notifier.dart';
import '../../expansion_panel/custom_expansion_panel.dart';
import '../buttondataoptions.dart';
import '../color_options/custom_color_row.dart';
import '../custom_switch_row.dart';

class ElevatedButtonDataOptions extends ButtonDataOptions {
  const ElevatedButtonDataOptions(
      {Key? key, required TextStyleNotifier textStyleNotifier})
      : super(key: key, textStyleNotifier: textStyleNotifier);

  @override
  Widget build(BuildContext context) {
    final buttonModel = Provider.of<ButtonModel>(context, listen: false);
    final ButtonData? buttonData = buttonModel.temporaryButton;

    if (buttonData == null || buttonData is! ElevatedButtonData) {
      // Mostrar un widget de error o una vista vacía si buttonData es nulo o no es del tipo correcto
      return const Center(
          child:
              Text('Error: No hay datos disponibles para el botón elevado.'));
    }

    final ElevatedButtonData elevatedButtonData = buttonData;

    return Column(
      children: [
        CustomExpansionPanel(
          items: [
            PanelItem(
              leading: RainbowIcon(iconData: Icons.format_color_fill),
              headerValue: 'Color de fondo',
              expandedValue: [
                CustomColorButtonRow(
                  initialColor: elevatedButtonData.color,
                  updateButtonColor: (Color newColor) {
                    buttonModel.updateButton(
                      buttonData.copyWith(color: newColor),
                    );
                    Provider.of<ColorNotifier>(context, listen: false)
                        .setBackgroundColor(buttonData.id, newColor);
                  },
                  colorChoices: [
                    ColorChoice(color: const Color(0xFF4F4F4F), name: 'Gris'),
                    ColorChoice(color: const Color(0xFF2196F3), name: 'Azul'),
                  ],
                ),
              ],
            ),
            PanelItem(
              leading: RainbowIcon(iconData: Icons.format_color_text),
              headerValue: "Color de texto",
              expandedValue: [
                CustomColorButtonRow(
                  initialColor: elevatedButtonData.textColor,
                  updateButtonColor: (Color newColor) {
                    buttonModel.updateButton(
                      buttonData.copyWith(textColor: newColor),
                    );
                    Provider.of<ColorNotifier>(context, listen: false)
                        .setTextColor(buttonData.id, newColor);
                  },
                ),
              ],
            ),
          ],
        ),
        CustomSwitchRow(
          initialValue: elevatedButtonData.isBold,
          updateButtonAttribute: (bool newValue) {
            buttonModel.updateButton(
              buttonData.copyWith(isBold: newValue),
            );
            Provider.of<TextStyleNotifier>(context, listen: false)
                .setBold(newValue);
          },
          label: 'Negrita',
          iconData: Icons.format_bold,
        ),
        CustomSwitchRow(
          initialValue: elevatedButtonData.isItalic,
          updateButtonAttribute: (bool newValue) {
            buttonModel.updateButton(
              buttonData.copyWith(isItalic: newValue),
            );
            Provider.of<TextStyleNotifier>(context, listen: false)
                .setItalic(newValue);
          },
          label: 'Itálica',
          iconData: Icons.format_italic,
        ),
        CustomSwitchRow(
          initialValue: elevatedButtonData.isUnderline,
          updateButtonAttribute: (bool newValue) {
            buttonModel.updateButton(
              buttonData.copyWith(isUnderline: newValue),
            );
            Provider.of<TextStyleNotifier>(context, listen: false)
                .setUnderline(newValue);
          },
          label: 'Subrayado',
          iconData: Icons.format_underline,
        ),
        CustomSwitchRow(
          initialValue: elevatedButtonData.isBorder,
          updateButtonAttribute: (bool newValue) {
            buttonModel.updateButton(
              buttonData.copyWith(isBorder: newValue),
            );
            Provider.of<TextStyleNotifier>(context, listen: false)
                .setBorder(newValue);
          },
          label: 'Borde',
          iconData: Icons.border_outer,
        ),
      ],
    );
  }
}
