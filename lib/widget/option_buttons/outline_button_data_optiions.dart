import 'package:flutter/material.dart';

import '../../controller/text_style_notifier.dart';
import 'buttondataoptions.dart';

class OutlinedButtonDataOptions extends ButtonDataOptions {
  const OutlinedButtonDataOptions({Key? key, required TextStyleNotifier textStyleNotifier})
      : super(key: key, textStyleNotifier: textStyleNotifier);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text(
            'Negrita',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          value: textStyleNotifier.isBold,
          onChanged: (bool value) {
            textStyleNotifier.setBold(value);
          },
        ),
        SwitchListTile(
          title: const Text(
            'Itálica',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          value: textStyleNotifier.isItalic,
          onChanged: (bool value) {
            textStyleNotifier.setItalic(value);
          },
        ),
        SwitchListTile(
          title: const Text('Subrayado'),
          value: textStyleNotifier.isUnderline,
          onChanged: (bool value) {
            textStyleNotifier.setUnderline(value);
          },
        ),
        SwitchListTile(
          title: const Text('Borde'),
          value: textStyleNotifier.isBorder,
          onChanged: (bool value) {
            textStyleNotifier.setBorder(value);
          },
        ),
      ],
    );
  }
}
