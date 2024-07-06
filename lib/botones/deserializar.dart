
import 'boton/adaptive_button.dart';
import 'boton/elevated_button_data.dart';
import 'boton/outlined_button_data.dart';
import 'button_data.dart';

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
