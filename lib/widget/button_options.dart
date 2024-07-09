import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../botones/button_data.dart';
import '../botones/patron_builder/button_builder.dart';
import '../botones/widget/expansion_panel/custom_expansion_panel.dart';
import '../botones/widget/rainbow_icon.dart';
import '../controller/color_notifier.dart';
import '../controller/text_style_notifier.dart';
import '../rowbuttoncolor/custom_color_row.dart';

import '../controller/button_model.dart';




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

        // Usar ButtonBuilder para sincronizar el estilo del texto con el ButtonData actual
        final buttonBuilder = ButtonBuilder().fromButtonData(buttonData);

        // Asegurarnos de no llamar setState dentro de la fase de construcción
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _syncTextStyleWithButtonData(buttonBuilder);
        });

        switch (buttonBuilder.type) {
          case ButtonType.elevated:
            return Column(
              children: [
                CustomExpansionPanel(
                  items: [
                    PanelItem(
                      leading: RainbowIcon(iconData: Icons.format_color_fill),
                      headerValue: 'Color de fondo',
                      expandedValue: [
                        CustomColorButtonRow(
                          initialColor: buttonBuilder.color!,
                          updateButtonColor: (Color newColor) {
                            buttonModel.updateButton(
                              buttonBuilder
                                  .setColor(newColor)
                                  .build(buttonData: buttonData),
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
                          initialColor: buttonBuilder.textColor!,
                          updateButtonColor: (Color newColor) {
                            buttonModel.updateButton(
                              buttonBuilder
                                  .setTextColor(newColor)
                                  .build(buttonData: buttonData),
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
            return Text("Tipo de botón no soportado: ${buttonBuilder.type}");
        }
      },
    );
  }

  void _syncTextStyleWithButtonData(ButtonBuilder buttonBuilder) {
    widget.buttonTextController.text = buttonBuilder.text ?? '';
    widget.textStyleNotifier.updateTextStyle(
      isBold: buttonBuilder.isBold ?? false,
      isItalic: buttonBuilder.isItalic ?? false,
      isUnderline: buttonBuilder.isUnderline ?? false,
      isBorder: buttonBuilder.isBorder ?? false,
    );
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
