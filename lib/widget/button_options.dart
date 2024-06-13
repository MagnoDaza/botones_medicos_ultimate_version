import 'package:botones_medicos_ultimate_version/botones/widget/rainbow_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../botones/boton/elevated_button_data.dart';
import '../botones/button_data.dart';
import '../botones/widget/expansion_panel/custom_expansion_panel.dart';
import '../controller/button_model.dart';
import '../controller/color_notifier.dart';
import '../controller/text_style_notifier.dart';
// import '../rowbuttoncolor/button_row_fondo.dart';
// import '../rowbuttoncolor/color_button_text.dart';
import '../rowbuttoncolor/custom_color_row.dart';

class ButtonOptions extends StatefulWidget {
  final TextEditingController buttonTextController;
  final TextStyleNotifier textStyleNotifier;

  const ButtonOptions({
    super.key,
    required this.buttonTextController,
    required this.textStyleNotifier,
  });

  @override
  createState() => ButtonOptionsState();
}

class ButtonOptionsState extends State<ButtonOptions> {
  ButtonType? lastButtonType;

  @override
  Widget build(BuildContext context) {
    return Consumer<ButtonModel>(
      builder: (context, buttonModel, child) {
        if (buttonModel.factoryButtons.isEmpty) {
          return const Center(child: Text("Escribe un nombre para empezar"));
        }

        ButtonData buttonData =
            buttonModel.factoryButtons[buttonModel.selectedIndex];

        // Reset TextStyleNotifier to default values when button type changes new button type and old button

        if (lastButtonType != buttonData.type) {
          lastButtonType = buttonData.type;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<TextStyleNotifier>().reset();
          });
        }

        switch (buttonData.type) {
          case ButtonType.elevated:
            ElevatedButtonData elevatedButtonData =
                buttonData as ElevatedButtonData;
            return Column(
              children: [
                CustomExpansionPanel(items: [
                  PanelItem(
                      leading: RainbowIcon(
                        iconData: Icons.format_color_fill,
                      ),
                      headerValue: 'Color de fondo',
                      expandedValue: [
                        CustomColorButtonRow(
                          initialColor: const Color(0xFF4F4F4F),
                          updateButtonColor: (Color newColor) {
                            buttonModel.updateButton(
                              buttonModel.selectedIndex,
                              elevatedButtonData.copyWith(color: newColor),
                            );
                            Provider.of<ColorNotifier>(context, listen: false)
                                .setBackgroundColor(buttonData.id, newColor);
                          },
                          colorChoices: [
                            ColorChoice(
                                color: const Color(0xFF4F4F4F), name: 'Gris'),
                            ColorChoice(
                                color: const Color(0xFF2196F3), name: 'Azul'),
                          ],
                        ),
                      ]),
                  PanelItem(
                    leading: RainbowIcon(iconData: Icons.format_color_text),
                    headerValue: "Color de texto",
                    expandedValue: [
                      CustomColorButtonRow(
                          initialColor: Colors.white,
                          updateButtonColor: (Color newColor) {
                            buttonModel.updateButton(
                              buttonModel.selectedIndex,
                              elevatedButtonData.copyWith(textColor: newColor),
                            );
                            Provider.of<ColorNotifier>(context, listen: false)
                                .setTextColor(buttonData.id, newColor);
                          }),
                    ],
                  ),
                  PanelItem(
                    leading: const Icon(Icons.format_italic),
                    headerValue: "Estilos de texto",
                    expandedValue: [
                      TextStyleOptions(
                          textStyleNotifier: widget.textStyleNotifier),
                    ],
                  ),
                ]),

                // ColorButtonRowFondo(
                //   initialColor: elevatedButtonData.color,
                //   updateButtonColor: (Color newColor) {
                //     buttonModel.updateButton(
                //       buttonModel.selectedIndex,
                //       elevatedButtonData.copyWith(color: newColor),
                //     );
                //     Provider.of<ColorNotifier>(context, listen: false)
                //         .setBackgroundColor(buttonData.id, newColor);
                //   },
                // // ),

                // TextColorButtonRow(
                //   initialColor: elevatedButtonData.textColor,
                //   updateButtonTextColor: (Color newColor) {
                //     buttonModel.updateButton(
                //       buttonModel.selectedIndex,
                //       elevatedButtonData.copyWith(textColor: newColor),
                //     );
                //     Provider.of<ColorNotifier>(context, listen: false)
                //         .setTextColor(buttonData.id, newColor);
                //   },
                // ),
              ],
            );
          case ButtonType.outlined:
            return Column(
              children: [
                CustomExpansionPanel(items: [
                  PanelItem(
                      leading: const Icon(Icons.format_italic),
                      headerValue: "Estilos de texto",
                      expandedValue: [
                        TextStyleOptions(
                            textStyleNotifier: widget.textStyleNotifier),
                      ])
                ]),
              ],
            );
          // Implementar opciones para OutlinedButton
          case ButtonType.adaptive:
            return Column(
              children: [
                customStylesExpansionPanelWidget(widget.textStyleNotifier),
              ],
            );
          // Implementar opciones para AdaptiveButton
          default:
            return Text("Tipo de botón no soportado: ${buttonData.type}");
        }
      },
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

//create a function to add a all button options to the button the same at buttonoption

  


