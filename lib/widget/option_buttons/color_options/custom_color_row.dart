import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import '../../../common/color_icon/rainbow_icon.dart';

import 'color_picker_dialog.dart';

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
  Color customColor = Colors.transparent;
  List<ColorChoice> displayedChoices = [];

  @override
  void initState() {
    super.initState();
    currentColor = widget.initialColor;
    displayedChoices = List.from(widget.colorChoices);
    if (!widget.colorChoices
        .any((choice) => choice.color == widget.initialColor)) {
      displayedChoices
          .add(ColorChoice(color: widget.initialColor, name: 'Custom'));
    }
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ColorPickerDialog(
          enableAlpha: false,
          pickerColor:
              customColor == Colors.transparent ? currentColor : customColor,
          onColorChanged: (color) {
            if (mounted) {
              setState(() {
                customColor = color;
                if (!displayedChoices.any((choice) => choice.color == color)) {
                  displayedChoices
                      .add(ColorChoice(color: color, name: 'Custom'));
                }
                currentColor = color;
              });
            }
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
            if (item.value == Colors.transparent) {
              return customColor == Colors.transparent
                  ? RainbowIcon(iconData: Icons.circle)
                  : Icon(Icons.circle, color: customColor);
            } else {
              return Icon(Icons.circle, color: item.value);
            }
          },
          value: currentColor,
          onChanged: (val) {
            if (val == Colors.transparent) {
              _showColorPicker();
            } else {
              setState(() {
                currentColor = val;
                customColor = Colors.transparent; // Reset customColor
              });
              widget.updateButtonColor(val);
            }
          },
          choiceItems: [
            ...displayedChoices.map((choice) {
              return C2Choice<Color>(value: choice.color, label: choice.name);
            }).toList(),
            const C2Choice<Color>(value: Colors.transparent, label: 'Custom'),
          ],
        ),
      ],
    );
  }
}
