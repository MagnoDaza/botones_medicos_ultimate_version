
import 'boton_types/adaptive_button.dart';
import 'boton_types/elevated_button_data.dart';
import 'boton_types/outlined_button_data.dart';
import 'button_data/button_data.dart';

// Importa otros tipos de botón según los tengas

class ButtonFactory {
  static ButtonData fromJson(Map<String, dynamic> json) {
    ButtonType type = ButtonType.values.firstWhere((e) => e.toString() == json['type']);
    switch (type) {
      case ButtonType.elevated:
        return ElevatedButtonData.fromJson(json);
      case ButtonType.adaptive:
        return AdaptiveButtonData.fromJson(json);
      // Maneja otros tipos de botón aquí
      case ButtonType.outlined:
        return OutlinedButtonData.fromJson(json);
      default:
        throw Exception('Tipo de botón no soportado');
    }
  }
}
