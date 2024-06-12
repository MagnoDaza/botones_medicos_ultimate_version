import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import '../botones/widget/rainbow_icon.dart';
import '../widget/color_picker_dialog.dart';

class ColorChoice {
  final Color color;
  final String name;

  ColorChoice({required this.color, required this.name});
}

class CustomColorButtonRow extends StatefulWidget {
  final Function(Color) updateButtonColor;
  final Color initialColor;
  final List<ColorChoice> colorChoices;

  CustomColorButtonRow({
    super.key,
    required this.updateButtonColor,
    this.initialColor = Colors.white,
    List<ColorChoice>? colorChoices,
  }) : colorChoices = colorChoices ??
            [
              ColorChoice(color: Colors.white, name: 'Blanco'),
              ColorChoice(color: Colors.black, name: 'Negro'),
            ];

  @override
  _CustomColorButtonRowState createState() => _CustomColorButtonRowState();
}

class _CustomColorButtonRowState extends State<CustomColorButtonRow> {
  late Color currentColor;

  @override
  void initState() {
    super.initState();
    currentColor = widget.initialColor;
  }

  void _showColorPicker() {
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
            return Icon(Icons.circle, color: item.value);
          },
          value: currentColor,
          onChanged: (val) {
            if (val == Colors.transparent) {
              _showColorPicker();
            } else {
              setState(() {
                currentColor = val;
              });
              widget.updateButtonColor(val);
            }
          },
          choiceItems: [
            ...widget.colorChoices.map((choice) {
              return C2Choice<Color>(value: choice.color, label: choice.name);
            }).toList(),
            C2Choice<Color>(value: Colors.transparent, label: 'Custom'),
          ],
        ),
      ],
    );
  }
}
