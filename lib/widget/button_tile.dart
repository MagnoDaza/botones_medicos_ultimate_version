import 'package:flutter/material.dart';

import '../botones/button_data.dart';

class ButtonTile extends StatelessWidget {
  final ButtonData button;

  const ButtonTile({super.key, required this.button});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicWidth(
          child: ListTile(
            title: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              padding: const EdgeInsets.all(0),
              child: button.build(context),
            ),
          ),
        ),
      ],
    );
  }
}
