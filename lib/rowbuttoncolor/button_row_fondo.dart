import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import '../botones/widget/rainbow_icon.dart';
import '../widget/color_picker_dialog.dart';

class ColorButtonRowFondo extends StatefulWidget {
  final Function(Color) updateButtonColor;
  final Color initialColor;

  ColorButtonRowFondo({
    required this.updateButtonColor,
    this.initialColor = const Color(0xFF4F4F4F),
  });

  @override
  _ColorButtonRowFondoState createState() => _ColorButtonRowFondoState();
}

class _ColorButtonRowFondoState extends State<ColorButtonRowFondo> {
  late Color currentColor;

  @override
  void initState() {
    super.initState();
    currentColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
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
            if (i < 3) {
              return Icon(Icons.circle, color: item.value);
            } else {
              return RainbowIcon(
                iconData: Icons.circle,
              );
            }
          },
          value: currentColor,
          onChanged: (val) {
            if (val == Colors.transparent) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ColorPickerDialog(
                    enableAlpha: false,
                    pickerColor: currentColor,
                    onColorChanged: (color) {
                      setState(() {
                        currentColor = color;
                      });
                      widget.updateButtonColor(color);
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
                currentColor = val;
              });
              widget.updateButtonColor(val);
            }
          },
          choiceItems: const [
            C2Choice<Color>(value: Color(0xFF4F4F4F), label: 'Gris Oscuro'),
            C2Choice<Color>(value: Color(0xFF939393), label: 'Gris Claro'),
            C2Choice<Color>(
              value: Color.fromARGB(255, 105, 105, 105),
              label: 'Automático',
            ),
            C2Choice<Color>(value: Colors.transparent, label: 'Custom'),
          ],
        ),
      ],
    );
  }
}
