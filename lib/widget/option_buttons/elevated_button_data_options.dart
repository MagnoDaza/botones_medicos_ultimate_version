import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../botones/boton_types/elevated_button_data.dart';
import '../../botones/button_data/button_data.dart';
import '../../common/color_icon/rainbow_icon.dart';
import '../../controller/button_model.dart';
import '../../controller/color_notifier.dart';
import '../../controller/text_style_notifier.dart';
import '../expansion_panel/custom_expansion_panel.dart';
import 'buttondataoptions.dart';
import 'color_options/custom_color_row.dart';


class ElevatedButtonDataOptions extends ButtonDataOptions {
  const ElevatedButtonDataOptions({Key? key, required TextStyleNotifier textStyleNotifier})
      : super(key: key, textStyleNotifier: textStyleNotifier);

  @override
  Widget build(BuildContext context) {
    final buttonModel = Provider.of<ButtonModel>(context, listen: false);
    final ButtonData buttonData = buttonModel.temporaryButton!;
    final ElevatedButtonData elevatedButtonData = buttonData as ElevatedButtonData;

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
      ],
    );
  }
}
