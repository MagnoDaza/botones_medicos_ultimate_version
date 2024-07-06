import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../botones/boton/elevated_button_data.dart';
import '../botones/widget/expansion_panel/custom_expansion_panel.dart';
import '../botones/widget/rainbow_icon.dart';
import '../controller/button_model.dart';
import '../controller/color_notifier.dart';
import '../controller/text_style_notifier.dart';
import '../botones/button_data.dart';
import '../rowbuttoncolor/custom_color_row.dart';
class ButtonOptions extends StatefulWidget {
  final TextEditingController buttonTextController;
  final TextStyleNotifier textStyleNotifier;
  final ButtonType? selectedButtonType;

  const ButtonOptions({
    super.key,
    required this.buttonTextController,
    required this.textStyleNotifier,
    this.selectedButtonType,
  });

  @override
  createState() => ButtonOptionsState();
}

class ButtonOptionsState extends State<ButtonOptions> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ButtonModel>(
      builder: (context, buttonModel, child) {
        if (widget.selectedButtonType == null) {
          return const Center(child: Text("Selecciona un tipo de botón"));
        }

        final buttonData = buttonModel.temporaryButton;

        if (buttonData == null) {
          return const Center(child: Text("Escribe un nombre para empezar"));
        }

        // Sincronizar el estilo del texto con el ButtonData actual
        _syncTextStyleWithButtonData(buttonData);

        switch (buttonData.type) {
          case ButtonType.elevated:
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
                    PanelItem(
                      leading: const Icon(Icons.format_italic),
                      headerValue: "Estilos de texto",
                      expandedValue: [
                        TextStyleOptions(textStyleNotifier: widget.textStyleNotifier),
                      ],
                    ),
                  ],
                ),
              ],
            );
          case ButtonType.outlined:
          case ButtonType.adaptive:
            return Column(
              children: [
                CustomExpansionPanel(
                  items: [
                    PanelItem(
                      leading: const Icon(Icons.format_italic),
                      headerValue: "Estilos de texto",
                      expandedValue: [
                        TextStyleOptions(textStyleNotifier: widget.textStyleNotifier),
                      ],
                    ),
                  ],
                ),
              ],
            );
          default:
            return Text("Tipo de botón no soportado: ${buttonData.type}");
        }
      },
    );
  }

  // Sincroniza el estilo del texto con el buttonData actual
  void _syncTextStyleWithButtonData(ButtonData buttonData) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.textStyleNotifier.updateTextStyle(
        isBold: buttonData.isBold,
        isItalic: buttonData.isItalic,
        isUnderline: buttonData.isUnderline,
        isBorder: buttonData.isBorder,
      );
    });
  }
}

  



class TextStyleOptions extends StatefulWidget {
  final TextStyleNotifier textStyleNotifier;

  const TextStyleOptions({
    Key? key,
    required this.textStyleNotifier,
  }) : super(key: key);

  @override
  _TextStyleOptionsState createState() => _TextStyleOptionsState();
}

class _TextStyleOptionsState extends State<TextStyleOptions> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TextStyleNotifier>(
      builder: (context, textStyleNotifier, child) {
        return Column(
          children: [
            SwitchListTile(
              title: const Text('Negrita',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              value: textStyleNotifier.isBold,
              onChanged: (bool value) {
                textStyleNotifier.isBold = value;
                Provider.of<ButtonModel>(context, listen: false)
                    .updateButtonTextStyle(
                  textStyleNotifier.isBold,
                  textStyleNotifier.isItalic,
                  textStyleNotifier.isUnderline,
                  textStyleNotifier.isBorder,
                );
              },
            ),
            SwitchListTile(
              title: const Text('Itálica',
                  style: TextStyle(fontStyle: FontStyle.italic)),
              value: textStyleNotifier.isItalic,
              onChanged: (bool value) {
                textStyleNotifier.isItalic = value;
                Provider.of<ButtonModel>(context, listen: false)
                    .updateButtonTextStyle(
                  textStyleNotifier.isBold,
                  textStyleNotifier.isItalic,
                  textStyleNotifier.isUnderline,
                  textStyleNotifier.isBorder,
                );
              },
            ),
            SwitchListTile(
              title: const Text('Subrayado'),
              value: textStyleNotifier.isUnderline,
              onChanged: (bool value) {
                textStyleNotifier.isUnderline = value;
                Provider.of<ButtonModel>(context, listen: false)
                    .updateButtonTextStyle(
                  textStyleNotifier.isBold,
                  textStyleNotifier.isItalic,
                  textStyleNotifier.isUnderline,
                  textStyleNotifier.isBorder,
                );
              },
            ),
            SwitchListTile(
              title: const Text('Borde'),
              value: textStyleNotifier.isBorder,
              onChanged: (bool value) {
                textStyleNotifier.isBorder = value;
                Provider.of<ButtonModel>(context, listen: false)
                    .updateButtonTextStyle(
                  textStyleNotifier.isBold,
                  textStyleNotifier.isItalic,
                  textStyleNotifier.isUnderline,
                  textStyleNotifier.isBorder,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

Widget customStylesExpansionPanelWidget(TextStyleNotifier textStyleNotifier) {
  return CustomExpansionPanel(
    items: [
      PanelItem(
        leading: const Icon(Icons.format_italic),
        headerValue: "Estilos de texto",
        expandedValue: [
          TextStyleOptions(textStyleNotifier: textStyleNotifier),
        ],
      ),
    ],
  );
}
