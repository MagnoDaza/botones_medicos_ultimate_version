import 'package:flutter/material.dart';

import 'package:chips_choice/chips_choice.dart';

import '../botones/widget/rainbow_icon.dart';
import '../widget/color_picker_dialog.dart';

class TextColorButtonRow extends StatefulWidget {
  final Function(Color) updateButtonTextColor;

  final Color initialColor;

  const TextColorButtonRow({
    super.key,
    this.initialColor = Colors.white,
    required this.updateButtonTextColor,
  });

  @override
  TextColorButtonRowState createState() => TextColorButtonRowState();
}

class TextColorButtonRowState extends State<TextColorButtonRow> {
  late Color currentTextColor;

  @override
  void initState() {
    super.initState();
    currentTextColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    // Accede al ColorNotifier del contexto para obtener el color actual del texto
    return Wrap(
      alignment: WrapAlignment.center,
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        ChipsChoice<Color>.single(
          alignment: WrapAlignment.center,
          wrapped: true,
          scrollController: ScrollController(),
          scrollToSelectedOnChanged: true,
          direction: Axis.horizontal,
          choiceCheckmark: true,
          choiceLeadingBuilder: (item, i) {
            if (i < 2) {
              return Icon(Icons.circle, color: item.value);
            } else {
              return RainbowIcon(iconData: Icons.circle);
            }
          },
          value: currentTextColor,
          onChanged: (val) {
            if (val == Colors.transparent) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ColorPickerDialog(
                    enableAlpha: false,
                    pickerColor: currentTextColor,
                    onColorChanged: (textColor) {
                      setState(() {
                        currentTextColor = textColor;
                      });
                      widget.updateButtonTextColor(textColor);
                    },
                    colorHistory: [],
                    onHistoryChanged: (List<Color> colors) {
                      Navigator.of(context).pop();
                    },
                  );
                },
              );
            } else {
              setState(() {
                currentTextColor = val;
              });
              widget.updateButtonTextColor(val);
            }
          },
          choiceItems: const [
            C2Choice<Color>(value: Colors.white, label: 'Blanco'),
            C2Choice<Color>(value: Colors.black, label: 'Negro'),
            C2Choice<Color>(value: Colors.transparent, label: 'Custom'),
          ],
        ),
      ],
    );
  }
}
