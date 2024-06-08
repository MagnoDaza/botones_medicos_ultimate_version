import 'package:flutter/material.dart';

import 'widget/color_picker_dialog.dart';

class CustomButtonDialog extends StatefulWidget {
  @override
  _CustomButtonDialogState createState() => _CustomButtonDialogState();
}

class _CustomButtonDialogState extends State<CustomButtonDialog> {
  Color color = Colors.limeAccent;
  Color gradientColor1 = Colors.blue;
  Color gradientColor2 = Colors.red;
  List<Color> colorHistory = [];
  Gradient gradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomCenter,
    colors: [Colors.blue, Colors.red],
    tileMode: TileMode.clamp,
  );
  String gradientType = 'LinearGradient';
  AlignmentGeometry gradientBegin = Alignment.topLeft; // Asegúrate de que esta variable esté definida aquí
  AlignmentGeometry gradientEnd = Alignment.bottomCenter; // Asegúrate de que esta variable esté definida aquí
  TileMode tileMode = TileMode.clamp; // Asegúrate de que esta vari

  void changeColor1(Color color) => setState(() {
    gradientColor1 = color;
    gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomCenter,
      colors: [gradientColor1, gradientColor2],
      tileMode: TileMode.clamp,
    );
  });

  void changeColor2(Color color) => setState(() {
    gradientColor2 = color;
    gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomCenter,
      colors: [gradientColor1, gradientColor2],
      tileMode: TileMode.clamp,
    );
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          DropdownButton<String>(
            value: gradientType,
            onChanged: (String? newValue) {
              setState(() {
                gradientType = newValue ?? 'LinearGradient';
                switch (gradientType) {
                  case 'LinearGradient':
                    gradient = LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: [gradientColor1, gradientColor2],
                      tileMode: TileMode.clamp,
                    );
                    break;
                  case 'RadialGradient':
                    gradient = RadialGradient(colors: [gradientColor1, gradientColor2]);
                    break;
                  case 'SweepGradient':
                    gradient = SweepGradient(colors: [gradientColor1, gradientColor2]);
                    break;
                }
              });
            },
            items: <String>['LinearGradient', 'RadialGradient', 'SweepGradient']
                .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
          ),
          if (gradientType == 'LinearGradient') ...[
            IconButton(
              icon: Icon(Icons.circle, color: gradientColor1),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ColorPickerDialog(
                      pickerColor: gradientColor1,
                      onColorChanged: changeColor1,
                      colorHistory: colorHistory,
                      onHistoryChanged: (List<Color> colors) {
                        colorHistory = colors;
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.circle, color: gradientColor2),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ColorPickerDialog(
                      
                      pickerColor: gradientColor2,
                      onColorChanged: changeColor2,
                      colorHistory: colorHistory,
                      onHistoryChanged: (List<Color> colors) {
                        colorHistory = colors;
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
            ),
  Container(
    child: Row(
      children: <Widget>[
        const Text('Begin:'),
        DropdownButton<AlignmentGeometry>(
          value: gradientBegin,
          onChanged: (AlignmentGeometry? newValue) {
            setState(() {
              gradientBegin = newValue ?? Alignment.topLeft;
              gradient = LinearGradient(
                begin: gradientBegin,
                end: gradientEnd,
                colors: [gradientColor1, gradientColor2],
                tileMode: tileMode,
              );
            });
          },
          items: <AlignmentGeometry>[Alignment.topLeft, Alignment.bottomCenter]
              .map<DropdownMenuItem<AlignmentGeometry>>((AlignmentGeometry value) {
                return DropdownMenuItem<AlignmentGeometry>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
        ),
      ],
    ),
  ),
  Row(
    children: <Widget>[
      const Text('End:'),
      DropdownButton<AlignmentGeometry>(
        value: gradientEnd,
        onChanged: (AlignmentGeometry? newValue) {
          setState(() {
            gradientEnd = newValue ?? Alignment.bottomCenter;
            gradient = LinearGradient(
              begin: gradientBegin,
              end: gradientEnd,
              colors: [gradientColor1, gradientColor2],
              tileMode: tileMode,
            );
          });
        },
        items: <AlignmentGeometry>[Alignment.topLeft, Alignment.bottomCenter]
            .map<DropdownMenuItem<AlignmentGeometry>>((AlignmentGeometry value) {
              return DropdownMenuItem<AlignmentGeometry>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
      ),
    ],
  ),
  Row(
    children: <Widget>[
      const Text('TileMode:'),
      DropdownButton<TileMode>(
        value: tileMode,
        onChanged: (TileMode? newValue) {
          setState(() {
            tileMode = newValue ?? TileMode.clamp;
            gradient = LinearGradient(
              begin: gradientBegin,
              end: gradientEnd,
              colors: [gradientColor1, gradientColor2],
              tileMode: tileMode,
            );
          });
        },
        items: <TileMode>[TileMode.clamp, TileMode.mirror, TileMode.repeated]
            .map<DropdownMenuItem<TileMode>>((TileMode value) {
              return DropdownMenuItem<TileMode>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
      ),
    ],
  ),
],

          ],
      crossAxisAlignment: CrossAxisAlignment.center  ,
      
      ),
    );
  }
}
