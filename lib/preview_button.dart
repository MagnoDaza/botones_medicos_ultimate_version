import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import 'botones/button_data.dart';
import 'controller/button_model.dart';
import 'controller/text_style_notifier.dart';

class ButtonPreview extends StatelessWidget {
  final TextEditingController controller;
  final TextStyleNotifier textStyleNotifier;

  const ButtonPreview(
      {super.key, required this.controller, required this.textStyleNotifier});

  @override
  Widget build(BuildContext context) {
    return Consumer<ButtonModel>(
      builder: (context, buttonModel, child) {
        return ScrollSnapList(
          dynamicItemOpacity: 0.5,
          onItemFocus: (index) {
            Provider.of<ButtonModel>(context, listen: false).cloneText(
                index, controller.text,
                isBold: textStyleNotifier.isBold,
                isItalic: textStyleNotifier.isItalic,
                isUnderline: textStyleNotifier.isUnderline,
                isBorder: textStyleNotifier.isBorder);

            buttonModel.selectButton(index); // Selects the button

            controller.text = buttonModel.factoryButtons[index].text;
          },
          itemSize: 150,
          dynamicItemSize: true,
          itemCount: buttonModel.factoryButtons.length,
          itemBuilder: (context, index) {
            ButtonData buttonData = buttonModel.factoryButtons[index];
            return SizedBox(
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buttonData.build(context),
                  const SizedBox(height: 20),
                  Text(
                    buttonData.type.toString().split('.').last,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
          initialIndex: buttonModel.selectedIndex.toDouble(),
        );
      },
    );
  }
}
