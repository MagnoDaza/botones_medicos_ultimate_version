import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../botones/button_data/button_data.dart';
import '../../controller/button_model.dart';
import '../../controller/text_style_notifier.dart';
import 'options_types_buttons/adaptive_button_data_options.dart';
import 'options_types_buttons/elevated_button_data_options.dart';
import 'options_types_buttons/outline_button_data_optiions.dart';

class ButtonOptions extends StatelessWidget {
  final TextEditingController buttonTextController;
  final TextStyleNotifier textStyleNotifier;
  final ButtonType? selectedButtonType;

  const ButtonOptions({
    Key? key,
    required this.buttonTextController,
    required this.textStyleNotifier,
    this.selectedButtonType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ButtonModel>(
      builder: (context, buttonModel, child) {
        if (selectedButtonType == null) {
          return const Center(child: Text("Selecciona un tipo de botón"));
        }
        switch (selectedButtonType) {
          case ButtonType.elevated:
            return ElevatedButtonDataOptions(
                textStyleNotifier: textStyleNotifier);
          case ButtonType.outlined:
            return OutlinedButtonDataOptions(
                textStyleNotifier: textStyleNotifier);
          case ButtonType.adaptive:
            return AdaptiveButtonDataOptions(
                textStyleNotifier: textStyleNotifier);
          // Agregar más casos según sea necesario
          default:
            return const Center(child: Text("Tipo de botón no soportado"));
        }
      },
    );
  }
}
